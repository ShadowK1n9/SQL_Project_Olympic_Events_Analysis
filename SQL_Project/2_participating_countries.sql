-- Question: Mention the total no of nations who participated in each olympics game?
SELECT 
    games, 
    COUNT(DISTINCT NOC) AS total_nations
FROM 
    athlete_events
GROUP BY 
    games
ORDER BY 
    games;

-- Question: Which year saw the highest and lowest no of countries participating in olympics?
WITH olympic_year as 
(
    SELECT 
        games, COUNT(DISTINCT NOC) AS total_nations
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