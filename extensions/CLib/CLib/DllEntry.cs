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
        private static Dictionary<Guid, string> taskResults = new Dictionary<Guid, string>();

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

            if (input[0] == '>')
            {
                try
                {
                    DllEntry.Debugger.Log(input);
                    string[] parameter = input.Substring(1).Split(new char[] { '\u001E' }, 3);
                    DllEntry.Debugger.Log(parameter[0]);
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
                    if (DllEntry.taskResults.Count == 0)
                        return;

                    foreach (Guid key in DllEntry.taskResults.Keys)
                    {
                        output.Append(key.ToString() + '\u001E' + DllEntry.taskResults[key] + '\u001E');
                        DllEntry.Debugger.Log("Task result: " + key);
                    }
                    DllEntry.taskResults.Clear();
                }
                catch (Exception e)
                {
                    output.Append(e.Message);
                }
            }

            outputSize -= output.Length + 1;
        }

        private static string Execute(string extension, string action)
        {
            Guid id = Guid.NewGuid();

            DllEntry.Debugger.Log("Execute task: " + id);
            DllEntry.taskResults.Add(id, "resultString");

            return id.ToString();
        }
    }
}