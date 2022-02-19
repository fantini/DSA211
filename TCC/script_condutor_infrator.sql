-- Negocio em analise: listar todas as infracaoes de condutores que resultaram em pontuacao
-- - PontuacaoFacade.java
--   - setarInfracoesEmPontosAdvertencias

-- TIPOS RESPONSAVEL:
-- - PROPRIETARIO	((short) 1,"PROPRIETARIO"),
-- - CONDUTOR		((short) 2,"CONDUTOR"),
-- - PESSOA_FISICA	((short) 3,"PESSOA FISICA"),
-- - PESSOA_JURIDICA	((short) 4,"PESSOA JURIDICA");

-- TIPOS SUSPENSAO:
-- - DIRETA('D'),
-- - VINTE_PONTOS('P'),
-- - CASSACAO('C');

-- TIPOS GRAVIDADE:
-- - LEVE((short) 1, "Leve", (short) 3, 'L'), 
-- - MEDIA((short) 2, "Média", (short) 4, 'M'), 
-- - GRAVE((short) 3, "Grave", (short) 5, 'G'), 
-- - GRAVISSIMA((short) 4, "Gravíssima", (short) 7, 'V')

select 
	numregcnh, indtipocnh, datainfracao, horainfracao, codmunicinfracao, marcamodeloveic, 
	codtipoinstrumento, indreincidencia, ei.codtipogravidade, ei.qtdepontos, ei.codresp, ei.indsuspensao
from 
	sa_pontuacao.tb_infratorpontuacao i
left join
	sa_pontuacao.tb_espinfracao ei using(idespinfracao)
where 
	indativo = 1
	and numregcnh is not null and indtipocnh = 2
	and codsitpontuacao = 0 and (indadvertencia is null or indadvertencia <> 1)
	and datainfracao > '2015-01-01'
