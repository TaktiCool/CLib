using System;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using RGiesecke.DllExport;

namespace CLibLogging
{
    public class DllEntry
    {
        private static string startTime = "";
        static DllEntry()
        {
            startTime = currentDate("{0}-{1}-{2}_{3}-{4}-{5}");
        }

        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            if (input.ToLower() == "version")
            {
                output.Append("0.2");
            }
        }

        [DllExport("_CLiblog@8", CallingConvention = CallingConvention.Winapi)]
        public static string log(Action<string> logFunc, string input)
        {
            string[] inputParts = input.Split(new char[] { ':' }, 2);

            string path = Environment.CurrentDirectory + "\\CLib_Logs\\" + startTime.ToString().Replace("-", "");
            if (!File.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            // TODO let the user define the File format
            StreamWriter file = new System.IO.StreamWriter(path + string.Format("\\CLibLog_{0}_{1}.{2}", startTime, inputParts[0], "log"), true);
            string log = currentDate("[{3}:{4}:{5}]") + inputParts[1];
            logFunc(log);
            file.WriteLine(log);
            file.Close();
            return "";
            
        }

        private static string currentDate(string formating)
        {
            return string.Format(formating, DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
        }
    }
}
