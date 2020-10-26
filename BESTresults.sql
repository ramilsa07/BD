DROP DATABASE IF EXISTS winners;
CREATE DATABASE winners;
USE winners;

CREATE TABLE trainer (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;

CREATE TABLE team(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;

CREATE TABLE trainer_team (
  trainer_id INT NOT NULL,
  team_id INT NOT NULL, 
  FOREIGN KEY (trainer_id) REFERENCES trainer (id) ON DELETE CASCADE,
  FOREIGN KEY (team_id) REFERENCES team (id) ON DELETE CASCADE,
  PRIMARY KEY (trainer_id, team_id))
ENGINE = InnoDB;

CREATE TABLE check_points(
points INT UNSIGNED NOT NULL,
team_id INT NOT NULL, 
FOREIGN KEY (team_id) REFERENCES team (id) ON DELETE CASCADE,
PRIMARY KEY(points, team_id))
ENGINE = InnoDB;

CREATE TABLE result(
place INT UNSIGNED NOT NULL,
check_points_points INT UNSIGNED NOT NULL,
team_id INT NOT NULL, 
trainer_id INT NOT NULL,
FOREIGN KEY (trainer_id) REFERENCES trainer (id) ON DELETE CASCADE,
FOREIGN KEY (team_id) REFERENCES team (id) ON DELETE CASCADE,
FOREIGN KEY (check_points_points) REFERENCES check_points (points) ON DELETE CASCADE,
PRIMARY KEY(place, check_points_points, team_id, trainer_id))
ENGINE = InnoDB;

INSERT INTO trainer VALUES (null,"trainer1");
INSERT INTO trainer VALUES (null,"trainer2");
INSERT INTO trainer VALUES (null,"trainer3");
INSERT INTO trainer VALUES (null,"trainer4");

INSERT INTO team VALUES (null,"team1");
INSERT INTO team VALUES (null,"team2");
INSERT INTO team VALUES (null,"team3");
INSERT INTO team VALUES (null,"team4");
INSERT INTO team VALUES (null,"team5");

INSERT INTO trainer_team VALUES (1,1);
INSERT INTO trainer_team VALUES (2,1);
INSERT INTO trainer_team VALUES (2,2);
INSERT INTO trainer_team VALUES (3,2);
INSERT INTO trainer_team VALUES (3,3);
INSERT INTO trainer_team VALUES (3,4);
INSERT INTO trainer_team VALUES (4,5);

INSERT INTO check_points VALUES(1000, 1);
INSERT INTO check_points VALUES(2000, 2);
INSERT INTO check_points VALUES(3000, 3);
INSERT INTO check_points VALUES(4000, 4);
INSERT INTO check_points VALUES(5000, 5);

INSERT INTO result VALUES(1, 5000, 5, 4);
INSERT INTO result VALUES(2, 4000, 4, 3);
INSERT INTO result VALUES(3, 3000, 3, 3);
INSERT INTO result VALUES(4, 2000, 2, 3);
INSERT INTO result VALUES(4, 2000, 2, 2);
INSERT INTO result VALUES(5, 1000, 1, 2);
INSERT INTO result VALUES(5, 1000, 1, 1);

-- 5) тренеров, для которых среднее количество очков команд, которые они
-- тренировали, больше среднего значения по всем тренерам из таблицы.
-- т.е. сумма средних значений тренеров / кол тренеров = 2625 

-- SELECT trainer_id, COUNT(trainer_id), ROUND(AVG(check_points_points)) 
-- FROM result
-- GROUP BY trainer_id
-- HAVING ROUND(AVG(check_points_points)) > (SELECT AVG(check_points_points) FROM result);


-- 6) команды, становившиеся чемпионами с разными тренерами;

-- INSERT INTO team VALUES (null,"team6");
-- INSERT INTO trainer_team VALUES (1,6);
-- INSERT INTO trainer_team VALUES (3,6);
-- INSERT INTO trainer_team VALUES (4,6);
-- INSERT INTO check_points VALUES(10000, 6);
-- INSERT INTO result VALUES(1, 10000, 6, 1);
-- INSERT INTO result VALUES(1, 10000, 6, 3);
-- INSERT INTO result VALUES(1, 10000, 6, 4);

-- SELECT team_id, place, COUNT(trainer_id) FROM result GROUP BY team_id, place HAVING COUNT(trainer_id)>1 AND place = 1;

-- 7) команды, которые тренировали тренеры, выигравшие чемпионат не с
-- этой, а с другими командами.

-- INSERT INTO team VALUES (null,"team6");
-- INSERT INTO trainer_team VALUES (1,6);
-- INSERT INTO trainer_team VALUES (3,6);
-- INSERT INTO trainer_team VALUES (4,6);
-- INSERT INTO check_points VALUES(10000, 6);
-- INSERT INTO result VALUES(1, 10000, 6, 1);
-- INSERT INTO result VALUES(1, 10000, 6, 3);
-- INSERT INTO result VALUES(1, 10000, 6, 4);

-- SELECT team_id, place, trainer_id 
-- FROM result 
-- WHERE (place <> 1) AND (trainer_id IN (SELECT trainer_id FROM result WHERE place = 1));

