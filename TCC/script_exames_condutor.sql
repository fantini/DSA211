select 
	numprocesso, 
	count(case when codtipoexame in (1,2,8) then 1 end) as examesmedicos, 
	count(case when codtipoexame in (3) then 1 end) as examesteoricos,
	count(case when codtipoexame in (4,9) then 1 end) as examespraticos
from sa_dut.tb_exameprocesso where codtipoexame in (1,2,8,3,4,9) group by numprocesso 

select p.numprocesso, 
	count(case when ep.codtipoexame in (1,2,8) then 1 end) as examesmedicos, 
	count(case when ep.codtipoexame in (3) then 1 end) as examesteoricos,
	count(case when ep. codtipoexame in (4,9) then 1 end) as examespraticos 
from sa_dut.tb_processo p 
	left join sa_dut.tb_motivoprocesso mp using(numprocesso)
	left join sa_dut.tb_exameprocesso ep using(numprocesso)
where mp.codmot = 1 and ep.codtipoexame in (1,2,8,3,4,9) group by p.numprocesso 

select p.numprocesso, 
	count(rm) as examesmedicos, 
	count(rt) as examesteoricos,
	count(rp) as examespraticos 
from sa_dut.tb_processo p 
	left join sa_dut.tb_motivoprocesso mp using(numprocesso)
	left join sa_dut.tb_resultadoteorico rt using(numprocesso)
	left join sa_dut.tb_resultadopratico rp using(numprocesso)
	left join sa_dut.tb_resultadomedico rm using(numprocesso)
where mp.codmot = 1 and p.codsitprocesso = 99 group by p.numprocesso 
