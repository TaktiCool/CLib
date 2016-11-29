using RGiesecke.DllExport;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;

namespace CLib
{
    public class DllEntry
    {
        public static Debugger Debugger;

        private static string inputBuffer;
        private static StringBuilder outputBuffer;
        private static Dictionary<Guid, string> taskResults = new Dictionary<Guid, string>();

        private const char SOH = '\x01';
        private const char STX = '\x02';
        private const char ETX = '\x03';
        private const char EOT = '\x04';
        private const char ENQ = '\x05';
        private const char ACK = '\x06';

        private const char RS = '\x1E';
        private const char US = '\x1F';

        private struct Request
        {
            public int TaskID { get; private set; }
            public string ExtensionName { get; private set; }
            public string ActionName { get; private set; }
            public string Data { get; private set; }
            public string Response { get; private set; }

            public static Request Parse(string input)
            {
                int headerStart = input.IndexOf(SOH);
                int textStart = input.IndexOf(STX);
                int textEnd = input.IndexOf(ETX);

                string header = input.Substring(headerStart < 0 ? 0 : headerStart + 1, textStart < 0 ? input.Length : textStart);
                string[] headerValues = header.Split(new char[] { US }, 3);

                Request request = new Request();
                int taskId;
                if (!int.TryParse(headerValues[0], out taskId))
                    throw new ArgumentException("Invalid task id: " + headerValues[0]);
                request.TaskID = taskId;
                request.ExtensionName = headerValues[1];
                request.ActionName = headerValues[2];
                request.Data = textStart < 0 ? "" : input.Substring(textStart + 1, textEnd - textStart - 2);

                return request;
            }
        }

        private class FunctionLoader
        {
            [DllImport("Kernel32.dll")]
            private static extern IntPtr LoadLibrary(string path);

            [DllImport("Kernel32.dll")]
            private static extern IntPtr GetProcAddress(IntPtr hModule, string procName);

            public static T LoadFunction<T>(string dllPath, string functionName)
            {
                IntPtr hModule = FunctionLoader.LoadLibrary(dllPath);
                if (hModule == IntPtr.Zero)
                    throw new ArgumentException("Dll not found: " + dllPath);

                IntPtr functionAddress = FunctionLoader.GetProcAddress(hModule, functionName);
                if (functionAddress == IntPtr.Zero)
                    throw new ArgumentException("Function not found: " + functionName);
                
                return Marshal.GetDelegateForFunctionPointer<T>(functionAddress);
            }
        }


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

            if (input == "version")
            {
                output.Append(FileVersionInfo.GetVersionInfo(Assembly.GetExecutingAssembly().Location).FileVersion);
            }

            if (input[0] == ACK)
            {
                output.Append(DllEntry.outputBuffer);
            }
            else if (input[0] == ENQ)
            {
                try
                {
                    if (DllEntry.taskResults.Count == 0)
                        return;

                    foreach (Guid key in DllEntry.taskResults.Keys)
                    {
                        output.Append(key.ToString() + '\u001E' + DllEntry.taskResults[key] + '\u001D');
                        DllEntry.Debugger.Log("Task result: " + key);
                    }
                    DllEntry.taskResults.Clear();
                }
                catch (Exception e)
                {
                    output.Append(e);
                }
            }
            else
            {
                try
                {
                    DllEntry.inputBuffer += input;
                        
                    if (DllEntry.inputBuffer[DllEntry.inputBuffer.Length - 1] == ETX)
                        output.Append(DllEntry.ExecuteRequest(Request.Parse(DllEntry.inputBuffer)));
                    else
                        output.Append(ACK);
                }
                catch (Exception e)
                {
                    output.Append(e);
                }
            }

            if (output.Length > outputSize - 1)
                DllEntry.outputBuffer = output.Remove(outputSize - 1, output.Length);

            DllEntry.Debugger.Log(output);
            outputSize -= output.Length + 1;
        }

        private static string ExecuteRequest(Request request)
        {
            DllEntry.inputBuffer = "";

            string extensionPath = Path.Combine(Environment.CurrentDirectory, request.ExtensionName) + ".dll";
            extensionPath = Path.GetFullPath(string.Join("", extensionPath.Split(Path.GetInvalidPathChars())));
            if (!extensionPath.StartsWith(Environment.CurrentDirectory))
                throw new ArgumentException("Extension has to be in " + Environment.CurrentDirectory);
            Func<string, string> function = FunctionLoader.LoadFunction<Func<string, string>>(extensionPath, request.ActionName);
            return STX + function(request.Data) + EOT;
        }
    }
}