

select * from sa_dut.tb_usuario limit 20

select * from sa_dut.tb_processo limit 20

select * from sa_dut.tb_cursoprocesso limit 2

-- u.numregcnh, u.numcpf, u.indtipocnh

select * from sa_dut.tb_cursoprocesso where codcurso in (38.43,51)


select u.numcpf, count(*) from sa_dut.tb_usuario u
	left join sa_dut.tb_cursoprocesso cp using(numprocesso)
where
	cp.codcurso in (38.43,51) and cp.codsitcurso = 2 and cp.dthrinclusao < '2022-01-01' 
group by u.numcpf

select u.numcpf, u.numregcnh, u.indtipocnh, cp.dthrinclusao from sa_dut.tb_usuario u
	left join sa_dut.tb_cursoprocesso cp using(numprocesso)
where
	cp.codcurso in (38.43,51) and cp.codsitcurso = 2 and cp.dthrinclusao < '2022-01-01'

-- trabalhando com a data de 2018-01-01 devido ao periodo de implantacao do modulo do curso
select count(*) from sa_pontuacao.tb_infratorpontuacao 
	where indativo = 1 and datainfracao > '2018-01-01' and datainfracao < '2022-01-01' and numregcnh is not null and indtipocnh is not null and codsitpontuacao = 0 and (indadvertencia is null or indadvertencia <> 1)

-- 1554306 registros
select distinct numregcnh, indtipocnh from sa_pontuacao.tb_infratorpontuacao 
	where 
		indativo = 1 and datainfracao > '2018-01-01' and datainfracao < '2022-01-01' 
		and numregcnh is not null and indtipocnh is not null 
		and codsitpontuacao = 0 and (indadvertencia is null or indadvertencia <> 1)
		and indtipocnh = 2

with reciclagemcnh as (
	select distinct u.numregcnh as numregcnh, u.indtipocnh as indtipocnh from sa_dut.tb_usuario u
		left join sa_dut.tb_cursoprocesso cp using(numprocesso)
	where
		cp.codcurso in (38.43,51) and cp.codsitcurso = 2 and cp.dthrinclusao < '2022-01-01'
)
select 
	distinct ip.numregcnh, ip.indtipocnh,
	u.codsexo, date_part('year', age(u.datanascimento)) as idade,
	case when rc.numregcnh is not null then 1 else 0 end as curso
from sa_pontuacao.tb_infratorpontuacao ip
	left join reciclagemcnh rc on ip.numregcnh = rc.numregcnh and ip.indtipocnh = rc.indtipocnh
	left join sa_dut.tb_usuario u on ip.numregcnh = u.numregcnh and ip.indtipocnh = u.indtipocnh
where 
	indativo = 1 and datainfracao > '2018-01-01' and datainfracao < '2022-01-01' 
	and ip.numregcnh is not null and ip.indtipocnh = 2
	and codsitpontuacao = 0 and (indadvertencia is null or indadvertencia <> 1)
	and u.codsexo in (1,2) and u.datanascimento BETWEEN '1900-01-01' and '2005-01-01'

-- base de condutores: condutores que possuem ear
with ear as (
	select 
		"ISN"
	from 
		sa_condutor.tb_condutor_codobscnh
	where
		codobscnh = '15'
)
select 
	numpgu, tipocondutor, codsexo, datanascimento, categoriareal 
from 
	sa_condutor.tb_condutor c
where
	tipocondutor = '2' and
	EXISTS (select * from ear e where e."ISN" = c."ISN")

-- filtrar condutores ativos
select 
	count(*) 
from 
	sa_condutor.tb_condutor 
where 
	to_date(lpad(datavalidade::TEXT, 8, '0'), 'DDMMYYYY') > '2022-01-14'
	and numpgu is not null and numpgu <> 0 
	and (codhist is null or codhist <> 205)

select 
	"ISN" as isn, numrg, numpgu, codsexo, datanascimento, categoriareal, categoriavigente, cpf 
from 
	sa_condutor.tb_condutor 
where
	to_date(lpad(datavalidade::TEXT, 8, '0'), 'DDMMYYYY') > '2022-01-14'
	and numpgu is not null and numpgu <> 0 
	and (codhist is null or codhist <> 205)
	and tipocondutor = '2'
limit 10000 offset 0
		
