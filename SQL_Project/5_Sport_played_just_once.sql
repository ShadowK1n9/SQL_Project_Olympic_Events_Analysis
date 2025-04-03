-- Question: Which sports were just played only once in the olympics
SELECT 
    sport, 
    COUNT(DISTINCT games) AS total_games
FROM 
    athlete_events
GROUP BY 
    sport
HAVING 
    total_games = 1
ORDER BY 1;
