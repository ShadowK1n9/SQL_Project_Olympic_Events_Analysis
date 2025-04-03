-- Question: Fetch the top 5  most successful countries in olympics. Success is defined by no of medals won
WITH awarded_countries AS 
(
    SELECT 
        nr.region AS region, count(medal) AS total_medals
    FROM athlete_events ae JOIN noc_regions nr
    ON ae.NOC = nr.NOC
    WHERE medal <> 'NA'
    GROUP BY nr.region
    ORDER BY total_medals DESC
),
ranked_countries as
(
    SELECT 
        *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS ranking
    FROM awarded_countries
)
SELECT
    region, total_medals
FROM ranked_countries
WHERE ranking <= 5;
