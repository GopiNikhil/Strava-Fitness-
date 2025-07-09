-- STRAVA FITNESS Daily Level Project

-- 1. Create the table
/*CREATE TABLE daily_level (
    Id BIGINT,
    ActivityDate DATE,
    TotalSteps INT,
    TotalDistance FLOAT,
    TrackerDistance FLOAT,
    LoggedActivitiesDistance FLOAT,
    VeryActiveDistance FLOAT,
    ModeratelyActiveDistance FLOAT,
    LightActiveDistance FLOAT,
    SedentaryActiveDistance FLOAT,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories INT
);*/

-- 2. Create cleaned table with no NULLs and no duplicates
/*
CREATE TABLE daily_level_cleaned AS
SELECT 
    Id, 
    ActivityDate,
    ANY_VALUE(TotalSteps) AS TotalSteps,
    ANY_VALUE(TotalDistance) AS TotalDistance,
    ANY_VALUE(TrackerDistance) AS TrackerDistance,
    ANY_VALUE(LoggedActivitiesDistance) AS LoggedActivitiesDistance,
    ANY_VALUE(VeryActiveDistance) AS VeryActiveDistance,
    ANY_VALUE(ModeratelyActiveDistance) AS ModeratelyActiveDistance,
    ANY_VALUE(LightActiveDistance) AS LightActiveDistance,
    ANY_VALUE(SedentaryActiveDistance) AS SedentaryActiveDistance,
    ANY_VALUE(VeryActiveMinutes) AS VeryActiveMinutes,
    ANY_VALUE(FairlyActiveMinutes) AS FairlyActiveMinutes,
    ANY_VALUE(LightlyActiveMinutes) AS LightlyActiveMinutes,
    ANY_VALUE(SedentaryMinutes) AS SedentaryMinutes,
    ANY_VALUE(Calories) AS Calories
FROM daily_level
WHERE Id IS NOT NULL 
  AND ActivityDate IS NOT NULL
  AND TotalSteps IS NOT NULL 
  AND TotalDistance IS NOT NULL 
  AND TrackerDistance IS NOT NULL 
  AND LoggedActivitiesDistance IS NOT NULL 
  AND VeryActiveDistance IS NOT NULL 
  AND ModeratelyActiveDistance IS NOT NULL 
  AND LightActiveDistance IS NOT NULL 
  AND SedentaryActiveDistance IS NOT NULL 
  AND VeryActiveMinutes IS NOT NULL 
  AND FairlyActiveMinutes IS NOT NULL 
  AND LightlyActiveMinutes IS NOT NULL 
  AND SedentaryMinutes IS NOT NULL 
  AND Calories IS NOT NULL
GROUP BY Id, ActivityDate;*/

-- 3. Replace original table with cleaned one
/*DROP TABLE daily_level;
RENAME TABLE daily_level_cleaned TO daily_level;*/

-- Insights

-- Insight 1: Average steps and calories per user
/*SELECT Id,
       ROUND(AVG(TotalSteps)) AS AvgSteps,
       ROUND(AVG(Calories)) AS AvgCalories
FROM daily_level
GROUP BY Id;*/

-- Insight 2: Average time spent in each activity level
/*SELECT 
  ROUND(AVG(VeryActiveMinutes)) AS Avg_VeryActive,
  ROUND(AVG(FairlyActiveMinutes)) AS Avg_FairlyActive,
  ROUND(AVG(LightlyActiveMinutes)) AS Avg_LightlyActive,
  ROUND(AVG(SedentaryMinutes)) AS Avg_Sedentary
FROM daily_level;*/

-- Insight 3: Top 10 most active days
/*SELECT Id, ActivityDate, TotalSteps
FROM daily_level
ORDER BY TotalSteps DESC
LIMIT 10;*/

-- Insight 4: Manually calculate correlation between TotalSteps and Calories
/*SELECT 
    ROUND((
        SUM((TotalSteps - avg_steps) * (Calories - avg_calories)) /
        SQRT(SUM(POW(TotalSteps - avg_steps, 2)) * SUM(POW(Calories - avg_calories, 2)))
    ), 4) AS Correlation_Steps_Calories
FROM (
    SELECT *,
        (SELECT AVG(TotalSteps) FROM daily_level) AS avg_steps,
        (SELECT AVG(Calories) FROM daily_level) AS avg_calories
    FROM daily_level
) AS subquery;*/


-- Insight 5: Compare calories on Active vs Inactive days
/*SELECT
  CASE 
    WHEN VeryActiveMinutes >= 30 THEN 'Active Day'
    ELSE 'Inactive Day'
  END AS DayType,
  ROUND(AVG(Calories)) AS AvgCalories
FROM daily_level
GROUP BY DayType;*/

-- Final Check: Count of cleaned records
#SELECT COUNT(*) AS CleanedRowCount FROM daily_level

# FOR HOURLY_LEVEL ----------------------------------------------------------------------------------------------------------------------------

/*CREATE TABLE hourly_level (
    Id BIGINT,
    ActivityHour DATETIME,
    Calories INT,
    TotalIntensity INT,
    AverageIntensity FLOAT,
    StepTotal INT
);*/

/*INSERT INTO hourly_level (Id, ActivityHour, Calories, TotalIntensity, AverageIntensity, StepTotal)
SELECT 
    hc.Id,
    hc.ActivityHour,
    hc.Calories,
    hi.TotalIntensity,
    hi.AverageIntensity,
    hs.StepTotal
FROM hourlycalories hc
JOIN hourlyintensities hi ON hc.Id = hi.Id AND hc.ActivityHour = hi.ActivityHour
JOIN hourlysteps hs ON hc.Id = hs.Id AND hc.ActivityHour = hs.ActivityHour;*/

-- Remove rows with any NULL values
/*DELETE FROM hourly_level
WHERE Id IS NULL
   OR ActivityHour IS NULL
   OR Calories IS NULL
   OR TotalIntensity IS NULL
   OR AverageIntensity IS NULL
   OR StepTotal IS NULL;*/
   
   -- Create a temporary table with row numbers
/*CREATE TEMPORARY TABLE temp_hourly AS
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY Id, ActivityHour, Calories, TotalIntensity, AverageIntensity, StepTotal
           ORDER BY Id
       ) AS row_num
FROM hourly_level;

-- Delete everything from original table
/*DELETE FROM hourly_level;

-- Keep only unique rows
INSERT INTO hourly_level (Id, ActivityHour, Calories, TotalIntensity, AverageIntensity, StepTotal)
SELECT Id, ActivityHour, Calories, TotalIntensity, AverageIntensity, StepTotal
FROM temp_hourly
WHERE row_num = 1;

-- Step 4: Drop temp table
DROP TEMPORARY TABLE temp_hourly;*/

# Re-run necessary code after reset to recreate the SQL script

-- Insights - hourly_level------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. Most Active Hours (Avg Steps by Hour of Day)
/*SELECT 
    HOUR(ActivityHour) AS HourOfDay,
    ROUND(AVG(StepTotal), 2) AS AvgSteps
FROM hourly_level
GROUP BY HourOfDay
ORDER BY AvgSteps DESC;*/

-- 2. Calories Burned per Hour (Daily Avg)
/*SELECT 
    DATE(ActivityHour) AS Day,
    ROUND(AVG(Calories), 2) AS AvgCaloriesBurned
FROM hourly_level
GROUP BY Day
ORDER BY Day;*/

-- 3. Top 5 Most Intense Hours
/*SELECT 
    ActivityHour,
    TotalIntensity
FROM hourly_level
ORDER BY TotalIntensity DESC
LIMIT 5;*/

-- 4. Total Steps Per Day
/*SELECT 
    DATE(ActivityHour) AS Day,
    SUM(StepTotal) AS TotalSteps
FROM hourly_level
GROUP BY Day
ORDER BY TotalSteps DESC;*/

-- 5. Average Intensity by Hour of Day
/*SELECT 
    HOUR(ActivityHour) AS HourOfDay,
    ROUND(AVG(AverageIntensity), 2) AS AvgIntensity
FROM hourly_level
GROUP BY HourOfDay
ORDER BY AvgIntensity DESC;*/


#for MINUTE_LEVEL -----------------------------------------------------------------------------------------------------------------------------------------------------
#cal
-- Add a new column for the corrected datetime
/*ALTER TABLE minuteCaloriesWide ADD COLUMN ActivityHour_fixed DATETIME;

-- Populate the new column with correctly formatted datetime
UPDATE minuteCaloriesWide
SET ActivityHour_fixed = STR_TO_DATE(ActivityHour, '%c/%e/%Y %r');

-- Optional: drop the old column
ALTER TABLE minuteCaloriesWide DROP COLUMN ActivityHour;

-- Rename the fixed column
ALTER TABLE minuteCaloriesWide CHANGE ActivityHour_fixed ActivityHour DATETIME;

#in
-- Add a new column for the corrected datetime
ALTER TABLE minuteIntensitiesWide ADD COLUMN ActivityHour_fixed DATETIME;

-- Populate the new column with correctly formatted datetime
UPDATE minuteIntensitiesWide
SET ActivityHour_fixed = STR_TO_DATE(ActivityHour, '%c/%e/%Y %r');
-- Optional: drop the old column
ALTER TABLE minuteIntensitiesWide DROP COLUMN ActivityHour;

-- Rename the fixed column
ALTER TABLE minuteIntensitiesWide CHANGE ActivityHour_fixed ActivityHour DATETIME;

#step
-- Add a new column for the corrected datetime
ALTER TABLE minuteStepsWide ADD COLUMN ActivityHour_fixed DATETIME;

-- Populate the new column with correctly formatted datetime
UPDATE minuteStepsWide
SET ActivityHour_fixed = STR_TO_DATE(ActivityHour, '%c/%e/%Y %r');

-- Optional: drop the old column
ALTER TABLE minuteStepsWide DROP COLUMN ActivityHour;

-- Rename the fixed column
ALTER TABLE minuteStepsWide CHANGE ActivityHour_fixed ActivityHour DATETIME;


-- Fix date format for sleep table
-- First drop the column (only if you're sure it's okay to delete it)
ALTER TABLE minuteSleep DROP COLUMN date_fixed;

-- Then re-add it
ALTER TABLE minuteSleep ADD COLUMN date_fixed DATETIME;

-- Now update with correct format
UPDATE minuteSleep
SET date_fixed = STR_TO_DATE(date, '%c/%e/%Y %r');
*/



/*-- Assume datetime is stored as VARCHAR in `ActivityHour` column
-- Convert it to proper DATETIME format
SELECT 
    STR_TO_DATE(ActivityHour, '%m/%d/%Y %r') AS FormattedDateTime
FROM minuteCaloriesWide;
SELECT 
    STR_TO_DATE(ActivityHour, '%m/%d/%Y %r') AS FormattedDateTime
FROM minuteStepsWide;
SELECT 
    STR_TO_DATE(ActivityHour, '%m/%d/%Y %r') AS FormattedDateTime
FROM minuteintensitieswide;
SELECT 
    STR_TO_DATE(date, '%m/%d/%Y %r') AS FormattedDateTime
FROM minutesleep;*/

/*CREATE TABLE temp_calories AS
SELECT 
    Id,
    ActivityHour,
    (
        Calories00 + Calories01 + Calories02 + Calories03 + Calories04 + Calories05 +
        Calories06 + Calories07 + Calories08 + Calories09 + Calories10 + Calories11 +
        Calories12 + Calories13 + Calories14 + Calories15 + Calories16 + Calories17 +
        Calories18 + Calories19 + Calories20 + Calories21 + Calories22 + Calories23 +
        Calories24 + Calories25 + Calories26 + Calories27 + Calories28 + Calories29 +
        Calories30 + Calories31 + Calories32 + Calories33 + Calories34 + Calories35 +
        Calories36 + Calories37 + Calories38 + Calories39 + Calories40 + Calories41 +
        Calories42 + Calories43 + Calories44 + Calories45 + Calories46 + Calories47 +
        Calories48 + Calories49 + Calories50 + Calories51 + Calories52 + Calories53 +
        Calories54 + Calories55 + Calories56 + Calories57 + Calories58 + Calories59
    ) AS TotalCalories
FROM minuteCaloriesWide;*/

/*CREATE TABLE temp_steps AS
SELECT 
    Id,
    ActivityHour,
    (
        Steps00 + Steps01 + Steps02 + Steps03 + Steps04 + Steps05 +
        Steps06 + Steps07 + Steps08 + Steps09 + Steps10 + Steps11 +
        Steps12 + Steps13 + Steps14 + Steps15 + Steps16 + Steps17 +
        Steps18 + Steps19 + Steps20 + Steps21 + Steps22 + Steps23 +
        Steps24 + Steps25 + Steps26 + Steps27 + Steps28 + Steps29 +
        Steps30 + Steps31 + Steps32 + Steps33 + Steps34 + Steps35 +
        Steps36 + Steps37 + Steps38 + Steps39 + Steps40 + Steps41 +
        Steps42 + Steps43 + Steps44 + Steps45 + Steps46 + Steps47 +
        Steps48 + Steps49 + Steps50 + Steps51 + Steps52 + Steps53 +
        Steps54 + Steps55 + Steps56 + Steps57 + Steps58 + Steps59
    ) AS TotalSteps
FROM minuteStepsWide;*/

/*CREATE TABLE temp_intensity AS
SELECT 
    Id,
    ActivityHour,
    (
        Intensity00 + Intensity01 + Intensity02 + Intensity03 + Intensity04 + Intensity05 +
        Intensity06 + Intensity07 + Intensity08 + Intensity09 + Intensity10 + Intensity11 +
        Intensity12 + Intensity13 + Intensity14 + Intensity15 + Intensity16 + Intensity17 +
        Intensity18 + Intensity19 + Intensity20 + Intensity21 + Intensity22 + Intensity23 +
        Intensity24 + Intensity25 + Intensity26 + Intensity27 + Intensity28 + Intensity29 +
        Intensity30 + Intensity31 + Intensity32 + Intensity33 + Intensity34 + Intensity35 +
        Intensity36 + Intensity37 + Intensity38 + Intensity39 + Intensity40 + Intensity41 +
        Intensity42 + Intensity43 + Intensity44 + Intensity45 + Intensity46 + Intensity47 +
        Intensity48 + Intensity49 + Intensity50 + Intensity51 + Intensity52 + Intensity53 +
        Intensity54 + Intensity55 + Intensity56 + Intensity57 + Intensity58 + Intensity59
    ) AS TotalIntensity
FROM minuteIntensitiesWide;*/

/*ALTER TABLE temp_calories ADD COLUMN ActivityDate DATE;
UPDATE temp_calories SET ActivityDate = DATE(ActivityHour);

ALTER TABLE temp_steps ADD COLUMN ActivityDate DATE;
UPDATE temp_steps SET ActivityDate = DATE(ActivityHour);

ALTER TABLE temp_intensity ADD COLUMN ActivityDate DATE;
UPDATE temp_intensity SET ActivityDate = DATE(ActivityHour);*/

/*CREATE TABLE minute_level AS
SELECT 
    c.Id,
    c.ActivityHour,
    c.TotalCalories,
    s.TotalSteps,
    i.TotalIntensity,
    sl.value AS SleepValue
FROM temp_calories c
JOIN temp_steps s ON c.Id = s.Id AND c.ActivityHour = s.ActivityHour
JOIN temp_intensity i ON c.Id = i.Id AND c.ActivityHour = i.ActivityHour
LEFT JOIN minuteSleep sl ON c.Id = sl.Id AND c.ActivityDate = sl.date_fixed;*/

-- Check if there are duplicates
/*SELECT Id, ActivityHour, COUNT(*) AS count
FROM minute_level
GROUP BY Id, ActivityHour
HAVING count > 1;*/

-- Remove duplicates by keeping only the first row
/*CREATE TABLE minute_level_clean AS
SELECT *
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY Id, ActivityHour ORDER BY Id) AS rn
    FROM minute_level
) t
WHERE rn = 1;*/

-- Then, replace original table
/*DROP TABLE minute_level;
RENAME TABLE minute_level_clean TO minute_level;*/

-- Remove rows with NULL values in important fields:
/*DELETE FROM minute_level
WHERE TotalCalories IS NULL
   OR TotalSteps IS NULL
   OR TotalIntensity IS NULL;*/

/*DELETE FROM minute_level
WHERE SleepValue IS NULL;*/

#SELECT COUNT(*) FROM minute_level;

/*SELECT Id, ActivityHour, COUNT(*) AS cnt
FROM minute_level
GROUP BY Id, ActivityHour
HAVING cnt > 1;*/

#INSIGHTS--------------------------------------------------------------------------------------------------------------------------------------------

-- 1.Average Calories, Steps, and Intensity per Hour
/*SELECT 
    HOUR(ActivityHour) AS HourOfDay,
    ROUND(AVG(TotalCalories), 2) AS AvgCalories,
    ROUND(AVG(TotalSteps), 2) AS AvgSteps,
    ROUND(AVG(TotalIntensity), 2) AS AvgIntensity
FROM minute_level
GROUP BY HOUR(ActivityHour)
ORDER BY HourOfDay;*/

-- 2.Total Daily Activity per User
/*SELECT 
    Id,
    DATE(ActivityHour) AS ActivityDate,
    SUM(TotalCalories) AS DailyCalories,
    SUM(TotalSteps) AS DailySteps,
    SUM(TotalIntensity) AS DailyIntensity
FROM minute_level
GROUP BY Id, DATE(ActivityHour)
ORDER BY DailyCalories DESC;*/

-- 3.Compare Sleep vs. Activity
/*SELECT 
    Id,
    DATE(ActivityHour) AS Date,
    SUM(TotalCalories) AS TotalCalories,
    SUM(TotalSteps) AS TotalSteps,
    SUM(TotalIntensity) AS TotalIntensity,
    AVG(SleepValue) AS AvgSleep
FROM minute_level
GROUP BY Id, DATE(ActivityHour)
HAVING AvgSleep IS NOT NULL
ORDER BY AvgSleep DESC;*/

-- 4.Most Active Users (by Steps)
/*SELECT 
    Id,
    SUM(TotalSteps) AS TotalSteps
FROM minute_level
GROUP BY Id
ORDER BY TotalSteps DESC
LIMIT 10;*/

-- 5.Day of Week Analysis (Peak Activity Days)
/*SELECT 
    DayOfWeek,
    AvgSteps,
    AvgCalories
FROM (
    SELECT 
        DAYNAME(ActivityHour) AS DayOfWeek,
        ROUND(AVG(TotalSteps), 2) AS AvgSteps,
        ROUND(AVG(TotalCalories), 2) AS AvgCalories
    FROM minute_level
    GROUP BY DAYNAME(ActivityHour)
) AS weekly_summary
ORDER BY FIELD(DayOfWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
*/

-- 6.Low Activity Hours
/*
SELECT 
    HOUR(ActivityHour) AS HourOfDay,
    ROUND(AVG(TotalSteps), 2) AS AvgSteps
FROM minute_level
GROUP BY HOUR(ActivityHour)
ORDER BY AvgSteps ASC
LIMIT 5;















