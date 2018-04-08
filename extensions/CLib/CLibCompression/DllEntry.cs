﻿﻿using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Reflection;
using System.Diagnostics;

namespace CLibCompression
{
    public class DllEntry
    {
        private const int WindowSize = 1 << 11;
        private const int MinMatchLength = 2;
        private const uint MaxMatchLength = (1 << 4) - MinMatchLength;

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
            if (input != "version")
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

        [DllExport("Compress")]
        public static string Compress(string input)
        {
            var output = new StringBuilder();
            var writeBuffer = new List<char>();
            int symbolsWritten = 0;
            int encodeFlag = 1;

            output.Append(input.Substring(0, MinMatchLength));

            for (int inputPosition = MinMatchLength; inputPosition < input.Length; inputPosition++)
            {
                char currentChar = input[inputPosition];

                int searchSteps = Math.Min(WindowSize, inputPosition);
                int bestMatchLength = 0;
                int bestMatchOffset = 0;

                for (int windowPosition = 1; windowPosition <= searchSteps; windowPosition++)
                {
                    if (currentChar != input[inputPosition - windowPosition])
                        continue;

                    int currentMatchLength = 1;
                    while (inputPosition + currentMatchLength < input.Length && input[inputPosition - searchSteps + ((searchSteps - windowPosition + currentMatchLength) % searchSteps)]
                        == input[inputPosition + currentMatchLength]
                        && currentMatchLength < MaxMatchLength)
                    {
                        currentMatchLength++;
                    }

                    if (currentMatchLength <= bestMatchLength)
                        continue;

                    bestMatchLength = currentMatchLength;
                    bestMatchOffset = windowPosition;
                }

                symbolsWritten++;

                if (bestMatchLength > MinMatchLength)
                {
                    inputPosition += bestMatchLength - 1;
                    encodeFlag |= 1 << symbolsWritten;
                    writeBuffer.Add((char)(((bestMatchOffset >> 4) << 1) | 0x1));
                    writeBuffer.Add((char)(((bestMatchOffset & 0xF) << 4) | (bestMatchLength - MinMatchLength)));
                }
                else
                {
                    writeBuffer.Add(currentChar);
                }

                if (symbolsWritten < 7)
                    continue;

                output.Append((char)encodeFlag);
                output.Append(writeBuffer.ToArray());

                encodeFlag = 1;
                symbolsWritten = 0;
                writeBuffer.Clear();
            }

            if (writeBuffer.Count > 0)
            {
                output.Append((char)encodeFlag);
                output.Append(writeBuffer.ToArray());
            }

            return Encoding.Default.GetString(Encoding.Convert(Encoding.Unicode, Encoding.UTF8, Encoding.Unicode.GetBytes(output.ToString())));
        }
    }
}
