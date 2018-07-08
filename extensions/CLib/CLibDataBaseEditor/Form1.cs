using SimpleJSON;
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Windows.Forms;
using System.Xml.Linq;

namespace CLibDataBaseEditor
{
    public partial class Form1 : Form
    {
        private readonly Dictionary<string, string> database = new Dictionary<string, string>();

        public Form1()
        {
            InitializeComponent();
        }

        #region Events

        private void OpenToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
            LoadFile(openFileDialog1.FileName);
            saveFileDialog1.FileName = openFileDialog1.FileName;
            FillDataGrid();
        }

        private void SaveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog1.ShowDialog();
            openFileDialog1.FileName = saveFileDialog1.FileName;
            SaveFile(saveFileDialog1.FileName);
        }

        private void ExitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Close();
            Environment.Exit(0);
        }

        #endregion Events

        #region Functions

        private void FillDataGrid()
        {
            dataGridView1.Rows.Clear();
            foreach (KeyValuePair<string, string> item in database)
            {
                dataGridView1.Rows.Add(item.Key, item.Value);
            }

            dataGridView1.AutoResizeRows();
            dataGridView1.AutoResizeColumns();
            dataGridView1.Update();
        }
        private void LoadFile(string filePath)
        {
            database.Clear();
            switch (Path.GetExtension(filePath))
            {
                case ".json":
                    ImportJson(filePath);
                    break;
                case ".bson":
                    ImportJsonBinary(filePath);
                    break;
                case ".clibdata":
                    ImportDataBase(filePath);
                    break;
                case ".xml":
                    ImportXml(filePath);
                    break;
            }
        }
        private void SaveFile(string filePath)
        {
            database.Clear();
            foreach (DataGridViewRow item in dataGridView1.Rows)
            {
                string key = item.Cells[0].EditedFormattedValue.ToString();
                string value = item.Cells[1].EditedFormattedValue.ToString();
                if (!(database.ContainsKey(key) || string.IsNullOrEmpty(key)))
                {
                    database.Add(key, value);
                }
            }

            database.Remove("");
            switch (Path.GetExtension(filePath))
            {
                case ".json":
                    ExportJson(filePath);
                    break;
                case ".bson":
                    ExportJsonBinary(filePath);
                    break;
                case ".clibdata":
                    ExportDatabase(filePath);
                    break;
                case ".xml":
                    ExportXml(filePath);
                    break;
            }
        }

        #region Convertion
        private JSONNode ConvertToJson()
        {
            JSONNode json = JSON.Parse("{}");
            foreach (KeyValuePair<string, string> item in database)
            {
                json.Add(item.Key, new JSONString(item.Value));
            }

            return json;
        }
        private XDocument ConvertToXML()
        {
            XDocument xml = new XDocument();
            foreach (KeyValuePair<string, string> item in database)
            {
                xml.Add(item.Key, new JSONString(item.Value));
            }
            return xml;
        }
        private void ConvertToDictionary(JSONNode json)
        {
            database.Clear();
            foreach (KeyValuePair<string, JSONNode> item in json.Linq)
            {
                database.Add(item.Key, item.Value.Value);
            }
        }
        private void ConvertToDictionary(XContainer xml)
        {
            database.Clear();
            foreach (XElement item in xml.Elements())
            {
                database.Add(item.Name.LocalName, item.Value);
            }
        }

        #endregion Convertion

        #region Import/Export

        private void ExportJson(string filePath)
        {
            JSONNode json = ConvertToJson();
            File.WriteAllText(filePath, json.ToString(4));
        }
        private void ExportJsonBinary(string filePath)
        {
            JSONNode json = ConvertToJson();
            json.SaveToCompressedFile(filePath);
        }
        private void ExportDatabase(string filePath)
        {
            using (FileStream fs = File.OpenWrite(filePath))
            {
                GZipStream dcmp = new GZipStream(fs, CompressionLevel.Optimal);

                using (BinaryWriter writer = new BinaryWriter(dcmp))
                {
                    writer.Write(database.Count);
                    foreach (KeyValuePair<string, string> pair in database)
                    {
                        writer.Write(pair.Key);
                        writer.Write(pair.Value);
                    }
                }
            }
        }
        private void ExportXml(string filePath)
        {
            XDocument xml = ConvertToXML();
            xml.Save(filePath, SaveOptions.OmitDuplicateNamespaces);
        }
        private void ImportJson(string filePath)
        {
            string jsonStr = File.ReadAllText(filePath);
            JSONNode json = JSON.Parse(jsonStr);
            ConvertToDictionary(json);
        }
        private void ImportJsonBinary(string filePath)
        {
            JSONNode json = JSONNode.LoadFromCompressedFile(filePath);
            ConvertToDictionary(json);
        }
        private void ImportDataBase(string filePath)
        {
            using (FileStream fs = File.OpenRead(filePath))
            {
                GZipStream cmp = new GZipStream(fs, CompressionMode.Decompress);
                using (BinaryReader reader = new BinaryReader(cmp))
                {
                    int count = reader.ReadInt32();
                    for (int i = 0; i < count; i++)
                    {
                        string key = reader.ReadString();
                        string value = reader.ReadString();
                        database.Add(key, value);
                    }
                }
            }
        }
        private void ImportXml(string filePath)
        {
            XDocument xml = XDocument.Load(filePath);
            ConvertToDictionary(xml);
        }
        #endregion Import/Export

        #endregion Functions
    }
}