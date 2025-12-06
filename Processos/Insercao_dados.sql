INSERT INTO seasons_db (year , url)
SELECT year, url From seasons
order by year
-- falta season ID (da pra fazer um for)
 
INSERT INTO circuits_db (circuitId , circuitRef, name, location, country, lat, lng, alt, url)
SELECT circuitId , circuitRef, name, location, country, lat, lng, alt, url From circuits
order by circuitId
 
INSERT INTO status_db (statusId , status)
SELECT statusId, status From status
order by statusId
 
INSERT INTO constructor_db (constructorId , constructorRef, name, nationality, url)
SELECT constructorId, constructorRef, name, nationality, url From constructors
order by constructorId
 
INSERT INTO drivers_db (driverId , driverRef, number, code, name, nationality, url , date_of_birth)
SELECT driverId , driverRef, number, code, surname || forename, nationality, url , dob From drivers
order by driverId
--falta ConstructorId
INSERT INTO races_db (raceId, round, circuitId, name, date, time, url)
SELECT raceId, round, circuitId, name, date , time , url From races
order by raceId
--falta seasonID
INSERT INTO results_db (resultId , raceId, driverId, number, grid, position, points, laps, time, milliseconds, fastestlap, rank, fastestlaptime, fastestlapspeed, statusId)
SELECT resultId , raceId, driverId, number, grid, position, points, laps, time, milliseconds, fastestlap, rank, fastestlaptime, fastestlapspeed, statusId From results
order by resultId
 
INSERT INTO qualifying_db (qualifyId , raceId, driverId, number, position)
SELECT qualifyId , raceId, driverId, number, position From qualifying
order by qualifyId
 
INSERT INTO qualifying_qs_db (qualifyId , Q, time_q)
SELECT qualifyid, 3, q3 from qualifying
 
INSERT INTO pitstops_db (raceId , driverId, stop, lap, time, milliseconds, duration)
SELECT raceId , driverId, stop, lap, time, duration, milliseconds from pitstops
ORDER BY raceId
 
INSERT INTO laptimes_db (raceId , driverId, lap, position , time , milliseconds)
SELECT raceId , driverId, lap, position , time , milliseconds from laptimes
ORDER BY raceId