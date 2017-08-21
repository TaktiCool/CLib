using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace CLibSocket
{
    public class DllEntry {
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
                throw new ArgumentException("Socket for address not connected");

            TcpClient tcpClient = DllEntry.tcpClients[hash];
            byte[] dataBytes = Encoding.Default.GetBytes(data);
            tcpClient.GetStream().Write(dataBytes, 0, dataBytes.Length);

            return "Success";
        }

        private static void Log(params object[] obj) {
            System.IO.File.AppendAllText("CLibSocket.log", string.Concat(DateTime.Now.ToString("HH:mm:ss.fff"), " ", string.Concat(obj), "\r\n"));
        }
    }
}
