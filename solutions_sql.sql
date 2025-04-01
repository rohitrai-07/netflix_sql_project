-- NETFLIX PROJECT.

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);


select * from netflix;
SELECT COUNT(*) FROM netflix;

SELECT
DISTINCT TYPE
FROM NETFLIX;

-- 15 BUSINESS PROBLEMS .
-- 1:COUNT THE NUMBER OF MOVIES VS TV SHOWS .

SELECT TYPE, 
COUNT(*) AS TOTAL_CONTENT 
FROM NETFLIX 
GROUP BY TYPE;

 --2: FIND THE MOST COMMON RATINGS FOR MOVIES AND SERIES.
 
select 
type ,
rating
from
   ( SELECT 
        TYPE, 
        RATING, 
        COUNT(*),
        RANK() OVER (PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS ranking
    FROM NETFLIX
    GROUP BY TYPE, RATING) AS T1 
	where 
	ranking = 1;

	-- 3:list all movies released in a specifc year(eg:2020)

SELECT 
    type, 
	TITLE,
    release_year 
FROM 
    NETFLIX 
WHERE 
    release_year = 2020 
    AND type = 'Movie';

--4: FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT ON NETFLIX .

SELECT 
    UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country, 
    COUNT(*) AS total_count
FROM 
    NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--5:IDENTIFY THE LONGEST MOVIE.


SELECT
type,
title,
SPLIT_PART (duration, ' ', 1) :: INT 
FROM
netflix
WHERE type IN ('Movie') AND duration IS NOT NULL
ORDER BY 3 DESC
LIMIT 1;

--6: find the content added in last 5 years .

select * from netflix
where to_date(date_added , 'month,DD,YYYY')>= CURRENT_DATE - INTERVAL '5 YEARS' ;

--7: find all the movies/tv shows by director 'RAJIV CHILAKA'.

SELECT * FROM NETFLIX ;
WHERE DIRECTOR ILIKE '%RAJIV CHILAKA%';

--8: LIST ALL TV SHOWS WITH MORE THAN 5 SEASONS.

SELECT * 
FROM NETFLIX
WHERE TYPE = 'TV SHOWS'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

--9: count the number of content items in each genre.


select 
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS GENRE,
COUNT(show_id) as genre_count
 from netflix
GROUP BY 1
order by 2 desc ;

--10: find each year and the average number of content release in india on netflix.
--return top 5 year with highest avg content release!

select 
EXTRACT (YEAR FROM TO_DATE(date_added,'MONTH,DD, YYYY')) AS YEAR,
COUNT(*) AS TOTAL_COUNT,
COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM NETFLIX WHERE COUNTRY ='India')::numeric * 100 as avg_content_per_year
from netflix
where country ='India'
GROUP BY 1;

--11: list all movie which are documentaries.

select * from netflix 
where
listed_in ilike '%documentaries%';

--12: find all content without the director.

 select * from netflix;
where director is NULL;

--13: find in how many movies actor 'salman khan' appered in last 15 year.

select * from netflix
where 
 casts ILIKE '%salman khan%'
 AND 
 release_year > EXTRACT(YEAR FROM CURRENT_DATE)-15;

 --14: find the top 10 actors who have appeared in the highest number of movies produced in India.
 
select 
UNNEST(STRING_TO_ARRAY(CASTS,',')) AS ACTORS,
COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX
WHERE COUNTRY ILIKE '%INDIA%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--15: CATEGORIZE THE CONTENT BASED ON THE PRESENCE OF THE KEYWORD 'KILL' AND 'VIOLENCE' IN THE DESCRIPTION FEILD.
--LABLE CONTENT CONTAINING THESE KEYWORD AS 'BAD' AND ALL OTHER CONTENT AS 'GOOD'. COUNT HOW MANY ITEMS FALL INTO EACH CATEGORY .

WITH new_table
AS
(
SELECT *,
CASE 
WHEN 
DESCRIPTION ILIKE '%KILL%' OR 
DESCRIPTION ILIKE '%VIOLENCE%' THEN 'BAD_CONTENT'
ELSE 'GOOD_CONTENT'
END CATEGORY
FROM NETFLIX
)
SELECT 
CATEGORY,
COUNT(*) AS TOTAL_CONTENT
FROM new_table
group by 1 ;


 










