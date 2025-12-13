INSERT INTO seasons_db (seasonId, year, url)
SELECT ROW_NUMBER() OVER (ORDER BY s.year) AS seasonId, s.year, s.url FROM seasons s
ORDER BY s.year;
 
INSERT INTO circuits_db (circuitId , circuitRef, name, location, country, lat, lng, alt, url)
SELECT circuitId , circuitRef, name, location, country, lat, lng, alt, url From circuits
order by circuitId
 
INSERT INTO status_db (statusId , status)
SELECT statusId, status From status
order by statusId;
 
INSERT INTO constructor_db (constructorId , constructorRef, name, nationality, url)
SELECT constructorId, constructorRef, name, nationality, url From constructors
order by constructorId;
 
INSERT INTO drivers_db (driverId, constructorId, driverRef, number, code, name, nationality, url , date_of_birth)
SELECT
    d.driverId , (SELECT r.constructorId FROM results r WHERE r.driverId = d.driverId ORDER BY r.raceId DESC LIMIT 1)
    AS constructorId, d.driverRef, d.number, d.code, d.surname || ' ' || d.forename AS name, d.nationality, d.url,
    d.dob AS date_of_birth FROM drivers d
ORDER BY d.driverId;
 
INSERT INTO races_db (seasonId, raceId, round, circuitId, name, date, time, url)
SELECT
    sd.seasonId, r.raceId, r.round, r.circuitId, r.name, r.date, r.time, r.url FROM races r
JOIN seasons_db sd ON r.year = sd.year
ORDER BY raceId;
 
INSERT INTO results_db (resultId , raceId, driverId, number, grid, position, points, laps, time, milliseconds, fastestlap, rank, fastestlaptime, fastestlapspeed, statusId)
SELECT resultId , raceId, driverId, number, grid, position, points, laps, time, milliseconds, fastestlap, rank, fastestlaptime, fastestlapspeed, statusId From results
order by resultId
 
INSERT INTO qualifying_db (qualifyId , raceId, driverId, number, position)
SELECT qualifyId , raceId, driverId, number, position From qualifying
order by qualifyId;
 
INSERT INTO qualifying_qs_db (qualifyId , Q, time_q)
SELECT qualifyId, 1, q1 from qualifying
WHERE q1 IS NOT NULL;
 
INSERT INTO qualifying_qs_db (qualifyId , Q, time_q)
SELECT qualifyId, 2, q2 from qualifying
WHERE q2 IS NOT NULL;
 
INSERT INTO qualifying_qs_db (qualifyId , Q, time_q)
SELECT qualifyId, 3, q3 from qualifying
WHERE q3 IS NOT NULL;
 
INSERT INTO pitstops_db (raceId , driverId, stop, lap, time, milliseconds, duration)
SELECT raceId , driverId, stop, lap, time, duration, milliseconds from pitstops
ORDER BY raceId
 
INSERT INTO laptimes_db (raceId , driverId, lap, position , time , milliseconds)
SELECT raceId , driverId, lap, position , time , milliseconds from laptimes
ORDER BY raceId
