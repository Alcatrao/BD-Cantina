using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Prato
	{
		private int _Pid;
		private int _Mid;
		private String _Nome;
		private String _Tipo;


		public int Pid
		{
			get { return _Pid; }
			set { _Pid = value; }
		}

		public int Mid
		{
			get { return _Mid; }
			set { _Mid = value; }
		}


		public String Nome
		{
			get { return _Nome; }
			set { _Nome = value; }
		}

		public String Tipo
		{
			get { return _Tipo; }
			set { _Tipo = value; }
		}

		public override String ToString()
		{
			return _Nome + "   (" + _Tipo +")";
		}

	}
}
