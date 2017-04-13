using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CLib
{
    public class DllEntry
    {
        private static string _inputBuffer;
        private static string _outputBuffer;
        private static readonly Debugger Debugger;
        private static readonly Dictionary<string, string> AvailableExtensions = new Dictionary<string, string>();
        private static readonly Dictionary<int, Task<string>> Tasks = new Dictionary<int, Task<string>>();

        static DllEntry()
        {
            Debugger = new Debugger();
            Debugger.Show();
            Debugger.Log("Extension framework initializing");

            try
            {
                DetectExtensions();
            }
            catch (Exception e)
            {
                Debugger.Log(e);
            }


            Debugger.Log("Extension framework initialized");
        }

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
                        string location = executingAssembly.Location;
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
                        case ControlCharacter.ACK:
                            output.Append(_outputBuffer);
                            break;
                        case ControlCharacter.ENQ:
                            if (Tasks.Count == 0)
                                break;

                            try
                            {
                                var completedTasksIndices = new List<int>();
                                foreach (var taskEntry in Tasks)
                                {
                                    if (!taskEntry.Value.IsCompleted)
                                        continue;

                                    output.Append(ControlCharacter.SOH + taskEntry.Key.ToString() + ControlCharacter.STX + taskEntry.Value.Result);
                                    Debugger.Log("Task result: " + taskEntry.Key);
                                    completedTasksIndices.Add(taskEntry.Key);
                                }

                                foreach (int index in completedTasksIndices)
                                {
                                    Tasks.Remove(index);
                                }

                                output.Append(ControlCharacter.EOT);
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

                                if (_inputBuffer[_inputBuffer.Length - 1] == ControlCharacter.ETX)
                                    output.Append(ExecuteRequest(ArmaRequest.Parse(_inputBuffer)));
                                else
                                    output.Append(ControlCharacter.ACK);
                            }
                            catch (Exception e)
                            {
                                output.Append(e);
                            }
                            break;
                    }
                    break;
            }

            List<byte> outputBytes = Encoding.UTF8.GetBytes(output.ToString()).ToList();
            if (outputBytes.Count <= outputSize)
                return;

            int outputSplitPosition = outputSize;
            while ((outputBytes[outputSplitPosition - 1] & 0xC0) == 0x80)
            {
                outputSplitPosition--;
            }

            _outputBuffer = Encoding.UTF8.GetString(outputBytes.GetRange(outputSplitPosition, outputBytes.Count - outputSplitPosition).ToArray());
            output.Remove(output.Length - _outputBuffer.Length, _outputBuffer.Length);
        }

        private delegate string CLibFuncDelegate(string input);
        private static string ExecuteRequest(ArmaRequest request)
        {
            _inputBuffer = "";

            if (!AvailableExtensions.ContainsKey(request.ExtensionName))
                throw new ArgumentException("Extension is not valid: " + Environment.CurrentDirectory);

            var function = FunctionLoader.LoadFunction<CLibFuncDelegate>(AvailableExtensions[request.ExtensionName], request.ActionName);

            if (request.TaskId == -1)
            {
                return ControlCharacter.STX + function(request.Data) + ControlCharacter.EOT;
            }

            var task = Task.Run(() => function(request.Data));
            if (Tasks.ContainsKey(request.TaskId))
                Tasks.Remove(request.TaskId);
            Tasks.Add(request.TaskId, task);
            return (ControlCharacter.ACK).ToString();
        }

        private static void DetectExtensions()
        {
            Debugger.Log("Extensions Found:");
            var startParameters = Environment.GetCommandLineArgs();
            foreach (string startParameter in startParameters)
            {
                var match = Regex.Match(startParameter, "^-(?:server)?mod=(.*)", RegexOptions.IgnoreCase);
                if (!match.Success)
                    continue;

                foreach (string path in match.Groups[1].Value.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    string fullPath = path;
                    if (!Path.IsPathRooted(fullPath))
                        fullPath = Path.Combine(Environment.CurrentDirectory, path);

                    var extensionPaths = Directory.GetFiles(fullPath, "*.dll", SearchOption.AllDirectories);
                    foreach (string extensionPath in extensionPaths)
                    {
                        try
                        {
                            var exports = FunctionLoader.ExportTable(extensionPath);
                            if (!exports.Contains("_RVExtension@12"))
                                continue;

                            string filename = Path.GetFileNameWithoutExtension(extensionPath);
                            if (filename == null)
                                continue;

                            if (AvailableExtensions.ContainsKey(filename))
                            {
                                Debugger.Log($"Duplicate: {filename} at: {extensionPath}");
                            }
                            else
                            {
                                AvailableExtensions.Add(filename, extensionPath);
                                Debugger.Log($"Added: {filename} at: {extensionPath}");
                            }
                            
                        }
                        catch (Win32Exception e)
                        {
                            // Trying to load an x64 dll within an x86 process fails with an error with no nativ error code. We can ignore that.
                            if (e.NativeErrorCode != 0)
                                Debugger.Log(e);
                        }
                        catch (Exception e)
                        {
                            Debugger.Log(e);
                        }
                    }
                }
            }
        }
    }
}