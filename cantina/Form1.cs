using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Collections;
using System.Text.RegularExpressions;
using System.Transactions;

namespace cantina
{
    public partial class Form1 : Form
    {
        private SqlConnection cn;
        private int currentFuncionario;
        private bool adding;
        private Dictionary<int, HashSet<Turno_Atribuido>> dicionarioTA = new Dictionary<int, HashSet<Turno_Atribuido>>();


        //iniciar design
        public Form1()
        {
            InitializeComponent();
        }

        //Carrega logo nas toolboxes a info do primeiro funcionário
        private void Form1_Load(object sender, EventArgs e)
        {
            cn = getSGBDConnection();
            loadFuncionarioToolStripMenuItem_Click(null, new EventArgs());
        }

        //estabelecer ligação com esta base de dados
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


        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        //FALTA TANSACTION [feito]
        //carregar informação quando se entra na tab dos funcionários
        private void tabPage1_Enter(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            using (TransactionScope tran = new TransactionScope())
            {
                if (cn != null)
                    cn.EnlistTransaction(Transaction.Current);

                //SqlCommand cmd = new SqlCommand("SELECT * FROM Cantina.FUNCIONARIO LEFT OUTER JOIN Cantina.TURNO_ATRIBUIDO", cn);
                SqlCommand cmd = new SqlCommand("Select_Funcionario", cn);
                cmd.CommandType = CommandType.StoredProcedure;



                SqlDataReader reader = cmd.ExecuteReader();
                listBox1.Items.Clear();


                while (reader.Read())
                {
                    Funcionario F = new Funcionario();
                    F.Id = int.Parse(reader["Id"].ToString());
                    F.Ccodigo = reader["Ccodigo"].ToString();
                    F.Email = reader["Email"].ToString();
                    F.Fname = reader["Fname"].ToString();
                    F.Lname = reader["Lname"].ToString();
                    F.Salario = Double.Parse(reader["Salario"].ToString());

                    //  F.Fid = int.Parse(reader["Fid"].ToString());
                    // F.Datahora_inicio = reader["Datahora_inicio"].ToString();
                    //F.Datahora_fim = reader["Datahora_fim"].ToString();

                    listBox1.Items.Add(F);
                }


                //cn.Close();
                reader.Close();






                // carregar turnos para a checkedBox1
                SqlCommand cmdTurno = new SqlCommand("Select_Turno", cn);
                cmdTurno.CommandType = CommandType.StoredProcedure;
                SqlDataReader readerTurno = cmdTurno.ExecuteReader();
                checkedListBox1.Items.Clear();

                if (readerTurno != null && readerTurno.HasRows)
                {
                    while (readerTurno.Read())
                    {
                        Turno T = new Turno();
                        T.Datahora_inicio = readerTurno["Datahora_inicio"].ToString();
                        T.Datahora_fim = readerTurno["Datahora_fim"].ToString();

                        checkedListBox1.Items.Add(T);
                    }
                    readerTurno.Close();
                }



                // carregar turnos atribuidos
                SqlCommand cmdTA = new SqlCommand("Select_Turno_Atribuido", cn);
                cmdTA.CommandType = CommandType.StoredProcedure;
                SqlDataReader readerTA = cmdTA.ExecuteReader();

                while (readerTA.Read())
                {
                    Turno_Atribuido TA = new Turno_Atribuido();
                    TA.Fid = int.Parse(readerTA["Fid"].ToString());
                    TA.Datahora_inicio = readerTA["Datahora_inicio"].ToString();
                    TA.Datahora_fim = readerTA["Datahora_fim"].ToString();

                    if (!dicionarioTA.ContainsKey(TA.Fid))
                    {
                        dicionarioTA.Add(TA.Fid, new HashSet<Turno_Atribuido>());
                        dicionarioTA[TA.Fid].Add(TA);
                    }
                    else
                    {
                        dicionarioTA[TA.Fid].Add(TA);
                    }


                }
                readerTA.Close();
                //  }

                /*
                foreach (KeyValuePair<int, HashSet<Turno_Atribuido>> i in dicionarioTA)
                {
                    Console.WriteLine(i.Key + "\t" + i.Value[1]);

                }
                */




                // carregar combobox de cargos
                SqlCommand cmdCb = new SqlCommand("Select_Cargo", cn);
                cmdCb.CommandType = CommandType.StoredProcedure;
                SqlDataReader readerCb = cmdCb.ExecuteReader();
                comboBoxCargo.Items.Clear();


                while (readerCb.Read())
                {
                    comboBoxCargo.Items.Add(readerCb["Codigo"].ToString().ToLower());
                }

                readerCb.Close();
                cn.Close();

                tran.Complete();
            }

        }


        //load dos dados para as toolboxes do funcionário
        private void loadFuncionarioToolStripMenuItem_Click(object sender, EventArgs e)
        {
 
            tabPage1_Enter(sender, e);
        }


        //info de (cada) funcionário
        public void ShowFuncionario()
        {
            if (listBox1.Items.Count == 0 | currentFuncionario < 0)
                return;
            Funcionario func = new Funcionario();
            func = (Funcionario)listBox1.Items[currentFuncionario];
            txtFname.Text = func.Fname;
            txtLname.Text = func.Lname;
            txtEmail.Text = func.Email;
            txtId.Text = func.Id.ToString();
            comboBoxCargo.SelectedItem = func.Ccodigo.ToLower();
            txtSalario.Text = func.Salario.ToString();

            //turnos
            for (int idxCheck = 0; idxCheck<checkedListBox1.Items.Count; idxCheck++)
            {
                checkedListBox1.SetItemChecked(idxCheck, false);


                Turno telio = new Turno();
                telio = (Turno)checkedListBox1.Items[idxCheck];

                String telioInicio = telio.Datahora_inicio;
                String telioFim = telio.Datahora_fim;
      
                Turno_Atribuido telisma = new Turno_Atribuido();
                telisma.Datahora_inicio = telioInicio;
                telisma.Datahora_fim = telioFim;
                telisma.Fid = func.Id;

                if (dicionarioTA.ContainsKey(func.Id))
                {
  
                    HashSet<Turno_Atribuido> Set_Turno_Atribuido = new HashSet<Turno_Atribuido>();
                    Set_Turno_Atribuido = dicionarioTA[func.Id];

                    foreach (Turno_Atribuido i in Set_Turno_Atribuido)
                    {
                        if (i.Datahora_inicio.Equals(telisma.Datahora_inicio) && i.Datahora_fim.Equals(telisma.Datahora_fim)) {
                            checkedListBox1.SetItemChecked(idxCheck, true);
                        }

                    }
                }
            }

          


        }

        //update da info de cada funcionário conforme a seleção de funcionario no painel da esquerda
        private void listBox1_SelectedIndexChanged_1(object sender, EventArgs e)
        {
            if (listBox1.SelectedIndex >= 0)
            {
                currentFuncionario = listBox1.SelectedIndex;
                ShowFuncionario();
            }

        }


        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox6_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox5_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
                try
                {
                    SaveFuncionario();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
                listBox1.Enabled = true;
                int idx = listBox1.FindString(txtId.Text);
                listBox1.SelectedIndex = idx;
                ShowButtons();
        }


        private void SubmitFuncionario(Funcionario F, String a)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Submit_Funcionario";
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Clear();
           // cmd.Parameters.AddWithValue("@Id", F.Id);
            cmd.Parameters.AddWithValue("@Fname", F.Fname);
            cmd.Parameters.AddWithValue("@Lname", F.Lname);
            cmd.Parameters.AddWithValue("@Salario", F.Salario);
            cmd.Parameters.AddWithValue("@Email", F.Email);
            cmd.Parameters.AddWithValue("@Ccodigo", F.Ccodigo);

            cmd.Parameters.AddWithValue("@string", a);
            cmd.Connection = cn;


            try
            {
                IdFuncReturned = Convert.ToInt32(cmd.ExecuteScalar());
              //  cmd.ExecuteNonQuery();
                F.Id = IdFuncReturned;
                //MessageBox.Show(F.Id.ToString());
            }
            catch (Exception ex)
            {
                throw new Exception("Id: " + F.Id + "\nErro ao atualizar contacto na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void UpdateFuncionario(Funcionario F)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Update_Funcionario";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", F.Id);
            cmd.Parameters.AddWithValue("@Fname", F.Fname);
            cmd.Parameters.AddWithValue("@Lname", F.Lname);
            cmd.Parameters.AddWithValue("@Salario", F.Salario);
            cmd.Parameters.AddWithValue("@Email", F.Email);
            cmd.Parameters.AddWithValue("@Ccodigo", F.Ccodigo);
            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
                MessageBox.Show("Sucesso!");
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao atualizar funcionário da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemoveFuncionario(string FuncionarioId)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Delete_Funcionario";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", FuncionarioId);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar funcionário da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        //turno_atribuido funções
        private void SubmitTurno_Atribuido(Turno_Atribuido TA)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd2 = new SqlCommand();

            cmd2.CommandText = "Submit_Turno_Atribuido";
            cmd2.CommandType = CommandType.StoredProcedure;
            cmd2.Parameters.Clear();
            cmd2.Parameters.AddWithValue("@Datahora_inicio", TA.Datahora_inicio);
            cmd2.Parameters.AddWithValue("@Datahora_fim", TA.Datahora_fim);
            cmd2.Parameters.AddWithValue("@Fid", TA.Fid);
            cmd2.Connection = cn;


            try
            {
                cmd2.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception(TA.Fid +" Erro ao atualizar turno atribuído na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemoveTurno_Atribuido(int Turno_Atribuido_Fid)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Delete_Turno_Atribuido";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Fid", Turno_Atribuido_Fid);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar turno atribuido da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        /*
        private void UpdateTurno_Atribuido(Turno_Atribuido TA)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "UPDATE Cantina.Turno_Atribuido SET Datahora_inicio = @Datahora_inicio, Datahora_fim= @Datahora_fim WHERE Fid = @Fid";
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Datahora_inicio", TA.Datahora_inicio);
            cmd.Parameters.AddWithValue("@Datahora_fim", TA.Datahora_fim);
            cmd.Parameters.AddWithValue("@Fid", TA.Fid);
            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao atualizar turno atribuído na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {

                if (rows == 1)
                    MessageBox.Show("Sucesso!");
                else
                    MessageBox.Show("Erro!");

                cn.Close();
            }
        }
        */









        // Helper routines

        public void LockControls()
        {
            txtId.ReadOnly = true;
            txtFname.ReadOnly = true;
            txtLname.ReadOnly = true;
            comboBoxCargo.Enabled = false;
            txtSalario.ReadOnly = true;
            txtEmail.ReadOnly = true;

            checkedListBox1.Enabled = false;


            txtClienteNif.ReadOnly = true;
            txtClienteFname.ReadOnly = true;
            txtClienteLname.ReadOnly = true;
            txtClienteTipo.ReadOnly = true;
            txtClienteEmail.ReadOnly = true;

            //ClienteSearchBox.ReadOnly = true;
        }

        public void UnlockControls()
        {
            
            if (adding == true)
            {
                //txtId.ReadOnly = false;
                txtClienteNif.ReadOnly = false;
            }
            checkedListBox1.Enabled = true;


            txtFname.ReadOnly = false;
            txtLname.ReadOnly = false;
            comboBoxCargo.Enabled = true;
            txtSalario.ReadOnly = false;
            txtEmail.ReadOnly = false;

            txtClienteFname.ReadOnly = false;
            txtClienteLname.ReadOnly = false;
            txtClienteTipo.ReadOnly = false;
            txtClienteEmail.ReadOnly = false;
           // ClienteSearchBox.ReadOnly = false;

        }

        public void ShowButtons()
        {
            LockControls();
            Adicionar.Visible = true;
            Eliminar.Visible = true;
            Editar.Visible = true;
            Ok.Visible = false;
            Cancelar.Visible = false;

            //ClienteAdd.Visible = true;
            ClienteDelete.Visible = true;
            ClienteEdit.Visible = true;
            ClienteOk.Visible = false;
            ClienteCancel.Visible = false;

            ClientePesquisar.Visible = true;
            label23.Visible = true;
            ClienteSearchBox.Visible = true;

        }

        public void ClearFields()
        {
            txtId.Text = "";
            txtFname.Text = "";
            txtLname.Text = "";
            txtSalario.Text = "";
            txtEmail.Text = "";
            comboBoxCargo.SelectedIndex = 0;
            txtClienteNif.Text = "";
            txtClienteFname.Text = "";
            txtClienteLname.Text = "";
            txtClienteTipo.Text = "";
            txtClienteEmail.Text = "";
            checkedListBox1.ClearSelected();
        }

        public void HideButtons()
        {
            UnlockControls();
            Adicionar.Visible = false;
            Eliminar.Visible = false;
            Editar.Visible = false;
            Ok.Visible = true;
            Cancelar.Visible = true;

            //ClienteAdd.Visible = false;
            ClienteDelete.Visible = false;
            ClienteEdit.Visible = false;
            ClienteOk.Visible = true;
            ClienteCancel.Visible = true;

            ClientePesquisar.Visible = false;
            ClienteSearchBox.Visible = false;
            label23.Visible = false;



        }

        int IdFuncReturned;
        //FALTA TANSACTION [feito]
        private bool SaveFuncionario()
        {

            Funcionario func = new Funcionario();
            HashSet<Turno_Atribuido> SetT_A = new HashSet<Turno_Atribuido>();
 
            if (adding)
            {
                try
                {
                    //func.Id = int.Parse(txtId.Text);
                    func.Id = IdFuncReturned;
                    func.Fname = txtFname.Text;
                    func.Lname = txtLname.Text;
                    func.Salario = Double.Parse(txtSalario.Text);
                    func.Email = txtEmail.Text;
                    func.Ccodigo = comboBoxCargo.SelectedItem.ToString();

                    foreach (int idxCB1 in checkedListBox1.CheckedIndices)
                    {
                        Turno_Atribuido T_A = new Turno_Atribuido();
                        T_A.Datahora_inicio = checkedListBox1.Items[idxCB1].ToString().Split('-')[0];
                        T_A.Datahora_fim = checkedListBox1.Items[idxCB1].ToString().Split('-')[1];
                        T_A.Fid = func.Id;
                        SetT_A.Add(T_A);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(func.Id + ex.Message);
                    return false;
                }
                using (TransactionScope trans = new TransactionScope())
                {
                    String a = "";
                    foreach (Turno_Atribuido ta in SetT_A)
                    {
                        a = a + ta.Datahora_inicio + "," + ta.Datahora_fim + ",";
                    }
                    a = a.Substring(0, a.Length - 1);
                    SubmitFuncionario(func, a);
                    trans.Complete();
                }
            

                //listBox1.Items.Add(func);
                 
                tabPage1_Enter(null, null);
                //listBox1.Items[currentFuncionario] = func;
                currentFuncionario = listBox1.Items.Count-1;
                ShowFuncionario();
            }
            else
            {
                try
                {
                    func.Id = int.Parse(txtId.Text);
                    //func.Id = IdFuncReturned;
                    func.Fname = txtFname.Text;
                    func.Lname = txtLname.Text;
                    func.Salario = Double.Parse(txtSalario.Text);
                    func.Email = txtEmail.Text;
                    func.Ccodigo = comboBoxCargo.SelectedItem.ToString();

                    foreach (int idxCB1 in checkedListBox1.CheckedIndices)
                    {
                        Turno_Atribuido T_A = new Turno_Atribuido();
                        T_A.Datahora_inicio = checkedListBox1.Items[idxCB1].ToString().Split('-')[0];
                        T_A.Datahora_fim = checkedListBox1.Items[idxCB1].ToString().Split('-')[1];
                        T_A.Fid = func.Id;
                        SetT_A.Add(T_A);

                    }

                }
                catch (Exception ex)
                {
                    MessageBox.Show(func.Id + ex.Message);
                    return false;
                }
                using (TransactionScope trans = new TransactionScope())
                {
  
                    using (TransactionScope trans2 = new TransactionScope())
                    {
                        UpdateFuncionario(func);
                        RemoveTurno_Atribuido(func.Id);

                        trans2.Complete();
                    }


                    //atualizar checkedListBox1
                    dicionarioTA.Remove(func.Id);

                    foreach (Turno_Atribuido ta in SetT_A)
                    {
                        SubmitTurno_Atribuido(ta);
                        if (!dicionarioTA.ContainsKey(func.Id))
                        {
                            dicionarioTA.Add(func.Id, new HashSet<Turno_Atribuido>());
                        }
                        dicionarioTA[func.Id].Add(ta);
                    }

                    trans.Complete();
                }

                ShowFuncionario();
                //tabPage1_Enter(null, null);
                listBox1.Items[currentFuncionario] = func;

            }
            return true;
        }









        /* private void exitToolStripMenuItem_Click(object sender, EventArgs e)
         {
             Application.Exit();
         }
         */
        private void Adicionar_Click(object sender, EventArgs e)
        {
            adding = true;
            ClearFields();
            HideButtons();
            listBox1.Enabled = false;
        }


        private void Cancelar_Click(object sender, EventArgs e)
            {
                listBox1.Enabled = true;
                if (listBox1.Items.Count > 0)
                {
                    currentFuncionario = listBox1.SelectedIndex;
                    if (currentFuncionario < 0)
                        currentFuncionario = 0;
                    ShowFuncionario();
                }
                else
                {
                    ClearFields();
                    LockControls();
                }
                ShowButtons();
            }

        private void Eliminar_Click(object sender, EventArgs e)
        {
            if (listBox1.SelectedIndex > -1)
            {
                try
                {
                    RemoveTurno_Atribuido(((Funcionario)listBox1.SelectedItem).Id);
                    RemoveFuncionario(((Funcionario)listBox1.SelectedItem).Id.ToString());
                    checkedListBox1.ClearSelected();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    return;
                }
                listBox1.Items.RemoveAt(listBox1.SelectedIndex);
                if (currentFuncionario == listBox1.Items.Count)
                    currentFuncionario = listBox1.Items.Count - 1;
                if (currentFuncionario == -1)
                {
                    ClearFields();
                    MessageBox.Show("Não existem funcionários");
                }
                else
                {
                    ShowFuncionario();
                }
            }
        }

        private void Editar_Click(object sender, EventArgs e)
        {
            currentFuncionario = listBox1.SelectedIndex;
            if (currentFuncionario < 0) //tirei o =< e meti só <, porque pareceu-me que isto é que tava a bloquear a edição no contacto de indíce 0
            {
                MessageBox.Show("Selecione um funcionário para editar");
                return;
            }
            adding = false;
            HideButtons();
            listBox1.Enabled = false;
        }



        //TAB DOS CLIENTES

        public int currentCliente;

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox2.SelectedIndex >= 0)
            {
                currentCliente = listBox2.SelectedIndex;
                ShowCliente();
            }

        }

        //carregar informação quando se entra na tab dos clientes
        private void tabPage2_Enter(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            SqlCommand cmd = new SqlCommand("Select_Cliente", cn);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader = cmd.ExecuteReader();
            listBox2.Items.Clear();


            while (reader.Read())
            {
                Cliente C = new Cliente();
                C.Fname = reader["Fname"].ToString();
                C.Lname = reader["Lname"].ToString();
                C.Email = reader["Email"].ToString();
                C.Tipo = reader["Tipo"].ToString();
                C.Nif = reader["Nif"].ToString();
                C.Tipo_Nome = reader["Nome"].ToString();
                listBox2.Items.Add(C);
            }

            cn.Close();

            Console.WriteLine(cn);
        }
        
        //info de (cada) cliente
        public void ShowCliente()
        {
            if (listBox2.Items.Count == 0 | currentCliente < 0)
                return;
            Cliente clit = new Cliente();
            clit = (Cliente)listBox2.Items[currentCliente];
            txtClienteFname.Text = clit.Fname;
            txtClienteLname.Text = clit.Lname;
            txtClienteEmail.Text = clit.Email;
            txtClienteNif.Text = clit.Nif;
            txtClienteTipo.Text = clit.Tipo +" - "+clit.Tipo_Nome;

        }

        private void ClienteAdd_Click(object sender, EventArgs e)
        {
            adding = true;
            ClearFields();
            HideButtons();
            listBox2.Enabled = false;

        }

        private void ClienteEdit_Click(object sender, EventArgs e)
        {
            currentCliente = listBox2.SelectedIndex;
            if (currentCliente < 0) //tirei o =< e meti só <, porque pareceu-me que isto é que tava a bloquear a edição no contacto de indíce 0
            {
                MessageBox.Show("Selecione um cliente para editar");
                return;
            }
            adding = false;
            HideButtons();
            listBox2.Enabled = false;
        }

        private void ClienteDelete_Click(object sender, EventArgs e)
        {
            if (listBox2.SelectedIndex > -1)
            {
                try
                {
                    RemoveCliente(((Cliente)listBox2.SelectedItem).Nif);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    return;
                }
                listBox2.Items.RemoveAt(listBox2.SelectedIndex);
                if (currentCliente == listBox2.Items.Count)
                    currentCliente = listBox2.Items.Count - 1;
                if (currentCliente == -1)
                {
                    ClearFields();
                    MessageBox.Show("Não existem clientes");
                }
                else
                {
                    ShowCliente();
                }
            }

        }

        private void ClienteOk_Click(object sender, EventArgs e)
        {
            try
            {
                SaveCliente();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            listBox2.Enabled = true;
            int idx = listBox2.FindString(txtClienteNif.Text);
            listBox2.SelectedIndex = idx;
            ShowButtons();

        }

        private void ClienteCancel_Click(object sender, EventArgs e)
        {
            listBox2.Enabled = true;
            if (listBox2.Items.Count > 0)
            {
                currentCliente = listBox2.SelectedIndex;
                if (currentCliente < 0)
                    currentCliente = 0;
                ShowCliente();
            }
            else
            {
                ClearFields();
                LockControls();
            }
            ShowButtons();

        }


        private void SubmitCliente(Cliente C)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Submit_Cliente";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Nif", C.Nif);
            cmd.Parameters.AddWithValue("@Fname", C.Fname);
            cmd.Parameters.AddWithValue("@Lname", C.Lname);
            cmd.Parameters.AddWithValue("@Tipo", C.Tipo);
            cmd.Parameters.AddWithValue("@Email", C.Email);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao atualizar contacto na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void UpdateCliente(Cliente C)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Update_Cliente";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            //se editar 76763 para 7676 dá erro lmao, com o AddWithValue, tirar um dígito transforma tudo num nvarchar
            cmd.Parameters.AddWithValue("@Nif", C.Nif);
            cmd.Parameters.AddWithValue("@Fname", C.Fname);
            cmd.Parameters.AddWithValue("@Lname", C.Lname);
            cmd.Parameters.AddWithValue("@Tipo", C.Tipo);
            cmd.Parameters.AddWithValue("@Email", C.Email);
            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
                MessageBox.Show("Sucesso!");
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao atualizar cliente da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemoveCliente(string ClienteNif)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Delete_Cliente";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Nif", ClienteNif);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar cliente da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }


        }

        private bool SaveCliente()
        {
            Cliente clit = new Cliente();
            try
            {
                clit.Nif = txtClienteNif.Text;
                clit.Fname = txtClienteFname.Text;
                clit.Lname = txtClienteLname.Text;
                clit.Tipo = txtClienteTipo.Text.Substring(0,1);
                clit.Email = txtClienteEmail.Text;

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
            if (adding)
            {
                SubmitCliente(clit);
                listBox2.Items.Add(clit);
            }
            else
            {
                UpdateCliente(clit);
                listBox2.Items[currentCliente] = clit;
            }
            return true;
        }









        //TAB DOS INGREDIENTES

        public int currentIngrediente;

        private void listBox3_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox3.SelectedIndex >= 0)
            {
                currentIngrediente = listBox3.SelectedIndex;
                ShowIngrediente();
            }

        }

        //info de (cada) Ingrediente
        public void ShowIngrediente()
        {
            if (listBox3.Items.Count == 0 | currentIngrediente < 0)
                return;
            Ingrediente Ing = new Ingrediente();
            Ing = (Ingrediente)listBox3.Items[currentIngrediente];
            txtIngredienteNome.Text = Ing.Nome;
            txtQuantidade_disponivel.Text = Ing.Quantidade_disponivel;
            txtValor_nutritivo.Text = Ing.Valor_nutritivo;
            txtIngredienteId.Text = Ing.Id;
            txtIngredienteDid.Text = Ing.Did;
            //txtAlergenios.Text = Ing.Alergenios;

        }

        //cena da dispensa
        public Double cena;
        private int outInt;
        public HashSet<int> arrayDispensas = new HashSet<int>();

        private void tabPage3_Enter(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            using (TransactionScope tran = new TransactionScope())
            {


                //SqlCommand cmd = new SqlCommand("SELECT * FROM Cantina.INGREDIENTE INNER JOIN Cantina.DISPENSA ON Cantina.INGREDIENTE.Did=Cantina.DISPENSA.Id", cn);
                //SqlCommand cmd = new SqlCommand("SP_Name", cn);
                //cmd.CommandType = CommandType.StoredProcedure;
                SqlCommand cmd = new SqlCommand("Select_Ingrediente", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataReader reader = cmd.ExecuteReader();
                listBox3.Items.Clear();

                listBox4.Items.Clear();


                while (reader.Read())
                {
                    Ingrediente I = new Ingrediente();
                    I.Id = reader["Id"].ToString();
                    I.Nome = reader["Nome"].ToString();
                    I.Quantidade_disponivel = reader["Quantidade_disponivel"].ToString();
                    I.Valor_nutritivo = reader["Valor_nutritivo"].ToString();
                    I.Did = reader["Did"].ToString();

                    listBox3.Items.Add(I);

                }

                reader.Close();

                //CONVERTER PARA STORED PROCEDURE/TRANSAÇÃO
                foreach (Ingrediente i in listBox3.Items)
                {
                    if (int.TryParse(i.Did, out outInt) == false)
                    {
                        continue;
                    }
                    else
                    {
                        if (!arrayDispensas.Contains(int.Parse(i.Did)))
                        {
                            arrayDispensas.Add(int.Parse(i.Did));
                            Dispensa D = new Dispensa();
                            D.Id = int.Parse(i.Did);
                            SqlCommand cmd2 = new SqlCommand("Select_Ingrediente_Sum", cn);
                            cmd2.CommandType = CommandType.StoredProcedure;
                            cmd2.Parameters.Clear();
                            cmd2.Parameters.AddWithValue("@iDid", i.Did);
                            D.CapacidadeAtual = Double.Parse(cmd2.ExecuteScalar().ToString());

                            SqlCommand cmd3 = new SqlCommand("Select_Dispensa_Capacidade", cn);
                            cmd3.CommandType = CommandType.StoredProcedure;
                            cmd3.Parameters.Clear();
                            cmd3.Parameters.AddWithValue("@id", i.Did);
                            D.Capacidade = Double.Parse(cmd3.ExecuteScalar().ToString());

                            //método novo de garantir que as quantidades na dispensa batem sempre certo com as dos ingredientes; a coluna CapacidadeAtual da tabela Dispensa na BD é atualizada sempre que se carregam os dados dos Ingredientes na interface (ou seja, quando o evento tabPage3_Enter é ativado)
                            SqlCommand cmd4 = new SqlCommand("Update_Dispensa_Capacidade", cn);
                            cmd4.CommandType = CommandType.StoredProcedure;
                            cmd4.Parameters.Clear();
                            cmd4.Parameters.AddWithValue("@capacity", D.CapacidadeAtual);
                            cmd4.Parameters.AddWithValue("@id", D.Id);
                            cmd4.Connection = cn;
                            cmd4.ExecuteNonQuery();

                            if (D.CapacidadeAtual > D.Capacidade)
                            {
                                MessageBox.Show("Atenção! A dispensa tem uma capacidade máxima de " + D.Capacidade + " unidades!\n" + "(A dispensa possui agora: " + D.CapacidadeAtual + " unidades de Ingredientes)");
                            }

                            listBox4.Items.Add(D);
                        }


                    }
                }


                SqlCommand cmdDisp = new SqlCommand("Select_Dispensa_Null", cn);
                cmdDisp.CommandType = CommandType.StoredProcedure;
                SqlDataReader readerDisp = cmdDisp.ExecuteReader();

                while (readerDisp.Read())
                {

                    Dispensa Disp = new Dispensa();
                    Disp.Id = int.Parse(readerDisp["Id"].ToString());
                    Disp.Capacidade = double.Parse(readerDisp["Capacidade"].ToString());
                    Disp.CapacidadeAtual = readerDisp["CapacidadeAtual"] as double? ?? default(double);

                    listBox4.Items.Add(Disp);

                }
                readerDisp.Close();
                cn.Close();

                arrayDispensas.Clear();

                Console.WriteLine(cn);
                tran.Complete();
            }
        }




        private void IngredienteAdd_Click(object sender, EventArgs e)
        {
            adding = true;
            IngredienteClearFields();
            IngredienteHideButtons();
            //listBox3.Enabled = false;


        }

        private void IngredienteEdit_Click(object sender, EventArgs e)
        {
            currentIngrediente = listBox3.SelectedIndex;
            if (currentIngrediente < 0) //tirei o =< e meti só <, porque pareceu-me que isto é que tava a bloquear a edição no contacto de indíce 0
            {
                MessageBox.Show("Selecione um Ingrediente para editar");
                return;
            }
            adding = false;
            IngredienteHideButtons();
            //listBox3.Enabled = false;
        }

        private void IngredienteDelete_Click(object sender, EventArgs e)
        {
            if (listBox3.SelectedIndex > -1)
            {
                try
                {
                    RemoveIngrediente(((Ingrediente)listBox3.SelectedItem).Id);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    return;
                }
                listBox3.Items.RemoveAt(listBox3.SelectedIndex);
                if (currentIngrediente == listBox3.Items.Count)
                    currentIngrediente = listBox3.Items.Count - 1;
                if (currentIngrediente == -1)
                {
                    ClearFields();
                    MessageBox.Show("Não existem Ingredientes");
                }
                else
                {
                    ShowIngrediente();
                }
            }

        }

        private void IngredienteOk_Click(object sender, EventArgs e)
        {
            try
            {
                SaveIngrediente();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            //listBox3.Enabled = true;
            int idx = listBox3.FindString(txtIngredienteId.Text);
            listBox3.SelectedIndex = idx;
            IngredienteShowButtons();

        }

        private void IngredienteCancel_Click(object sender, EventArgs e)
        {
            //listBox3.Enabled = true;
            if (listBox3.Items.Count > 0)
            {
                currentIngrediente = listBox3.SelectedIndex;
                if (currentIngrediente < 0)
                    currentIngrediente = 0;
                ShowIngrediente();
            }
            else
            {
                IngredienteClearFields();
                IngredienteLockControls();
            }
            IngredienteShowButtons();

        }


        private void SubmitIngrediente(Ingrediente I)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Submit_Ingrediente";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            //cmd.Parameters.AddWithValue("@Id", int.Parse00(I.Id));
            cmd.Parameters.AddWithValue("@Nome", I.Nome);
            cmd.Parameters.AddWithValue("@Did", int.Parse(I.Did));
            //cmd.Parameters.AddWithValue("@Alergenios", I.Alergenios);
            cmd.Parameters.AddWithValue("@Valor_nutritivo", Double.Parse(I.Valor_nutritivo));
            cmd.Parameters.AddWithValue("@Quantidade_disponivel", Double.Parse(I.Quantidade_disponivel));
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao atualizar contacto na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {

                cn.Close();
            }
        }

        private void UpdateIngrediente(Ingrediente I)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Update_Ingrediente";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            //se editar 76763 para 7676 dá erro lmao, com o AddWithValue, tirar um dígito transforma tudo num nvarchar
            cmd.Parameters.AddWithValue("@Id", int.Parse(I.Id));
            cmd.Parameters.AddWithValue("@Nome", I.Nome);
            cmd.Parameters.AddWithValue("@Did", int.Parse(I.Did));
            cmd.Parameters.AddWithValue("@Valor_nutritivo", Double.Parse(I.Valor_nutritivo));
            //cmd.Parameters.AddWithValue("@Alergenios", I.Alergenios);
            cmd.Parameters.AddWithValue("@Quantidade_disponivel", Double.Parse(I.Quantidade_disponivel));
            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
                MessageBox.Show("Sucesso!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro!");
                throw new Exception("Erro ao atualizar Ingrediente da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemoveIngrediente(string IngredienteId)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Delete_Ingrediente";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", IngredienteId);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar Ingrediente da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }


        }

        private bool SaveIngrediente()
        {
            Ingrediente Ing = new Ingrediente();
            try
            {
                Ing.Id = txtIngredienteId.Text;
                Ing.Nome = txtIngredienteNome.Text;
                Ing.Quantidade_disponivel = (txtQuantidade_disponivel.Text);
                Ing.Valor_nutritivo = txtValor_nutritivo.Text;
                Ing.Did = txtIngredienteDid.Text;
                //Ing.Alergenios = txtAlergenios.Text;

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
            if (adding)
            {
                SubmitIngrediente(Ing);
                listBox3.Items.Add(Ing);
            }
            else
            {
                UpdateIngrediente(Ing);
                listBox3.Items[currentIngrediente] = Ing;
            }

            object sender = null;
            //--- update da listbox3
            tabPage3_Enter(sender, null);

            //selecionar o item alterado na listbox
            int idx3 = listBox3.FindString(txtIngredienteId.Text);
            listBox3.SelectedIndex = idx3;
            return true;
        }

        //helper functions ingredientes
        public void IngredienteLockControls()
        {
            txtIngredienteId.ReadOnly = true;
            txtIngredienteNome.ReadOnly = true;
            //txtAlergenios.ReadOnly = true;
            txtQuantidade_disponivel.ReadOnly = true;
            txtValor_nutritivo.ReadOnly = true;
            txtIngredienteDid.ReadOnly = true;
        }

        public void IngredienteUnlockControls()
        {
         //   if (adding==true)
         //   {
          //      txtIngredienteId.ReadOnly = false;
          //  }
            txtIngredienteNome.ReadOnly = false;
            //txtAlergenios.ReadOnly = false;
            txtQuantidade_disponivel.ReadOnly = false;
            txtValor_nutritivo.ReadOnly = false;
            txtIngredienteDid.ReadOnly = false;
        }

        public void IngredienteShowButtons()
        {
            IngredienteLockControls();
            IngredienteAdd.Visible = true;
            IngredienteDelete.Visible = true;
            IngredienteEdit.Visible = true;
            IngredienteOk.Visible = false;
            IngredienteCancel.Visible = false;

            DispensaAdd.Visible = true;
            DispensaEdit.Visible = true;

            txtQuantidadeInput.Visible = true;
            label14.Visible = true;
            AdicionarSubtrair.Visible = true;
        }

        public void IngredienteClearFields()
        {
            txtIngredienteId.Text = "";
            txtIngredienteNome.Text = "";
            //txtAlergenios.Text = "";
            txtQuantidade_disponivel.Text = "";
            txtValor_nutritivo.Text = "";
            txtIngredienteDid.Text = "";
        }

        public void IngredienteHideButtons()
        {
            IngredienteUnlockControls();
            IngredienteAdd.Visible = false;
            IngredienteDelete.Visible = false;
            IngredienteEdit.Visible = false;
            IngredienteOk.Visible = true;
            IngredienteCancel.Visible = true;

            DispensaAdd.Visible = false;
            DispensaEdit.Visible = false;

            txtQuantidadeInput.Visible = false;
            label14.Visible = false;
            AdicionarSubtrair.Visible = false;
        }





        // Dispensas

        public int currentDispensa;


        public void ShowDispensa()
        {
            if (listBox4.Items.Count == 0 | currentDispensa < 0)
                return;
            Dispensa Disp = new Dispensa();
            Disp = (Dispensa)listBox4.Items[currentDispensa];
            txtDispensaId.Text = Disp.Id.ToString();
            txtDispensaCapacidade.Text = Disp.Capacidade.ToString();
            if (Disp.CapacidadeAtual > 0)
            {
                DispensaDelete.Visible = false;
            }
            else
            {
                DispensaDelete.Visible = true;
            }

        }
        private void DispensaAdd_Click(object sender, EventArgs e)
        {
            adding = true;
            DispensaClearFields();
            DispensaHideButtons();
            listBox3.Enabled = false;
            listBox4.Enabled = false;

        }

        private void DispensaOk_Click(object sender, EventArgs e)
        {
            try
            {
                SaveDispensa();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
            listBox4.Enabled = true;
            listBox3.Enabled = true;
            int idx4 = listBox4.FindString(txtDispensaId.Text);
            listBox4.SelectedIndex = idx4;
            DispensaShowButtons();


        }

        private void DispensaEdit_Click(object sender, EventArgs e)
        {
            currentDispensa = listBox4.SelectedIndex;
            if (currentDispensa < 0)
            {
                MessageBox.Show("Selecione uma Dispensa para editar");
                return;
            }
            adding = false;
            DispensaHideButtons();

            txtDispensaId.ReadOnly = true;

            listBox4.Enabled = false;
            listBox3.Enabled = false;

        }

        private void DispensaDelete_Click(object sender, EventArgs e)
        {
            if (listBox4.SelectedIndex > -1)
            {
                try
                {
                    RemoveDispensa(((Dispensa)listBox4.SelectedItem).Id);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                    return;
                }
                listBox4.Items.RemoveAt(listBox4.SelectedIndex);
                if (currentDispensa == listBox4.Items.Count)
                    currentDispensa = listBox4.Items.Count - 1;
                if (currentDispensa == -1)
                {
                    ClearFields();
                    MessageBox.Show("Não existem Dispensas");
                }
                else
                {
                    ShowDispensa();
                }
            }

        }


        private void DispensaCancel_Click(object sender, EventArgs e)
        {
            listBox4.Enabled = true;
            listBox3.Enabled = true;
            if (listBox4.Items.Count > 0)
            {
                currentDispensa = listBox4.SelectedIndex;
                if (currentDispensa < 0)
                    currentDispensa = 0;
                ShowDispensa();
            }
            else
            {
                DispensaClearFields();
                DispensaLockControls();
            }
            DispensaShowButtons();



        }


        private void SubmitDispensa(Dispensa D)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Submit_Dispensa";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", D.Id);
            cmd.Parameters.AddWithValue("@Capacidade", D.Capacidade);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao atualizar dispensa na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {

                cn.Close();
            }
        }

        private void UpdateDispensa(Dispensa D)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "Update_Dispensa";
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", D.Id);
            cmd.Parameters.AddWithValue("@Capacidade", D.Capacidade);

            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
                MessageBox.Show("Sucesso!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro!");
                throw new Exception("Erro ao atualizar Dispensa da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemoveDispensa(int DispensaId)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Delete_Dispensa";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", DispensaId);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar Dispensa da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }


        }

        private bool SaveDispensa()
        {
            Dispensa Disp = new Dispensa();
            try
            {
                Disp.Id = int.Parse(txtDispensaId.Text);
                Disp.Capacidade = Double.Parse(txtDispensaCapacidade.Text);


            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
                return false;
            }
            if (adding)
            {
                SubmitDispensa(Disp);
                listBox4.Items.Add(Disp);
            }
            else
            {
                UpdateDispensa(Disp);
                listBox4.Items[currentDispensa] = Disp;
            }

            object sender = null;
            //--- update da listBox4
            tabPage3_Enter(sender, null);

            //selecionar o item alterado na listbox
            int idx4 = listBox4.FindString(txtDispensaId.Text);
            listBox4.SelectedIndex = idx4;
            return true;
        }

        //helper functions Dispensas
        public void DispensaLockControls()
        {
            txtDispensaId.ReadOnly = true;
            txtDispensaCapacidade.ReadOnly = true;
        }

        public void DispensaUnlockControls()
        {
            txtDispensaId.ReadOnly = false;
            txtDispensaCapacidade.ReadOnly = false;
        }

        public void DispensaShowButtons()
        {
            DispensaLockControls();
            DispensaAdd.Visible = true;
          //  DispensaDelete.Visible = true;
            DispensaEdit.Visible = true;
            DispensaOk.Visible = false;
            DispensaCancelar.Visible = false;

            label24.Visible = false;
            label25.Visible = false;
            txtDispensaCapacidade.Visible = false;
            txtDispensaId.Visible = false;

            IngredienteAdd.Visible = true;
            IngredienteDelete.Visible = true;
            IngredienteEdit.Visible = true;
           // IngredienteOk.Visible = true;
           // IngredienteCancel.Visible = true;
            AdicionarSubtrair.Visible = true;
            txtQuantidadeInput.Visible = true;
            txtQuantidade_disponivel.Visible = true;
            txtIngredienteId.Visible = true;
            txtIngredienteDid.Visible = true;
            txtIngredienteNome.Visible = true;
            txtValor_nutritivo.Visible = true;
            label13.Visible = true;
            label16.Visible = true;
            label22.Visible = true;
            label7.Visible = true;
            label18.Visible = true;
            label14.Visible = true;


        }

        public void DispensaClearFields()
        {
            txtDispensaId.Text = "";
            txtDispensaCapacidade.Text = "";

        }

        public void DispensaHideButtons()
        {
            DispensaUnlockControls();
            DispensaAdd.Visible = false;
          //  DispensaDelete.Visible = false;
            DispensaEdit.Visible = false;
            DispensaOk.Visible = true;
            DispensaCancelar.Visible = true;

            label24.Visible = true;
            label25.Visible = true;
            txtDispensaCapacidade.Visible = true;
            txtDispensaId.Visible = true;


            IngredienteAdd.Visible = false;
            IngredienteDelete.Visible = false;
            IngredienteEdit.Visible = false;
           // IngredienteOk.Visible = false;
           // IngredienteCancel.Visible = false;
            AdicionarSubtrair.Visible = false;
            txtQuantidadeInput.Visible = false;
            txtQuantidade_disponivel.Visible = false;
            txtIngredienteId.Visible = false;
            txtIngredienteDid.Visible = false;
            txtIngredienteNome.Visible = false;
            txtValor_nutritivo.Visible = false;
            label13.Visible = false;
            label16.Visible = false;
            label22.Visible = false;
            label7.Visible = false;
            label18.Visible = false;
            label14.Visible = false;
        }








        private void textBox1_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void tabPage2_Click(object sender, EventArgs e)
        {

        }

        private void AdicionarSubtrair_Click(object sender, EventArgs e)
        {
            try
            {

                txtQuantidadeInput.Visible = true;
                currentIngrediente = listBox3.SelectedIndex;
                if (currentIngrediente < 0)
                {
                    MessageBox.Show("Selecione um Ingrediente para editar");
                    return;
                }
                adding = false;
                //IngredienteHideButtons();

                //IngredienteOk.Visible = false;
                //IngredienteCancel.Visible = false;
                //listBox3.Enabled = false;

                Ingrediente ing = new Ingrediente();
                ing = (Ingrediente)listBox3.Items[currentIngrediente];
                double Qt = Double.Parse(ing.Quantidade_disponivel);

                double QtInput;
                try
                {
                    if (txtQuantidadeInput.Text == "" || Double.TryParse(txtQuantidadeInput.Text, out QtInput) == false)
                    {
                        MessageBox.Show("Por favor introduza um número real.");
                        return;
                    }

                    else
                    {
                        QtInput = Double.Parse(txtQuantidadeInput.Text);
                    }

                }
                catch(Exception Ex)
                {
                    throw new Exception("Erro! Conversão do input para double falhou! \n" + Ex.Message);
                }

                double QuantidadeOutput = Qt - QtInput;
                if (QuantidadeOutput < 0)
                {
                    throw new Exception("Erro! Número inserido não é válido! \n");
                }

                //txtQuantidadeInput.Visible = false;
                UpdateIngredienteQuantidade(ing, QuantidadeOutput);
                IngredienteShowButtons();

                //--- update da listbox3
                tabPage3_Enter(sender, null);

                //selecionar o item alterado na listbox
                int idx3 = listBox3.FindString(txtIngredienteId.Text);
                listBox3.SelectedIndex = idx3;
                txtQuantidadeInput.Text = "";
            }
            catch(Exception exp)
            {
                throw new Exception("Erro! \n" + exp.Message);
            }

        }


        private void UpdateIngredienteQuantidade(Ingrediente I, double QuantidadeOutput)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Update_Ingrediente_Quantidade";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            //fazer parse int
            cmd.Parameters.AddWithValue("@Id", I.Id);
            cmd.Parameters.AddWithValue("@QuantidadeOutput", QuantidadeOutput);
            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
                MessageBox.Show("Sucesso!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro!");
                throw new Exception("Erro ao atualizar Ingrediente da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private Funcionario createFuncionario(SqlDataReader reader)
        {
            Funcionario F = new Funcionario();
            F.Id = int.Parse(reader["Id"].ToString());
            F.Ccodigo = reader["Ccodigo"].ToString();
            F.Email = reader["Email"].ToString();
            F.Fname = reader["Fname"].ToString();
            F.Lname = reader["Lname"].ToString();
            F.Salario = Double.Parse(reader["Salario"].ToString());
            return F;
        }

       
        //TAB VENDAS

        int pagVendas = 0;
        ArrayList listaVendas = new ArrayList();
        private void tabPageVendas_Enter(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            comboBoxFuncionario.Items.Clear();
            comboBoxVendasMenu.Items.Clear();
            checkedListBox3.Items.Clear();
            checkedListBox3.Visible = false;
            bttTopPratosVendidos.Visible = true;
            bttEqVendas.Visible = true;
            vendasNifCliente.Clear();
            comboBoxFuncionario.Text = "";
            comboBoxVendasMenu.Text = "";




            using (TransactionScope trans = new TransactionScope())
            {


                listaVendas = new ArrayList();
                SqlCommand cmd = new SqlCommand("Select_Vendas", cn);
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@pagVendas", pagVendas);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataReader reader = cmd.ExecuteReader();
                dataGridViewVendas.Rows.Clear();

                while (reader.Read())
                {
                    Venda v = new Venda();
                    v.Nif = reader["Nif"].ToString();
                    v.DataHora = reader["DataHora"].ToString();
                    v.refFatura = reader["Ref_Fatura"].ToString();
                    v.CNome = reader["cFname"].ToString() + " " + reader["cLname"].ToString();
                    v.FNome = reader["ffname"].ToString() + " " + reader["flname"].ToString();
                    v.Email = reader["email"].ToString();
                    v.Precario = reader["nome"].ToString();
                    listaVendas.Add(v);
                    String[] r = { v.DataHora, v.CNome, v.Precario };
                    dataGridViewVendas.Rows.Add(r);
                }

                //cn.Close();
                reader.Close();

                // carregar combobox de cargos
                SqlCommand cmdC = new SqlCommand("Select_Funcionario", cn);
                cmdC.CommandType = CommandType.StoredProcedure;
                SqlDataReader readerC = cmdC.ExecuteReader();
                comboBoxCargo.Items.Clear();


                while (readerC.Read())
                {
                    Funcionario F = createFuncionario(readerC);
                    comboBoxFuncionario.Items.Add(Regex.Replace(F.ToString(), @"\s+", " "));

                }
                readerC.Close();

                // carregar combobox de menu
                SqlCommand cmdM = new SqlCommand("Select_Menu", cn);
                cmdM.CommandType = CommandType.StoredProcedure;
                SqlDataReader readerM = cmdM.ExecuteReader();
                comboBoxCargo.Items.Clear();


                while (readerM.Read())
                {
                    Menu M = new Menu();
                    M.Id = int.Parse(readerM["id"].ToString());
                    M.Nome = readerM["nome"].ToString();
                    comboBoxVendasMenu.Items.Add(M);

                }
                readerM.Close();
                cn.Close();

                trans.Complete();
            }

        }


        private void buttonVendasPgAnt_Click(object sender, EventArgs e)
        {
            if (pagVendas > 0)
            {
                pagVendas--;
                labelVendasPg.Text = (pagVendas + 1).ToString();
                tabPageVendas_Enter(sender, e);
            }
        }

        private void buttonVendasPgSeg_Click(object sender, EventArgs e)
        {
            pagVendas++;
            labelVendasPg.Text = (pagVendas + 1).ToString();
            tabPageVendas_Enter(sender, e);
        }

        private void label14_Click(object sender, EventArgs e)
        {

        }

        private void listBox4_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox4.SelectedIndex >= 0)
            {
                currentDispensa = listBox4.SelectedIndex;
                ShowDispensa();
            }
        }

        private void dataGridViewVendas_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void tabControl1_Resize(object sender, EventArgs e)
        {

        }

        private void ClienteSearchBox_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void searchBoxCliente(String searchString)
        {
            for (int i = 0; i < listBox2.Items.Count; i++)
            {
                if (listBox2.Items[i].ToString().IndexOf(searchString, StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    listBox2.SetSelected(i, true);
                }
                else
                {
                    listBox2.SetSelected(i, false);

                }
            }

        }

        private void label21_Click(object sender, EventArgs e)
        {

        }

        private void labelVendasEmail_Click(object sender, EventArgs e)
        {

        }

        private void buttonVendasInserir_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            HashSet<int> Nifs = new HashSet<int>();

            SqlCommand cmd2 = new SqlCommand("Select_Cliente", cn);
            cmd2.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader2 = cmd2.ExecuteReader();

            int n;

            while (reader2.Read()) 
            {
                n = int.Parse(reader2["Nif"].ToString());
                Nifs.Add(n);
            }
            reader2.Close();




            if ((string)comboBoxCargo.SelectedItem == "" || vendasNifCliente.Text == "" || int.TryParse(vendasNifCliente.Text, out int result) == false || vendasNifCliente.Text.Length != 9)
            {
                System.Windows.Forms.MessageBox.Show("Cliente Nif or Funcionário missing or invalid");
                return;
            }
            

            String a = "";
            foreach (int i in checkedListBox3.CheckedIndices)
            {
                Prato P2 = (Prato)checkedListBox3.Items[i];
                a = a + P2.Pid + ",";

            }
            if (a.Length == 0)
            {
                MessageBox.Show("Erro! O cliente não comprou nada!");
                return;
            }
            a = a.Substring(0, a.Length - 1);
            //MessageBox.Show(a);


            if (Nifs.Contains(int.Parse(vendasNifCliente.Text)))
            {

                SqlCommand cmd = new SqlCommand();
                //cmd.CommandText = "INSERT Cantina.compra (cnif, datahora, fid) VALUES (@Id, GETDATE(), @fid)";
                cmd.CommandText = "Insert_Compra";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Clear();
                cmd.Parameters.AddWithValue("@fid", comboBoxFuncionario.SelectedItem.ToString().Split(' ')[0]);
                cmd.Parameters.AddWithValue("@Id", vendasNifCliente.Text);
                cmd.Parameters.AddWithValue("@string", a);
                cmd.Connection = cn;

                try
                {
                    cmd.ExecuteNonQuery();
                    checkedListBox3.Items.Clear();
                    checkedListBox3.Visible = false;
                    bttTopPratosVendidos.Visible = true;
                    bttEqVendas.Visible = true;
                    vendasNifCliente.Clear();
                    comboBoxFuncionario.Text = "";
                    comboBoxVendasMenu.Text = "";
                    tabPageVendas_Enter(sender, e);
                    MessageBox.Show("Venda inserida!");


                }
                catch (Exception ex)
                {
                    throw new Exception("Erro ao atualizar compra na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
                }
                finally
                {

                    cn.Close();
                }
            }
            else
            {
                Form2 form2 = new Form2(vendasNifCliente.Text, comboBoxFuncionario.SelectedItem.ToString().Split(' ')[0], a);
                form2.ShowDialog();
                checkedListBox3.Items.Clear();
                checkedListBox3.Visible = false;
                bttTopPratosVendidos.Visible = true;
                bttEqVendas.Visible = true;
                vendasNifCliente.Clear();
                comboBoxFuncionario.Text = "";
                comboBoxVendasMenu.Text = "";
                tabPageVendas_Enter(null, null);
                cn.Close();
     
            }
        }

        private void dataGridViewVendas_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
           
        }
        private void ClientePesquisar_Click(object sender, EventArgs e)
        {
            String searchString = ClienteSearchBox.Text.ToString();
            searchBoxCliente(searchString);
            ClienteSearchBox.Text = "";
            
        }

        private void dataGridViewVendas_CellEnter(object sender, DataGridViewCellEventArgs e)
        {
            int i = dataGridViewVendas.CurrentCell.RowIndex;
            Venda v = (Venda)listaVendas[i];
            vendasHora.Text = v.DataHora;
            vendasEmail.Text = v.Email;
            vendasFatura.Text = v.refFatura;
            vendasFuncionario.Text = v.FNome;
            vendasNif.Text = v.Nif;
            vendasPrecario.Text = v.Precario;
            vendasNome.Text = v.CNome;
        }









        //TAB DOS MENUS
        private HashSet<Prato> pratos = new HashSet<Prato>();
        private HashSet<Composicao_Prato> ings = new HashSet<Composicao_Prato>();
        public int currentMenu;
        public int currentPrato;

        private void listBox5_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox5.SelectedIndex >= 0)
            {
                currentMenu = listBox5.SelectedIndex;
                ShowMenu();
            }

        }

        private void listBox6_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (listBox6.SelectedIndex >= 0)
            {
                currentPrato = listBox6.SelectedIndex;
                ShowPrato();
            }

        }

        private void ShowMenu()
        {
            if (listBox5.Items.Count == 0 | currentMenu < 0)
                return;
            Menu Men = new Menu();
            Men = (Menu)listBox5.Items[currentMenu];
            listBox6.Items.Clear();
            foreach (Prato p in pratos)
            {
                if (p.Mid==Men.Id)
                {
                    listBox6.Items.Add(p);
                }
            }
        }

        private void ShowPrato()
        {
            if (listBox6.Items.Count == 0 | currentPrato < 0)
                return;
            Prato C_prato = new Prato();
            C_prato = (Prato)listBox6.Items[currentPrato];
            listBox7.Items.Clear();
            foreach (Composicao_Prato p in ings)
            {
                if (p.Pid == C_prato.Pid)
                {
                    listBox7.Items.Add(p);
                }
            }
            txtPratoId.Text = C_prato.Pid.ToString();
            txtPratoNome.Text = C_prato.Nome.ToString();
            txtPratoTipo.Text = C_prato.Tipo.ToString();
        }



        //carregar informação quando se entra na tab dos clientes
        //PRECISA DE TRANSAÇÃO TRANSACTION [feito]
        private void tabMenu_Enter(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            using (TransactionScope trans = new TransactionScope())
            {



                SqlCommand cmd = new SqlCommand("Select_Menu", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataReader reader = cmd.ExecuteReader();
                listBox5.Items.Clear();


                while (reader.Read())
                {
                    Menu C = new Menu();
                    C.Id = int.Parse(reader["Id"].ToString());
                    C.Nome = reader["Nome"].ToString();

                    listBox5.Items.Add(C);
                }

                reader.Close();



                //carregar pratos
                pratos.Clear();
                SqlCommand cmd2 = new SqlCommand("Select_Prato", cn);
                cmd2.CommandType = CommandType.StoredProcedure;
                SqlDataReader reader2 = cmd2.ExecuteReader();
                listBox6.Items.Clear();


                while (reader2.Read())
                {
                    Prato P = new Prato();
                    P.Pid = int.Parse(reader2["Pid"].ToString());
                    P.Mid = int.Parse(reader2["Mid"].ToString());
                    P.Tipo = reader2["Tipo"].ToString();
                    P.Nome = reader2["Nome"].ToString();

                    pratos.Add(P);
                }

                reader2.Close();


                //carregar ingredientes de cada prato
                ings.Clear();
                SqlCommand cmd3 = new SqlCommand("Select_Composicao_Prato", cn);
                cmd3.CommandType = CommandType.StoredProcedure;
                SqlDataReader reader3 = cmd3.ExecuteReader();
                listBox7.Items.Clear();


                while (reader3.Read())
                {
                    Composicao_Prato CP = new Composicao_Prato();
                    CP.Pid = int.Parse(reader3["Pid"].ToString());
                    CP.Iid = int.Parse(reader3["Iid"].ToString());
                    CP.Alergenios = reader3["Alergenios"] as String ?? default(String);
                    //CP.Alergenios = reader3["Alergenios"].ToString();
                    CP.Nome = reader3["Nome"].ToString();

                    ings.Add(CP);
                }

                reader3.Close();
                cn.Close();
                Console.WriteLine(cn);

                trans.Complete();
            }
        }


        private void EditarMenu_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;

            currentPrato = listBox6.SelectedIndex;
            if (currentPrato < 0)
            {
                MessageBox.Show("Selecione um prato para editar");
                return;
            }

            currentMenu = listBox5.SelectedIndex;
            if (currentMenu < 0)
            {
                MessageBox.Show("Selecione um dos menus disponíveis");
                return;
            }

            adding = false;

            checkedListBox2.Items.Clear();
            checkedListBox2.Visible = true;
            listBox5.Enabled = false;
            listBox6.Enabled = false;
            listBox7.Enabled = false;
            MenuOk.Visible = true;
            MenuCancelar.Visible = true;
            txtPratoNome.ReadOnly = false;
            txtPratoTipo.ReadOnly = false;
            PratoAdicionar.Visible = false;
            //PratoRemover.Visible = false;
            MenuEditar.Visible = false;
            

            SqlCommand cmdIng = new SqlCommand("Select_Ingrediente", cn);
            cmdIng.CommandType = CommandType.StoredProcedure;
            SqlDataReader readerMIng = cmdIng.ExecuteReader();

            // carregar ingredientes disponiveis


            Dictionary<int, Ingrediente> dictionaryMI = new Dictionary<int, Ingrediente>();

            while (readerMIng.Read())
            {
                Ingrediente MI = new Ingrediente();
                MI.Id = readerMIng["Id"].ToString();
                MI.Nome = readerMIng["Nome"].ToString();

                if (!dictionaryMI.ContainsKey(int.Parse(MI.Id)))
                {
                    dictionaryMI.Add(int.Parse(MI.Id), MI);
                    checkedListBox2.Items.Add(MI);
                }


            }
            readerMIng.Close();
            cn.Close();

            //Dictionary<int, Composicao_Prato> dictionaryCP = new Dictionary<int, Composicao_Prato>();
            HashSet<int> hashsetCP = new HashSet<int>();
            foreach (Composicao_Prato cp in listBox7.Items)
            {
                hashsetCP.Add(cp.Iid);
            }

            for (int i = 0; i<checkedListBox2.Items.Count; i++)
            {
                Ingrediente telisma = (Ingrediente)checkedListBox2.Items[i];
                if (hashsetCP.Contains(int.Parse(telisma.Id))) {
                    checkedListBox2.SetItemChecked(i, true);
                }
                
            }
        }

        private void MenuOk_Click(object sender, EventArgs e)
        {
            try
            {
                SaveComposicao_do_prato();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
       
            checkedListBox2.Visible = false;
            listBox5.Enabled = true;
            listBox6.Enabled = true;
            //listBox7.Enabled = true;
            MenuOk.Visible = false;
            MenuCancelar.Visible = false;
            txtPratoNome.ReadOnly = true;
            txtPratoTipo.ReadOnly = true;
            txtPratoId.ReadOnly = true;
            MenuEditar.Visible = true;
            PratoAdicionar.Visible = true;
            //alteração pratoremover
            //PratoRemover.Visible = false;

        }

        private void MenuCancelar_Click(object sender, EventArgs e)
        {
            checkedListBox2.Visible = false;
            listBox5.Enabled = true;
            listBox6.Enabled = true;
            //listBox7.Enabled = true;
            MenuOk.Visible = false;
            MenuCancelar.Visible = false;
            txtPratoNome.ReadOnly = true;
            txtPratoTipo.ReadOnly = true;
            txtPratoId.ReadOnly = true;
            MenuEditar.Visible = true;
            PratoAdicionar.Visible = true;
            //alteração pratoremover
            //PratoRemover.Visible = false;

            if (listBox6.Items.Count > 0)
            {
                currentPrato = listBox6.SelectedIndex;
                if (currentPrato < 0)
                    currentPrato = 0;
                ShowPrato();
            }

        }

        //PRECISA DE TRANSACTION
        private bool SaveComposicao_do_prato()
        {
           
            HashSet<Composicao_Prato> SetCP = new HashSet<Composicao_Prato>();
            Prato P = new Prato();
            //P = (Prato)listBox6.Items[currentPrato];
            Menu M = new Menu();
            M = (Menu)listBox5.Items[currentMenu];

            P.Nome = txtPratoNome.Text;
            P.Mid = M.Id;
            P.Tipo = txtPratoTipo.Text;

            //var trans = cn.BeginTransaction();


            if (adding)
            {
                try
                {
                    using (TransactionScope trans = new TransactionScope())
                    {

                        SubmitPrato(P);
                        P.Pid = IdInserido;

                        try
                        {
                            foreach (int idxCB2 in checkedListBox2.CheckedIndices)
                            {
                                Ingrediente telisma = (Ingrediente)checkedListBox2.Items[idxCB2];

                                Composicao_Prato CP = new Composicao_Prato();
                                CP.Pid = P.Pid;
                                CP.Iid = int.Parse(telisma.Id);

                                SetCP.Add(CP);

                            }
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show(ex.Message);
                            return false;
                        }

                        SubmitComposicao_do_Menu(P, M);
                        RemoveComposicao_do_Prato(P.Pid);


                        foreach (Composicao_Prato ta in SetCP)
                        {
                            SubmitComposicao_do_Prato(ta);
                        }

                        trans.Complete();

                    }
                
                }
                
                 catch (Exception ex)
                {
                    //if (trans != null)
                    //    trans.Rollback();

                    //throw;
                    MessageBox.Show("Erro!"+ex.Message);
                }
                


            // listBox6.Items.Add(P);
            tabMenu_Enter(null, null);
            //listBox6.Items[currentPrato] = P;
            int idx5 = listBox5.FindString(M.ToString());
            listBox5.SelectedIndex = idx5;
            //listBox5.Items[currentMenu] = M;
            ShowMenu();
            int idx6 = listBox6.FindString(P.Nome);
            listBox6.SelectedIndex = idx6;

            }
            else
            {
                using (TransactionScope trans = new TransactionScope())
                {

                    P.Pid = int.Parse(txtPratoId.Text);

                    try
                    {
                        foreach (int idxCB2 in checkedListBox2.CheckedIndices)
                        {
                            Ingrediente telisma = (Ingrediente)checkedListBox2.Items[idxCB2];

                            Composicao_Prato CP = new Composicao_Prato();
                            CP.Pid = P.Pid;
                            CP.Iid = int.Parse(telisma.Id);

                            SetCP.Add(CP);

                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                        return false;
                    }

                    EditarPrato(P);
                    RemoveComposicao_do_Prato(P.Pid);

                    foreach (Composicao_Prato ta in SetCP)
                    {
                        SubmitComposicao_do_Prato(ta);
                    }

                    trans.Complete();
                }

                tabMenu_Enter(null, null);
                
                //listBox6.Items[currentPrato] = P;
                int idx5 = listBox5.FindString(M.Nome);
                listBox5.SelectedIndex = idx5;
                //listBox5.Items[currentMenu] = M;
                ShowMenu();
                int idx6 = listBox6.FindString(P.Nome);
                listBox6.SelectedIndex = idx6;

            }
            return true;
        }



        int IdInserido;
        private void SubmitPrato(Prato P)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Insert_Prato";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            //cmd.Parameters.AddWithValue("@Id", P.Pid);
            cmd.Parameters.AddWithValue("@Nome", P.Nome);
            cmd.Parameters.AddWithValue("@Tipo", P.Tipo);
            cmd.Connection = cn;


            try
            {
                //cmd.ExecuteNonQuery();
                IdInserido = Convert.ToInt32(cmd.ExecuteScalar());
                P.Pid = IdInserido;
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao adicionar prato na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void SubmitComposicao_do_Menu(Prato P, Menu M)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Insert_Composicao_Menu";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Pid", P.Pid);
            cmd.Parameters.AddWithValue("@Mid", M.Id);
            cmd.Connection = cn;


            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao adicionar composição do menu na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void EditarPrato(Prato P)
        {
            int rows = 0;

            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Update_Prato";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", P.Pid);
            cmd.Parameters.AddWithValue("@Nome", P.Nome);
            cmd.Parameters.AddWithValue("@Tipo", P.Tipo);
            cmd.Connection = cn;

            try
            {
                rows = cmd.ExecuteNonQuery();
                MessageBox.Show("Sucesso!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro!");
                throw new Exception("Erro ao atualizar prato da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemovePrato(int PratoId)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Apaga_Prato";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Id", PratoId);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar prato da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        //prato, composição do prato, menu funções
        private void SubmitComposicao_do_Prato(Composicao_Prato TA)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd2 = new SqlCommand();

            cmd2.CommandText = "Insert_Composicao_Prato";
            cmd2.CommandType = CommandType.StoredProcedure;
            cmd2.Parameters.Clear();
            cmd2.Parameters.AddWithValue("@Pid", TA.Pid);
            cmd2.Parameters.AddWithValue("@Iid", TA.Iid);
            cmd2.Connection = cn;


            try
            {
                cmd2.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao atualizar composição do prato na base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemoveComposicao_do_Prato(int Composicao_do_prato_pid)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Remove_Composicao_Prato";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Pid", Composicao_do_prato_pid);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar composição do prato da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void RemoveComposicao_do_Menu(int Composicao_do_menu_pid, int Composicao_do_menu_mid)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Remove_Composicao_Menu";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@Pid", Composicao_do_menu_pid);
            cmd.Parameters.AddWithValue("@Mid", Composicao_do_menu_mid);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar composição do menu da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }


        private void PratoAdicionar_Click(object sender, EventArgs e)
        {
            currentMenu = listBox5.SelectedIndex;
            if (currentMenu < 0)
            {
                MessageBox.Show("Selecione em que menu deseja adicionar o prato");
                return;
            }
            adding = true;

            checkedListBox2.Items.Clear();
            checkedListBox2.Visible = true;
            listBox5.Enabled = false;
            listBox6.Enabled = false;
            listBox7.Enabled = false;
            MenuOk.Visible = true;
            MenuCancelar.Visible = true;
            txtPratoNome.ReadOnly = false;
           // txtPratoId.ReadOnly = false;
            txtPratoTipo.ReadOnly = false;
            txtPratoId.Text = "";
            txtPratoNome.Text = "";
            txtPratoTipo.Text = "";
            MenuEditar.Visible = false;
            PratoAdicionar.Visible = false;
            //PratoRemover.Visible = false;

        }

        //PRECISA DE TRANSACTION [feito]
        private void PratoEliminar_Click(object sender, EventArgs e)
        {

            currentMenu = listBox5.SelectedIndex;
            if (currentMenu < 0)
            {
                MessageBox.Show("Selecione em que menu deseja remover o prato");
                return;
            }
            currentPrato = listBox6.SelectedIndex;
            if (currentPrato < 0)
            {
                MessageBox.Show("Selecione qual o prato que pretende remover");
                return;
            }

            if (listBox6.SelectedIndex > -1)
            {
                using (TransactionScope trans = new TransactionScope())
                {
                    try
                    {
                        RemoveComposicao_do_Prato(((Prato)listBox6.SelectedItem).Pid);
                        RemoveComposicao_do_Menu(((Prato)listBox6.SelectedItem).Pid, ((Prato)listBox6.SelectedItem).Mid);
                        RemovePrato(((Prato)listBox6.SelectedItem).Pid);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                        return;
                    }

                    trans.Complete();
                }

                listBox6.Items.RemoveAt(listBox6.SelectedIndex);
                if (currentPrato == listBox6.Items.Count)
                    currentPrato = listBox6.Items.Count - 1;
                if (currentPrato == -1)
                {
                    MessageBox.Show("Não existem pratos");
                }
                else
                {
                    ShowPrato();
                }
            }
        }

        private void buttonVendasRemove_Click(object sender, EventArgs e)
        {
            if (!verifySGBDConnection())
                return;
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "Remove_Vendas";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Clear();
            cmd.Parameters.AddWithValue("@fatura", vendasFatura.Text);
            cmd.Connection = cn;

            try
            {
                cmd.ExecuteNonQuery();
                tabPageVendas_Enter(sender, e);
                MessageBox.Show("Venda Eliminada!");
            }
            catch (Exception ex)
            {
                throw new Exception("Erro ao eliminar venda da base de dados. \n ERROR MESSAGE: \n" + ex.Message);
            }
            finally
            {
                cn.Close();
            }
        }

        private void vendasPratos_Click(object sender, EventArgs e)
        {

            if (!verifySGBDConnection())
                return;

            Menu M = (Menu)comboBoxVendasMenu.SelectedItem;

            SqlCommand cmd2 = new SqlCommand("Select_Prato_Menu", cn);
            cmd2.Parameters.AddWithValue("@id", M.Id);

            cmd2.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader2 = cmd2.ExecuteReader();

            bttTopPratosVendidos.Visible = false;
            bttEqVendas.Visible = false;
            checkedListBox3.Visible = true;
            checkedListBox3.Items.Clear();


            while (reader2.Read())
            {
                Prato P = new Prato();
                P.Pid = int.Parse(reader2["Pid"].ToString());
                P.Mid = int.Parse(reader2["Mid"].ToString());
                P.Tipo = reader2["Tipo"].ToString();
                P.Nome = reader2["Nome"].ToString();

                checkedListBox3.Items.Add(P);
                pratos.Add(P);
            }

            reader2.Close();
            cn.Close();


        }

        private void Compra_Click (object sender, DataGridViewCellEventArgs e)
        {
          
            if (!verifySGBDConnection())
                return;

            int i = dataGridViewVendas.CurrentCell.RowIndex;
            Venda v = (Venda)listaVendas[i];
            HashSet<String> cestoCompras = new HashSet<string>();
            int fatura = 0;
            try
            {
                fatura = int.Parse(v.refFatura);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Erro! Referência de fatura inválida" + ex.Message);
                return;
            }


            SqlCommand cmd2 = new SqlCommand("Select_Cesto_Compra", cn);
            cmd2.Parameters.AddWithValue("@fatura", fatura);
            cmd2.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader2 = cmd2.ExecuteReader();

            while (reader2.Read())
            {
                String p = reader2["Nome"].ToString();
                cestoCompras.Add(p);
            }

            reader2.Close();
            cn.Close();

            String b = "";
            foreach (String l in cestoCompras)
            {
                b = b + l + "\n";
            }
            MessageBox.Show("Cesto de Compras:\n"+b);

        }



        private void bttTop_Pratos_Vendidos_Click (object sender, EventArgs e)
        {

            if (!verifySGBDConnection())
                return;

            String a = "";

            SqlCommand cmd2 = new SqlCommand("Select_N_Pratos_Vendidos", cn);
            cmd2.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader2 = cmd2.ExecuteReader();
            

            while (reader2.Read())
            {
                String p = reader2["nome"].ToString();
                String p2 = reader2["N_Pratos_vendidos"].ToString();
                a = a + p + ": " + p2 + "\n";
            }
            
            reader2.Close();
            cn.Close();
            MessageBox.Show("Prato: Unidades vendidas:\n" + a);
        }

        private void bttTop_Eq_Negocio_Click(object sender, EventArgs e)
        {

            if (!verifySGBDConnection())
                return;

            String a = "";

            SqlCommand cmd2 = new SqlCommand("Select_N_Pratos_Vendidos_Por_Tipo_Cliente", cn);
            cmd2.CommandType = CommandType.StoredProcedure;
            SqlDataReader reader2 = cmd2.ExecuteReader();


            while (reader2.Read())
            {
                String p = reader2["N_compras"].ToString();
                String p2 = reader2["nome"].ToString();
                a = a+ p + "\t" + p2 + "\n";
            }

            reader2.Close();
            cn.Close();
            MessageBox.Show("Compras por tipo de cliente (preçário):\n" + a);
        }
    }
}
