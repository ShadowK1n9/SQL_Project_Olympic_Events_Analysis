-- Question: Find the ration of male and female athletes participated in each olympic games

WITH gender_counts AS 
(
SELECT 
    COUNT(case when sex = 'M' then 1 else NULL end) as Male_Count,
    COUNT(case when sex = 'F' then 1 else NULL end) as female_count
FROM athlete_events
)
SELECT 
    Male_Count,
    female_count,
    CASE
        WHEN female_count > 0 THEN -- -- error handling to avoid division by zero error
            CONCAT('1 : ', ROUND(CAST(male_count AS DECIMAL) /female_count, 2)) 
        ELSE
            'Undefined'
    END AS female_to_male_ratio,
    CASE
        WHEN male_count > 0 THEN
            CONCAT('1 : ', ROUND(CAST(female_count AS DECIMAL) /male_count, 2)) -- casting to decimal to avoid integer division and truncation
        ELSE
            'Undefined'
    END AS male_to_female_ratio
FROM gender_counts;