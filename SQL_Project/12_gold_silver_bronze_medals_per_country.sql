-- Question: List down total gold, silver, and bronze medals won by each country
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

-- Question: List down the total gold, silver and bronze medal won by each country corresponding to each olympic game
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