
INSERT INTO SHOW_TYPE
(Show_Type)
SELECT DISTINCT `type` FROM BULK_NETFLIX_SHOWS;

INSERT INTO MATURITY_RATING
(Rating)
SELECT DISTINCT rating FROM BULK_NETFLIX_SHOWS;

INSERT INTO GENRE
(Genre)
SELECT DISTINCT genre_name
FROM BULK_NETFLIX_SHOWS
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(listed_in, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (genre_name VARCHAR(255) PATH "$")) AS genres;


UPDATE BULK_NETFLIX_SHOWS
SET country = 'Unknown Country'
WHERE country IS NULL OR TRIM(country) = '';


INSERT INTO COUNTRY
(Country)
SELECT DISTINCT TRIM(countries.country)
FROM BULK_NETFLIX_SHOWS
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(country, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (country VARCHAR(255) PATH "$")) AS countries;


UPDATE BULK_NETFLIX_SHOWS
SET director = 'Unknown Director'
WHERE director IS NULL OR TRIM(director) = '';


INSERT INTO DIRECTOR
(First_Name, Last_Name)
SELECT DISTINCT TRIM(SUBSTRING(directors.director, 1, LOCATE(' ', directors.director))) AS First_Name,
TRIM(SUBSTRING(directors.director, LOCATE(' ', directors.director)+1)) AS Last_Name
FROM BULK_NETFLIX_SHOWS
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(director, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (director VARCHAR(255) PATH "$")) AS directors;


INSERT INTO ACTOR
(First_Name, Last_Name)
SELECT DISTINCT TRIM(SUBSTRING(actors.cast, 1, LOCATE(' ', actors.cast))) AS First_Name,
TRIM(SUBSTRING(actors.cast, LOCATE(' ', actors.cast)+1)) AS Last_Name
FROM BULK_NETFLIX_SHOWS
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(cast, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (cast VARCHAR(255) PATH "$")) AS actors
WHERE TRIM(actors.cast) <> '';
    

ALTER TABLE BULK_NETFLIX_SHOWS
ADD Show_Type_ID INT,
ADD Rating_ID INT;

UPDATE BULK_NETFLIX_SHOWS b, SHOW_TYPE s
SET b.Show_Type_ID = s.Show_Type_ID
WHERE b.`type` = s.Show_Type;

UPDATE BULK_NETFLIX_SHOWS b, MATURITY_RATING m
SET b.Rating_ID = m.Rating_ID
WHERE b.rating = m.Rating;


INSERT INTO SHOW_DETAILS
(Title, Show_Type_ID, Date_Added, Release_Year, Duration_Value, Duration_Unit, `Description`, Rating_ID)
SELECT TRIM(title) AS Title,
Show_Type_ID,
STR_TO_DATE(TRIM(date_added), '%y-%b-%d') AS Date_Added, 
TRIM(release_year) AS Release_Year,
CAST(SUBSTRING(TRIM(duration),1,LOCATE(' ', duration)) AS UNSIGNED) AS Duration_Value,
SUBSTRING(TRIM(duration),LOCATE(' ', duration)+1) AS Duration_Unit,
TRIM(`description`) AS `Description`,
Rating_ID
FROM BULK_NETFLIX_SHOWS;


UPDATE SHOW_DETAILS
SET Duration_Unit = 'Season'
WHERE Duration_Unit = 'Seasons';


INSERT INTO SHOW_GENRE_INT
(Show_ID, Genre_ID)
SELECT DISTINCT sd.Show_ID, g.Genre_ID
FROM BULK_NETFLIX_SHOWS b
JOIN SHOW_DETAILS sd ON TRIM(b.title) = sd.Title
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(b.listed_in, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (genre_name VARCHAR(255) PATH "$")) AS genres
JOIN GENRE g ON genres.genre_name = g.Genre;


INSERT INTO SHOW_DIRECTOR_INT
(Show_ID, Director_ID)
SELECT DISTINCT sd.Show_ID, d.Director_ID
FROM BULK_NETFLIX_SHOWS b
JOIN SHOW_DETAILS sd ON TRIM(b.title) = sd.Title
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(b.director, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (director VARCHAR(255) PATH "$")) AS directors
JOIN DIRECTOR d 
ON TRIM(SUBSTRING(directors.director, 1, LOCATE(' ', directors.director))) = d.First_Name
AND TRIM(SUBSTRING(directors.director, LOCATE(' ', directors.director)+1)) = d.Last_Name;


INSERT INTO SHOW_ACTOR_INT
(Show_ID, Actor_ID)
SELECT DISTINCT sd.Show_ID, a.Actor_ID
FROM BULK_NETFLIX_SHOWS b
JOIN SHOW_DETAILS sd ON TRIM(b.title) = sd.Title
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(b.cast, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (cast VARCHAR(255) PATH "$")) AS actors
JOIN ACTOR a 
ON TRIM(SUBSTRING(actors.cast, 1, LOCATE(' ', actors.cast))) = a.First_Name
AND TRIM(SUBSTRING(actors.cast, LOCATE(' ', actors.cast)+1)) = a.Last_Name
WHERE TRIM(actors.cast) <> '';


INSERT INTO SHOW_COUNTRY_INT
(Show_ID, Country_ID)
SELECT DISTINCT sd.Show_ID, c.Country_ID
FROM BULK_NETFLIX_SHOWS b
JOIN SHOW_DETAILS sd ON TRIM(b.title) = sd.Title
JOIN JSON_TABLE(CONCAT('[\"', REPLACE(b.country, ', ', '\",\"'), '\"]'),
    "$[*]" COLUMNS (country VARCHAR(255) PATH "$")) AS countries
JOIN COUNTRY c ON countries.country = c.Country;
