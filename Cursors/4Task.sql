-- Сгенерируйте в соответствии с равномерным распределением значения a
-- и поместите их в таблицу с полями id/a, где a – натуральное число.
-- Постройте по этой выборке выборку с полями id/a', где a'=min a, если a
-- больше среднего значения по столбцу, и a'=max a иначе. Рассчитайте и
-- сравните для исходной и полученной выборок медиану, среднее и
-- среднеквадратичное отклонение.

DROP DATABASE IF EXISTS task4_4;
CREATE DATABASE task4_4;
USE task4_4;

CREATE TABLE num (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    a INT NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE num_res (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    a INT NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO num (a) VALUES(1);
INSERT INTO num (a) VALUES(FLOOR(RAND() * 100));
INSERT INTO num (a) VALUES(FLOOR(RAND() * 100));
INSERT INTO num (a) VALUES(FLOOR(RAND() * 100));
INSERT INTO num (a) VALUES(FLOOR(RAND() * 100));
INSERT INTO num (a) VALUES(FLOOR(RAND() * 100));

DROP PROCEDURE IF EXISTS minMax;
DELIMITER |
	CREATE PROCEDURE minMax ()
		BEGIN
			DECLARE done INT DEFAULT 0;
            DECLARE curId INT DEFAULT 0;
            DECLARE curA INT DEFAULT 0;
            DECLARE minA INT DEFAULT 1000;
            DECLARE maxA INT DEFAULT -1000;
            DECLARE rows_amount INT DEFAULT 0;
            DECLARE average INT DEFAULT 0;
            DECLARE sum_value INT DEFAULT 0;
            
            DECLARE cur 
				CURSOR FOR SELECT id, a FROM num;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
			OPEN cur;
            
            countValues: LOOP
				FETCH cur INTO curId, curA;
                IF done = 1 THEN
					LEAVE countValues;
				END IF;
                
                SET average = average + curA;
                IF curA > maxA THEN 
						SET maxA = curA; 
				END IF;
                
                IF curA < minA THEN
					SET minA = curA;
				END IF;
                
                SET rows_amount = rows_amount + 1;
                
                END LOOP countValues;
                
                CLOSE cur;
                
                SET average = average / rows_amount;
                
                SET done = 0;
                
                OPEN cur;
                
                fillNums: LOOP
					FETCH cur INTO curId, curA;
					
                    IF done = 1 THEN
						LEAVE fillNums;
					END IF;
                    
                    IF curA >  average THEN 
						INSERT INTO num_res VALUES (curId, minA);
					END IF;
                     IF curA <= average THEN
						INSERT INTO num_res VALUES (curId, maxA);
					END IF;
                    
                    END LOOP fillNums;
                    
                    CLOSE cur;
                    
        END;
|

DELIMITER |
DROP PROCEDURE IF EXISTS getStatistic;
|


-- Для рассчета медианы, среднего и
-- среднеквадратичного отклонения
-- В результирующей таблице столбцы *_res - статистика для результирующей таблицы
-- Иначе - для начальной табилцы.

DELIMITER |
CREATE PROCEDURE getStatistic ()
BEGIN
	DECLARE avg REAL DEFAULT 0;
    DECLARE avg_res REAL DEFAULT 0;
    DECLARE median REAL DEFAULT 0;
	DECLARE median_res REAL DEFAULT 0;
    DECLARE std REAL DEFAULT 0;
    DECLARE std_res REAL DEFAULT 0;
    
    DECLARE half_amount INT DEFAULT 0;
    DECLARE half_amount_delta INT DEFAULT 0;
    
    SET avg = (SELECT avg(a) FROM num);
    SET avg_res = (SELECT avg(a) FROM num_res);
    SET std = (SELECT std(a) FROM num);
    SET std_res = (SELECT std(a) FROM num_res);
    SET half_amount = (SELECT CEIL(COUNT(*)/2) FROM num);
    SET half_amount_delta = (half_amount mod 2) + 1;
    SET median = (SELECT avg(a) FROM (SELECT a FROM num ORDER BY a LIMIT half_amount, half_amount_delta) x);
    SET median_res = (SELECT avg(a) FROM (SELECT a FROM num_res ORDER BY a LIMIT half_amount, half_amount_delta) x);
   
   SELECT avg, avg_res, std, std_res, median, median_res;
		
END
|
CALL minMax(); |

CALL getStatistic(); |

SELECT * FROM num_res;