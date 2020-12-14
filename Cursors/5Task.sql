-- Сгенерируйте в соответствии с равномерным распределением значения a
-- (a – натуральное число) и поместите их в таблицу с полями id/a/b,
-- b=0.01a. Постройте по этой выборке выборку с полями id/a'/b', где a'=a,
-- b=a^2. Рассчитайте и сравните для исходной и полученной выборок
-- медиану, среднее и среднеквадратичное отклонение.


DROP DATABASE IF EXISTS task4_5;
CREATE DATABASE task4_5;
USE task4_5;

CREATE TABLE num (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    a INT NOT NULL,
    b REAL NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE num_res (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    a INT NOT NULL,
    b REAL NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP PROCEDURE IF EXISTS fillNums;

DELIMITER |
CREATE PROCEDURE fillNums(IN rows_amount INT)
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE curA INT DEFAULT 0;
    DECLARE counter INT DEFAULT 0;
    DECLARE a INT DEFAULT 0;
    
    DECLARE cur 
		CURSOR FOR SELECT a FROM num;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    fill: LOOP
		SET a = floor(rand() * 10);
        INSERT INTO num VALUES (null, a, 0.01 * a);
        SET counter = counter + 1;
			IF counter = rows_amount then
				LEAVE fill;
			END IF;
	END LOOP fill;
    
    OPEN cur;
    fill_res: LOOP
		FETCH cur INTO a;
        IF done = 1 THEN
			LEAVE fill_res;
		END IF;
        
        INSERT INTO num_res VALUES (null, a, a*a);
        
        END LOOP fill_res;
        
        CLOSE cur;
END;
    
|

/*Вывод статистических данных по тому же принципу, что и в предыдущем задании 4_4*/
DELIMITER |
CREATE PROCEDURE getStatistic ()
BEGIN
	DECLARE avgA REAL DEFAULT 0;
	DECLARE avgB REAL DEFAULT 0;
    DECLARE avgA_res REAL DEFAULT 0;
    DECLARE avgB_res REAL DEFAULT 0;
    DECLARE medianA REAL DEFAULT 0;
    DECLARE medianB REAL DEFAULT 0;
	DECLARE medianA_res REAL DEFAULT 0;
	DECLARE medianB_res REAL DEFAULT 0;
    DECLARE stdA REAL DEFAULT 0;
    DECLARE stdB REAL DEFAULT 0;
    DECLARE stdA_res REAL DEFAULT 0;
    DECLARE stdB_res REAL DEFAULT 0;
    
    DECLARE half_amount INT DEFAULT 0;
    DECLARE half_amount_delta INT DEFAULT 0;
    
    SET avgA = (SELECT avg(a) FROM num);
    SET avgB = (SELECT avg(b) FROM num);
    SET avgA_res = (SELECT avg(a) FROM num_res);
    SET avgB_res = (SELECT avg(b) FROM num_res);
    SET stdA = (SELECT std(a) FROM num);
    SET stdB = (SELECT std(b) FROM num);
    SET stdA_res = (SELECT std(a) FROM num_res);
    SET stdB_res = (SELECT std(b) FROM num_res);
    SET half_amount = (SELECT ceil(count(*)/2) FROM num);
    SET half_amount_delta = (half_amount mod 2) + 1;
    SET medianA = (SELECT avg(a) FROM (SELECT a FROM num ORDER BY a LIMIT half_amount, half_amount_delta) x);
    SET medianB = (SELECT avg(b) FROM (SELECT b FROM num ORDER BY b LIMIT half_amount, half_amount_delta) x);
    SET medianA_res = (SELECT avg(a) FROM (SELECT a from num_res ORDER BY a LIMIT half_amount, half_amount_delta) x);
    SET medianB_res = (SELECT avg(b) FROM (SELECT b from num_res ORDER BY b LIMIT half_amount, half_amount_delta) x);
   
   SELECT avgA, avgB, avgA_res, avgB_res, stdA, stdB, stdA_res, stdB_res, medianA, medianB, medianA_res, medianB_res;
		
END;
|
DELIMITER |
CALL fillNums(10);
|
DELIMITER |
CALL getStatistic();
|