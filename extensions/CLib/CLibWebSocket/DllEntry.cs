using System;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using CLib;
namespace CLibWebSocket
{
    public class DllEntry
	{
#if WIN64
		[DllExport("RVExtensionVersion")]
#else
		[DllExport("_RVExtensionVersion@6", CallingConvention.StdCall)]
#endif
		public static void RVExtensionVersion(StringBuilder output, int outputSize)
		{
			outputSize--;
			var executingAssembly = Assembly.GetExecutingAssembly();
			try
			{
				string location = executingAssembly.Location;
				if (location == null)
					throw new Exception("Assembly location not found");
				output.Append(FileVersionInfo.GetVersionInfo(location).FileVersion);
			}
			catch (Exception e)
			{
				output.Append(e.Message);
			}
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
            return "";
        }
    }
}
