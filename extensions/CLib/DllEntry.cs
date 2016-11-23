using RGiesecke.DllExport;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;

namespace CLib
{
    public class DllEntry
    {
        public static Debugger Debugger;
        private static List<Guid> tasks = new List<Guid>();

        static DllEntry()
        {
            DllEntry.Debugger = new Debugger();
            DllEntry.Debugger.Show();
            DllEntry.Debugger.Log("Console created.");
        }

        [DllExport("_RVExtension@12", CallingConvention = System.Runtime.InteropServices.CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            if (input == "")
                return;

            if  (input[0] == '>')
            {
                try
                {
                    string[] parameter = input.Substring(1).Split(new char[] { '|' }, 3);
                    if (parameter.Length < 2)
                        return;
                    output.Append(DllEntry.Execute(parameter[0], parameter[1]));
                }
                catch (Exception e)
                {
                    output.Append(e.Message);
                }
            }

            if (input[0] == '<')
            {
                try
                {
                    if (DllEntry.tasks.Count == 0)
                        return;

                    Guid id = DllEntry.tasks[0];
                    DllEntry.tasks.RemoveAt(0);
                    output.Append(id);
                }
                catch (Exception e)
                {
                    output.Append(e.Message);
                }
            }

            outputSize--;
        }

        private static string Execute(string extension, string action)
        {
            Guid id = Guid.NewGuid();

            DllEntry.tasks.Add(id);

            return id.ToString();
        }
    }
}
