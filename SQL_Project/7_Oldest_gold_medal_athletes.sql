-- Quesiton: Fetch deails of the oldest athletes to win a gold medal
With ranked_athletes as
(
    SELECT name, sex, age, team, games, sport, city, Event, medal,
            rank() OVER(ORDER BY age DESC) as ranking
    FROM athlete_events
        WHERE medal = 'Gold'
)
SELECT * FROM ranked_athletes
WHERE ranking = 1;