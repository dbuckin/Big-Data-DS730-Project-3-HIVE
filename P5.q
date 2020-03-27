DROP TABLE IF EXISTS fielding;
CREATE EXTERNAL TABLE IF NOT EXISTS fielding(id STRING, year INT,
team STRING, league STRING, position STRING, games INT, gs INT, innouts
INT, po INT, a INT, errors INT, double_play INT, pb INT, wp
INT, sb INT, cs INT, zr INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/maria_dev/hivetest/fielding';

SELECT id FROM
(SELECT id, SUM(errors) AS summed_errors, row_number() over (ORDER BY SUM(errors) DESC) AS row_num
FROM fielding
GROUP BY id) subquery WHERE subquery.row_num = 1;