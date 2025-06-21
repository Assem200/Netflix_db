-- 1. Count the number of Movies vs TV Shows

SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY 1

-- 2. Find the most common rating for movies and TV shows

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * 
FROM netflix
WHERE release_year = 2020


-- 4. Find the top 5 countries with the most content on Netflix

SELECT * 
FROM
(
	SELECT 
		-- country,
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5


-- 5. Identify the longest movie

SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC


-- 6. Find content added in the last 5 years
SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM
(

SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM 
netflix
)
WHERE 
	director_name = 'Rajiv Chilaka'
--8. list all tv shows with more than 5 seasons

select * 
from netflix
where 
	  TYPE='TV Show'
	  and
	  split_part(duration, ' ', 1):: numeric > 5 

--9. Count the number of content items in each genre 

SELECT unnest(string_to_array(listed_in, ',')) as genre,
	   count(show_id) as total_content
FROM netflix
group by 1

--10. Find each year and the average numbers of content release by India on netflix
select 
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
	count(*),
	round(
	count(*)::numeric/(select count(*) from netflix where country='India')::numeric*100
	,2) as avg_content_per_year
from netflix
where country='India'
group by 1

--11. list all the movies that are documentaries

select *
from netflix 
where listed_in ilike '%documentaries%'

--12. find all content without a director

select * from netflix
where 
	director is null

-- 13.Find how many movies actor 'Salman Khan' appeared in last 10 years

select * from netflix
where 
	casts ilike '%Salman Khan%'
	and 
	release_year> extract(year from current_date)-10

	--14. find the top 10 actors who have appeared in the highest umber of movies produced in India

	select 
			--lised_id,
			--casts,	
			unnest(string_to_array(casts,',')) as actors
			COUNT(*) AS TOTAL_CONTENT
	from netflix
	where country ilike '%india'
	group by 1
	
	


	  