using System;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using System.Collections.Generic;
using System.IO.Compression;
using SimpleJSON;
namespace CLibDatabase
{
    public class DllEntry
    {
        private static string loadedDatabase = "";
        private static string databaseFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase");
        private static Dictionary<string, string> database = new Dictionary<string, string>();

        static DllEntry()
        {
            if (!Directory.Exists(DllEntry.databaseFolder))
                Directory.CreateDirectory(DllEntry.databaseFolder);
        }

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
            if (input.ToLower() != "version")
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

        [DllExport("KeyExists")]
        public static string KeyExists(string key)
        {
            return DllEntry.database.ContainsKey(key).ToString();
        }

        [DllExport("Get")]
        public static string Get(string key)
        {
            if (!DllEntry.database.ContainsKey(key))
                return "ERROR";
            return DllEntry.database[key];
        }

        [DllExport("Set")]
        public static string Set(string input)
        {
            string[] keyAndValue = input.Split(new[] { "~>" }, StringSplitOptions.RemoveEmptyEntries);
            if (!DllEntry.database.ContainsKey(keyAndValue[0]))
                DllEntry.database.Add(keyAndValue[0], keyAndValue[1]);
            else
                DllEntry.database[keyAndValue[0]] = keyAndValue[1];

            return "true";
        }

        [DllExport("Load")]
        public static string Load(string filename)
        {
            if (DllEntry.loadedDatabase == filename)
                return "true";

            using (FileStream fs = File.OpenRead(Path.Combine(DllEntry.databaseFolder, filename + ".clibdata")))
            {
                GZipStream cmp = new GZipStream(fs, CompressionLevel.Optimal);
                using (BinaryReader reader = new BinaryReader(cmp))
                {
                    int count = reader.ReadInt32();
                    DllEntry.database = new Dictionary<string, string>(count);
                    for (int i = 0; i < count; i++)
                    {
                        string key = reader.ReadString();
                        string value = reader.ReadString();
                        DllEntry.database.Add(key, value);
                    }
                }
            }

            DllEntry.loadedDatabase = filename;
            return "true";
        }

        [DllExport("Save")]
        public static string Save(string filename)
        {
            using (FileStream fs = File.OpenWrite(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".clibdata")))
            {
                GZipStream dcmp = new GZipStream(fs, CompressionMode.Decompress);

                using (BinaryWriter writer = new BinaryWriter(dcmp))
                {
                    writer.Write(DllEntry.database.Count);
                    foreach (var pair in DllEntry.database)
                    {
                        writer.Write(pair.Key);
                        writer.Write(pair.Value);
                    }
                }
                return "true";
            }
        }

        private static JSONNode ConvertToJson()
        {
            JSONNode json = JSON.Parse("{}");
            foreach (var item in database)
            {
                json.Add(item.Key, item.Value);
            }
            return json;
        }
        private static void ConvertToDictionary(JSONNode json)
        {
            database.Clear();
            foreach (var item in json.Linq)
            {
                database.Add(item.Key, item.Value.Value);
            }
        }
        #region Import/Export
        [DllExport("ExportJson")]
        public static string ExportJson(string filename)
        {
            JSONNode json = ConvertToJson();
            StringBuilder exportStringBuilder = new StringBuilder();
            json.WriteToStringBuilder(exportStringBuilder, 0, 4, JSONTextMode.Indent);
            File.WriteAllText(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".json"), exportStringBuilder.ToString());
            return "true";
        }

        [DllExport("ExportJsonBinary")]
        public static string ExportJsonBinary(string filename)
        {
            var json = ConvertToJson();
            json.SaveToCompressedFile(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".bson"));
            return "true";
        }

        [DllExport("ImportJson")]
        public static string ImportJson(string filename)
        {
            string jsonStr = File.ReadAllText(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".json"));
            JSONNode json = JSON.Parse(jsonStr);
            ConvertToDictionary(json);
            return "true";
        }

        [DllExport("ImportJsonBinary")]
        public static string ImportJsonBinary(string filename)
        {
            var json = JSONNode.LoadFromCompressedFile(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".bson"));
            ConvertToDictionary(json);
            return "true";
        }
        #endregion Import/Export

        ~DllEntry()
        {
            DllEntry.Save(DllEntry.loadedDatabase);
        }
    }
}

