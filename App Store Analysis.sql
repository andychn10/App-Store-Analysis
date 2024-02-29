CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

-- Check for missing values --

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS null OR user_rating IS null OR prime_genre is NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS null

-- Find the number of apps per genre --

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

-- Summarize app ratings --

SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore

-- Basic summary of paid apps --

SELECT min(price) AS MinPrice,
	   max(price) AS MaxPrice,
       avg(price) AS AvgPrice
FROM AppleStore
WHERE price > 0

-- Distribution of App Prices --

SELECT
	(price / 2) *2 AS PriceBinStart,
    ((price / 2) *2) +2 AS PriceBinEnd,
    COUNT(*) AS NumApps
FROM AppleStore
GROUP BY PriceBinStart
ORDER BY PriceBinStart

** ANALYSIS **

-- Determine whether paid apps have higher ratings --

SELECT CASE
	   WHEN price > 0 THEN 'Paid App'
           ELSE 'Free App'
       END AS App_Type,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type

-- Check if apps with more supported languages have higher ratings --

SELECT CASE
	    WHEN lang_num < 10 THEN 'Less than 10 languages'
            WHEN lang_num BETWEEN 10 AND 15 THEN '10 - 20 languages'
            WHEN lang_num BETWEEN 20 AND 25 THEN '20 - 30 languages'
            ELSE 'Greater than 30 languages'
       END AS language_basket,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_basket
ORDER BY Avg_Rating DESC

-- Check genres with low ratings --

SELECT prime_genre,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 5

-- Check genres with high ratings --
SELECT prime_genre,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating DESC
LIMIT 5

-- Check top-rated apps for each genre --

SELECT
      prime_genre,
      track_name,
      user_rating
FROM (
      SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
      FROM
      AppleStore
    ) AS a
WHERE 
a.rank = 1
 
