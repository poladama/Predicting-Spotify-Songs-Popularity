-- Note: all the insights from SQL queries are based on only 100 observations and not the full dataset.

-- 1) Who are the top 5 actor/actress who appear in Netflix shows/movies the most? 
SELECT First_Name, Last_Name, COUNT(*) AS appearances
FROM ACTOR a 
JOIN SHOW_ACTOR_INT sai ON a.Actor_ID = sai.Actor_ID
GROUP BY a.Actor_ID
ORDER BY appearances DESC
LIMIT 5;

/* Answer: actors Junko Takeuchi, Chie Nakamura, Kazuhiko Inoue, Houko Kuwashima, and Showtaro Morikubo
 apper in the 100-row dataset most.*/

-- 2) Which director has the most movies/shows available on Netflix?

SELECT First_Name, Last_Name, COUNT(*) AS number_of_movies_directed
FROM DIRECTOR d 
JOIN SHOW_DIRECTOR_INT sdi ON d.Director_ID = sdi.Director_ID
WHERE First_Name <> 'Unknown' AND Last_Name <> 'Director'
GROUP BY d.Director_ID
ORDER BY number_of_movies_directed DESC
LIMIT 1;

-- Answer: Toshiya Shinohara is the most popular director: 4 movies/shows on the platform are directed/co-directed by him.

-- 3) How many movies/shows released each year since 2015 are on the platform?
SELECT release_year, COUNT(*) AS number_of_movies
FROM vw_ALL
WHERE release_year > 2014
GROUP BY release_year;

-- Answer: 2021: 46 movies/shows, 2020: 6 movies/shows, 2018: 5 movies/shows, 2017: 2 movies/shows, 2019: 2 movies/shows.

-- 4) How many movies vs tv shows are on the platform?
SELECT `type`, COUNT(*) AS number_of_movies 
FROM vw_ALL
GROUP BY `type`;

-- Answer: There are 37 TV shows vs 52 movies in the dataset.

-- 5) What are the top 3 the most popular maturity rating categories of the Netflix content?
SELECT rating, COUNT(*) AS number_of_movies 
FROM vw_ALL
GROUP BY rating
ORDER BY number_of_movies DESC
LIMIT 3;

-- Answer: TV-MA, TV-PG, and TV-14. 