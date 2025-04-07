# Introduction
Get a breakdown of the Olympics and see how countries have performed against one another over the years. 🇺🇳 Discover the top-performing athletes 🏃‍♂️, the most successful nations 🏅, and the sports that have shaped the Games. 🎯 From participation trends 📊 to medal counts 🥇🥈🥉, this analysis uncovers key insights using SQL.💡

🔍 SQL queries? Check them out here [sql_project_folder](/SQL_Project/)
# Background
I've always been fascinated by the Olympics—the competition, the athletes, and the stories behind every medal. This project started as a way to explore the history of the Games through data. Using SQL, I analyzed participation trends, medal counts, and standout performances to uncover patterns and insights. The goal was to go beyond just numbers and truly understand how nations and athletes have shaped the Olympics over the years.

Data hails from [kaggle](https://www.kaggle.com/datasets/bhanupratapbiswas/olympic-data). It contains information about every game held from 1896 - 2016, the teams, countries, games, athletes and sports played.

### The questions I wanted to answer through my SQL queries were:
1.	How many olympics games have been held?
2.	List down all Olympics games held so far.
3.	Mention the total no of nations who participated in each olympics game?
4.	Which year saw the highest and lowest no of countries participating in olympics?
5.	Which nation has participated in all of the olympic games?
6.	Identify the sport which was played in all summer olympics.
7.	Which Sports were just played only once in the olympics?
8.	Fetch the total no of sports played in each olympic games.
9.	Fetch details of the oldest athletes to win a gold medal.
10.	Find the Ratio of male and female athletes participated in all olympic games.
11.	Fetch the top 5 athletes who have won the most gold medals.
12.	Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
13.	Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
14.	List down total gold, silver and broze medals won by each country.
15.	List down total gold, silver and broze medals won by each country corresponding to each olympic games.
16.	Identify which country won the most gold, most silver and most bronze medals in each olympic games.
17.	Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
18.	Which countries have never won gold medal but have won silver/bronze medals?
19.	In which Sport/event, Nigeria has won highest medals.
20.	Break down all olympic games where Nigeria won medal for Hockey and how many medals in each olympic games.
# Tools I used
To carry out this analysis, I relied on a combination of tools that made querying, managing, and sharing the data more efficient. Here's why I chose each one:

- **SQL:** The backbone of this project, used to extract insights from the Olympic dataset.

- **MySQL:** A powerful relational database management system for storing and querying the data.

- **Visual Studio Code:** My go-to code editor for writing and testing SQL queries efficiently.

- **Git & GitHub:** Essential for version control and sharing my SQL scripts with others.
# The Analysis
This project involved running a series of SQL queries to explore different aspects of the Olympic Games. From identifying the countries that have participated the most to analyzing medal trends and standout athletes, each query provided valuable insights. Below are some of the key analyses and the insights gained from them.

### 1. How many Olympic Games have been held?
To identify how many games have been held, I counted the number of unique games held so far over the years.
This ensured I got a list of unique Olympic events, without duplicates. By sorting the results in ascending order, I was able to easily identify and count the total number of distinct Olympic Games, which gave me a comprehensive overview of the Games held from 1896 to 2016.
```sql
SELECT 
    DISTINCT games 
FROM 
    athlete_events
ORDER BY 
    games;
```
*Based on the results, a total of 48 Olympic Games have been held, including both Summer and Winter editions. The earliest Olympics started in 1896, and the most recent one listed is the 2016 Summer Olympics. The Games are held in a cycle, with the Winter Olympics taking place every four years between the Summer Games.*

### 2. Which nation has participated in all Olympic Games? 
To answer this question, I used a combination of SQL Common Table Expressions (CTEs). First, I counted the total number of distinct Olympic Games by selecting unique `games` from the `athlete_events` table. Next, I joined the `athlete_events` table with the `noc_regions` table to identify the countries that participated in each Olympic event. After grouping by both the `games` and the country (from `noc_regions`), I counted how many Olympic Games each country participated in. Finally, I compared these counts with the total number of Games and retrieved the countries that participated in all of them. 

```sql
WITH tot_games AS
(
    SELECT COUNT(DISTINCT games) AS total_games -- Counting the total number of games
    FROM athlete_events
),
-- retrieving the countries that participated in each game
countries as
(
    SELECT games, nr.region as country
    FROM athlete_events ah JOIN noc_regions nr  
    ON ah.NOC = nr.NOC
    GROUP BY games, nr.region -- grouping by games and country
),
-- counting the total number of games each country participated in
participating_countries as
(
    SELECT country, COUNT(*) AS total_games_participated
    FROM countries
    GROUP BY country
)
-- retriving the countries that participated in all the games
SELECT pc.*
FROM participating_countries pc
JOIN tot_games tg
ON tg.total_games = pc.total_games_participated
ORDER BY 1;
```

**Result:**
| Country      | Total Games Participated |
|--------------|--------------------------|
| France       | 51                       |
| Italy        | 51                       |
| Switzerland  | 51                       |
| UK           | 51                       |



*The result shows that **France, Italy, Switzerland, and the UK** have participated in all 51 Olympic Games.*

### 3. Identify the sport which was played in all Summer Olympics
To answer this question, I first counted the total number of distinct Summer Olympic Games by filtering the athlete_events table for rows where the season is 'Summer'. Then, I identified all the sports that were part of each Summer Olympic Games. After grouping by sport and counting how many times each sport participated in the Summer Olympics, I compared these counts to the total number of Summer Games. 

```SQL
WITH total_summer_games as
(
    SELECT COUNT(DISTINCT games) AS total_summer_games
    FROM athlete_events
    WHERE season = 'Summer'
),
-- retriving the sport that participated in each summer game
summer_sports AS
(
    SELECT  DISTINCT games, sport
    FROM athlete_events
    WHERE season = 'Summer'
),
-- counting the total number of games each sport participated in
participating_sports AS
(
    SELECT sport, COUNT(*) AS total_games_participated
    FROM summer_sports
    GROUP BY sport
)
-- retriving the sports that participated in all the summer games
SELECT ps.*
FROM participating_sports ps
JOIN total_summer_games tg
ON tg.total_summer_games = ps.total_games_participated
ORDER BY 1;
```
**Result:**
| Sport       | Total Games Participated |
|-------------|--------------------------|
| Athletics   | 29                       |
| Cycling     | 29                       |
| Fencing     | 29                       |
| Gymnastics  | 29                       |
| Swimming    | 29                       |

*The result shows that **Athletics, Cycling, Fencing, Gymnastics, and Swimming** were played in all 29 Summer Olympic Games.*
### 4. Which sports were played only once in the Olympics?
To find out which sports were played only once, I grouped the data in the athlete_events table by sport and counted the number of distinct games each sport appeared in. Then, using a HAVING clause, I filtered out only those sports that occurred in just one Olympic event.

```sql
SELECT 
    sport, 
    COUNT(DISTINCT games) AS total_games
FROM 
    athlete_events
GROUP BY 
    sport
HAVING 
    total_games = 1
ORDER BY 1;
```

**Result:**
| Sport                | Total Games |
|----------------------|-------------|
| Aeronautics          | 1           |
| Basque Pelota        | 1           |
| Cricket              | 1           |
| Croquet              | 1           |
| Jeu De Paume         | 1           |
| Military Ski Patrol  | 1           |
| Motorboating         | 1           |
| Racquets             | 1           |
| Roque                | 1           |
| Rugby Sevens         | 1           |

*The result revealed a list of 10 unique sports—including Cricket, Croquet, Roque, and Motorboating—that were featured in only one edition of the Olympic Games, making them some of the rarest events in Olympic history.*

### 5. Fetch details of the oldest athletes to win a gold medal.
To identify the oldest gold medalists, I filtered the `athlete_events` table for entries where the medal won was 'Gold'. Using a window function `RANK()`, I ranked the athletes based on their age in descending order. Finally, I selected the top-ranked athletes. The query returned **Oscar Gomer Swahn** from **Sweden** and **Charles Jacobus** from the **United States**, both aged **64**, as the oldest athletes to ever win a gold medal—Swahn in **Shooting** at the 1912 Summer Olympics, and Jacobus in **Roque** at the 1904 Summer Games.
```sql
With ranked_athletes as
(
    SELECT name, sex, age, team, games, sport, city, Event, medal,
            rank() OVER(ORDER BY age DESC) as ranking
    FROM athlete_events
        WHERE medal = 'Gold'
)
SELECT * FROM ranked_athletes
WHERE ranking = 1;
```
**Result:**
| Name               | Sex | Age | Team          | Games       | Sport    | City      | Event                                               | Medal |
|--------------------|-----|-----|---------------|-------------|----------|-----------|------------------------------------------------------|--------|
| Oscar Gomer Swahn  | M   | 64  | Sweden        | 1912 Summer | Shooting | Stockholm | Shooting Men's Running Target, Single Shot, Team    | Gold   |
| Charles Jacobus    | M   | 64  | United States | 1904 Summer | Roque    | St. Louis | Roque Men's Singles                                 | Gold   |

### 6. Fetch the top 5 athletes who have won the most gold medals.
**6. Identify the top 5 athletes who have won the most gold medals.**
To solve this, I filtered the dataset to include only athletes who won *Gold* medals. Then, I grouped the results by name, sport, and team, counting the number of gold medals each athlete earned. Using a `DENSE_RANK()` window function, I ranked athletes by their total gold medals and selected those within the top five ranks. 
```sql
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
```
![Top athletes to with most gold medals](assets\1_top_gold_medalists.png)
*Bar graph visualizing the top athletes with most gold medals; Chatgpt generated this graph from my SQL query results*

The standout performer was **Michael Phelps** with a record-breaking **23 gold medals** in *Swimming* for the **United States**. He was followed by legendary figures like **Ray Ewry** with 10 golds in *Athletics*, and a three-way tie with **Larysa Latynina**, **Carl Lewis**, and **Paavo Nurmi**, each securing 9 golds in their respective sports.
### 7. Fetch the top 5 most successful countries in the Olympics (by total medals won).
**7. Identify the top 5 most successful countries in the Olympics (by total medals won).**
To find the most successful countries, I first filtered out any entries without medals and joined the athlete data with country region names using their NOC codes. Then, I grouped the data by country (`region`) and counted all medals (gold, silver, and bronze) to get the total medal count per country. Using `DENSE_RANK()`, I ranked the countries and selected the top five. 
```sql
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
```
**Result:**
| Region   | Total Medals |
|----------|--------------|
| USA      | 5637         |
| Russia   | 3947         |
| Germany  | 3756         |
| UK       | 2067         |
| France   | 1767         |

The **USA** emerged as the most successful with **5,637 medals**, followed by **Russia** (3,947), **Germany** (3,756), **UK** (2,067), and **France** (1,767).
### 8. Identify which country won the most gold, most silver, and most bronze medals in each Olympic Games.
To answer the question using SQL, I first aggregated the medal counts for each country in every Olympic game using a **Common Table Expression (CTE)** called `awarded_countries`. This CTE groups the data by `games` and `country` while counting the occurrences of each medal type (Gold, Silver, Bronze). I then used the `RANK()` window function to assign ranks based on the medal count for each country within each game. By filtering for countries ranked #1 in each medal category (Gold, Silver, and Bronze), I ensured that only the top-performing countries for each medal type per Olympic game were selected. Finally, I combined the results into a single query that shows the top Gold, Silver, and Bronze medal-winning countries for each Olympic event, including ties where applicable.
```sql
WITH awarded_countries AS (
    SELECT 
        ae.games,
        nr.region AS country,
        COUNT(CASE WHEN ae.medal = 'Gold' THEN 1 END) AS gold_count,
        COUNT(CASE WHEN ae.medal = 'Silver' THEN 1 END) AS silver_count,
        COUNT(CASE WHEN ae.medal = 'Bronze' THEN 1 END) AS bronze_count
    FROM athlete_events ae
    JOIN noc_regions nr ON ae.NOC = nr.NOC
    WHERE ae.medal <> 'NA'
    GROUP BY ae.games, nr.region
),
ranked_countries AS (
    SELECT
        games,
        country,
        gold_count,
        silver_count,
        bronze_count,
        RANK() OVER(PARTITION BY games ORDER BY gold_count DESC) AS gold_rank,
        RANK() OVER(PARTITION BY games ORDER BY silver_count DESC) AS silver_rank,
        RANK() OVER(PARTITION BY games ORDER BY bronze_count DESC) AS bronze_rank
    FROM awarded_countries
)
SELECT
    games,
    GROUP_CONCAT(CASE WHEN gold_rank = 1 THEN CONCAT(country, ' (', gold_count, ' Gold)') END) AS top_gold,
    GROUP_CONCAT(CASE WHEN silver_rank = 1 THEN CONCAT(country, ' (', silver_count, ' Silver)') END) AS top_silver,
    GROUP_CONCAT(CASE WHEN bronze_rank = 1 THEN CONCAT(country, ' (', bronze_count, ' Bronze)') END) AS top_bronze
FROM ranked_countries
GROUP BY games
ORDER BY games;
```
**Result:**
| Games           | Top Gold                       | Top Silver                        | Top Bronze                           |
|-----------------|---------------------------------|-----------------------------------|--------------------------------------|
| 1896 Summer    | Germany (25 Gold)               | Greece (18 Silver)                | Greece (20 Bronze)                   |
| 1900 Summer    | UK (58 Gold)                    | France (93 Silver)                | France (82 Bronze)                   |
| 1904 Summer    | USA (128 Gold)                  | USA (141 Silver)                  | USA (125 Bronze)                     |
| 1906 Summer    | Greece (24 Gold)                | Greece (48 Silver)                | Greece (30 Bronze)                   |
| 1908 Summer    | UK (147 Gold)                   | UK (131 Silver)                   | UK (90 Bronze)                       |
| 1912 Summer    | Sweden (103 Gold)               | UK (64 Silver)                    | UK (59 Bronze)                       |
| 1920 Summer    | USA (111 Gold)                  | France (71 Silver)                | Belgium (66 Bronze)                  |
| 1924 Summer    | USA (97 Gold)                   | France (51 Silver)                | USA (49 Bronze)                      |
| 1924 Winter    | UK (16 Gold)                    | USA (10 Silver)                   | UK (11 Bronze)                       |
| 1928 Summer    | USA (47 Gold)                   | Netherlands (29 Silver)           | Germany (41 Bronze)                  |
| 1928 Winter    | Canada (12 Gold)                | Sweden (13 Silver)                | Switzerland (12 Bronze)              |
| 1932 Summer    | USA (81 Gold)                   | USA (47 Silver)                   | USA (61 Bronze)                      |
| 1932 Winter    | Canada (14 Gold)                | USA (21 Silver)                   | Germany (14 Bronze)                  |
| 1936 Summer    | Germany (93 Gold)               | Germany (70 Silver)               | Germany (61 Bronze)                  |
| 1936 Winter    | UK (12 Gold)                    | Canada (13 Silver)                | USA (14 Bronze)                      |
| 1948 Summer    | USA (87 Gold)                   | UK (42 Silver)                    | USA (35 Bronze)                      |
| 1948 Winter    | Canada (13 Gold)                | Czech Republic (17 Silver)        | Switzerland (19 Bronze)              |
| 1952 Summer    | USA (83 Gold)                   | Russia (62 Silver)                | Hungary (32 Bronze)                  |
| 1952 Winter    | Canada (16 Gold)                | USA (25 Silver)                   | Sweden (23 Bronze)                   |
| 1956 Summer    | Russia (68 Gold)                | Russia (46 Silver)                | Russia (55 Bronze)                   |
| 1956 Winter    | Russia (26 Gold)                | USA (19 Silver)                   | Canada (18 Bronze)                   |
| 1960 Summer    | USA (81 Gold)                   | Russia (63 Silver)                | Russia (45 Bronze)                   |
| 1960 Winter    | USA (19 Gold)                   | Canada (17 Silver)                | Russia (28 Bronze)                   |
| 1964 Summer    | USA (95 Gold)                   | Russia (63 Silver)                | Russia (51 Bronze)                   |
| 1964 Winter    | Russia (30 Gold)                | Sweden (21 Silver)                | Czech Republic (17 Bronze)           |
| 1968 Summer    | USA (99 Gold)                   | Russia (63 Silver)                | Russia (64 Bronze)                   |
| 1968 Winter    | Russia (26 Gold)                | Czech Republic (19 Silver)        | Canada (18 Bronze)                   |
| 1972 Summer    | Russia (107 Gold)               | Germany (83 Silver)               | Germany (96 Bronze)                  |
| 1972 Winter    | Russia (36 Gold)                | USA (18 Silver)                   | Czech Republic (19 Bronze)           |
| 1976 Summer    | Germany (123 Gold)              | Russia (95 Silver)                | Russia (77 Bronze)                   |
| 1976 Winter    | Russia (38 Gold)                | Czech Republic (19 Silver)        | Germany (37 Bronze)                  |
| 1980 Summer    | Russia (187 Gold)               | Russia (129 Silver)               | Russia (126 Bronze)                  |
| 1980 Winter    | USA (24 Gold)                   | Russia (29 Silver)                | Sweden (20 Bronze)                   |
| 1984 Summer    | USA (186 Gold)                  | USA (116 Silver)                  | Germany (53 Bronze)                  |
| 1984 Winter    | Russia (29 Gold)                | Czech Republic (24 Silver)        | Sweden (21 Bronze)                   |
| 1988 Summer    | Russia (134 Gold)               | Germany (91 Silver)               | Russia (99 Bronze)                   |
| 1988 Winter    | Russia (40 Gold)                | Germany (22 Silver), Finland (22 Silver) | Sweden (23 Bronze)           |
| 1992 Summer    | Russia (92 Gold)                | Russia (61 Silver)                | USA (85 Bronze)                      |
| 1992 Winter    | Russia (35 Gold)                | Canada (28 Silver)                | Czech Republic (27 Bronze)           |
| 1994 Winter    | Sweden (23 Gold)                | Canada (29 Silver)                | Finland (29 Bronze)                  |
| 1996 Summer    | USA (159 Gold)                  | China (70 Silver)                 | Australia (84 Bronze)                |
| 1998 Winter    | USA (25 Gold)                   | Russia (32 Silver)                | Finland (49 Bronze)                  |
| 2000 Summer    | USA (130 Gold)                  | Australia (69 Silver)             | Germany (64 Bronze)                  |
| 2002 Winter    | Canada (52 Gold)                | USA (58 Silver)                   | Russia (27 Bronze)                   |
| 2004 Summer    | USA (117 Gold)                  | Australia (77 Silver)             | Russia (95 Bronze)                   |
| 2006 Winter    | Sweden (35 Gold)                | Finland (34 Silver)               | USA (32 Bronze)                      |
| 2008 Summer    | USA (127 Gold)                  | USA (110 Silver)                  | USA (80 Bronze)                      |
| 2010 Winter    | Canada (67 Gold)                | USA (63 Silver)                   | Finland (46 Bronze)                  |
| 2012 Summer    | USA (145 Gold)                  | USA (57 Silver)                   | Australia (59 Bronze)                |
| 2014 Winter    | Canada (59 Gold)                | Sweden (32 Silver)                | USA (24 Bronze), Finland (24 Bronze) |
| 2016 Summer    | USA (139 Gold)                  | UK (55 Silver), France (55 Silver)| USA (71 Bronze)                      |

*The results show the countries that won the most Gold, Silver, and Bronze medals in each Olympic game. For each event, the top-performing country in each medal category is highlighted. In cases of ties, multiple countries are listed for the respective medal category.*
### 9. Which countries have never won a gold medal but have won silver/bronze medals
To answer the question, I wrote an SQL query that joins the `athlete_events` table with the `noc_regions` table to associate each medal with its corresponding country. The query filters out rows where the medal is "NA" and groups the data by country. I then used conditional counting (`CASE WHEN`) to count the occurrences of each medal type (Gold, Silver, Bronze) for each country. The `HAVING` clause ensures that only countries with zero gold medals but at least one silver or bronze medal are included in the result. 
```sql
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
```
**Result:**
| Country                | Gold | Silver | Bronze |
|------------------------|------|--------|--------|
| Paraguay               | 0    | 17     | 0      |
| Iceland                | 0    | 15     | 2      |
| Montenegro             | 0    | 14     | 0      |
| Malaysia               | 0    | 11     | 5      |
| Namibia                | 0    | 4      | 0      |
| Philippines            | 0    | 3      | 7      |
| Moldova                | 0    | 3      | 5      |
| Lebanon                | 0    | 2      | 2      |
| Tanzania               | 0    | 2      | 0      |
| Sri Lanka              | 0    | 2      | 0      |
| Ghana                  | 0    | 1      | 22     |
| Saudi Arabia           | 0    | 1      | 5      |
| Qatar                  | 0    | 1      | 4      |
| Kyrgyzstan             | 0    | 1      | 2      |
| Niger                  | 0    | 1      | 1      |
| Zambia                 | 0    | 1      | 1      |
| Botswana               | 0    | 1      | 0      |
| Guatemala              | 0    | 1      | 0      |
| Senegal                | 0    | 1      | 0      |
| Curacao                | 0    | 1      | 0      |
| Virgin Islands, US     | 0    | 1      | 0      |
| Sudan                  | 0    | 1      | 0      |
| Cyprus                 | 0    | 1      | 0      |
| Gabon                  | 0    | 1      | 0      |
| Tonga                  | 0    | 1      | 0      |
| Kuwait                 | 0    | 0      | 2      |
| Afghanistan            | 0    | 0      | 2      |
| Guyana                 | 0    | 0      | 1      |
| Iraq                   | 0    | 0      | 1      |
| Togo                   | 0    | 0      | 1      |
| Bermuda                | 0    | 0      | 1      |
| Macedonia              | 0    | 0      | 1      |
| Mauritius              | 0    | 0      | 1      |
| Monaco                 | 0    | 0      | 1      |
| Djibouti               | 0    | 0      | 1      |
| Eritrea                | 0    | 0      | 1      |
| Barbados               | 0    | 0      | 1      |

*Countries like Paraguay, Iceland, and Malaysia are among those that have achieved silver and/or bronze medals but have not secured any gold medals. This result highlights countries with notable achievements in the Olympics despite not having won the most prestigious medal.*
### 10. In which sport/event has Nigeria won the highest number of medals?
To answer the question, I wrote an SQL query that first filters the data for Nigeria (`NOC = 'NGR'`) and only includes rows where a medal was won (excluding 'NA'). The query then groups the results by sport and event and counts the number of medals won in each group. I used the `RANK()` window function to rank the sports/events based on the total number of medals won, ordered in descending order. Finally, I selected the sport and event with the highest number of medals (ranking = 1) to find the sport/event where Nigeria has won the most medals, which in this case is "Football Men's Football" with 50 total medals.
```sql
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
```
# What I learned
Throughout this analysis, I've boosted my SQL toolkit with some serious horsepower:

- **Advanced Quering:** Cracked the code of advanced SQL—merging tables like a wizard, conjuring WITH clauses, and slicing data with Window Functions like a data ninja on a mission. 🥷💻
- **📊Analytical Wizardry Unlocked:** Upgraded my problem-solving game, transforming real-world riddles into razor-sharp, insight-packed SQL queries like a data sorcerer on a mission.🧙‍♂️💡
# Conclusions
## Insights
### **1. Consistent Participation & Core Sports**  
France, Italy, Switzerland, and the UK participated in all 51 Olympic Games, demonstrating unparalleled consistency. Athletics, Cycling, Fencing, Gymnastics, and Swimming were the only sports featured in every Summer Olympics, underscoring their timeless appeal and foundational role in the Games.  

### **2. Rare Sports & Historic Feats**  
Sports like Cricket, Croquet, and Roque appeared in only one Olympic edition, reflecting experimental or discontinued events. Notably, **Oscar Swahn (64, Shooting)** and **Charles Jacobus (64, Roque)** remain the oldest gold medalists, with Roque itself being a one-time sport.  

### **3. Dominance of Nations & Athletes**  
The **USA** emerged as the most successful nation, amassing **5,637 total medals**, driven by stars like **Michael Phelps (23 golds in Swimming)**. Russia and Germany followed, showcasing sustained excellence across decades.  

### **4. Geopolitical & Underdog Stories**  
The **USA** dominated Summer Games (e.g., 186 golds in 1984), while **USSR/Russia** peaked during the Cold War (e.g., 187 golds in 1980). Smaller nations like **Paraguay (17 silver)** and **Iceland (15 silver)** earned medals but never gold, highlighting perseverance without top-tier success.  

### **5. Regional Strengths & Legacy**  
Nigeria’s **Men’s Football team** secured **50 medals**, emphasizing regional prowess. Geopolitical shifts, like the USSR’s dissolution and Germany’s reunification, are mirrored in medal trends, illustrating how the Olympics reflect global history.
### Closing thoughts
**Closing Thoughts**  

This project was more than just crunching numbers, it was a deep dive into over a century of Olympic history, all while leveling up my SQL game. Wrangling complex queries (think CTEs, window functions, and nested joins) taught me how to transform messy data into clear insights, like uncovering medal trends or pinpointing record-breaking athletes.  

The analysis revealed fascinating patterns: the dominance of certain nations, the rise and fall of sports, and the quiet persistence of underdog countries. But it’s worth noting that the dataset stops at 2016, meaning recent events like Paris 2024 aren’t included, a reminder that history’s lessons are always evolving.  

Ultimately, this project sharpened my ability to ask the right questions and let the data tell its story. Whether you’re a sports fan or a data nerd, the Olympics remind us that behind every medal is a human saga of grit, politics, and legacy. And SQL? It’s the ultimate tool for decoding those sagas. 🏅🔍  

---  
*P.S. If you spot a query that could be optimized or have ideas to expand this analysis, drop a suggestion! Data, like the Games, thrives on collaboration.*