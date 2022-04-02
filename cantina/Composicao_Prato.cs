using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Composicao_Prato
	{
		private int _Pid;
		private String _Nome;
		private String _Alergenios;
		private int _Iid;
	


		public int Pid
		{
			get { return _Pid; }
			set { _Pid = value; }
		}
		public String Nome
		{
			get { return _Nome; }
			set { _Nome = value; }
		}
		public String Alergenios
		{
			get { return _Alergenios; }
			set { _Alergenios = value; }
		}

		public int Iid
		{
			get { return _Iid; }
			set { _Iid = value; }
		}


		public override String ToString()
		{
			return _Nome;
		}
	}
}
