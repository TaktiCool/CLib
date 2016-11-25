using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CLib
{
    public partial class Debugger : Form
    {
        public Debugger()
        {
            InitializeComponent();
        }

        public void Log(object obj)
        {
            this.rtb_log.AppendText(obj.ToString() + "\n");
        }

        private void rtb_log_TextChanged(object sender, EventArgs e)
        {
            this.rtb_log.SelectionStart = this.rtb_log.Text.Length;
            this.rtb_log.ScrollToCaret();
        }
    }
}
