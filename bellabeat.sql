/*Rename tables*/
ALTER TABLE dailyactivity_merged RENAME TO daily_activity;
ALTER TABLE sleepday_merged RENAME TO sleep_log;
ALTER TABLE sleepday_merged1 RENAME TO sleep_log_copy;
ALTER TABLE weightloginfo_merged RENAME TO weight_log;

/*Check for duplicate rows*/
SELECT ID, ActivityDate 
FROM daily_activity
GROUP BY ID, ActivityDate
HAVING COUNT(*) > 1; 
/*No results mean there are no duplicate rows*/

SELECT ID, SleepDay 
FROM sleep_log
GROUP BY ID, SleepDay
HAVING COUNT(*) > 1;
/*3 results, create a new table with only the distinct values from sleep log*/
CREATE TABLE sleep_log_unique SELECT DISTINCT * FROM sleep_log;
 
SELECT ID, Date, WeightKg 
FROM weight_log
GROUP BY ID, Date, WeightKg 
HAVING COUNT(*) > 1;
/*No results mean there are no duplicate rows*/

/*Finds the number of participants in this case study - 33*/
SELECT distinct d.Id 
FROM daily_activity AS d;

/*Finds the duration of the study with the start and end date*/
SELECT MIN(ActivityDate) AS startDate, MAX(ActivityDate) AS endDate
FROM daily_activity;
/*The start date was 4/12/2016, end date 5/9/2016*/

/* Change the date across the tables to only include mm/dd/yy */
UPDATE weight_log SET Date = SUBSTRING_INDEX(Date, ' ', 1);
UPDATE sleep_log_unique SET SleepDay = SUBSTRING_INDEX(SleepDay, ' ', 1);
/* Join the daily activity, sleep log, and weight log table */
SELECT distinct d.Id, d.SedentaryMinutes, d.LightlyActiveMinutes, d.FairlyActiveMinutes, d.VeryActiveMinutes, s.TotalMinutesAsleep 
FROM daily_activity AS d 
JOIN sleep_log AS s
ON d.ActivityDate = s.SleepDay AND d.Id = s.Id
LEFT JOIN weight_log AS w
ON s.SleepDay = w.Date AND s.Id = w.Id
;

/* Average minutes asleep and average hours asleep */
SELECT AVG(TotalMinutesAsleep) AS AvgMinutesAsleep, AVG(TotalMinutesAsleep / 60) AS AvgHoursAsleep
FROM sleep_log_copy
;

/* Average steps, distance, and calories */
SELECT AVG(TotalSteps) AS AvgSteps, AVG(TotalDistance) AS AvgDistance, AVG(Calories) AS AvgCalories
FROM daily_activity
;

/*Finds the ids that do not have records in either the SleepLog or WeightLog tables (or both), 28/33*/
SELECT DISTINCT Id
FROM daily_activity
WHERE Id NOT IN (
	SELECT d.Id
	FROM daily_activity AS d 
	JOIN sleep_log_unique AS s
	ON d.ActivityDate = s.SleepDay AND d.Id = s.Id
	JOIN weight_log AS w
	ON s.SleepDay = w.Date AND s.Id = w.Id);
    
