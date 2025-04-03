-- Question: Fetch the top 5 athletes who have won the most gold medals

WITH top_ranking_atheletes AS 
(
    SELECT 
        name, sport, team, count(medal) as total_gold_medals
    FROM athlete_events
        WHERE medal = 'Gold'
        GROUP BY name, sport, team
        ORDER BY total_gold_medals DESC
),
ranked_athletes as
(
    SELECT 
        *, DENSE_RANK() OVER(ORDER BY total_gold_medals DESC) as ranking
    FROM top_ranking_atheletes
)
SELECT 
    name, sport, team, total_gold_medals
FROM ranked_athletes
WHERE ranking <= 5;