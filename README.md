# 🎬 Netflix Movies and TV Shows Data Analysis using SQL

![NETFLIX LOGO](https://github.com/rohitrai-07/netflix_sql_project/blob/main/logo.png)

---

## 📌 Overview
 
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL.  
The goal is to extract valuable insights and answer various business questions based on the dataset.

---

## 🎯 Objectives

- Analyze the distribution of content types (Movies vs TV Shows).
- Identify the most common ratings for Movies and TV Shows.
- Analyze content by release years, countries, and durations.
- Categorize content using keywords and specific criteria.

---

## 📊 Dataset

- **Source**: Kaggle  
- **Dataset Link**: _[Movies Dataset](https://www.kaggle.com/shivamb/netflix-shows)_

### 🧩 Schema

```sql
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
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
```

## Bussiness Problems and SQL Solutions

### 1. Count number of movies and TV Shows

```sql
SELECT 
    type,
    COUNT(*) 
FROM netflix 
GROUP BY type;
```
### 2.Find the Most Common Ratings for Movies and TV Shows

```sql
SELECT 
    type,
    rating
FROM (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS count_rating,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) AS ranked
WHERE ranking = 1;
```

### 3.List All Movies Released in the Year 2020

```sql
SELECT 
    type, 
    title,
    release_year 
FROM netflix 
WHERE release_year = 2020 AND type = 'Movie';
```

### 4.Find Top 5 Countries with the Most Content

```sql
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country, 
    COUNT(*) AS total_count
FROM netflix
GROUP BY country
ORDER BY total_count DESC
LIMIT 5;
```

### 5.Identify the Longest Movie on Netflix

```sql
SELECT
    type,
    title,
    duration,
    SPLIT_PART(duration, ' ', 1)::INT AS minutes
FROM netflix
WHERE type = 'Movie' AND duration ILIKE '%min%'
ORDER BY minutes DESC
LIMIT 1;
```

### 6. Find All Content Added in the Last 5 Years

```sql
SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

### 7.Find All Movies or TV Shows Directed by Rajiv Chilaka


```sql
SELECT * 
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%';
```

### 8.List All TV Shows With More Than 5 Seasons

```sql
SELECT * 
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
    COUNT(*) AS genre_count
FROM netflix
GROUP BY genre
ORDER BY genre_count DESC;
```

### 10.Find Each Year and the Average Percentage of Content Released in India

```sql
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS total_count,
    ROUND(COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%') * 100, 2) AS avg_content_percent
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY year
ORDER BY avg_content_percent DESC
LIMIT 5;
```

### 11.List All Movies That Are Documentaries

```sql
SELECT * 
FROM netflix 
WHERE listed_in ILIKE '%Documentaries%' AND type = 'Movie';
```

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL OR director = '';
```

### 13. Count How Many Movies Salman Khan Appeared In During the Last 15 Years

```sql
SELECT * 
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 15;
```

### 14. Find Top 10 Actors Who Appeared the Most in Indian Movies

```sql
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*) AS total_movies
FROM netflix
WHERE country ILIKE '%India%' AND type = 'Movie'
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;
```


### 15.Categorize Content Based on Presence of 'Kill' or 'Violence' in Description


```sql
WITH categorized AS (
    SELECT *,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content'
            ELSE 'Good_Content'
        END AS category
    FROM netflix
)
SELECT 
    category,
    COUNT(*) AS total_content
FROM categorized
GROUP BY category;
```


### Tools Used

* PostgreSQL / SQL

* Kaggle for dataset

* GitHub for version control

### Insights & Learnings

* Netflix hosts significantly more movies than TV shows.

* The most common rating differs between content types.

* Indian content is consistently released every year with noticeable patterns.

* Metadata quality (like missing directors) needs cleaning for analysis.

* Keyword-based classification can reveal thematic trends.

