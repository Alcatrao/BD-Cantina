namespace cantina
{
    partial class Form2
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
            this.Form2Ok = new System.Windows.Forms.Button();
            this.Form2Exit = new System.Windows.Forms.Button();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.txtClienteNif2 = new System.Windows.Forms.TextBox();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.txtClienteEmail2 = new System.Windows.Forms.TextBox();
            this.txtClienteLname2 = new System.Windows.Forms.TextBox();
            this.txtClienteFname2 = new System.Windows.Forms.TextBox();
            this.cbTipo = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // Form2Ok
            // 
            this.Form2Ok.Location = new System.Drawing.Point(151, 102);
            this.Form2Ok.Name = "Form2Ok";
            this.Form2Ok.Size = new System.Drawing.Size(75, 23);
            this.Form2Ok.TabIndex = 0;
            this.Form2Ok.Text = "Ok";
            this.Form2Ok.UseVisualStyleBackColor = true;
            this.Form2Ok.Click += new System.EventHandler(this.Form2Ok_Click);
            // 
            // Form2Exit
            // 
            this.Form2Exit.Location = new System.Drawing.Point(272, 102);
            this.Form2Exit.Name = "Form2Exit";
            this.Form2Exit.Size = new System.Drawing.Size(75, 23);
            this.Form2Exit.TabIndex = 5;
            this.Form2Exit.Text = "Cancelar";
            this.Form2Exit.UseVisualStyleBackColor = true;
            this.Form2Exit.Click += new System.EventHandler(this.Form2Exit_Click);
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(19, 62);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(88, 13);
            this.label8.TabIndex = 33;
            this.label8.Text = "Tipo (Obrigatório)";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(19, 11);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(80, 13);
            this.label9.TabIndex = 32;
            this.label9.Text = "Nif (Obrigatório)";
            // 
            // txtClienteNif2
            // 
            this.txtClienteNif2.Location = new System.Drawing.Point(117, 8);
            this.txtClienteNif2.Name = "txtClienteNif2";
            this.txtClienteNif2.ReadOnly = true;
            this.txtClienteNif2.Size = new System.Drawing.Size(100, 20);
            this.txtClienteNif2.TabIndex = 30;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(19, 37);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(92, 13);
            this.label10.TabIndex = 29;
            this.label10.Text = "Email (Obrigatório)";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(226, 37);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(90, 13);
            this.label11.TabIndex = 28;
            this.label11.Text = "Lname (Opcional)";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(226, 8);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(90, 13);
            this.label12.TabIndex = 27;
            this.label12.Text = "Fname (Opcional)";
            // 
            // txtClienteEmail2
            // 
            this.txtClienteEmail2.Location = new System.Drawing.Point(117, 34);
            this.txtClienteEmail2.Name = "txtClienteEmail2";
            this.txtClienteEmail2.Size = new System.Drawing.Size(100, 20);
            this.txtClienteEmail2.TabIndex = 26;
            // 
            // txtClienteLname2
            // 
            this.txtClienteLname2.Location = new System.Drawing.Point(331, 34);
            this.txtClienteLname2.Name = "txtClienteLname2";
            this.txtClienteLname2.Size = new System.Drawing.Size(100, 20);
            this.txtClienteLname2.TabIndex = 25;
            // 
            // txtClienteFname2
            // 
            this.txtClienteFname2.Location = new System.Drawing.Point(331, 8);
            this.txtClienteFname2.Name = "txtClienteFname2";
            this.txtClienteFname2.Size = new System.Drawing.Size(100, 20);
            this.txtClienteFname2.TabIndex = 24;
            // 
            // cbTipo
            // 
            this.cbTipo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbTipo.FormattingEnabled = true;
            this.cbTipo.Location = new System.Drawing.Point(117, 59);
            this.cbTipo.Name = "cbTipo";
            this.cbTipo.Size = new System.Drawing.Size(100, 21);
            this.cbTipo.TabIndex = 34;
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(459, 131);
            this.Controls.Add(this.cbTipo);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.txtClienteNif2);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.txtClienteEmail2);
            this.Controls.Add(this.txtClienteLname2);
            this.Controls.Add(this.txtClienteFname2);
            this.Controls.Add(this.Form2Exit);
            this.Controls.Add(this.Form2Ok);
            this.MaximizeBox = false;
            this.Name = "Form2";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form2";
            this.Load += new System.EventHandler(this.Form2_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Form2Ok;
        private System.Windows.Forms.Button Form2Exit;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.TextBox txtClienteNif2;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.TextBox txtClienteEmail2;
        private System.Windows.Forms.TextBox txtClienteLname2;
        private System.Windows.Forms.TextBox txtClienteFname2;
        private System.Windows.Forms.ComboBox cbTipo;
    }
}