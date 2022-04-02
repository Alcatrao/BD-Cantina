using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Venda
	{
		private String _Nif;
		private String _DataHora;
		private String _refFatura;
		private String _CNome;
		private String _FNome;
		private String _Email;
		private String _Precario;


		public String Nif
		{
			get { return _Nif; }
			set { _Nif = value; }
		}
		public String DataHora
		{
			get { return _DataHora; }
			set { _DataHora = value; }
		}
		public String refFatura
		{
			get { return _refFatura; }
			set { _refFatura = value; }
		}

		public String CNome
		{
			get { return _CNome; }
			set { _CNome = value; }
		}

		public String FNome
		{
			get { return _FNome; }
			set { _FNome = value; }
		}

		public String Email
		{
			get { return _Email; }
			set { _Email= value; }
		}

		public String Precario
		{
			get { return _Precario; }
			set { _Precario = value; }
		}


		public override String ToString()
		{
			return String.Format("{0,20} {1,12} {2} {3,30} {4,24}", _DataHora, _Nif, _CNome, _Precario, _FNome);
			
		}
	}
}