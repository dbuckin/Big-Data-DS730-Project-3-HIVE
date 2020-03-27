DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting(id STRING, year INT,
team STRING, league STRING, games INT, ab INT, runs INT, hits
INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs
INT, walks INT, strikeouts INT, ibb INT, hbp INT, sh INT, sf
INT, gidp INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/maria_dev/hivetest/batting';

DROP TABLE IF EXISTS fielding;
CREATE EXTERNAL TABLE IF NOT EXISTS fielding(id STRING, year INT,
team STRING, league STRING, position STRING, games INT, gs INT, innouts
INT, po INT, a INT, errors INT, double_play INT, pb INT, wp
INT, sb INT, cs INT, zr INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/maria_dev/hivetest/fielding';

CREATE VIEW bat_agged AS 
SELECT id, SUM(ab) AS summed_atbat, SUM(hits) AS summed_hits
FROM batting
WHERE year >= 2005 AND year <= 2009
GROUP BY id;

CREATE VIEW field_agged AS
SELECT id, SUM(errors) AS summed_errors, SUM(games) AS summed_games 
FROM fielding
WHERE NOT (gs IS NULL AND innouts IS NULL AND po IS NULL AND a IS NULL AND errors IS NULL AND 
double_play IS NULL AND pb IS NULL AND wp IS NULL AND sb IS NULL AND cs IS NULL AND zr IS NULL)
AND year >= 2005 AND year <= 2009
GROUP BY id;

SELECT id FROM
(SELECT b.id, ((b.summed_hits/b.summed_atbat)-(f.summed_errors/f.summed_games)) AS stat,
DENSE_RANK() OVER(ORDER BY ((b.summed_hits/b.summed_atbat)-(f.summed_errors/f.summed_games)) DESC) AS rank
FROM bat_agged b
JOIN field_agged f
ON b.id = f.id
WHERE summed_atbat >=40 AND summed_games >= 20) subquery WHERE subquery.rank IN (1,2,3);



