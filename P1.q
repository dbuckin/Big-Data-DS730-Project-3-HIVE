DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting(id STRING, year INT,
team STRING, league STRING, games INT, ab INT, runs INT, hits
INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs
INT, walks INT, strikeouts INT, ibb INT, hbp INT, sh INT, sf
INT, gidp INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/maria_dev/hivetest/batting';

DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master(id STRING, byear INT,
bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity
STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate
STRING, dcity STRING, fname STRING, lname STRING, name STRING,
weight INT, height INT, bats STRING, throws STRING, debut
STRING, finalgame STRING, retro STRING, bbref STRING) ROW FORMAT
DELIMITED FIELDS TERMINATED BY ',' LOCATION
'/user/maria_dev/hivetest/master';

SELECT birth_city FROM
(SELECT b.id, m.bcity AS birth_city, SUM(b.ab) AS summed_atbat, row_number() over (ORDER BY SUM(b.ab) DESC) AS row_num 
FROM batting b 
JOIN master m 
ON b.id = m.id
GROUP BY b.id, m.bcity) subquery WHERE subquery.row_num = 1;