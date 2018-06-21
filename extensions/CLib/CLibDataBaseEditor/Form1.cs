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

namespace CLibDataBaseEditor
{
    public partial class Form1 : Form
    {

        private Dictionary<string, string> Dict = new Dictionary<string, string>();
        public Form1()
        {
            InitializeComponent();
        }

        #region Events
        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
            loadFile(openFileDialog1.FileName);
            fillDataGrid();
        }
        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog1.ShowDialog();
            saveFile(saveFileDialog1.FileName);
        }
        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Close();
            Environment.Exit(0);
        }
        #endregion Events
        #region Functions
        public void fillDataGrid()
        {
            dataGridView1.Rows.Clear();
            foreach (var item in Dict)
            {
                dataGridView1.Rows.Add(new string[] { item.Key, item.Value });
            }
            dataGridView1.AutoResizeRows();
            dataGridView1.AutoResizeColumns();
            dataGridView1.Update();
        }
        public void loadFile(string filePath)
        {
            Dict.Clear();

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
                        Dict.Add(key, value);
                    }
                }
            }
        }
        public void saveFile(string filePath)
        {
            Dict.Clear();
            foreach (DataGridViewRow item in dataGridView1.Rows)
            {
                string key = item.Cells[0].EditedFormattedValue.ToString();
                string value = item.Cells[1].EditedFormattedValue.ToString();
                if (!(Dict.ContainsKey(key) || String.IsNullOrEmpty(key)))
                {
                    Dict.Add(key, value);
                }
            }
            Dict.Remove("");
            using (FileStream fs = File.OpenWrite(filePath))
            {
                GZipStream dcmp = new GZipStream(fs, CompressionLevel.Optimal);

                using (BinaryWriter writer = new BinaryWriter(dcmp))
                {
                    writer.Write(Dict.Count);
                    foreach (var pair in Dict)
                    {
                        writer.Write(pair.Key);
                        writer.Write(pair.Value);
                    }
                }
            }
        }
        #endregion Functions
    }
}
