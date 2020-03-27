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

SELECT bcity, bstate FROM
(SELECT m.bcity, m.bstate, SUM(b.doubles + b.triples) AS stat,
DENSE_RANK() OVER(ORDER BY SUM(b.doubles + b.triples) DESC) AS rank
FROM master m
JOIN batting b
ON m.id = b.id
WHERE m.bstate != ''
GROUP BY m.bcity, m.bstate) subquery WHERE rank IN (1,2,3,4,5);


