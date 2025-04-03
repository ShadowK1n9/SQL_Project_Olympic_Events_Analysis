-- Question: Identify the sport which played in all summer olympics
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