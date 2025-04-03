-- Question: Fetch the total no of sports played in each olympic games.
SELECT 
    games, 
    COUNT(DISTINCT sport) as Total_Sports
FROM 
    athlete_events
GROUP BY 
    games
ORDER BY 
    2 desc;