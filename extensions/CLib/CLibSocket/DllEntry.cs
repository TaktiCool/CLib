using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Sockets;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;

namespace CLibSocket
{
    public class DllEntry {
        private const int AF_INET = 2;    // IP_v4 = System.Net.Sockets.AddressFamily.InterNetwork
        private const int AF_INET6 = 23;  // IP_v6 = System.Net.Sockets.AddressFamily.InterNetworkV6

        [StructLayout(LayoutKind.Sequential)]
        public struct MIB_UDPROW_OWNER_PID
        {
            public uint LocalAddress;
            public ushort LocalPort;
            public uint PID;
        }

        enum UDP_TABLE_CLASS
        {
            UDP_TABLE_BASIC,
            UDP_TABLE_OWNER_PID,
            UDP_TABLE_OWNER_MODULE
        }

        [DllImport("iphlpapi.dll", SetLastError = true)]
        private static extern uint GetExtendedUdpTable(IntPtr pTcpTable, ref int dwOutBufLen, bool sort, int ipVersion, UDP_TABLE_CLASS tblClass, uint reserved = 0);

        private static Dictionary<string, TcpClient> tcpClients = new Dictionary<string, TcpClient>();

        static DllEntry() {
            System.IO.File.WriteAllText("CLibSocket.log", string.Empty);
        }

#if WIN64
        [DllExport("RVExtension")]
#else
        [DllExport("_RVExtension@12", CallingConvention.StdCall)]
#endif
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input) {
            if (input != "version")
                return;

            var executingAssembly = Assembly.GetExecutingAssembly();
            try {
                var location = executingAssembly.Location;
                if (location == null)
                    throw new Exception("Assembly location not found");
                output.Append(FileVersionInfo.GetVersionInfo(location).FileVersion);
            } catch (Exception e) {
                output.Append(e.Message);
            }
        }

        [DllExport("Connect")]
        public static string Connect(string address) {
            string hash = "";
            using (SHA1Managed sha1 = new SHA1Managed()) {
                hash = string.Join("", sha1.ComputeHash(Encoding.Default.GetBytes(address)).Select(b => b.ToString("x2"))).Substring(0, 7);
            }

            if (DllEntry.tcpClients.ContainsKey(hash) && !DllEntry.tcpClients[hash].Connected) {
                Log("Closed");
                DllEntry.tcpClients[hash].Close();
                DllEntry.tcpClients.Remove(hash);
            }

            if (!DllEntry.tcpClients.ContainsKey(hash)) {
                if (Uri.TryCreate(address, UriKind.Absolute, out Uri uri))
                {
                    TcpClient tcpClient = new TcpClient();
                    DllEntry.tcpClients.Add(hash, tcpClient);

                    Log("Connecting to: " + uri.Host + ":" + uri.Port);

                    tcpClient.Connect(uri.Host, uri.Port);
                    if (tcpClient.Connected)
                    {
                        Log("Connected");
                        DllEntry.Send(tcpClient, "Arma3Server:" + string.Join<int>(":", DllEntry.GetArmaServerPorts()));
                        return hash;
                    }

                    Log("Connecting error");
                    DllEntry.tcpClients[hash].Close();
                    DllEntry.tcpClients.Remove(hash);
                    return "error";
                }

                Log("Malformed address: " + address);
                return "error";
            }

            return hash;
        }

        [DllExport("IsConnected")]
        public static string IsConnected(string hash)
        {
            if (!DllEntry.tcpClients.ContainsKey(hash))
            {
                return "false";
            }

            if (DllEntry.tcpClients[hash].Client.Poll(1, SelectMode.SelectRead) && DllEntry.tcpClients[hash].Client.Available == 0)
            {
                Log("Closed");
                DllEntry.tcpClients[hash].Close();
                DllEntry.tcpClients.Remove(hash);
                return "false";
            }

            return "true";
        }

        [DllExport("Send")]
        public static string Send(string data) {
            string[] dataParts = data.Split(new char[] { ':' }, 2);
            string hash = dataParts[0];
            data = dataParts[1];

            if (!DllEntry.tcpClients.ContainsKey(hash))
                return "Socket for address not connected";

            TcpClient tcpClient = DllEntry.tcpClients[hash];
            DllEntry.Send(tcpClient, data);

            return "Success";
        }

        private static void Send(TcpClient tcpClient, string message)
        {
            byte[] dataBytes = Encoding.Default.GetBytes(message);
            tcpClient.GetStream().Write(dataBytes, 0, dataBytes.Length);
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
            System.IO.File.AppendAllText("CLibSocket.log", string.Concat(DateTime.Now.ToString("HH:mm:ss.fff"), " ", string.Concat(obj), "\r\n"));
        }
    }
}
