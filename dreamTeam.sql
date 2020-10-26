DROP DATABASE IF EXISTS bestTeam;
CREATE DATABASE bestTeam;
USE bestTeam ;

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
    FOREIGN KEY (trainer_id)
    REFERENCES trainer (id)
    ON DELETE CASCADE,
    FOREIGN KEY (team_id)
    REFERENCES team (id)
    ON DELETE CASCADE,
     PRIMARY KEY (trainer_id, team_id))
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

INSERT INTO trainer_team VALUES (1,2);
INSERT INTO trainer_team VALUES (1,3);
INSERT INTO trainer_team VALUES (1,1);
INSERT INTO trainer_team VALUES (2,2);
INSERT INTO trainer_team VALUES (2,3);
INSERT INTO trainer_team VALUES (3,1);
INSERT INTO trainer_team VALUES (4,5);

/*команды, которые тренировал более чем один тренер*/
SELECT team.*, COUNT(*) FROM trainer_team , team WHERE team.id = trainer_team.team_id
GROUP BY team_id HAVING COUNT(*)>1;

/*тренеров, которые не тренировали заданную команду*/
SELECT * FROM trainer WHERE id
NOT IN(SELECT trainer_id FROM trainer_team,team WHERE (team_id= 2 ));