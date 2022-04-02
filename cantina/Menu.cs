using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Menu
	{
		private int _Id;
		private String _Nome;


		public int Id
		{
			get { return _Id; }
			set { _Id = value; }
		}
		public String Nome
		{
			get { return _Nome; }
			set { _Nome = value; }
		}

		public override String ToString()
		{
			return _Id + " " + _Nome;
		}

	}
}
