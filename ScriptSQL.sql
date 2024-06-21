#create a database and a table
create database coronavirusdata;
CREATE TABLE CoronaVirusData (
    Province VARCHAR(100),
    CountryRegion VARCHAR(100),
    Latitude FLOAT,
    Longitude FLOAT,
    Date DATE,
    Confirmed INT,
    Deaths INT,
    Recovered INT
);
#load file csv
LOAD DATA INFILE 'C: \Corona Virus Dataset (2).csv'
INTO TABLE CoronaVirusData
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(Province, Country, Latitude, Longitude, Date, Confirmed, Deaths, Recovered);
#Select rows  where columuns are NULL values
SELECT * FROM coronavirusdata
WHERE Province IS NULL OR 
Country IS NULL OR 
Latitude IS NULL OR 
Longitude IS NULL OR 
Date IS NULL OR 
Confirmed IS NULL OR 
Deaths IS  NULL OR 
Recovered IS  NULL;
#count the total number of rows
SELECT COUNT(*) AS TotalRows
FROM CoronaVirusData;
#find the start and end dates
SELECT 
    MIN(Date) AS StartDate,
    MAX(Date) AS EndDate
FROM CoronaVirusData;
#Find Number of months present in the dataset
SELECT COUNT(DISTINCT DATE_FORMAT(Date, '%Y-%m')) AS NumberOfMonths
FROM CoronaVirusData;
#Find monthly average for confirmed, deaths, recovered
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    AVG(Confirmed) AS AvgConfirmed,
    AVG(Deaths) AS AvgDeaths,
    AVG(Recovered) AS AvgRecovered
FROM CoronaVirusData
GROUP BY Month
ORDER BY Month;
# Find most frequent value for confirmed,Deaths,Recovered
SELECT
EXTRACT(Month FROM str_to_date(Date, "%Y-%m-%d")) AS Month,
EXTRACT(Year FROM str_to_date(Date, '%Y-%m-%d')) AS Year,
SUBSTRING_INDEX(GROUP_CONCAT(Confirmed ORDER BY Confirmed DESC), ',', 1) AS Most_frequent_confirmed,
SUBSTRING_INDEX(GROUP_CONCAT(Deaths ORDER BY Deaths DESC), ',', 1) AS Most_frequent_deaths,
SUBSTRING_INDEX(GROUP_CONCAT(Recovered ORDER BY Recovered DESC), ',', 1) AS Most_frequent_recovered
FROM
Coronavirusdata
GROUP BY
Year, Month
ORDER BY
Year, Month;
#Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year,
    MIN(Confirmed) AS MinConfirmed,
    MIN(Deaths) AS MinDeaths,
    MIN(Recovered) AS MinRecovered
FROM CoronaVirusData
GROUP BY Year
ORDER BY Year;
#Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS Year,
    MAX(Confirmed) AS MaxConfirmed,
    MAX(Deaths) AS MaxDeaths,
    MAX(Recovered) AS MaxRecovered
FROM CoronaVirusData
GROUP BY Year
ORDER BY Year;
#The total number of cases of confirmed, deaths, recovered each month
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    SUM(Confirmed) AS TotalConfirmed,
    SUM(Deaths) AS TotalDeaths,
    SUM(Recovered) AS TotalRecovered
FROM CoronaVirusData
GROUP BY Month
ORDER BY Month;
#Check how the coronavirus spread out with respect to confirmed cases
SELECT 
    SUM(Confirmed) AS TotalConfirmed,
    AVG(Confirmed) AS AvgConfirmed,
    VARIANCE(Confirmed) AS VarianceConfirmed,
    STDDEV(Confirmed) AS StdDevConfirmed
FROM CoronaVirusData;
#Check how the coronavirus spread out with respect to death cases per month
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    SUM(Deaths) AS TotalDeaths,
    AVG(Deaths) AS AvgDeaths,
    VARIANCE(Deaths) AS VarianceDeaths,
    STDDEV(Deaths) AS StdDevDeaths
FROM CoronaVirusData
GROUP BY Month
ORDER BY Month;
#Check how the coronavirus spread out with respect to recovered cases
SELECT 
    SUM(Recovered) AS TotalRecovered,
    AVG(Recovered) AS AvgRecovered,
    VARIANCE(Recovered) AS VarianceRecovered,
    STDDEV(Recovered) AS StdDevRecovered
FROM CoronaVirusData;
#Find the country having the highest number of confirmed cases
SELECT 
    Country,
    SUM(Confirmed) AS TotalConfirmed
FROM CoronaVirusData
GROUP BY Country
ORDER BY TotalConfirmed DESC
LIMIT 1;
#Find the country having the lowest number of death cases
SELECT 
    Country,
    SUM(Deaths) AS TotalDeaths
FROM CoronaVirusData
GROUP BY Country
ORDER BY TotalDeaths ASC
LIMIT 1;
#Find the top 5 countries having the highest recovered cases
SELECT 
    Country,
    SUM(Recovered) AS TotalRecovered
FROM CoronaVirusData
GROUP BY Country
ORDER BY TotalRecovered DESC
LIMIT 5;