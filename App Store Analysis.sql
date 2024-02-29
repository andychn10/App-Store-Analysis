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

SELECT prime_genre, COUNT(*) as NumApps
FROM AppleStore
group by prime_genre
ORDER by NumApps DESC

-- Summarize app ratings --

SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) as AvgRating
FROM AppleStore

-- Basic summary of paid apps --

SELECT min(price) as MinPrice,
	   max(price) as MaxPrice,
       avg(price) as AvgPrice
from AppleStore
where price > 0

-- Distribution of App Prices --

SELECT
	(price / 2) *2 as PriceBinStart,
    ((price / 2) *2) +2 as PriceBinEnd,
    count(*) as NumApps
From AppleStore
GROUP by PriceBinStart
order by PriceBinStart

** DATA ANALYSIS **

-- Determine whether paid apps have higher ratings --

select CASE
			when price > 0 then 'Paid App'
            else 'Free App'
       end as App_Type,
       avg(user_rating) as Avg_Rating
from AppleStore
Group by App_Type

-- Check if apps with more supported languages have higher ratings --

select CASE
			when lang_num < 10 then 'Less than 10 languages'
            when lang_num between 10 and 15 then '10 - 20 languages'
            when lang_num between 20 and 25 then '20 - 30 languages'
            else 'Greater than 30 languages'
       end as language_basket,
       avg(user_rating) as Avg_Rating
from AppleStore
group by language_basket
order by Avg_Rating DESC

-- Check genres with low ratings --

select prime_genre,
	   avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
Order by Avg_Rating ASC
limit 5

-- Check genres with high ratings --
select prime_genre,
	   avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating DESC
Limit 5

-- Check top-rated apps for each genre --

Select
	prime_genre,
    track_name,
    user_rating
from (
  	  SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) as rank
      from
      AppleStore
    ) as a
where 
a.rank = 1
 