-- Question: In which sport/event, has Nigeria won the highest number of medals?
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

-- Question: Break down all olympic games where Nigeria won medal(s) for football and how many medals in each olympic games
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