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
