-- Сгенерируйте в соответствии с равномерным распределением (по a и по
-- b) выборку {a,b}. Рассматривая b как функцию от a, проверить эту
-- функцию на монотонность. Рассчитайте для этой выборки (для a и для b)
-- медиану, среднее и среднеквадратичное отклонение.

DROP DATABASE IF EXISTS task4_6;
CREATE DATABASE task4_6;
USE task4_6;

CREATE table num (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    a REAL NOT NULL,
    b REAL NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;


/*Заполняю таблицу значениями*/
DROP PROCEDURE IF EXISTS fill;
DELIMITER |
CREATE PROCEDURE fill(IN rows_amount INT)
BEGIN
	DECLARE counter INT DEFAULT 0;
    fillNums: LOOP
		INSERT INTO num VALUES (null, rand(), rand());
        SET counter = counter +1;
        IF counter = rows_amount THEN
			LEAVE fillNums;
		END IF;
        
	END LOOP fillNums;
END;

|
DELIMITER |
DROP FUNCTION IF EXISTS isMon;
|

/*Проверка на монотонность*/
DELIMITER |
CREATE FUNCTION isMon()
RETURNS BOOL
DETERMINISTIC
BEGIN
	DECLARE done INT DEFAULT 0;
	DECLARE ascend BOOL DEFAULT TRUE;
	DECLARE descend BOOL DEFAULT TRUE;
	DECLARE curB REAL DEFAULT 0;
	DECLARE prevB REAL DEFAULT 0;
	DECLARE cur
		CURSOR FOR 
			SELECT b FROM num 
	ORDER BY a;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    l: LOOP
		SET prevB = curB;
        FETCH cur INTO curB;
        IF prevB < curB 
			THEN SET descend = FALSE;
		END IF;
        IF prevB > curB THEN SET ascend = TRUE;
        END IF;
        IF done = 1 THEN LEAVE l;
        END IF;
        
	END LOOP l;
    
    CLOSE cur;
    
    RETURN ascend OR descend;
    
    END;
|

/*Вывод статистических данных и информации о монотонности функции*/
DELIMITER |
CREATE PROCEDURE getStatistic ()
BEGIN
	DECLARE avgA REAL DEFAULT 0;
	DECLARE avgB REAL DEFAULT 0;
    DECLARE medianA REAL DEFAULT 0;
    DECLARE medianB REAL DEFAULT 0;
    DECLARE stdA REAL DEFAULT 0;
    DECLARE stdB REAL DEFAULT 0;
    
    DECLARE half_amount INT DEFAULT 0;
    DECLARE half_amount_delta INT DEFAULT 0;
    
    SET avgA = (SELECT avg(a) FROM num);
    SET avgB = (SELECT avg(b) FROM num);
    SET stdA = (SELECT std(a) FROM num);
    SET stdB = (SELECT std(b) FROM num);
    SET half_amount = (SELECT ceil(count(*)/2) FROM num);
    SET half_amount_delta = (half_amount mod 2) + 1;
    SET medianA = (SELECT avg(a) FROM (SELECT a FROM num ORDER BY a LIMIT half_amount, half_amount_delta) x);
    SET medianB = (SELECT avg(b) FROM (SELECT b FROM num ORDER BY b LIMIT half_amount, half_amount_delta) x);
   
   SELECT avgA, avgB, stdA, stdB, medianA, medianB, isMon();
		
END;
|
DELIMITER |
CALL fill(4);
|
CALL getStatistic();
|