SET search path = public; 

SET client_min_messages NOTICE;

DROP VIEW IF EXISTS pontos_construtores_db CASCADE;

DROP VIEW IF EXISTS nacionalidades_vencedoras_db CASCADE;

DROP VIEW IF EXISTS dominancia_equipes_circuitos_db CASCADE;

DROP VIEW IF EXISTS pontos_pilotos CASCADE;

DROP FUNCTION IF EXISTS vencedor_corrida (integer, varchar) CASCADE;

DROP FUNCTION IF EXISTS total_pilotos(varchar) CASCADE;

DROP FUNCTION IF EXISTS total_vitorias_piloto(varchar) CASCADE;

DROP PROCEDURE IF EXISTS estatisticas_piloto_temporada (integer, varchar) CASCADE;

DROP PROCEDURE IF EXISTS fastest_laps_do_piloto (varchar) CASCADE;

DROP PROCEDURE IF EXISTS estatisticas_equipe_temporada (integer, varchar) CASCADE;

DROP FUNCTION IF EXISTS valida_coordenada() CASCADE; 

DROP TRIGGER IF EXISTS trg_valida_coordenada ON public.circuits_db;

DROP FUNCTION IF EXISTS impede_resultados_futuros() CASCADE; 

DROP TRIGGER IF EXISTS trg_impede_resultados_futuros ON public.results_db;

DROP FUNCTION IF EXISTS atualiza fastestlaptime() CASCADE;

DROP TRIGGER IF EXISTS trg_atualiza_fastestlaptime ON public.laptimes_db;




CREATE VIEW pontos_construtores_db AS SELECT

c.name AS constructor_name, SUM(r.points) AS ranking_constructors 

FROM constructor_db c

 JOIN drivers_db d ON d.constructorId = c.constructorId 

JOIN results_db r ON r.driverId = d.driverId

GROUP BY c.name;



CREATE VIEW nacionalidades_vencedoras_db AS

 SELECT * FROM (

SELECT

d.nationality AS nationality_driver, SUM(r.points) AS total_points

FROM drivers_db d

JOIN results_db r ON r.driverid= d.driverid

GROUP BY d.nationality

ORDER BY SUM (r.points) DESC

LIMIT 5 

) AS sub;



CREATE VIEW dominancia_equipes_circuitos_db AS SELECT 

cons.constructorid, cons.name AS equipe, cir.circuitid, cir.name AS circuito, cir.country AS país, COUNT (CASE WHEN r.position = 1 THEN 1 END) AS vitorías, COUNT (CASE WHEN r.position <= 3 THEN 1 END) AS podios, SUM(r.points) AS total_pontos, MIN (r.position) AS melhor_posicao_no_circuito, MAX (CASE WHEN r.position = 1 THEN s.year END) AS ultimo_ano_vitoria

FROM results_db r

JOIN drivers_db d ON d.driverid = r.driverid

JOIN constructor_db cons ON cons.constructorid = d.constructorid

JOIN races_db ra ON ra.raceid = r.raceid

JOIN circuits_db cir ON cir.circuitid = ra.circuitid

JOIN seasons_db s ON s.seasonid = ra.seasonid

GROUP BY cons.constructorid, cons.name, cir.circuitid, cir.name, cir.country;



CREATE VIEW pontos_pilotos AS SELECT

d.name AS driver_name, SUM(r.points) AS ranking_drivers, d.nationality AS nationality_driver

FROM drivers_db d

JOIN results_db r ON r.driverid = d.driverid

GROUP BY d.name, d.nationality;



CREATE OR REPLACE FUNCTION vencedor_corrida (ano INTEGER, pista VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    nome_piloto_vencedor VARCHAR;
BEGIN
    SELECT d.name
    INTO nome_piloto_vencedor
    FROM results_db r
    JOIN races_db ra ON r.raceid = ra.raceid
    JOIN seasons_db s ON ra.seasonid = s.seasonid
    JOIN circuits_db c ON ra.circuitid = c.circuitid 
    JOIN drivers_db d ON r.driverid = d.driverid
    WHERE s.year = ano 
      AND c.name = pista 
      AND r.position = 1
    LIMIT 1;

    RETURN nome_piloto_vencedor;
END; 
$$ LANGUAGE plpgsql;



CREATE FUNCTION total_pilotos (equipe VARCHAR)
RETURNS INTEGER AS $$
DECLARE
qnt INTEGER;
BEGIN
SELECT COUNT (DISTINCT r.driverid)
INTO qnt
FROM results_db r
JOIN constructor_db c ON r.constructorid = c.constructorid
WHERE c.name = equipe;
RETURN qnt;
END;
$$ LANGUAGE plpgsql;
DROP FUNCTION IF EXISTS total_pilotos(varchar) CASCADE;



CREATE OR REPLACE FUNCTION total_vitorias_piloto (nome_piloto_param VARCHAR)
RETURNS VARCHAR AS $$
DECLARE
    qtd_vitorias INT;
BEGIN
    SELECT COUNT(*)
    INTO qtd_vitorias
    FROM drivers_db d
    JOIN results_db r ON r.driverid = d.driverid
    WHERE d.name = nome_piloto_param 
      AND r.position = 1;

    IF qtd_vitorias = 0 THEN
        RETURN 'Esse piloto não possui vitórias.';
    ELSE
        RETURN 'Esse piloto possui ' || qtd_vitorias || ' vitória(s).';
    END IF;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE estatisticas_piloto_temporada (
    IN ano_param INTEGER, 
    IN nome_piloto_param VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_driverid INT;
    total_corridas INT DEFAULT 0;
    vitorias INT DEFAULT 0;
    podios INT DEFAULT 0;
    pontos DECIMAL DEFAULT 0.0;
    melhor_posicao INT DEFAULT 0;
    media_posicao DECIMAL DEFAULT 0.0;
    posicao_final INT DEFAULT 0;
BEGIN
    SELECT driverid
    INTO v_driverid
    FROM drivers_db
    WHERE name = nome_piloto_param;

    IF v_driverid IS NULL THEN
        RAISE NOTICE 'Piloto não encontrado.';
        RETURN;
    END IF;

    SELECT COUNT(*)
    INTO total_corridas
    FROM results_db res
    JOIN races_db r ON r.raceid = res.raceid 
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND res.driverid = v_driverid;

    SELECT COUNT(*)
    INTO vitorias
    FROM results_db res
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND res.driverid = v_driverid AND res.position = 1;

    SELECT COUNT(*)
    INTO podios
    FROM results_db res
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND res.driverid = v_driverid AND res.position <= 3;

    SELECT COALESCE(SUM(res.points), 0)
    INTO pontos
    FROM results_db res
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND res.driverid = v_driverid;

    SELECT MIN(res.position)
    INTO melhor_posicao
    FROM results_db res
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND res.driverid = v_driverid;

    SELECT COALESCE(AVG(res.position), 0)
    INTO media_posicao
    FROM results_db res
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND res.driverid = v_driverid;

    RAISE NOTICE '=== Estatísticas de % na temporada % ===', nome_piloto_param, ano_param; 
    RAISE NOTICE 'Corridas disputadas: %', total_corridas;
    RAISE NOTICE 'Vitórias: %', vitorias;
    RAISE NOTICE 'Pódios: %', podios;
    RAISE NOTICE 'Pontos totais: %', pontos;
    RAISE NOTICE 'Melhor posição: %', melhor_posicao;
    RAISE NOTICE 'Média de posição: %', media_posicao;

END; 
$$;


CREATE OR REPLACE PROCEDURE fastest_laps_do_piloto (IN nome_piloto_param VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT s.year, 
               ra.name AS corrida, 
               c.name AS circuito, 
               res.rank AS pos_fastest_lap
        FROM results_db res
        JOIN drivers_db d ON d.driverid = res.driverid
        JOIN races_db ra ON ra.raceid = res.raceid
        JOIN seasons_db s ON s.seasonid = ra.seasonid
        JOIN circuits_db c ON c.circuitid = ra.circuitid
        WHERE d.name = nome_piloto_param
          AND res.rank = 1
        ORDER BY s.year
    LOOP
        RAISE NOTICE 'Ano: %, Corrida: %, Circuito: %, Rank Volta: %', 
                     r.year, r.corrida, r.circuito, r.pos_fastest_lap;
    END LOOP;

    IF NOT FOUND THEN
        RAISE NOTICE 'Nenhum registro de volta mais rápida para o piloto %.', nome_piloto_param;
    END IF;
END;
$$;



CREATE OR REPLACE PROCEDURE estatisticas_equipe_temporada (
    IN ano_param INTEGER,
    IN nome_equipe_param VARCHAR
) 
LANGUAGE plpgsql
AS $$
DECLARE
    v_equipe_id INT;
    total_pontos DECIMAL DEFAULT 0;
    vitorias INT DEFAULT 0;
    podios INT DEFAULT 0;
    total_corridas INT DEFAULT 0;
    melhor_posicao INT DEFAULT 0;
    media_posicao DECIMAL DEFAULT 0;
    posicao_final INT DEFAULT 0;
    pilotos TEXT;
BEGIN
    SELECT constructorid INTO v_equipe_id
    FROM constructor_db
    WHERE name = nome_equipe_param;

    IF v_equipe_id IS NULL THEN
        RAISE NOTICE 'Equipe não encontrada.';
        RETURN;
    END IF;

    SELECT COALESCE(SUM(res.points), 0)
    INTO total_pontos
    FROM results_db res
    JOIN drivers_db d ON res.driverid = d.driverid 
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND d.constructorid = v_equipe_id;

    SELECT COUNT(*)
    INTO vitorias
    FROM results_db res
    JOIN drivers_db d ON res.driverid = d.driverid
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND d.constructorid = v_equipe_id AND res.position = 1;

    SELECT COUNT(*)
    INTO podios
    FROM results_db res
    JOIN drivers_db d ON res.driverid = d.driverid
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND d.constructorid = v_equipe_id AND res.position <= 3;

    SELECT COUNT(*)
    INTO total_corridas
    FROM results_db res
    JOIN drivers_db d ON res.driverid = d.driverid
    JOIN races_db r ON r.raceid = res.raceid 
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND d.constructorid = v_equipe_id;

    SELECT MIN(res.position)
    INTO melhor_posicao
    FROM results_db res
    JOIN drivers_db d ON res.driverid = d.driverid
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND d.constructorid = v_equipe_id;

    SELECT COALESCE(AVG(res.position), 0)
    INTO media_posicao
    FROM results_db res
    JOIN drivers_db d ON res.driverid = d.driverid
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND d.constructorid = v_equipe_id;

    INTO pilotos
    FROM results_db res
    JOIN drivers_db d ON d.driverid = res.driverid
    JOIN races_db r ON r.raceid = res.raceid
    JOIN seasons_db s ON r.seasonid = s.seasonid
    WHERE s.year = ano_param AND d.constructorid = v_equipe_id;

    RAISE NOTICE '===== Estatísticas da equipe % na temporada % =====', nome_equipe_param, ano_param;
    RAISE NOTICE 'Pontos totais: %', total_pontos;
    RAISE NOTICE 'Vitórias: %', vitorias;
    RAISE NOTICE 'Pódios: %', podios;
    RAISE NOTICE 'Total de corridas disputadas: %', total_corridas;
    RAISE NOTICE 'Melhor posição obtida: %', melhor_posicao;
    RAISE NOTICE 'Média de posição: %', media_posicao;
    RAISE NOTICE 'Pilotos na temporada: %', pilotos;

END;
$$;

CREATE OR REPLACE FUNCTION valida_coordenada()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.lat IS NOT NULL AND (NEW.lat < -90 OR NEW.lat > 90) THEN
        RAISE EXCEPTION 'Input Inválido: Latitude % está fora do range permitido (-90 a 90).', NEW.lat;
    END IF;

    IF NEW.lng IS NOT NULL AND (NEW.lng < -180 OR NEW.lng > 180) THEN
        RAISE EXCEPTION 'Input Inválido: Longitude % está fora do range permitido (-180 a 180).', NEW.lng;
    END IF;

    RETURN NEW;
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_valida_coordenada
BEFORE INSERT OR UPDATE ON public.circuits_db
FOR EACH ROW
EXECUTE FUNCTION valida_coordenada();



CREATE OR REPLACE FUNCTION impede_resultados_futuros()
RETURNS TRIGGER AS $$
DECLARE
    race_data DATE;
BEGIN
    SELECT "date" INTO race_data
    FROM public.races_db
    WHERE raceid = NEW.raceid;

    IF race_data > CURRENT_DATE THEN
        RAISE EXCEPTION 'Lógica Temporal: Não é possível inserir resultados para uma corrida futura (Data: %).', race_data;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_impede_resultados_futuros
BEFORE INSERT OR UPDATE ON public.results_db 
FOR EACH ROW
EXECUTE FUNCTION impede_resultados_futuros();


CREATE OR REPLACE FUNCTION atualiza_fastestlaptime()
RETURNS TRIGGER AS $$
DECLARE
    best_time_atual INTERVAL;
BEGIN
    SELECT fastestlaptime INTO best_time_atual
    FROM public.results_db
    WHERE raceid = NEW.raceid AND driverid = NEW.driverid;

    IF best_time_atual IS NULL OR NEW.milliseconds < best_time_atual THEN
        
        UPDATE public.results_db
        SET fastestlaptime = NEW.milliseconds
        WHERE raceid = NEW.raceid AND driverid = NEW.driverid;
        
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualiza_fastestlaptime
AFTER INSERT OR UPDATE ON public.laptimes_db
FOR EACH ROW
EXECUTE FUNCTION atualiza_fastestlaptime();
