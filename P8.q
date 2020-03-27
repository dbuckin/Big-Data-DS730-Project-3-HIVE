DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master(id STRING, byear INT,
bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity
STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate
STRING, dcity STRING, fname STRING, lname STRING, name STRING,
weight INT, height INT, bats STRING, throws STRING, debut
STRING, finalgame STRING, retro STRING, bbref STRING) ROW FORMAT
DELIMITED FIELDS TERMINATED BY ',' LOCATION
'/user/maria_dev/hivetest/master';

DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting(id STRING, year INT,
team STRING, league STRING, games INT, ab INT, runs INT, hits
INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs
INT, walks INT, strikeouts INT, ibb INT, hbp INT, sh INT, sf
INT, gidp INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/maria_dev/hivetest/batting';

CREATE VIEW agged AS
SELECT m.bmonth, m.bstate, COUNT(DISTINCT(m.id)) AS count, SUM(b.ab) AS summed_atbat, SUM(b.hits) AS summed_hits
FROM batting b
JOIN master m
ON b.id = m.id
WHERE NOT (m.bmonth IS NULL OR m.bstate IS NULL OR m.bmonth == '' OR m.bstate == '')
GROUP BY m.bmonth, m.bstate;

SELECT bmonth, bstate FROM
(SELECT bmonth, bstate, (summed_hits/summed_atbat) AS stat, 
DENSE_RANK() OVER(ORDER BY (summed_hits/summed_atbat) ASC) AS rank
FROM agged
WHERE count >= 5 AND summed_atbat >= 100) subquery WHERE subquery.rank = 1;
