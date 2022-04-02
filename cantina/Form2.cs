using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace cantina
{
    public partial class Form2 : Form
    {
        private String pFid;
        private String pa;
        private SqlConnection cn;

        public Form2(string Nif, String Fid, String a)
        {
            InitializeComponent();
            txtClienteNif2.Text = Nif;
            pFid = Fid;
            pa = a;
        }

        private SqlConnection getSGBDConnection()
        {
            return new SqlConnection("data source=tcp:mednat.ieeta.pt\\SQLSERVER,8101;initial catalog=p2g8;User ID=p2g8;Password=Bd28jl.");
        }

        //verificar conecção com base de dados
        private bool verifySGBDConnection()
        {
            if (cn == null)
                cn = getSGBDConnection();

            if (cn.State != ConnectionState.Open)
                cn.Open();

            return cn.State == ConnectionState.Open;
        }

        private void Form2_Load(object sender, EventArgs e) 
        {
            cn = getSGBDConnection();
            load_comboBox();
        }

        private void load_comboBox()
        {
            if (!verifySGBDConnection())
                return;

            cbTipo.Items.Clear();

            SqlCommand cmdTipo = new SqlCommand("Select_Tipo_Cliente", cn);
            cmdTipo.CommandType = CommandType.StoredProcedure;
            SqlDataReader readerCb = cmdTipo.ExecuteReader();

            while (readerCb.Read())
            {
                string num = readerCb["Id"].ToString();
                string nome = readerCb["Nome"].ToString();
                cbTipo.Items.Add(num + "-" + nome);
            }
            cbTipo.SelectedItem = cbTipo.Items[0];

            readerCb.Close();
        }

        private void Form2Ok_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            try
            {


                if (txtClienteEmail2.Text.Length < 1)
                {
                    MessageBox.Show("Email inválido");
                    return;
                }


                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "Insert_Compra_E_Cliente";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@fid", pFid);
                cmd.Parameters.AddWithValue("@Id", txtClienteNif2.Text);
                cmd.Parameters.AddWithValue("@string", pa);
                cmd.Parameters.AddWithValue("@email", txtClienteEmail2.Text);
                cmd.Parameters.AddWithValue("@tipo", cbTipo.SelectedItem.ToString()[0]);

                cmd.Parameters.AddWithValue("Fname", txtClienteFname2.Text);
                cmd.Parameters.AddWithValue("Lname", txtClienteLname2.Text);
                cmd.Connection = cn;

                try
                {
                    cmd.ExecuteNonQuery();
                    MessageBox.Show("Venda inserida!");

                }
                catch (Exception ex)
                {
                    throw new Exception("Erro ao atualizar compra na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
                }
                finally
                {
                    cn.Close();
                    this.Close();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Erro! \n" + ex.Message);
            }
        }

        private void Form2Exit_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
