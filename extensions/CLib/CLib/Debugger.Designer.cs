namespace CLib
{
    partial class Debugger
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.rtb_log = new System.Windows.Forms.RichTextBox();
            this.SuspendLayout();
            // 
            // rtb_log
            // 
            this.rtb_log.BackColor = System.Drawing.Color.Black;
            this.rtb_log.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.rtb_log.ForeColor = System.Drawing.Color.Lime;
            this.rtb_log.Location = new System.Drawing.Point(12, 12);
            this.rtb_log.Name = "rtb_log";
            this.rtb_log.Size = new System.Drawing.Size(639, 237);
            this.rtb_log.TabIndex = 0;
            this.rtb_log.Text = "";
            // 
            // Debugger
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(663, 261);
            this.Controls.Add(this.rtb_log);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "Debugger";
            this.Text = "Debugger";
            this.TopMost = true;
            this.ResumeLayout(false);
        }

        #endregion

        private System.Windows.Forms.RichTextBox rtb_log;
    }
}