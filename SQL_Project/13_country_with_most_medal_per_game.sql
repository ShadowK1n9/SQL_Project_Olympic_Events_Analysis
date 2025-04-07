-- Question: Identify which country won the most gold, most silver, most broze medals in each olympic game
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
        COUNT(CASE WHEN ae.medal = 'Gold' THEN 1 END) AS gold_count,
        COUNT(CASE WHEN ae.medal = 'Silver' THEN 1 END) AS silver_count,
        COUNT(CASE WHEN ae.medal = 'Bronze' THEN 1 END) AS bronze_count
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
    GROUP_CONCAT(CASE WHEN gold_rank = 1 THEN CONCAT(country, ' (', gold_count, ' Gold)') END) AS top_gold,
    GROUP_CONCAT(CASE WHEN silver_rank = 1 THEN CONCAT(country, ' (', silver_count, ' Silver)') END) AS top_silver,
    GROUP_CONCAT(CASE WHEN bronze_rank = 1 THEN CONCAT(country, ' (', bronze_count, ' Bronze)') END) AS top_bronze
FROM ranked_countries
GROUP BY games
ORDER BY games;

-- Question: Identify which country won the most gold, most silver, most broze and most medals in each olympic game
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






