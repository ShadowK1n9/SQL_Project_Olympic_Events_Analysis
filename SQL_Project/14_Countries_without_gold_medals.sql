-- Question: Which countries have never won gold medal but have won silver/bronze medals?
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