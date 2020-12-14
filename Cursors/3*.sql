-- 3. Напишите процедуру, которая выводит тестовые вопросы из таблицы с
-- полями id-test/id-quest/var1/var2/var3 в случайном порядке. Варианты
-- ответов при этом для каждого вопроса также выводятся в случайном
-- порядке.

USE tests;

DROP PROCEDURE IF EXISTS shuffle;

DELIMITER |
CREATE PROCEDURE shuffle (IN testId INT)
BEGIN
	DECLARE done INT DEFAULT 0;
    DECLARE curQuestionId  INT DEFAULT 0;
    DECLARE curText VARCHAR(50) DEFAULT "";
    DECLARE curVar1  VARCHAR(50) DEFAULT "";
    DECLARE curVar2  VARCHAR(50) DEFAULT "";
    DECLARE curVar3  VARCHAR(50) DEFAULT "";
    DECLARE randomOrder INT DEFAULT 0;
    DECLARE cur 
			CURSOR FOR SELECT questionid, text, var1, var2, var3 FROM test
								JOIN question ON question.id = questionid
							WHERE testid = testId;
	 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
     
     CREATE TABLE IF NOT EXISTS RANDOM(
      testid INT NOT NULL,
      questionid INT NOT NULL,
      PRIMARY KEY(testid, questionid),
      text VARCHAR(50) NOT NULL,
      var1 VARCHAR(50) NOT NULL,
      var2 VARCHAR(50) NOT NULL,
      var3 VARCHAR(50) NOT NULL
     )ENGINE=INNODB DEFAULT CHARSET=utf8;
     
	 OPEN cur;
     fillRandom: LOOP
			FETCH cur INTO curQuestionId, curText, curVar1, curVar2, curVar3;
            
            IF done = 1
				THEN LEAVE fillRandom;
			END IF;
			/*Для того, чтобы варианты ответов выводились в случайном порядке*/
			SET randomOrder = floor(rand()*6);
            CASE randomOrder
				WHEN 0 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar1, curVar2, curVar3);
				WHEN 1 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar1, curVar3, curVar2);
				WHEN 2 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar2, curVar1, curVar3);
				WHEN 3 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar2, curVar3, curVar1);
				WHEN 4 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar3, curVar2, curVar1);
				WHEN 5 THEN INSERT INTO RANDOM VALUES(testId, curQuestionId, curText, curVar3, curVar1, curVar2);
			END CASE;
            
            END LOOP fillRandom;
            
            CLOSE cur;
            /*Для того чтобы сами вопросы выводились в рандомном порядке*/
            SELECT * FROM RANDOM ORDER BY rand();
END
|

CALL shuffle(1);