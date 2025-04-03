-- CREATING THE DATABASE AND TABLES

CREATE DATABASE IF NOT EXISTS Olympic_Events;
USE Olympic_Events;



-- CREATING THE COUNTRIES TABLES

CREATE TABLE noc_regions(
    NOC CHAR(3) PRIMARY KEY,
    region VARCHAR(150),
    notes VARCHAR(150)
);

-- CREATING THE ATHLETES EVENTS TABLE

CREATE TABLE athlete_events(
    ID INT,
    Name VARCHAR(200),
    Sex CHAR(1),
    Age INT,
    Height INT,
    Weight INT,
    Team VARCHAR(80),
    NOC CHAR(3),
    Games VARCHAR(80),
    Year INT,
    Season VARCHAR(80),
    City VARCHAR(80),
    Sport VARCHAR(80),
    Event VARCHAR(255),
    Medal VARCHAR(80),
    FOREIGN KEY(NOC) REFERENCES noc_regions(NOC)
);

-- LOADING THE DATA INTO THE TABLES

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/noc_regions.csv"
into table noc_regions 
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


-- Disabling foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/athlete_events.csv"
INTO TABLE athlete_events
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    ID,
    Name,
    Sex,
    @Age,
    @Height,
    @Weight,
    Team,
    NOC,
    Games,
    Year,
    Season,
    City,
    Sport,
    Event,
    Medal
)
SET 
    Age = NULLIF(@Age, ''),
    Height = NULLIF(@Height, ''),
    Weight = NULLIF(@Weight, '');