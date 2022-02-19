

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

-- filtrar condutores ativos
with ear as (
	select 
		"ISN"
	from 
		sa_condutor.tb_condutor_codobscnh
	where
		codobscnh = '15'
)
select 
	"ISN" as isn, numrg, numpgu, tipocondutor, codsexo, datanascimento, categoriareal, categoriavigente, cpf,
	date_part('year', age(to_date(lpad(datanascimento::TEXT, 8, '0'), 'DDMMYYYY'))) as idade,
	case when 1 = (select 1 from ear where ear."ISN" = c."ISN") then 1 else 0 end as ear
from 
	sa_condutor.tb_condutor c
where
	numpgu is not null and numpgu <> 0
	and substring(lpad(datavalidade::TEXT, 8, '0'), 5, 8) >= '2022'	
	and (codhist is null or codhist <> 205)	
	and to_date(lpad(datavalidade::TEXT, 8, '0'), 'DDMMYYYY') > '2022-01-01'
	and "ISN" not in (14605362, 165019)
order by
	idade desc;

-- script final
create MATERIALIZED view sa_condutor.view_condutor as
with ear as (
	select 
		"ISN"
	from 
		sa_condutor.tb_condutor_codobscnh
	where
		codobscnh = '15'
)
select 
	"ISN" as isn, numrg as rg, numpgu as cnh, tipocondutor as tipo, 
	codsexo, datanascimento, categoriareal, categoriavigente, cpf,
	date_part('year', age(to_date(lpad(datanascimento::TEXT, 8, '0'), 'DDMMYYYY'))) as idade,
	case when 1 = (select 1 from ear where ear."ISN" = c."ISN") then 1 else 0 end as ear
from 
	sa_condutor.tb_condutor c
where
	numpgu is not null and numpgu <> 0
	and substring(lpad(datavalidade::TEXT, 8, '0'), 5, 8) >= '2022'	
	and (codhist is null or codhist <> 205)	
	and to_date(lpad(datavalidade::TEXT, 8, '0'), 'DDMMYYYY') > '2022-01-01'
	and "ISN" not in (14605362)
	and tipocondutor = '2'
with no data;

refresh MATERIALIZED view sa_condutor.view_condutor

create MATERIALIZED view sa_condutor.view_condutor_final as
select c.*, case when ic is not null then 1 else 0 end as multa, case when ic.curso = 1 then 1 else 0 end as curso
from sa_condutor.view_condutor c left join sa_condutor.tb_condutor_infrator_curso ic on c.cnh = substring(ic.cnh::text, 0, length(ic.cnh::text)-1)::bigint
with no data;

refresh MATERIALIZED view sa_condutor.view_condutor_final;