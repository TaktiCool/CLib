using RGiesecke.DllExport;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace CLib
{
    public class DllEntry
    {
        public static Debugger Debugger;

        private static string _inputBuffer;
        private static StringBuilder _outputBuffer;
        private static readonly Dictionary<int, Task<string>> Tasks = new Dictionary<int, Task<string>>();

        static DllEntry()
        {
            Debugger = new Debugger();
            Debugger.Show();
            Debugger.Log("Extension framework initialized");
        }

        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            switch (input)
            {
                case "":
                    return;
                case "version":
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
                    break;
                default:
                    switch (input[0])
                    {
                        case (char)ControlCharacter.ACK:
                            output.Append(_outputBuffer);
                            break;
                        case (char)ControlCharacter.ENQ:
                            try
                            {
                                if (Tasks.Count == 0)
                                    break;

                                foreach (var taskId in Tasks.Keys)
                                {
                                    var task = Tasks[taskId];
                                    if (!task.IsCompleted)
                                        break;

                                    output.Append(taskId.ToString() + ControlCharacter.US + task.Result + ControlCharacter.RS);
                                    Debugger.Log("Task result: " + taskId);
                                    Tasks.Remove(taskId);
                                }
                            }
                            catch (Exception e)
                            {
                                output.Append(e);
                            }
                            break;
                        default:
                            try
                            {
                                _inputBuffer += input;

                                if (_inputBuffer[_inputBuffer.Length - 1] == (char)ControlCharacter.ETX)
                                    output.Append(ExecuteRequest(ArmaRequest.Parse(_inputBuffer)));
                                else
                                    output.Append((char)ControlCharacter.ACK);
                            }
                            catch (Exception e)
                            {
                                output.Append(e);
                            }
                            break;
                    }
                    break;
            }

            if (output.Length > outputSize - 1)
                _outputBuffer = output.Remove(outputSize - 1, output.Length);

            Debugger.Log(output);
            outputSize -= output.Length + 1;
        }

        private static string ExecuteRequest(ArmaRequest request)
        {
            _inputBuffer = "";

            var extensionPath = Path.Combine(Environment.CurrentDirectory, request.ExtensionName) + ".dll";

            extensionPath = Path.GetFullPath(string.Join("", extensionPath.Split(Path.GetInvalidPathChars())));
            if (!extensionPath.StartsWith(Environment.CurrentDirectory))
                throw new ArgumentException("Extension has to be in " + Environment.CurrentDirectory);

            var function = FunctionLoader.LoadFunction<Func<string, string>>(extensionPath, request.ActionName);

            if (request.TaskId == -1)
            {
                return ControlCharacter.STX + function(request.Data) + ControlCharacter.EOT;
            }
            else
            {
                var task = Task.Run(() => function(request.Data));
                Tasks.Add(request.TaskId, task);
                return ((char)ControlCharacter.ACK).ToString();
            }
        }

        [DllExport]
        public static string TestFunc(string input)
        {
            return input;
        }
    }
}