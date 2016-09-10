using RGiesecke.DllExport;
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace Clib
{
    public class DllEntry
    {
        private static Dictionary<string, Delegate> voidActions = new Dictionary<string, Delegate>();
        private static Dictionary<string, Func<string, string>> dataActions = new Dictionary<string, Func<string, string>>();

        public static string startTime;
        private static string fromGameData = "";
        private static string toGameData = "";
        private static List<string> toGameDataSplit;

        static DllEntry()
        {
            startTime = Misc.currentDate("{0}-{1}-{2}_{3}-{4}-{5}");
        }

        [DllExport("_RVExtension@12", CallingConvention = System.Runtime.InteropServices.CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            output.Append("Done");
            switch (input)
            {
                case "frameworkClear":
                    fromGameData = "";
                    toGameData = "";
                    break;
                case "frameworkImport":
                    if (toGameDataSplit.Count != 0)
                    {
                        output.Clear();
                        output.Append(toGameDataSplit[0]);
                        toGameDataSplit.RemoveAt(0);
                    }
                    break;
                default:
                    string[] inputSplited = input.Split(new char[] { ':' }, 2);
                    if (voidActions.ContainsKey(inputSplited[0]))
                    {
                        voidActions[inputSplited[0]]();
                    }
                    else if (dataActions.ContainsKey(inputSplited[0]))
                    {
                        string tempData = dataActions[input](fromGameData);
                        if (tempData != "")
                        {
                            toGameDataSplit = splitToGameDataArray(tempData);
                        }
                    }
                    else
                    {
                        fromGameData += input;
                    }
                    break;
            }
        }
        public static List<string> splitToGameDataArray(string input)
        {

            int chunkSize = 7000;
            int stringLength = input.Length;
            List<string> stringArray = new List<string>();
            for (int i = 0; i < stringLength; i += chunkSize)
            {
                if (i + chunkSize > stringLength) chunkSize = stringLength - i;
                stringArray.Add(input.Substring(i, chunkSize));
            }
            return stringArray;
        }
    }
}
