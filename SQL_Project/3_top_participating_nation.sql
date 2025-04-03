-- Question: Which nation has participated in all the olympic games

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