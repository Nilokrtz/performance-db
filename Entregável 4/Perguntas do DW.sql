-- Qual é a pista com maior número de acidentes?
select dim_circuits.name_circuit as nome_circuito, count(fato_result.id_status) as qtd_acidente
from dim_circuits
join fato_result on fato_result.id_circuit = dim_circuits.id_circuit
where fato_result.id_status = 3 
group by dim_circuits.name_circuit
order by qtd_acidente desc
limit 1;
 
-- Quais são as equipes mais vencedoras em cada pista?
select * from (select distinct on (dim_circuits.name_circuit)
dim_circuits.name_circuit as nome_circuito,
dim_constructor.name_constructor as nome_equipe, sum(fato_result.qtd_points) qtd_pontos
from dim_constructor
join fato_result on fato_result.id_constructor = dim_constructor.id_constructor
join dim_circuits on dim_circuits.id_circuit = fato_result.id_circuit
group by dim_circuits.name_circuit, dim_constructor.name_constructor
order by dim_circuits.name_circuit, qtd_pontos desc) as equipes_pistas_campeas
order by qtd_pontos desc
 
-- Qual são os 5 pilotos com o maior número de desclassificações?
select dim_drivers.name_driver as nome_piloto, count(fato_result.id_status) as qtd_desclassificacoes
from dim_drivers
join fato_result on fato_result.id_driver = dim_drivers.id_driver
where fato_result.id_status = 2
group by nome_piloto
order by qtd_desclassificacoes desc
limit 5;
 
-- Qual são os 3 pilotos com a maior quantidade de pole positions?
select dim_drivers.name_driver as nome_piloto, count(fato_result.position_grid) as qtd_pole_positions
from dim_drivers
join fato_result on fato_result.id_driver = dim_drivers.id_driver
where fato_result.position_grid = 1
group by nome_piloto
order by qtd_pole_positions desc
limit 3;
 
-- Quais foram os 10 anos com o maior número de desclassificações por quebra de regras?
select dim_season.year_season as ano_season, count(fato_result.id_status) as qtd_regras_quebradas
from dim_season
join fato_result on fato_result.id_season = dim_season.id_season
where fato_result.id_status in(2, 54, 81, 96, 97)
group by ano_season
order by qtd_regras_quebradas desc
limit 10;
 
-- Qual foi o piloto que teve a volta mais rápida em cada pista?
select * from(select distinct on (dim_circuits.name_circuit)
dim_circuits.name_circuit as nome_circuito, dim_drivers.name_driver as nome_piloto, 
fato_result.fastestlap_result as volta_rapida
from dim_drivers
join fato_result on fato_result.id_driver = dim_drivers.id_driver
join dim_circuits on dim_circuits.id_circuit = fato_result.id_circuit
where fato_result.fastestlap_result is not null
order by nome_circuito, volta_rapida) as voltas_rapidas_pistas
order by volta_rapida;
 
-- Quais foram as equipes com as maiores falhas tequinicas?
select dim_constructor.name_constructor as nome_equipe, 
count(fato_result.id_status) as erros_operacionais_equipe
from dim_constructor
join fato_result on fato_result.id_constructor = dim_constructor.id_constructor
where fato_result.id_status in (36, 59, 35, 69, 91, 134, 28, 58, 90, 75)
group by dim_constructor.name_constructor
order by erros_operacionais_equipe desc
limit 7;