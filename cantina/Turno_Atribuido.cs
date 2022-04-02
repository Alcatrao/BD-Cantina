using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace cantina
{

	[Serializable()]
	class Turno_Atribuido
	{
		private int _Fid;
		private String _Datahora_inicio;
		private String _Datahora_fim;


		public int Fid
		{
			get { return _Fid; }
			set { _Fid = value; }
		}
		public String Datahora_inicio
		{
			get { return _Datahora_inicio; }
			set { _Datahora_inicio = value; }
		}
		public String Datahora_fim
		{
			get { return _Datahora_fim; }
			set { _Datahora_fim = value; }
		}

		public override String ToString()
		{
			return _Fid + "\t" + _Datahora_inicio + "\t" + _Datahora_fim;
		}
	}
}
