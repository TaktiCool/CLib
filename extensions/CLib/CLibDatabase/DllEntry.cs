using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Xml.Linq;
using SimpleJSON;

namespace CLibDatabase {
    // ReSharper disable once UnusedMember.Global
    public class DllEntry {
        private static string loadedDatabase = "";
        private static readonly string DatabaseFolder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase");
        private static Dictionary<string, string> database = new Dictionary<string, string>();

        static DllEntry() {
            if (!Directory.Exists(DatabaseFolder))
                Directory.CreateDirectory(DatabaseFolder);
        }

#if WIN64
        [DllExport("RVExtensionVersion")]
#else
        [DllExport("_RVExtensionVersion@8", CallingConvention.StdCall)]
#endif
        // ReSharper disable once InconsistentNaming
        // ReSharper disable once UnusedMember.Global
        // ReSharper disable once UnusedParameter.Global
        public static void RVExtensionVersion(StringBuilder output, int outputSize) {
            output.Append(GetVersion());
        }

#if WIN64
        [DllExport("RVExtension")]
#else
        [DllExport("_RVExtension@12", CallingConvention.StdCall)]
#endif
        // ReSharper disable once InconsistentNaming
        // ReSharper disable once UnusedMember.Global
        // ReSharper disable once UnusedParameter.Global
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string input) {
            if (input.ToLower() != "version")
                return;

            output.Append(GetVersion());
        }

        private static string GetVersion() {
            var executingAssembly = Assembly.GetExecutingAssembly();
            try {
                var location = executingAssembly.Location;
                return FileVersionInfo.GetVersionInfo(location).FileVersion;
            } catch (Exception) {
                // ignored
            }

            return "0.0.0.0";
        }
        [DllExport("SetExportPath")]
        public static string SetExportPath(string path)
        {
            databaseFolder = path;
            if (!Directory.Exists(databaseFolder))
                Directory.CreateDirectory(databaseFolder);
            return "true";
        }

        [DllExport("KeyExists")]
        // ReSharper disable once UnusedMember.Global
        public static string KeyExists(string key) {
            return database.ContainsKey(key).ToString();
        }

        [DllExport("Get")]
        // ReSharper disable once UnusedMember.Global
        public static string Get(string key) {
            return !database.ContainsKey(key) ? "ERROR" : database[key];
        }

        [DllExport("Set")]
        // ReSharper disable once UnusedMember.Global
        public static string Set(string input) {
            var keyAndValue = input.Split(new[] {"~>"}, StringSplitOptions.RemoveEmptyEntries);
            if (!database.ContainsKey(keyAndValue[0]))
                database.Add(keyAndValue[0], keyAndValue[1]);
            else
                database[keyAndValue[0]] = keyAndValue[1];

            return "true";
        }

        [DllExport("Load")]
        // ReSharper disable once UnusedMember.Global
        public static string Load(string filename) {
            if (loadedDatabase == filename)
                return "true";

            using (var fs = File.OpenRead(Path.Combine(DatabaseFolder, filename + ".clibdata")))
            using (var gZipStream = new GZipStream(fs, CompressionLevel.Optimal))
            using (var reader = new BinaryReader(gZipStream)) {
                var count = reader.ReadInt32();
                database = new Dictionary<string, string>(count);
                for (var i = 0; i < count; i++) {
                    var key = reader.ReadString();
                    var value = reader.ReadString();
                    database.Add(key, value);
                }
            }

            loadedDatabase = filename;
            return "true";
        }

        [DllExport("Save")]
        // ReSharper disable once UnusedMember.Global
        // ReSharper disable once MemberCanBePrivate.Global
        // ReSharper disable once UnusedMethodReturnValue.Global
        public static string Save(string filename) {
            using (var fs = File.OpenWrite(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".clibdata")))
            using (var gZipStream = new GZipStream(fs, CompressionMode.Decompress))
            using (var writer = new BinaryWriter(gZipStream)) {
                writer.Write(database.Count);
                foreach (var pair in database) {
                    writer.Write(pair.Key);
                    writer.Write(pair.Value);
                }
                return "true";
            }
        }

        private static JSONNode ConvertToJson() {
            var json = JSON.Parse("{}");
            foreach (var item in database)
                json.Add(item.Key, item.Value);
            return json;
        }

        private static void ConvertToDictionary(JSONNode json) {
            database.Clear();
            foreach (var item in json.Linq)
                database.Add(item.Key, item.Value.Value);
        }

        private static void ConvertToDictionary(XContainer xml)
        {
            database.Clear();
            foreach (XElement item in xml.Elements())
            {
                database.Add(item.Name.LocalName, item.Value);
            }
        }
        private static XDocument ConvertToXML()
        {
            XDocument xml = new XDocument();
            foreach (KeyValuePair<string, string> item in database)
            {
                xml.Add(item.Key, new JSONString(item.Value));
            }
            return xml;
        }
        #region Import/Export
        [DllExport("ExportJson")]
        // ReSharper disable once UnusedMember.Global
        public static string ExportJson(string filename) {
            var json = ConvertToJson();
            var exportStringBuilder = new StringBuilder();
            json.WriteToStringBuilder(exportStringBuilder, 0, 4, JSONTextMode.Indent);
            File.WriteAllText(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".json"), exportStringBuilder.ToString());
            return "true";
        }

        [DllExport("ExportJsonBinary")]
        // ReSharper disable once UnusedMember.Global
        public static string ExportJsonBinary(string filename) {
            var json = ConvertToJson();
            json.SaveToCompressedFile(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".bson"));
            return "true";
        }

        [DllExport("ImportJson")]
        // ReSharper disable once UnusedMember.Global
        public static string ImportJson(string filename) {
            var jsonStr = File.ReadAllText(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".json"));
            var json = JSON.Parse(jsonStr);
            ConvertToDictionary(json);
            return "true";
        }

        [DllExport("ImportJsonBinary")]
        // ReSharper disable once UnusedMember.Global
        public static string ImportJsonBinary(string filename) {
            var json = JSONNode.LoadFromCompressedFile(Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "CLibDatabase", filename + ".bson"));
            ConvertToDictionary(json);
            return "true";
        }
        #endregion Import/Export

        ~DllEntry() {
            Save(loadedDatabase);
        }
    }
}
