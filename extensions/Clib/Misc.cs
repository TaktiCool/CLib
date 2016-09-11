using System;
using System.IO;

namespace CLib
{
    class Misc
    {
        
        public static string addLog(string input)
        {
            string[] inputParts = input.Split(new char[] { ':' }, 2);

            string path = Environment.CurrentDirectory + "\\CLib_Logs\\" + DllEntry.startTime.Replace("-", "");
            if (!File.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            // TODO let the user define the File format
            StreamWriter file = new System.IO.StreamWriter(path + string.Format("\\CLib_{0}_{1}.{2}", DllEntry.startTime, inputParts[0], "log"), true);
            file.WriteLine(currentDate("[{3}:{4}:{5}]") + inputParts[1]);
            file.Close();
            return "";
        }

        public static string currentDate(string formating)
        {
            return string.Format(formating, DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second);
        }
    }
}
