UPDATE races_db
SET time = '12:00:00'
WHERE time IS NULL
   OR time NOT LIKE '%:%';


UPDATE drivers_db SET name = 'Häkkinen Mika' where driverId = 57; --
UPDATE drivers_db SET name = 'Räikkönen Kimi' where "driverId" = 8; --
UPDATE drivers_db SET name = 'Mazzacane Gastón' where driverId = 60; --
UPDATE drivers_db SET name = 'Enge Tomáš' where driverId = 61; --
UPDATE drivers_db SET name = 'Comas Érik' where driverId = 100; --
UPDATE drivers_db SET name = 'Bernard Éric' where driverId = 103; --
UPDATE drivers_db SET name = 'Järvilehto Jyrki' where driverId = 109; --
UPDATE drivers_db SET name = 'Gugelmin Maurício' where driverId = 127; --
UPDATE drivers_db SET name = 'Campos Adrián' where driverId = 167; --
UPDATE drivers_db SET name = 'Belsø Tom' where driverId = 311; --
UPDATE drivers_db SET name = 'Rodríguez Pedro' where driverId = 345; --
UPDATE drivers_db SET name = 'Cabral Mário de Araújo' where driverId = 432; --
UPDATE drivers_db SET name = 'Seiffert Günther' where driverId = 445; --
UPDATE drivers_db SET name = 'Rodríguez Ricardo' where driverId = 454; --
UPDATE drivers_db SET name = 'González José Froilán' where driverId = 498; --
UPDATE drivers_db SET name = 'Bayol Élie' where driverId = 625; --
UPDATE drivers_db SET name = 'Marimón Onofre' where driverId = 670; --
UPDATE drivers_db SET name = 'Gálvez Oscar' where driverId = 695; --
UPDATE drivers_db SET name = 'Bechem Karl-Günther' where driverId = 715; --
UPDATE drivers_db SET name = 'Étancelin Philippe' where driverId = 741; --
UPDATE drivers_db SET name = 'Pián Alfredo' where driverId = 792; --
UPDATE drivers_db SET name = 'González Óscar' where driverId = 806; --
UPDATE drivers_db SET name = 'Vergne Jean-Éric' where "driverId" = 818; --
UPDATE drivers_db SET name = 'Hülkenberg Nico' where driverId = 807; --

UPDATE circuits_db SET location = 'Montmeló' where circuitId = 4;
UPDATE circuits_db SET name = 'Autódromo José Carlos Pace' where circuitId = 18;
UPDATE circuits_db SET location = 'São Paulo' where circuitId = 18;
UPDATE circuits_db SET name = 'Nürburgring' where circuitId = 20;
UPDATE circuits_db SET location = 'Nürburg' where circuitId = 20;
UPDATE circuits_db SET name = 'Autódromo Oscar Alfredo Gálvez' where circuitId = 25;
UPDATE circuits_db SET name = 'Autódromo do Estoril' where circuitId = 27;
UPDATE circuits_db SET name = 'Autódromo Hermanos Rodríguez' where circuitId = 32;
UPDATE circuits_db SET name = 'Autódromo Internacional Nelson Piquet' where circuitId = 36;
UPDATE circuits_db SET name = 'Montjuïc' where circuitId = 49;


UPDATE drivers_db
SET code = UPPER(SUBSTR(name, 1, 3)); 

UPDATE circuits_db
SET alt = 0
WHERE alt IS NULL OR alt = '';

select * from drivers_db;
select * from circuits_db;
select * from races_db;

-- Transforma vazios em NULL para data de nascimento
UPDATE drivers_db SET date_of_birth = NULL WHERE date_of_birth  = '';
UPDATE drivers_db SET number = NULL WHERE number = '\\N'; 
UPDATE drivers_db SET number = NULL WHERE number = '';
UPDATE drivers_db SET url = NULL WHERE url = '';

-- Limpa colunas numéricas e de tempo
UPDATE results_db SET number = NULL WHERE number = '';
UPDATE results_db SET position = NULL WHERE position = '';
UPDATE results_db SET milliseconds = NULL WHERE milliseconds = '';
UPDATE results_db SET fastestlap = NULL WHERE fastestlap = '';
UPDATE results_db SET rank = NULL WHERE rank = '';
UPDATE results_db SET fastestlaptime = NULL WHERE fastestlaptime = '';
UPDATE results_db SET fastestlapspeed = NULL WHERE fastestlapspeed = '';

update drivers_db set date_of_birth = '1932-04-30' where driverId = 415;

UPDATE drivers_db 
SET date_of_birth = substr(date_of_birth, 7, 4) || '-' || substr(date_of_birth, 4, 2) || '-' || substr(date_of_birth, 1, 2)
WHERE date_of_birth LIKE '%/%/%';