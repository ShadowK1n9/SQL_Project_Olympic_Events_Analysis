-- CLEANING THE DATA

-- counting the number of duplicates
with duplicate_rows as (
    SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY ID, Name, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal 
           ORDER BY ID
       ) AS rn
FROM athlete_events
)
SELECT COUNT(*) FROM duplicate_rows WHERE rn > 1;


-- removing duplicates from the athlete_events table using a deduplicated table
CREATE TABLE athlete_events_unique as
SELECT * FROM (
    SELECT *,
         ROW_NUMBER() OVER (
              PARTITION BY ID, Name, Sex, Age, Height, Weight, Team, NOC, Games, Year, Season, City, Sport, Event, Medal 
           ORDER BY ID
        ) AS rn
    FROM athlete_events
) AS t
WHERE rn = 1;

-- dropping the original athlete_events table
DROP TABLE athlete_events;

-- renaming the deduplicated table to the original table name
RENAME TABLE athlete_events_unique TO athlete_events;

-- Adding the foreign key constraint to the athlete_events table
ALTER TABLE athlete_events
ADD FOREIGN KEY(NOC) REFERENCES noc_regions(NOC);

-- enabling the foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- DROPPING THE rn COLUMN
ALTER TABLE athlete_events
DROP COLUMN rn;

-- checking the number of rows in the athlete_events table
SELECT COUNT(*) FROM athlete_events;