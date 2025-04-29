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

``sql
SELECT * 
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%';
```

