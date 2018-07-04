using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using SimpleJSON;

namespace CLibDataBaseEditor
{
    public partial class Form1 : Form
    {

        private Dictionary<string, string> database = new Dictionary<string, string>();
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
            this.Close();
            Environment.Exit(0);
        }
        #endregion Events
        #region Functions
        public void FillDataGrid()
        {
            dataGridView1.Rows.Clear();
            foreach (var item in database)
            {
                dataGridView1.Rows.Add(new string[] { item.Key, item.Value });
            }
            dataGridView1.AutoResizeRows();
            dataGridView1.AutoResizeColumns();
            dataGridView1.Update();
        }
        public void LoadFile(string filePath)
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
                default:
                    break;
            }
        }
        public void SaveFile(string filePath)
        {
            database.Clear();
            foreach (DataGridViewRow item in dataGridView1.Rows)
            {
                string key = item.Cells[0].EditedFormattedValue.ToString();
                string value = item.Cells[1].EditedFormattedValue.ToString();
                if (!(database.ContainsKey(key) || String.IsNullOrEmpty(key)))
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
                default:
                    break;
            }
        }

        private JSONNode ConvertToJson()
        {
            JSONNode json = JSON.Parse("{}");
            foreach (var item in database)
            {
                json.Add(item.Key, new JSONString(item.Value));
                
            }
            return json;
        }

        private void ConvertToDictionary(JSONNode json)
        {
            database.Clear();
            foreach (var item in json.Linq)
            {
                database.Add(item.Key, item.Value.Value);
            }
        }

        #region Import/Export
        public void ExportJson(string filePath)
        {
            JSONNode json = ConvertToJson();
            File.WriteAllText(filePath, json.ToString(4));
        }

        public void ExportJsonBinary(string filePath)
        {
            var json = ConvertToJson();
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
                    foreach (var pair in database)
                    {
                        writer.Write(pair.Key);
                        writer.Write(pair.Value);
                    }
                }
            }
        }

        public void ImportJson(string filePath)
        {
            string jsonStr = File.ReadAllText(filePath);
            JSONNode json = JSON.Parse(jsonStr);
            ConvertToDictionary(json);
        }

        public void ImportJsonBinary(string filePath)
        {
            var json = JSONNode.LoadFromCompressedFile(filePath);
            ConvertToDictionary(json);
        }

        public void ImportDataBase(string filePath)
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
        #endregion Import/Export


        #endregion Functions

    }
}
