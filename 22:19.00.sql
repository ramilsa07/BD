DROP DATABASE IF EXISTS music;
CREATE DATABASE music;
USE music;

CREATE TABLE genre(
name VARCHAR(45) NOT NULL UNIQUE, #COLLATE utf8_general_ci
PRIMARY KEY(name)
)
ENGINE=INNODB DEFAULT CHARSET=utf8;
#COLLATE utf8_general_ci;

CREATE TABLE album(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
PRIMARY KEY(id, name)
)
ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE song(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
album_id INT NOT NULL, 
album_name VARCHAR(45) NOT NULL,
PRIMARY KEY(id, name),
FOREIGN KEY(album_id, album_name) REFERENCES album(id, name) ON DELETE CASCADE 
)
ENGINE=INNODB DEFAULT CHARSET=utf8;


CREATE TABLE genre_has_song(
genre_name VARCHAR(45) NOT NULL,
song_name VARCHAR(45) NOT NULL,
song_id INT NOT NULL,
PRIMARY KEY(genre_name, song_name, song_id),
FOREIGN KEY(genre_name) REFERENCES genre(name) ON DELETE CASCADE,
FOREIGN KEY(song_id, song_name) REFERENCES song(id, name) ON DELETE CASCADE
)
ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE lable(
name VARCHAR(45) NOT NULL UNIQUE,
PRIMARY KEY(name)
)
ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE musican(
id INT NOT NULL AUTO_INCREMENT,
name VARCHAR(45) NOT NULL,
lable_name VARCHAR(45),
PRIMARY KEY(id, name),
FOREIGN KEY(lable_name) REFERENCES lable(name) ON DELETE SET NULL
)
ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE music_track(
song_id INT NOT NULL,
song_name VARCHAR(45) NOT NULL,
musican_id INT NOT NULL,
musican_name VARCHAR(45) NOT NULL,
duration INT NOT NULL, # Измеряется в секундах
PRIMARY KEY(song_id, song_name, musican_id, musican_name),
FOREIGN KEY(song_id, song_name) REFERENCES song(id, name) ON DELETE CASCADE,
FOREIGN KEY(musican_id, musican_name) REFERENCES musican(id, name) ON DELETE CASCADE
)
ENGINE=INNODB DEFAULT CHARSET=utf8;
################################################################
#Для заданий
CREATE TABLE another_tracks(
id INT NOT NULL AUTO_INCREMENT,
song_name VARCHAR(45) NOT NULL,
musican_name VARCHAR(45) NOT NULL,
duration INT NOT NULL,
PRIMARY KEY(id)
)
ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE another_tracks1(
id INT NOT NULL AUTO_INCREMENT,
song_name VARCHAR(45) NOT NULL,
musican_name VARCHAR(45) NOT NULL,
duration INT NOT NULL,
PRIMARY KEY(id)
)
ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO another_tracks VALUES(null, "song9", "mus9", 191);
INSERT INTO another_tracks VALUES(null, "song8", "mus8", 182);
INSERT INTO another_tracks VALUES(null, "song7", "mus7", 190);

INSERT INTO another_tracks1 VALUES(null, "song9", "mus9", 191);
INSERT INTO another_tracks1 VALUES(null, "song6", "mus6", 300);
INSERT INTO another_tracks1 VALUES(null, "song7", "mus7", 190);

################################################################

INSERT INTO genre VALUES("rock");
INSERT INTO genre VALUES("hip-hop");
INSERT INTO genre VALUES("disco");

INSERT INTO album VALUES(null, "album1");
INSERT INTO album VALUES(null, "album2");
INSERT INTO album VALUES(null, "album3");

INSERT INTO song VALUES(null, "song1", 1, "album1");
INSERT INTO song VALUES(null, "song2", 2, "album2");
INSERT INTO song VALUES(null, "song3", 3, "album3");
INSERT INTO song VALUES(null, "song1.1", 1, "album1");
INSERT INTO song VALUES(null, "song1.2", 1, "album1");

INSERT INTO genre_has_song VALUES("rock", "song1", 1);
INSERT INTO genre_has_song VALUES("rock", "song1.1", 4);
INSERT INTO genre_has_song VALUES("rock", "song1.2", 5);
INSERT INTO genre_has_song VALUES("hip-hop", "song2", 2);
INSERT INTO genre_has_song VALUES("disco", "song3", 3);

INSERT INTO lable VALUES("lable1");
INSERT INTO lable VALUES("lable2");

INSERT INTO musican VALUES(null, "mus1", "lable1");
INSERT INTO musican VALUES(null, "mus2", "lable2");
INSERT INTO musican VALUES(null, "mus3", null);

INSERT INTO music_track VALUES(1, "song1", 1, "mus1", 180);
INSERT INTO music_track VALUES(2, "song2", 2, "mus2", 237);
INSERT INTO music_track VALUES(3, "song3", 3, "mus3", 212);
INSERT INTO music_track VALUES(4, "song1.1", 1, "mus1", 195);
INSERT INTO music_track VALUES(5, "song1.2", 1, "mus1", 248);

-- SELECT * FROM genre;
-- SELECT * FROM album;
-- SELECT * FROM song;
-- SELECT * FROM lable;
-- SELECT * FROM genre_has_song;
-- SELECT * FROM musican;
-- SELECT * FROM music_track;


# I. Запросы с использованием одной таблицы.
# 1. Выборка без использования фразы WHERE. ALL, DISTINCT. Использование фразы CASE.

-- SELECT id, name, CASE WHEN lable_name IS NULL THEN "No lable :(" ELSE "Have lable" END lable_name FROM musican;
-- SELECT DISTINCT musican_name, duration FROM music_track WHERE duration > ALL(SELECT duration FROM another_tracks);

# 2. Выборка вычисляемых значений. Использование псевдонимов таблиц.

-- SELECT song_name AS "Название_песни", musican_name AS "Имя_музыканта", duration AS "Длительность" 
-- FROM music_track
-- WHERE duration > 200;

# 3. Синтаксис фразы WHERE. BETWEEN, IS [NOT] NULL, LIKE, UPPER, LOWER. IN, EXISTS.

-- SELECT * FROM music_track WHERE duration > 200;
-- SELECT * FROM music_track WHERE duration BETWEEN 190 AND 240;
-- SELECT * FROM music_track WHERE duration IN(180, 248)
-- SELECT * FROM musican WHERE lable_name IS NULL;
-- SELECT * FROM musican WHERE lable_name IS NOT NULL;
-- SELECT * FROM music_track WHERE song_name LIKE "song1%";
-- SELECT * FROM music_track WHERE song_name LIKE "song1._";
-- SELECT id, UPPER(name), LOWER(lable_name) FROM musican;
-- SELECT * FROM music_track WHERE EXISTS(SELECT * FROM song WHERE name LIKE "song1._");

# 4. Выборка с упорядочением. ORDER BY, ASC, DESC.

-- SELECT * FROM genre ORDER BY name ASC;
-- SELECT * FROM genre ORDER BY name DESC;

# 5. Агрегирование данных. Агрегатные SQL-функции (COUNT, SUM, AVG, MIN, MAX).

-- SELECT musican_name, SUM(duration) FROM music_track GROUP BY musican_name;
-- SELECT musican_name, ROUND(AVG(duration),1) FROM music_track GROUP BY musican_name;
-- SELECT musican_name, MIN(duration) FROM music_track GROUP BY musican_name;
-- SELECT musican_name, MAX(duration) FROM music_track GROUP BY musican_name;
-- SELECT musican_name, COUNT(song_name) FROM music_track GROUP BY musican_name;

# 6. Агрегирование данных без и с использованием фразы GROUP BY. Фраза HAVING.

-- SELECT musican_name, SUM(duration) FROM music_track GROUP BY musican_name HAVING SUM(duration) > 300;

########################################################################################################
# II. Запросы с использованием нескольких таблиц.
# II.1. Бинарные операции и соединения.
# 1. Реализация EXEPT (MINUS), INTERSECT, UNION.

# EXCEPT (MINUS) минус
-- SELECT DISTINCT * FROM another_tracks WHERE (song_name, musican_name, duration)
-- NOT IN (SELECT song_name, musican_name, duration FROM another_tracks1);

# INTERSECT пересечение
-- SELECT DISTINCT * FROM another_tracks WHERE (song_name, musican_name, duration)
-- IN (SELECT song_name, musican_name, duration FROM another_tracks1);

# UNION объединение
-- SELECT * FROM another_tracks UNION SELECT * FROM another_tracks1

# 2. Реализация операции деления отношений.
# НИЧЕГО НЕ НАЙДЕНО!!!! ЧТО ЭТО ВООБЩЕ?????

# 3. Эквисоединение, естественное соединение, композиция. Внутренние и внешние соединения.
# Пока оставим эту затею

# 4. Соединения таблиц с фразой JOIN и без неё. USING. CROSS JOIN (INNER JOIN), LEFT JOIN, RIGHT JOIN.

-- SELECT * FROM song JOIN music_track WHERE music_track.song_name = song.name;
-- SELECT * FROM genre NATURAL JOIN genre_has_song;
-- SELECT * FROM song INNER JOIN music_track WHERE music_track.song_name = song.name;

-- SELECT * FROM song LEFT OUTER JOIN music_track ON music_track.song_name = song.name;
-- SELECT * FROM song RIGHT OUTER JOIN music_track ON music_track.song_name = song.name;
-- SELECT * FROM song LEFT JOIN music_track ON music_track.song_name = song.name;
-- SELECT * FROM song RIGHT JOIN music_track ON music_track.song_name = song.name;
-- SELECT * FROM song CROSS JOIN music_track ON music_track.song_name = song.name;
-- SELECT * FROM song WHERE name IN(SELECT song_name FROM music_track WHERE musican_name LIKE "mus%");
-- SELECT * FROM song, music_track;

-- SELECT * FROM song RIGHT JOIN album USING(id);
-- SELECT * FROM song JOIN album USING(id);

# 5. Θ-соединение.

# 6. Соединение таблицы с самой собой. Удаление дубликатов записей в таблице.
-- SELECT another_tracks.* FROM another_tracks 
-- JOIN another_tracks AS us ON another_tracks.musican_name = us.musican_name
-- WHERE another_tracks.id = us.id
-- ORDER BY us.id;

# III. Индексы. Хранимые процедуры. Триггеры.
-- 1. Создайте индексы и обоснуйте их необходимость для выбранных таблиц.
-- CREATE INDEX duration ON music_track(duration);
-- # Индекс поможет быстро находить, например, небольшие треки для установки их на рингтон:)
-- SELECT * FROM music_track WHERE duration < 200;

-- 2. Реализуйте триггеры {BEFORE|AFTER}{INSERT|UPDATE|DELETE}.
-- DELIMITER // 
-- CREATE TRIGGER duration_Insert_Update AFTER INSERT ON music_track 
-- FOR EACH ROW BEGIN
-- SET duration = duration + 2;
--   END; // 
-- DELIMITER ;

CREATE DEFINER = duration_Insert_Update TRIGGER music_track BEFORE INSERT ON
BEGIN
SET duration = duration + 2;
END;

-- 3. Реализуйте хранимые процедуры и функции для всех типов входных параметров для коррелированных запросов и соединений.


