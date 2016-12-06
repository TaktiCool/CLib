using System;
using System.Runtime.InteropServices;
using System.Text;
using RGiesecke.DllExport;

namespace CLibCompression
{
    public class DllEntry
    {
        [DllExport("_CLibExtension@4", CallingConvention = CallingConvention.Winapi)]
        public static string CLibExtension(string input)
        {
            return input;
        }
    }
}
