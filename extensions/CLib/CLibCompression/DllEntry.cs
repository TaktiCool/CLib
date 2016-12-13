using System;
using System.Runtime.InteropServices;
using System.Text;
using RGiesecke.DllExport;
using System.Reflection;
using System.Diagnostics;

namespace CLibCompression
{
    public class DllEntry
    {
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            if (input != "version")
                return;

            var executingAssembly = Assembly.GetExecutingAssembly();
            try
            {
                var location = executingAssembly.Location;
                if (location == null)
                    throw new Exception("Assembly location not found");
                output.Append(FileVersionInfo.GetVersionInfo(location).FileVersion);
            }
            catch (Exception e)
            {
                output.Append(e);
            }
        }

        [DllExport("_Compress@8", CallingConvention = CallingConvention.Winapi)]
        public static string Compress(Action<string> logFunc, string input)
        {

            logFunc(input);
            return input;
        }
    }
}
