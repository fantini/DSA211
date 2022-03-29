select p.numprocesso, u.numcpf,
	count(distinct rm) as examesmedicos, 
	count(distinct rt) as examesteoricos,
	count(distinct rp) as examespraticos 
from sa_dut.tb_processo p 
	left join sa_dut.tb_usuario u using(numprocesso)	
	left join sa_dut.tb_motivoprocesso mp using(numprocesso)
	left join sa_dut.tb_resultadoteorico rt using(numprocesso)	
	left join sa_dut.tb_agendamentopratico ap using(numprocesso)
	left join sa_dut.tb_resultadopratico rp on ap.numpauta = rp.numpauta
	left join sa_dut.tb_agendamentomedico am using(numprocesso)
	left join sa_dut.tb_resultadomedico rm on am.numpauta = rm.numpauta
where 
	mp.codmot = 1 
	and p.codsitprocesso = 99 
	and rp.codresultado in (1,2)
	and rm.codresultado in (1,2,3,4,5,7)
	and rt.codresultado in (1,2)
group by p.numprocesso, u.numcpf
