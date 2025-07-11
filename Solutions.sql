-- Netflix project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type    VARCHAR(10),
	title	VARCHAR(150),
	director VARCHAR(208),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year INT,
	rating	VARCHAR(10),
	duration VARCHAR(15),
	listed_in	VARCHAR(100),
	description  VARCHAR(250)

);

SELECT * FROM netflix       

SELECT
	COUNT(*) AS total_content
FROM netflix;

SELECT
	DISTINCT type
FROM netflix;

-- Q.1 Count the number of Movies vs TV shows

SELECT
	type,
	COUNT(*) AS total
FROM netflix
GROUP BY type
	

-- Q.2 Find the most common rating for movies and TV shows

SELECT
	type,
	rating
FROM
(
SELECT
	type,
	rating,
	COUNT(*),
	RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY type,rating
) AS t1
WHERE
	ranking = 1


-- Q.3 List all movies released in a specific year(eg. 2020)
-- release_year & title

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = '2020'


-- Q.4 Find the top 5 countries with the most content on Netflix

SELECT
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
	COUNT(show_id) AS total
FROM netflix 
GROUP BY 1 DISTINCT
ORDER BY 2 DESC
LIMIT 5


-- Q.5 Identify the longest movie

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix)


-- Q.6 Find content added in the last 5 years

SELECT
	*
FROM netflix
WHERE
	TO_DATE(date_added,'Month DD YYYY') >= CURRENT_DATE - INTERVAL '5 years'


-- Q.7 Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'


-- Q.8 List all TB shows with more than 5 seasons

SELECT 
	*
FROM netflix
WHERE
	type = 'TV Show'
	AND
	SPLIT_PART(duration,' ',1)::numeric > 5


-- Q.9 Count the number of content items in each genre


SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in,','))) AS genre,
	COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC


-- Q.10 Find each year and the average numbers of content realse by India on betflix.
-- return to 5 year with highest avg content relase !


SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added,'Month,DD,YYYY')) AS Year,
	COUNT(*) AS yearly_content,
	ROUND(
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100
	,2) AS avg_content_perYear
FROM netflix
WHERE country = 'India'
GROUP BY 1


-- Q.11 List all movies that are documentaries

SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'


-- Q.12 Find all content without a director

SELECT * FROM netflix
WHERE
	director IS NULL


-- Q.13 Find how many movies actor 'salman khan' appeared in last 10 years!


SELECT * FROM netflix
WHERE
	casts ILIKE '%salman khan%'
	AND
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- Q.14 Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
	UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
	COUNT(*) AS total_content
FROM netflix
WHERE
	country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
	

-- Q.15 Categorize the content based on the presence of hte keywords 'kill' and 'violence' 
-- in the description field. Label content containing these keywords as 'Bad' and all other
-- content as 'Good'. Count how many items fall into each category.

SELECT
	content_good_bad,
	COUNT(*) AS Total
FROM
(
SELECT 
	description,
	CASE
	WHEN
		description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
		ELSE 'Good'
	END AS content_good_bad
FROM netflix
)
GROUP BY 1

	

















