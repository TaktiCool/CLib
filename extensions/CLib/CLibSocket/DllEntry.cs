using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Threading;

namespace CLibSocket
{
    public class DllEntry {
        private const int AF_INET = 2;    // IP_v4 = System.Net.Sockets.AddressFamily.InterNetwork
        private const int AF_INET6 = 23;  // IP_v6 = System.Net.Sockets.AddressFamily.InterNetworkV6

        [StructLayout(LayoutKind.Sequential)]
        public struct MIB_UDPROW_OWNER_PID
        {
            public uint LocalAddress;
            private ushort localPort;
            public uint PID;

            public ushort LocalPort
            {
                get
                {
                    byte[] bytes = BitConverter.GetBytes(this.localPort);
                    if (BitConverter.IsLittleEndian)
                        Array.Reverse(bytes);
                    
                    return BitConverter.ToUInt16(bytes, 0);
                }
            }
        }

        enum UDP_TABLE_CLASS
        {
            UDP_TABLE_BASIC,
            UDP_TABLE_OWNER_PID,
            UDP_TABLE_OWNER_MODULE
        }

        [DllImport("iphlpapi.dll", SetLastError = true)]
        private static extern uint GetExtendedUdpTable(IntPtr pTcpTable, ref int dwOutBufLen, bool sort, int ipVersion, UDP_TABLE_CLASS tblClass, uint reserved = 0);

        private class TcpClientEntry
        {
            public Uri Uri;
            public TcpClient TcpClient;
        }

        private static Dictionary<string, TcpClientEntry> tcpClients = new Dictionary<string, TcpClientEntry>();
        private static Timer tickTimer;
        private static List<int> serverPorts = new List<int>();
        private static ReaderWriterLock locker = new ReaderWriterLock();

        static DllEntry() {
            System.IO.File.WriteAllText("CLibSocket.log", string.Empty);

            DllEntry.tickTimer = new Timer(DllEntry.OnTick, null, 0, 5000);
        }

#if WIN64
        [DllExport("RVExtensionVersion")]
#else
        [DllExport("_RVExtensionVersion@8", CallingConvention.StdCall)]
#endif
        public static void RVExtensionVersion(StringBuilder output, int outputSize)
        {
            output.Append(DllEntry.GetVersion());
        }

#if WIN64
        [DllExport("RVExtension")]
#else
        [DllExport("_RVExtension@12", CallingConvention.StdCall)]
#endif
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input) {
            if (input != "version")
                return;

            output.Append(DllEntry.GetVersion());
        }

        private static string GetVersion()
        {
            var executingAssembly = Assembly.GetExecutingAssembly();
            try
            {
                string location = executingAssembly.Location;
                if (location == null)
                    throw new Exception("Assembly location not found");
                return FileVersionInfo.GetVersionInfo(location).FileVersion;
            }
            catch (Exception) { }
            return "0.0.0.0";
        }

        [DllExport("Connect")]
        public static string Connect(string address) {
            string hash = "";
            using (SHA1Managed sha1 = new SHA1Managed())
            {
                hash = string.Join("", sha1.ComputeHash(Encoding.Default.GetBytes(address)).Select(b => b.ToString("x2"))).Substring(0, 7);
            }
            Log(hash);

            if (DllEntry.tcpClients.ContainsKey(hash)) {
                return hash;
            }

            if (!Uri.TryCreate(address, UriKind.Absolute, out Uri uri))
            {
                Log("Malformed address: " + address);
                return "error";
            }

            Log("Connecting to: " + uri.Host + ":" + uri.Port);
            TcpClient tcpClient = DllEntry.Connect(uri);
            DllEntry.tcpClients.Add(hash, new TcpClientEntry() { Uri = uri, TcpClient = tcpClient });

            return hash;
        }

        [DllExport("Disconnect")]
        public static string Disconnect(string hash)
        {
            if (!DllEntry.tcpClients.ContainsKey(hash))
            {
                return "false";
            }
            
            DllEntry.tcpClients[hash].TcpClient.Close();
            DllEntry.tcpClients.Remove(hash);
            
            return "success";
        }

        [DllExport("IsConnected")]
        public static string IsConnected(string hash)
        {
            if (!DllEntry.tcpClients.ContainsKey(hash))
            {
                return "error";
            }

            return DllEntry.IsConnected(DllEntry.tcpClients[hash].TcpClient) ? "success" : "false";
        }

        [DllExport("Send")]
        public static string Send(string data) {
            string[] dataParts = data.Split(new char[] { ':' }, 2);
            string hash = dataParts[0];
            data = dataParts[1];

            if (!DllEntry.tcpClients.ContainsKey(hash))
                return "Socket for address not connected";

            DllEntry.Send(DllEntry.tcpClients[hash].TcpClient, data);

            return "success";
        }

        private static TcpClient Connect(Uri uri)
        {
            TcpClient tcpClient = new TcpClient(uri.Host, uri.Port);
            tcpClient.Client.SetSocketOption(SocketOptionLevel.Socket, SocketOptionName.KeepAlive, true);
            return tcpClient;
        }

        private static bool IsConnected(TcpClient tcpClient)
        {
            try
            {
                return tcpClient.Connected && !(tcpClient.Client.Poll(1, SelectMode.SelectRead) && tcpClient.Client.Available == 0);
            }
            catch (ObjectDisposedException)
            {
                return false;
            }
        }

        private static void Send(TcpClient tcpClient, string message)
        {
            byte[] dataBytes = Encoding.Default.GetBytes(message);
            tcpClient.GetStream().Write(dataBytes, 0, dataBytes.Length);
        }

        private static void OnTick(object state)
        {
            DllEntry.ReconnectAllSockets();

            List<int> ports = DllEntry.GetArmaServerPorts();
            if (!ports.SequenceEqual(DllEntry.serverPorts))
            {
                DllEntry.serverPorts = ports;
                foreach (TcpClientEntry tcpClientEntry in DllEntry.tcpClients.Values)
                {
                    DllEntry.Send(tcpClientEntry.TcpClient, $"PORTS:{string.Join(":", DllEntry.serverPorts)}");
                }
            }
        }

        private static void ReconnectAllSockets()
        {
            foreach (KeyValuePair<string, TcpClientEntry> kvPair in DllEntry.tcpClients)
            {
                string hash = kvPair.Key;
                TcpClientEntry entry = kvPair.Value;

                if (!DllEntry.IsConnected(entry.TcpClient))
                {
                    try
                    {
                        entry.TcpClient.Close();
                    }
                    catch (ObjectDisposedException) { }

                    try
                    {
                        entry.TcpClient = DllEntry.Connect(entry.Uri);
                        Log("Reconnected");
                    }
                    catch (SocketException e)
                    {
                        Log($"Reconnect - Socket exception {e.Message}");
                    }
                }
            }
        }

        private static List<int> GetArmaServerPorts()
        {
            List<int> ports = new List<int>();
            int bufferSize = 0;
            uint ret = GetExtendedUdpTable(IntPtr.Zero, ref bufferSize, false, AF_INET, UDP_TABLE_CLASS.UDP_TABLE_OWNER_PID);
            IntPtr bufferTable = Marshal.AllocHGlobal(bufferSize);

            try
            {
                ret = GetExtendedUdpTable(bufferTable, ref bufferSize, false, AF_INET, UDP_TABLE_CLASS.UDP_TABLE_OWNER_PID);
                if (ret != 0)
                {
                    return ports;
                }

                int numberOfEntires = Marshal.ReadInt32(bufferTable, 0);
                IntPtr rowPtr = bufferTable + 4;

                for (int i = 0; i < numberOfEntires; i++)
                {
                    MIB_UDPROW_OWNER_PID row = (MIB_UDPROW_OWNER_PID)Marshal.PtrToStructure(rowPtr, typeof(MIB_UDPROW_OWNER_PID));
                    rowPtr = rowPtr + Marshal.SizeOf(row);

                    if (row.PID == Process.GetCurrentProcess().Id && row.LocalAddress == 0)
                        ports.Add(row.LocalPort);
                }
            }
            finally
            {
                Marshal.FreeHGlobal(bufferTable);
            }

            return ports;
        }

        private static void Log(params object[] obj) {
            try
            {
                locker.AcquireWriterLock(int.MaxValue);
                System.IO.File.AppendAllText("CLibSocket.log", string.Concat(DateTime.Now.ToString("HH:mm:ss.fff"), " ", string.Concat(obj), "\r\n"));
            }
            finally
            {
                locker.ReleaseWriterLock();
            }
        }
    }
}
