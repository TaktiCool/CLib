﻿﻿using System;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using System.Reflection;
using System.Diagnostics;

namespace CLibLogging
{
    public class DllEntry
    {
        private static string startTime = "";
        static DllEntry()
        {
            startTime = DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss");
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
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            if (input.ToLower() != "version")
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

        [DllExport("Log")]
        public static string Log(string input)
        {
            string[] inputParts = input.Split(new char[] { ':' }, 2);

            string path = Path.Combine(Environment.CurrentDirectory, "CLib_Logs", startTime.Replace("-", ""));
            if (!File.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            // TODO let the user define the File format
            using (StreamWriter file = new StreamWriter(path + string.Format("\\CLibLog_{0}_{1}.{2}", startTime, inputParts[0], "log"), true))
            {
                string log = DateTime.Now.ToString("HH-mm-ss") + inputParts[1];
                file.WriteLine(log);
            }
            return "";
        }
    }
}
