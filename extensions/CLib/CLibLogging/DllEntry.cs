﻿﻿using System;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;

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
        [DllExport("RVExtension")]
#else
        [DllExport("_RVExtension@12")]
#endif
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            if (input.ToLower() == "version")
            {
                output.Append("0.2");
            }
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
