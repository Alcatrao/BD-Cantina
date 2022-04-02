using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Dispensa
	{
		private int _Id;
		private Double _Capacidade;
		private Double _CapacidadeAtual;
		public int Id
		{
			get { return _Id; }
			set { _Id = value; }
		}
		public Double Capacidade
		{
			get { return _Capacidade; }
			set { _Capacidade = value; }
		}
		public Double CapacidadeAtual
		{
			get { return _CapacidadeAtual; }
			set { _CapacidadeAtual = value; }
		}
		public override String ToString()
		{
			return _Id + "   " + "Quantidade: "+ _CapacidadeAtual + ";   Max: " +_Capacidade;
		}
	}
}
