DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master(id STRING, byear INT,
bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity
STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate
STRING, dcity STRING, fname STRING, lname STRING, name STRING,
weight INT, height INT, bats STRING, throws STRING, debut
STRING, finalgame STRING, retro STRING, bbref STRING) ROW FORMAT
DELIMITED FIELDS TERMINATED BY ',' LOCATION
'/user/maria_dev/hivetest/master';

SELECT bmonth, bday FROM
(SELECT COUNT(id) AS counted, bmonth, bday, DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS rank
FROM master
WHERE bmonth IS NOT NULL AND bday IS NOT NULL
GROUP BY bmonth, bday) subquery WHERE rank IN (1,2,3);






