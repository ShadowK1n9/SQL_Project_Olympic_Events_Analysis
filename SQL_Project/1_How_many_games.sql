-- How many olympic games has been held?
SELECT 
    COUNT(DISTINCT Games) as total_olympic_games
FROM 
    athlete_events;

-- List down all Olympics games held so far.
SELECT 
    DISTINCT games 
FROM 
    athlete_events
ORDER BY 
    games;
