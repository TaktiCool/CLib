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

#if Debug
            this.Show()
#else 
            this.Hide();
#endif
        }

        public void Toggle()
        {
            if (this.rtb_log.InvokeRequired)
            {
                try
                {
                    this.rtb_log.Invoke(new Action(delegate
                    {
                        this.Toggle();
                    }));
                }
                catch (ObjectDisposedException) {}
                return;
            }

            if (this.Visible)
            {
                this.Hide();
            }
            else
            {
                this.Show();
            }
        }

        public void Log(object obj)
        {
            if (this.rtb_log.InvokeRequired)
            {
                try
                {
                    this.rtb_log.Invoke(new Action(delegate {
                        this.Log(obj);
                    }));
                }
                catch (ObjectDisposedException) {}
                return;
            }

            this.rtb_log.AppendText(obj.ToString() + "\n");
        }

        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            if (this.rtb_log.InvokeRequired)
            {
                try
                {
                    this.rtb_log.Invoke(new Action(delegate
                    {
                        this.OnFormClosing(e);
                    }));
                }
                catch (ObjectDisposedException) {}
                return;
            }

            if (e.CloseReason != CloseReason.UserClosing)
            {
                this.Dispose(true);
                Application.Exit();
            }
            else
            {
                this.Hide();
            }
        }
    }
}
