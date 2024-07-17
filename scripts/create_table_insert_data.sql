-- Create staging tables because date format of csv file differs from postgres date format so I have converted it to text first.
CREATE TABLE bike_share_yr_0_staging (
    dteday TEXT,
    season INT,
    yr INT,
    mnth INT,
    hr INT,
    holiday INT,
    weekday INT,
    workingday INT,
    weathersit INT,
    temp NUMERIC,
    atemp NUMERIC,
    hum NUMERIC,
    windspeed NUMERIC,
    rider_type VARCHAR(10),
    riders INT
);

CREATE TABLE bike_share_yr_1_staging (
    dteday TEXT,
    season INT,
    yr INT,
    mnth INT,
    hr INT,
    holiday INT,
    weekday INT,
    workingday INT,
    weathersit INT,
    temp NUMERIC,
    atemp NUMERIC,
    hum NUMERIC,
    windspeed NUMERIC,
    rider_type VARCHAR(10),
    riders INT
);

CREATE TABLE cost_table_staging (
    yr INT,
    price NUMERIC,
    COGS NUMERIC
);

-- Import data into staging tables
COPY bike_share_yr_0_staging(dteday, season, yr, mnth, hr, holiday, weekday, workingday, weathersit, temp, atemp, hum, windspeed, rider_type, riders)
FROM 'C:/Projects/sql project bike data/bike_share_yr_0.csv'
DELIMITER ','
CSV HEADER;

COPY bike_share_yr_1_staging(dteday, season, yr, mnth, hr, holiday, weekday, workingday, weathersit, temp, atemp, hum, windspeed, rider_type, riders)
FROM 'C:/Projects/sql project bike data/bike_share_yr_1.csv'
DELIMITER ','
CSV HEADER;

COPY cost_table_staging(yr, price, COGS)
FROM 'C:/Projects/sql project bike data/cost_table.csv'
DELIMITER ','
CSV HEADER;

-- Create final tables
CREATE TABLE bike_share_yr_0 (
    dteday DATE,
    season INT,
    yr INT,
    mnth INT,
    hr INT,
    holiday INT,
    weekday INT,
    workingday INT,
    weathersit INT,
    temp NUMERIC,
    atemp NUMERIC,
    hum NUMERIC,
    windspeed NUMERIC,
    rider_type VARCHAR(10),
    riders INT
);

CREATE TABLE bike_share_yr_1 (
    dteday DATE,
    season INT,
    yr INT,
    mnth INT,
    hr INT,
    holiday INT,
    weekday INT,
    workingday INT,
    weathersit INT,
    temp NUMERIC,
    atemp NUMERIC,
    hum NUMERIC,
    windspeed NUMERIC,
    rider_type VARCHAR(10),
    riders INT
);

CREATE TABLE cost_table (
    yr INT,
    price NUMERIC,
    COGS NUMERIC
);

-- Insert transformed data into final tables
INSERT INTO bike_share_yr_0 (dteday, season, yr, mnth, hr, holiday, weekday, workingday, weathersit, temp, atemp, hum, windspeed, rider_type, riders)
SELECT 
    TO_DATE(dteday, 'DD/MM/YYYY'),
    season,
    yr,
    mnth,
    hr,
    holiday,
    weekday,
    workingday,
    weathersit,
    temp,
    atemp,
    hum,
    windspeed,
    rider_type,
    riders
FROM bike_share_yr_0_staging;

INSERT INTO bike_share_yr_1 (dteday, season, yr, mnth, hr, holiday, weekday, workingday, weathersit, temp, atemp, hum, windspeed, rider_type, riders)
SELECT 
    TO_DATE(dteday, 'DD/MM/YYYY'),
    season,
    yr,
    mnth,
    hr,
    holiday,
    weekday,
    workingday,
    weathersit,
    temp,
    atemp,
    hum,
    windspeed,
    rider_type,
    riders
FROM bike_share_yr_1_staging;

INSERT INTO cost_table (yr, price, COGS)
SELECT 
    yr,
    price,
    COGS
FROM cost_table_staging;

-- Drop staging tables
DROP TABLE IF EXISTS bike_share_yr_0_staging;
DROP TABLE IF EXISTS bike_share_yr_1_staging;
DROP TABLE IF EXISTS cost_table_staging;

-- Verify data import
SELECT * FROM bike_share_yr_0;
SELECT * FROM bike_share_yr_1;
SELECT * FROM cost_table;
