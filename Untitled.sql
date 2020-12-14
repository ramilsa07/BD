-- 1. Используя таблицу с полями дата/соперник/результат, найти самую
-- долгую серию побед, поражений и ничьих команды в сезоне. Поле
-- результат принимает следующие значения: 1 – победа, 0 – ничья, -1 –
-- поражение

DROP DATABASE IF EXISTS games;
CREATE DATABASE games;
USE games;

CREATE TABLE results(
date DATE,
opponent VARCHAR(50) NOT NULL,
result INT(11) NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', 0);
INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', -1);
INSERT INTO results VALUES(null, 'OPPONENT', -1);
INSERT INTO results VALUES(null, 'OPPONENT', -1);
INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', -1);
INSERT INTO results VALUES(null, 'OPPONENT', -1);
INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', 1);
INSERT INTO results VALUES(null, 'OPPONENT', 1);

DROP PROCEDURE IF EXISTS victories;
DELIMITER |
CREATE PROCEDURE victories(OUT lose INT)
BEGIN
	DECLARE maxLose INT DEFAULT 0;
	DECLARE curLose INT DEFAULT 0;
    
    DECLARE done INT DEFAULT 0;
    DECLARE res INT DEFAULT 0;
    DECLARE cur CURSOR FOR SELECT result FROM results;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
      OPEN cur;
		getRes: LOOP
			FETCH cur INTO res;
            
            IF done = 1 
				THEN LEAVE getRes;
            END IF;
            
            IF res = 1 
				THEN SET curLose = 0;
			END IF;
            
            IF res = 0
				THEN SET curLose = 0;
			END IF;
            
            IF res = -1
				THEN SET curLose = curLose + 1;
			END IF;
            
            IF curLose > maxLose
				THEN SET maxLose = curLose;
			END IF;
            
            END LOOP getRes;
            CLOSE cur;
            SET lose = maxLose;
END;
|

CALL victories(@lose);

SELECT @lose;