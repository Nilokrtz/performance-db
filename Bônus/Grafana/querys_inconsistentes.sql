SELECT COUNT(*) FROM seasons_db;
SELECT * FROM seasons_db WHERE year = 2020;
 

SELECT * FROM results_db 
WHERE position::text LIKE '%1%';
 

SELECT * FROM races_db 
WHERE LOWER(name) = 'monaco grand prix';

SELECT * FROM drivers_db 
WHERE name LIKE '%Hamilton%';

SELECT DISTINCT d.driverid, d.name
FROM drivers_db d
JOIN results_db r ON d.driverid = r.driverid;

SELECT 
    r.raceid,
    COUNT(*) as total_results,
    AVG(r.milliseconds) as avg_time,
    MAX(r.points) as max_points,
    MIN(r.points) as min_points,
    SUM(r.points) as total_points
FROM results_db r
WHERE r.milliseconds IS NOT NULL
GROUP BY r.raceid
HAVING COUNT(*) > 10 
ORDER BY AVG(r.milliseconds) DESC;

SELECT 
    (SELECT COUNT(*) FROM results_db r WHERE r.driverid = d.driverid) as total_races,
    (SELECT AVG(r.points) FROM results_db r WHERE r.driverid = d.driverid) as avg_points,
    (SELECT STRING_AGG(DISTINCT c.name, ', ') 
     FROM results_db r2
     JOIN races_db ra ON r2.raceid = ra.raceid
     JOIN circuits_db c ON ra.circuitid = c.circuitid
     WHERE r2.driverid = d.driverid
    ) as circuits_raced
FROM drivers_db d
WHERE d.name LIKE '%a%'
ORDER BY (SELECT COUNT(*) FROM results_db r WHERE r.driverid = d.driverid) DESC
LIMIT 50;