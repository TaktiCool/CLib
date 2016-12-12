using System;
using System.Runtime.InteropServices;
using System.Text;
using RGiesecke.DllExport;

namespace CLibCompression
{
    public class DllEntry
    {
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
        }

        [DllExport("_CLibExtension@8", CallingConvention = CallingConvention.Winapi)]
        public static string CLibExtension(Action<string> logFunc, string input)
        {
            logFunc(input);
            return input;
        }
    }
}
