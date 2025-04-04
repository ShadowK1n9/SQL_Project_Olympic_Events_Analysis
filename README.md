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
### 2. Which nation has participated in all Olympic Games?
### 3. Identify the sport which was played in all Summer Olympics
### 4. Which sports were played only once in the Olympics?
### 5. Fetch details of the oldest athletes to win a gold medal.
### 6. Fetch the top 5 athletes who have won the most gold medals.
### 7. Fetch the top 5 most successful countries in the Olympics (by total medals won).
### 8. Identify which country won the most gold, most silver, and most bronze medals in each Olympic Games.
### 9. Which countries have never won a gold medal but have won silver/bronze medals
### 10. In which sport/event has Nigeria won the highest number of medals?
# What I learned
# Conclusions
