using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using SimpleJSON;

namespace CLibDatabase
{
    public class DllEntry
    {
        private static string loadedDatabase = "";

        private static readonly string databaseFolder =
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase");

        private static Dictionary<string, string> database = new Dictionary<string, string>();

        static DllEntry()
        {
            if (!Directory.Exists(databaseFolder))
                Directory.CreateDirectory(databaseFolder);
        }

#if WIN64
        [DllExport("RVExtensionVersion")]
#else
        [DllExport("_RVExtensionVersion@8", CallingConvention.StdCall)]
#endif
        public static void RVExtensionVersion(StringBuilder output, int outputSize)
        {
            output.Append(GetVersion());
        }

#if WIN64
        [DllExport("RVExtension")]
#else
        [DllExport("_RVExtension@12", CallingConvention.StdCall)]
#endif
        public static void RVExtension(StringBuilder output, int outputSize,
            [MarshalAs(UnmanagedType.LPStr)] string input)
        {
            if (input.ToLower() != "version")
                return;

            output.Append(GetVersion());
        }

        private static string GetVersion()
        {
            Assembly executingAssembly = Assembly.GetExecutingAssembly();
            try
            {
                string location = executingAssembly.Location;
                if (location == null)
                    throw new Exception("Assembly location not found");
                return FileVersionInfo.GetVersionInfo(location).FileVersion;
            }
            catch (Exception)
            {
            }

            return "0.0.0.0";
        }

        [DllExport("KeyExists")]
        public static string KeyExists(string key)
        {
            return database.ContainsKey(key).ToString();
        }

        [DllExport("Get")]
        public static string Get(string key)
        {
            if (!database.ContainsKey(key))
                return "ERROR";
            return database[key];
        }

        [DllExport("Set")]
        public static string Set(string input)
        {
            string[] keyAndValue = input.Split(new[] {"~>"}, StringSplitOptions.RemoveEmptyEntries);
            if (!database.ContainsKey(keyAndValue[0]))
                database.Add(keyAndValue[0], keyAndValue[1]);
            else
                database[keyAndValue[0]] = keyAndValue[1];

            return "true";
        }

        [DllExport("Load")]
        public static string Load(string filename)
        {
            if (loadedDatabase == filename)
                return "true";

            using (FileStream fs = File.OpenRead(Path.Combine(databaseFolder, filename + ".clibdata")))
            {
                GZipStream cmp = new GZipStream(fs, CompressionLevel.Optimal);
                using (BinaryReader reader = new BinaryReader(cmp))
                {
                    int count = reader.ReadInt32();
                    database = new Dictionary<string, string>(count);
                    for (int i = 0; i < count; i++)
                    {
                        string key = reader.ReadString();
                        string value = reader.ReadString();
                        database.Add(key, value);
                    }
                }
            }

            loadedDatabase = filename;
            return "true";
        }

        [DllExport("Save")]
        public static string Save(string filename)
        {
            using (FileStream fs = File.OpenWrite(Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase",
                filename + ".clibdata")))
            {
                GZipStream dcmp = new GZipStream(fs, CompressionMode.Decompress);

                using (BinaryWriter writer = new BinaryWriter(dcmp))
                {
                    writer.Write(database.Count);
                    foreach (KeyValuePair<string, string> pair in database)
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
            foreach (KeyValuePair<string, string> item in database) json.Add(item.Key, item.Value);
            return json;
        }

        private static void ConvertToDictionary(JSONNode json)
        {
            database.Clear();
            foreach (KeyValuePair<string, JSONNode> item in json.Linq) database.Add(item.Key, item.Value.Value);
        }

        #region Import/Export

        [DllExport("ExportJson")]
        public static string ExportJson(string filename)
        {
            JSONNode json = ConvertToJson();
            StringBuilder exportStringBuilder = new StringBuilder();
            json.WriteToStringBuilder(exportStringBuilder, 0, 4, JSONTextMode.Indent);
            File.WriteAllText(
                Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase",
                    filename + ".json"), exportStringBuilder.ToString());
            return "true";
        }

        [DllExport("ExportJsonBinary")]
        public static string ExportJsonBinary(string filename)
        {
            JSONNode json = ConvertToJson();
            json.SaveToCompressedFile(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "CLibDatabase", filename + ".bson"));
            return "true";
        }

        [DllExport("ImportJson")]
        public static string ImportJson(string filename)
        {
            string jsonStr = File.ReadAllText(Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase",
                filename + ".json"));
            JSONNode json = JSON.Parse(jsonStr);
            ConvertToDictionary(json);
            return "true";
        }

        [DllExport("ImportJsonBinary")]
        public static string ImportJsonBinary(string filename)
        {
            JSONNode json = JSONNode.LoadFromCompressedFile(Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase",
                filename + ".bson"));
            ConvertToDictionary(json);
            return "true";
        }

        #endregion Import/Export

        ~DllEntry()
        {
            Save(loadedDatabase);
        }
    }
}