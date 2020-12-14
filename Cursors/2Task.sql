-- 2. Имеется таблица вопрос/ответ1/ответ2/ответ3/уровень сложности с
-- вопросами с указанием уровня их сложности: 1 – простые, 2 – средние, 3
-- – трудные. Необходимо сформировать тест из вопросов так, чтобы
-- простые и сложные вопросы входили в него в соответствии с заданным
-- процентным соотношением.

DROP DATABASE IF EXISTS tests;
CREATE DATABASE tests;
USE tests;

CREATE TABLE question (
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
text VARCHAR(50) NOT NULL,
var1 VARCHAR(50) NOT NULL,
var2 VARCHAR(50) NOT NULL,
var3 VARCHAR(50) NOT NULL,
dif INT NOT NULL
)ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE test (
testid INT NOT NULL,
questionid INT NOT NULL,
PRIMARY KEY (testid,questionid)
)ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 1);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 1);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 1);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 1);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 1);

INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 2);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 2);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 2);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 2);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 2);

INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 3);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 3);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 3);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 3);
INSERT INTO question (text,var1,var2,var3,dif) VALUES ("text", "a", "b", "c", 3);

DROP PROCEDURE IF EXISTS create_test;

DELIMITER |
CREATE PROCEDURE create_test(IN testId INT, IN easy INT, IN middle INT, IN hard INT)
BEGIN
	DECLARE needEasy INT DEFAULT 0;
	DECLARE needMiddle INT DEFAULT 0;
	DECLARE needHard INT DEFAULT 0;
	DECLARE curQuestionId INT DEFAULT 0;
	DECLARE curDif INT DEFAULT 0;
    
    DECLARE done INT DEFAULT 0;
    DECLARE res INT DEFAULT 0;
    DECLARE cur CURSOR
				FOR SELECT id, dif FROM question ORDER BY rand();
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
      OPEN cur;
      
      SET needEasy = easy;
      SET needMiddle = middle;
      SET needHard = hard;
      
		createTest: LOOP
			FETCH cur INTO curQuestionId, curDif;
            
            IF needEasy = 0 AND needMiddle = 0 AND needHard = 0
				THEN LEAVE createTest;
            END IF;
            
            IF curDif = 1 AND needEasy > 0
				THEN INSERT INTO test VALUES(testId, curQuestionId);
                     SET needEasy = needEasy - 1;
			END IF;
            
            IF curDif = 2 AND needMiddle > 0
				THEN INSERT INTO test VALUES(testId, curQuestionId);
                     SET needMiddle = needMiddle - 1;
			END IF;
            
			IF curDif = 3 AND needHard > 0
				THEN INSERT INTO test VALUES(testId, curQuestionId);
                     SET needHard = needHard - 1;
			END IF;
            
            END LOOP createTest;
            CLOSE cur;
END;
|

CALL create_test(1, 2, 1, 5);
SELECT * FROM test;

#######################################################################
-- USE tests;

-- DROP PROCEDURE IF EXISTS shuffle;

-- DELIMITER |
-- CREATE PROCEDURE shuffle (IN testId INT)
-- BEGIN
-- 	DECLARE done INT DEFAULT 0;
--     DECLARE curQuestionId  INT DEFAULT 0;
--     DECLARE curText VARCHAR(50) DEFAULT "";
--     DECLARE curVar1  VARCHAR(50) DEFAULT "";
--     DECLARE curVar2  VARCHAR(50) DEFAULT "";
--     DECLARE curVar3  VARCHAR(50) DEFAULT "";
--     DECLARE randomOrder INT DEFAULT 0;
--     DECLARE cur 
-- 			CURSOR FOR SELECT questionid, text, var1, var2, var3 FROM test
-- 								JOIN question ON question.id = questionid
-- 							WHERE testid = testId;
-- 	 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
--      
--      CREATE TABLE IF NOT EXISTS random(
--       testid INT NOT NULL,
--       questionid INT NOT NULL,
--       PRIMARY KEY(testid, questionid),
--       text VARCHAR(50) NOT NULL,
--       var1 VARCHAR(50) NOT NULL,
--       var2 VARCHAR(50) NOT NULL,
--       var3 VARCHAR(50) NOT NULL
--      )ENGINE=INNODB DEFAULT CHARSET=utf8;
--      
-- 	 OPEN cur;
--      fillRandom: LOOP
-- 			FETCH cur INTO curQuestionId, curText, curVar1, curVar2, curVar3;
--             
--             IF done = 1
-- 				THEN LEAVE fillRandom;
-- 			END IF;
-- 			/*Для того, чтобы варианты ответов выводились в случайном порядке*/
-- 			SET randomOrder = floor(rand()*6);
--             CASE randomOrder
-- 				WHEN 0 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar1, curVar2, curVar3);
-- 				WHEN 1 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar1, curVar3, curVar2);
-- 				WHEN 2 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar2, curVar1, curVar3);
-- 				WHEN 3 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar2, curVar3, curVar1);
-- 				WHEN 4 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar3, curVar2, curVar1);
-- 				WHEN 5 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar3, curVar1, curVar2);
-- 			END CASE;
--             
--             END LOOP fillRandom;
--             
--             CLOSE cur;
--             /*Для того чтобы сами вопросы выводились в рандомном порядке*/
--             SELECT * FROM RANDOM ORDER BY rand();
-- END
-- |

-- CALL shuffle(1);