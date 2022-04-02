using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Ingrediente
	{
		private String _Id;
		private String _Nome;
		private String _Alergenios;
		private String _Valor_nutritivo;
		private String _Quantidade_disponivel;
		private String _Did;


		public String Id
		{
			get { return _Id; }
			set { _Id = value; }
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

		public String Valor_nutritivo
		{
			get { return _Valor_nutritivo; }
			set { _Valor_nutritivo = value; }
		}

		public String Quantidade_disponivel
		{
			get { return _Quantidade_disponivel; }
			set { _Quantidade_disponivel = value; }
		}

		public String Did
		{
			get { return _Did; }
			set { _Did = value; }
		}

		public override String ToString()
		{
			return _Id + "\t" + _Nome + "\t" + _Quantidade_disponivel;
		}
	}
}
