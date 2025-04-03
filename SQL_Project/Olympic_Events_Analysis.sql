-- checking the first 5 rows in the table
SELECT * FROM athlete_events LIMIT 20;

-- ANALYZING THE DATA
-- 1. How many olympic games has been held?
SELECT COUNT(DISTINCT Games)  as total_olympic_games
FROM athlete_events;

-- 2. List down all Olympics games held so far.
SELECT DISTINCT games FROM athlete_events
ORDER BY games;

-- 3. Mention the total no of nations who participated in each olympics game?
SELECT games, COUNT(DISTINCT NOC) AS total_nations
FROM athlete_events
GROUP BY games
ORDER BY games;

-- 4. Which year saw the highest and lowest no of countries participating in olympics?
WITH olympic_year as 
(
    SELECT games, COUNT(DISTINCT NOC) AS total_nations
            FROM athlete_events
                GROUP BY games
    )
    SELECT games, total_nations
    FROM olympic_year
    WHERE total_nations = (SELECT MAX(total_nations) FROM olympic_year)
    OR total_nations = (SELECT MIN(total_nations) FROM olympic_year);

-- or

with tot_countries as
            (
                SELECT games, COUNT(DISTINCT NOC) as total_countries
                FROM athlete_events
                GROUP BY games
            )
        SELECT DISTINCT
        CONCAT(first_value(games) OVER(ORDER BY total_countries), 
        ' - ', first_value(total_countries) OVER(ORDER BY total_countries)) as lowest_participating_countries,
        CONCAT(first_value(games) OVER(ORDER BY total_countries DESC),
        ' - ', first_value(total_countries) OVER(ORDER BY total_countries DESC)) AS highest_participating_countries
        FROM tot_countries;

-- 5. Which nation has participated in all the olympic games
with tot_games AS
(
    SELECT COUNT(DISTINCT games) AS total_games -- Counting the total number of games
    FROM athlete_events
),
-- retrieving the countries that participated in each game
countries as
(
    SELECT games, nr.region as country
    FROM athlete_events ah JOIN noc_regions nr  
    ON ah.NOC = nr.NOC
    GROUP BY games, nr.region -- grouping by games and country
),
-- counting the total number of games each country participated in
participating_countries as
(
    SELECT country, COUNT(*) AS total_games_participated
    FROM countries
    GROUP BY country
)
-- retriving the countries that participated in all the games
SELECT pc.*
FROM participating_countries pc
JOIN tot_games tg
ON tg.total_games = pc.total_games_participated
ORDER BY 1;

-- 6. Identify the sport which played in all summer olympics
with total_summer_games as
(
    SELECT COUNT(DISTINCT games) AS total_summer_games
    FROM athlete_events
    WHERE season = 'Summer'
),
-- retriving the sport that participated in each summer game
summer_sports AS
(
    SELECT  DISTINCT games, sport
    FROM athlete_events
    WHERE season = 'Summer'
),
-- counting the total number of games each sport participated in
participating_sports AS
(
    SELECT sport, COUNT(*) AS total_games_participated
    FROM summer_sports
    GROUP BY sport
)
-- retriving the sports that participated in all the summer games
SELECT ps.*
FROM participating_sports ps
JOIN total_summer_games tg
ON tg.total_summer_games = ps.total_games_participated
ORDER BY 1;

-- 7. Which sports were just played only once in the olympics
SELECT sport, COUNT(DISTINCT games) AS total_games
FROM athlete_events
GROUP BY sport
HAVING total_games = 1
ORDER BY 1;

-- 8. Fetch the total no of sports played in each olympic games.
SELECT games, COUNT(DISTINCT sport) as Total_Sports
FROM athlete_events
GROUP BY games
ORDER BY 2 desc;

-- 9. Fetch deails of the oldest athletes to win a gold medal
With ranked_athletes as
(
    SELECT name, sex, age, team, games, sport, city, Event, medal,
            rank() OVER(ORDER BY age DESC) as ranking
    FROM athlete_events
        WHERE medal = 'Gold'
)
SELECT * FROM ranked_athletes
WHERE ranking = 1;

-- 10 Find the ration of male and female athletes participated in each olympic games

WITH gender_counts AS 
(
SELECT 
    COUNT(case when sex = 'M' then 1 else NULL end) as Male_Count,
    COUNT(case when sex = 'F' then 1 else NULL end) as female_count
FROM athlete_events
)
SELECT 
    Male_Count,
    female_count,
    CASE
        WHEN female_count > 0 THEN -- -- error handling to avoid division by zero error
            CONCAT('1 : ', ROUND(CAST(male_count AS DECIMAL) /female_count, 2)) 
        ELSE
            'Undefined'
    END AS female_to_male_ratio,
    CASE
        WHEN male_count > 0 THEN
            CONCAT('1 : ', ROUND(CAST(female_count AS DECIMAL) /male_count, 2)) -- casting to decimal to avoid integer division and truncation
        ELSE
            'Undefined'
    END AS male_to_female_ratio
FROM gender_counts;

-- 11. Fetch the top 5 athletes who have won the most gold medals

WITH top_ranking_atheletes AS 
(
    SELECT 
        name, sport, team, count(medal) as total_gold_medals
    FROM athlete_events
        WHERE medal = 'Gold'
        GROUP BY name, sport, team
        ORDER BY total_gold_medals DESC
),
ranked_athletes as
(
    SELECT 
        *, DENSE_RANK() OVER(ORDER BY total_gold_medals DESC) as ranking
    FROM top_ranking_atheletes
)
SELECT 
    name, sport, team, total_gold_medals
FROM ranked_athletes
WHERE ranking <= 5;

-- 12. Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)

WITH top_ranking_atheletes AS 
(
    SELECT 
        name, sport, team, count(medal) as total_gold_medals
    FROM athlete_events
        WHERE medal IN ('Gold', 'Silver', 'Bronze')
        GROUP BY name, sport, team
        ORDER BY total_gold_medals DESC
),
ranked_athletes as
(
    SELECT 
        *, DENSE_RANK() OVER(ORDER BY total_gold_medals DESC) as ranking
    FROM top_ranking_atheletes
)
SELECT 
    name, sport, team, total_gold_medals
FROM ranked_athletes
WHERE ranking <= 5;

-- 13 Fetch the top 5  most successful countries in olympics. Success is defined by no of medals won
WITH awarded_countries AS 
(
    SELECT 
        nr.region AS region, count(medal) AS total_medals
    FROM athlete_events ae JOIN noc_regions nr
    ON ae.NOC = nr.NOC
    WHERE medal <> 'NA'
    GROUP BY nr.region
    ORDER BY total_medals DESC
),
ranked_countries as
(
    SELECT 
        *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS ranking
    FROM awarded_countries
)
SELECT
    region, total_medals
FROM ranked_countries
WHERE ranking <= 5;

-- 14. List down total gold, silver, and bronze medals won by each country
SELECT 
    nr.region,
    COUNT(CASE WHEN medal = 'Gold' THEN 1 ELSE NULL END) AS gold,
    COUNT(CASE WHEN medal = 'Silver' THEN 1 ELSE NULL END) AS silver,
    COUNT(CASE WHEN medal = 'Bronze' THEN 1 ELSE NULL END) AS bronze
FROM athlete_events ae JOIN noc_regions nr
ON ae.NOC = nr.NOC
WHERE medal <> 'NA'
GROUP BY nr.region
ORDER BY 2 DESC, 3 DESC, 4 DESC;

-- 15 List down the total gold, silver and bronze medal won by each country corresponding to each olympic game
SELECT 
    CONCAT_WS(' - ',games, nr.region) as Olympic_games,
    COUNT(CASE WHEN medal = 'Gold' THEN 1 ELSE NULL END) AS gold,
    COUNT(CASE WHEN medal = 'Silver' THEN 1 ELSE NULL END) AS silver,
    COUNT(CASE WHEN medal = 'Bronze' THEN 1 ELSE NULL END) AS bronze,
    count(*) AS Total_Medals
FROM athlete_events ae JOIN noc_regions nr
ON ae.NOC = nr.NOC
WHERE medal <> 'NA'
GROUP BY Olympic_games
ORDER BY 1 desc, 2 DESC, 3 DESC, 4 DESC;

-- 16. Identify which country won the most gold, most silver, most broze medals in each olympic game
WITH awarded_countries AS 
(
    SELECT 
        games,
        nr.region AS country,
        COUNT(CASE WHEN medal = 'Gold' THEN 1 ELSE NULL END) AS gold,
        COUNT(CASE WHEN medal = 'Silver' THEN 1 ELSE NULL END) AS silver,
        COUNT(CASE WHEN medal = 'Bronze' THEN 1 ELSE NULL END) AS bronze
    FROM athlete_events ae 
    JOIN noc_regions nr ON ae.NOC = nr.NOC
    WHERE medal <> 'NA'
    GROUP BY games, nr.region
),
ranked_countries AS (
    SELECT
        games,
        country,
        gold,
        silver,
        bronze,
        RANK() OVER(PARTITION BY games ORDER BY gold DESC) AS gold_rank,
        RANK() OVER(PARTITION BY games ORDER BY silver DESC) AS silver_rank,
        RANK() OVER(PARTITION BY games ORDER BY bronze DESC) AS bronze_rank
    FROM
        awarded_countries
)
SELECT
    games,
    MAX(CASE WHEN gold_rank = 1 THEN country END) AS country_with_most_gold,
    MAX(CASE WHEN silver_rank = 1 THEN country END) AS country_with_most_silver,
    MAX(CASE WHEN bronze_rank = 1 THEN country END) AS country_with_most_bronze
FROM ranked_countries
GROUP BY games
ORDER BY games;

-- or to see the number of medals along with the country name
WITH awarded_countries AS (
    SELECT 
        ae.games,
        nr.region AS country,
        COUNT(CASE WHEN ae.medal = 'Gold' THEN 1 ELSE NULL END) AS gold_count,
        COUNT(CASE WHEN ae.medal = 'Silver' THEN 1 ELSE NULL END) AS silver_count,
        COUNT(CASE WHEN ae.medal = 'Bronze' THEN 1 ELSE NULL END) AS bronze_count
    FROM athlete_events ae
    JOIN noc_regions nr ON ae.NOC = nr.NOC
    WHERE ae.medal <> 'NA'
    GROUP BY ae.games, nr.region
),
ranked_countries AS (
    SELECT
        games,
        country,
        gold_count,
        silver_count,
        bronze_count,
        RANK() OVER(PARTITION BY games ORDER BY gold_count DESC) AS gold_rank,
        RANK() OVER(PARTITION BY games ORDER BY silver_count DESC) AS silver_rank,
        RANK() OVER(PARTITION BY games ORDER BY bronze_count DESC) AS bronze_rank
    FROM awarded_countries
)
SELECT
    games,
    GROUP_CONCAT(DISTINCT CASE WHEN gold_rank = 1 THEN CONCAT(country, ' (', gold_count, ' Gold)') END) AS top_gold,
    GROUP_CONCAT(DISTINCT CASE WHEN silver_rank = 1 THEN CONCAT(country, ' (', silver_count, ' Silver)') END) AS top_silver,
    GROUP_CONCAT(DISTINCT CASE WHEN bronze_rank = 1 THEN CONCAT(country, ' (', bronze_count, ' Bronze)') END) AS top_bronze
FROM ranked_countries
WHERE gold_rank = 1 OR silver_rank = 1 OR bronze_rank = 1
GROUP BY games
ORDER BY games;

-- 17. Identify which country won the most gold, most silver, most broze and most medals in each olympic game
WITH awarded_countries AS 
(
    SELECT 
        games,
        nr.region AS country,
        COUNT(CASE WHEN medal = 'Gold' THEN 1 ELSE NULL END) AS gold,
        COUNT(CASE WHEN medal = 'Silver' THEN 1 ELSE NULL END) AS silver,
        COUNT(CASE WHEN medal = 'Bronze' THEN 1 ELSE NULL END) AS bronze,
        COUNT(*) AS total_medals
    FROM athlete_events ae 
    JOIN noc_regions nr ON ae.NOC = nr.NOC
    WHERE medal <> 'NA'
    GROUP BY games, nr.region
),
ranked_countries AS (
    SELECT
        games,
        country,
        gold,
        silver,
        bronze,
        total_medals,
        RANK() OVER(PARTITION BY games ORDER BY gold DESC) AS gold_rank,
        RANK() OVER(PARTITION BY games ORDER BY silver DESC) AS silver_rank,
        RANK() OVER(PARTITION BY games ORDER BY bronze DESC) AS bronze_rank,
        RANK() OVER(PARTITION BY games ORDER BY total_medals DESC) AS total_medals_rank
    FROM awarded_countries
)
SELECT
    games,
    MAX(CASE WHEN gold_rank = 1 THEN country END) AS country_with_most_gold,
    MAX(CASE WHEN silver_rank = 1 THEN country END) AS country_with_most_silver,
    MAX(CASE WHEN bronze_rank = 1 THEN country END) AS country_with_most_bronze,
    MAX(CASE WHEN total_medals_rank = 1 THEN country END) AS country_with_most_medals
FROM ranked_countries
GROUP BY games
ORDER BY games;


-- 18. Which countries have never won gold medal but have won silver/bronze medals?
SELECT 
    nr.region as country,
    COUNT(CASE WHEN medal = 'Gold' THEN 1 ELSE NULL END) AS gold,
    COUNT(CASE WHEN medal = 'Silver' THEN 1 ELSE NULL END) AS silver,
    COUNT(CASE WHEN medal = 'Bronze' THEN 1 ELSE NULL END) AS bronze
FROM athlete_events ae JOIN noc_regions nr
ON ae.NOC = nr.NOC
WHERE medal <> 'NA'
GROUP BY nr.region
HAVING gold = 0
AND (silver > 0 OR bronze > 0)
ORDER BY 3 DESC, 4 DESC;

-- 19 In which sport/event, has Nigeria won the highest number of medals?
WITH sports_events AS
(
SELECT 
    sport,
    event,
    count(medal) as total_medals,
    RANK() OVER(ORDER BY count(medal) DESC) as ranking
FROM athlete_events
WHERE NOC = 'NGR'
AND medal <> 'NA'
GROUP BY sport, event
ORDER BY total_medals DESC
)
SELECT sport, event, total_medals
FROM sports_events
WHERE ranking = 1;

-- 20. Break down all olympic games where Nigeria won medal(s) for football and how many medals in each olympic games
SELECT
    games,
    COUNT(medal) as total_medals
FROM athlete_events JOIN noc_regions
ON athlete_events.NOC = noc_regions.NOC
WHERE noc_regions.region = 'Nigeria' 
AND sport = 'Football'
AND medal <> 'NA'
GROUP by Games
ORDER BY games;



