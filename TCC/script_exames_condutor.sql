select 
	numprocesso, 
	count(case when codtipoexame in (1,2,8) then 1 end) as examesmedicos, 
	count(case when codtipoexame in (3) then 1 end) as examesteoricos,
	count(case when codtipoexame in (4,9) then 1 end) as examespraticos
from sa_dut.tb_exameprocesso where codtipoexame in (1,2,8,3,4,9) group by numprocesso 
