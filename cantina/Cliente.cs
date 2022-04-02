using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Cliente
	{
		private String _Nif;
		private String _Fname;
		private String _Lname;
		private String _Email;
		private String _Tipo;
		private String _Tipo_Nome;


		public String Nif
		{
			get { return _Nif; }
			set { _Nif = value; }
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

		public String Tipo
		{
			get { return _Tipo; }
			set { _Tipo = value; }
		}

		public String Tipo_Nome
		{
			get { return _Tipo_Nome; }
			set { _Tipo_Nome = value; }
		}


		public override String ToString()
		{
			return _Nif + "\t" + _Fname + " " + _Lname;
		}
	}
}
