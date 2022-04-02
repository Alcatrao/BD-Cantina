using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Funcionario
	{
		private int _Id;
		private String _Fname;
		private String _Lname;
		private String _Email;
		private String _Ccodigo;
		private Double _Salario;

		public int Id
		{
			get { return _Id; }
			set { _Id = value; }
		}
		public String Fname
		{
			get { return _Fname; }
			set { _Fname = value; }
		}
		public String Lname
		{
			get { return _Lname; }
			set { _Lname = value; }
		}

		public String Email
		{
			get { return _Email; }
			set { _Email = value; }
		}

		public String Ccodigo
		{
			get { return _Ccodigo; }
			set { _Ccodigo = value; }
		}

		public Double Salario
		{
			get { return _Salario; }
			set { _Salario = value; }
		}


		public override String ToString()
		{
			return _Id + "\t" + _Fname + " " + _Lname;
		}
	}
}
