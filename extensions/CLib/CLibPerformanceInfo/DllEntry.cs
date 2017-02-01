using System;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using RGiesecke.DllExport;

namespace CLibPerformanceInfo
{
    public class DllEntry
    {
        private static FileStream file;

        static DllEntry()
        {
            DllEntry.file = new FileStream("performanceInfo.log", FileMode.Create, FileAccess.Write);    
        }
        
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            if (input.ToLower() == "version")
            {
                output.Append("0.1");
            }
        }

        [DllExport("_LogCall@4", CallingConvention = CallingConvention.Winapi)]
        public static string LogCall(string input)
        {
            byte[] bytes = Encoding.ASCII.GetBytes(input + "\r\n");
            file.WriteAsync(bytes, 0, bytes.Length);

            return "";
        }
    }
}