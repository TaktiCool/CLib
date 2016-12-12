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

        [DllExport("_CLibExtension@4", CallingConvention = CallingConvention.Winapi)]
        public static string CLibExtension(string input)
        {
            return input;
        }
    }
}
