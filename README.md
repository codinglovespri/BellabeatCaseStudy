# BellabeatCaseStudy    

## Scenario  
Bellabeat is a high-tech company that focuses on health-focused smart products. Since 2013, the company has not only launched multiple products like the Bellabeat app and Leaf, but it has also opened offices globally, and has successfully created a name for themselves as a tech-driven wellness company for women. In this case, I will analyze the smart device data to guide marketing strategy for the company. 

## 1. Ask    

#### Task:   
Analyze Fitbit data to gain insight and help guide marketing strategy for Bellabeat to grow as a global player.   
#### Stakeholders:   
Urška Sršen and Sando Mur (executive team members), and the Bellabeat marketing analytics team
## 2. Prepare   
#### Data Source:   
30 participants FitBit Fitness Tracker Data from Mobius: https://www.kaggle.com/arashnic/fitbit    

The dataset contains limitations:   
* The sample size is 30 people, which is not representative of the true population that uses Bellabeat products.
* There are 28 IDs that do not show up on either the weight log or sleep log table, so some records are missing. 
* The dataset is from 2016, so user habits from 6 years ago may be different.     


The dataset contains 18 CSV files, and aligns with the ROCCC approach:
* Reliability: The data contains data from 30 FitBit users who consented to the submission of personal tracker data and a distributed survey via Amazon Mechanical Turk.
* Original: The data is from 30 FitBit users who consented to the submission of personal tracker data via Amazon Mechanical Turk.
* Comprehensive: For physical activity, heart rate, and sleep monitoring, the data is represented in minutes. Though the data tracks a variety of factors that influence a user’s activity level, the sample size is on the smaller side.
* Current: Data is from March 2016 to May 2016. The dataset is 6 years old as of date of analysis, so user habits may be different now.
* Cited: Unknown.


## 3. Process    
### Explore and examine data
```diff
ALTER TABLE dailyactivity_merged RENAME TO daily_activity;
ALTER TABLE sleepday_merged RENAME TO sleep_log;
ALTER TABLE sleepday_merged1 RENAME TO sleep_log_copy;
ALTER TABLE weightloginfo_merged RENAME TO weight_log;
```
Changing the table names to match naming conventions.
```diff
SELECT distinct d.Id 
FROM daily_activity AS d;
/* Find the number of participants in the study */
```
There were 33 participants in the study.
```diff
SELECT MIN(ActivityDate) AS startDate, MAX(ActivityDate) AS endDate
FROM daily_activity;
/* Find the start and end date of the study */
```
The start date was 4/12/2016, end date 5/9/2016.


### Check for duplicate or NA values    
```diff
SELECT ID, ActivityDate 
FROM daily_activity
GROUP BY ID, ActivityDate
HAVING COUNT(*) > 1; 
```  
For the daily activity table, there are no duplicate rows based on the results from the query above.
```diff
SELECT ID, SleepDay 
FROM sleep_log
GROUP BY ID, SleepDay
HAVING COUNT(*) > 1;
CREATE TABLE sleep_log_unique SELECT DISTINCT * FROM sleep_log;
```
For the sleep log table, there were 3 duplicate rows, so I created a new sleep log table without the duplicates.
```diff
SELECT ID, Date, WeightKg 
FROM weight_log
GROUP BY ID, Date, WeightKg 
HAVING COUNT(*) > 1;
```
For the weight log table, there were no duplicate rows.

### Clean Data  
* I first converted the date columns to day of the week using Excel, then imported the csv file into Jupyter Notebook for aggregate analysis. 
```diff
activity['DayofWeek'] = pd.Categorical(activity['DayofWeek'], ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
activity = activity.sort_values('DayofWeek')
```
This sorts the dataframe by the day of weeks for easier aggregate analysis.

[Link to SQL script](https://github.com/codinglovespri/BellabeatCaseStudy/blob/10b3f80493b8cf798b5e74c78243bbe4ab34a2ea/bellabeat.sql)  

[Link to Jupyter Notebook](https://github.com/codinglovespri/BellabeatCaseStudy/blob/405b84af52ebeb1e2878b10fc213d3befb11a0c2/Bellabeat%20Visualizations.ipynb)  


## 4. Analyze    

```diff
SELECT AVG(TotalMinutesAsleep) AS AvgMinutesAsleep, AVG(TotalMinutesAsleep / 60) AS AvgHoursAsleep
FROM sleep_log_copy;
/* Finding the average total minutes asleep */
```
The average minutes asleep is 419.4673, also about 7 hours.

```diff
SELECT AVG(TotalSteps) AS AvgSteps, AVG(TotalDistance) AS AvgDistance, AVG(Calories) AS AvgCalories
FROM daily_activity;
/* Finding the average total steps, total distance, and calories */
```
The average total steps, total distance, and calories is 7637.9106, 5.4897, and 2303.609 calories respectively. 

```diff
SELECT DISTINCT Id
FROM daily_activity
WHERE Id NOT IN (
	SELECT d.Id
	FROM daily_activity AS d 
	JOIN sleep_log_unique AS s
	ON d.ActivityDate = s.SleepDay AND d.Id = s.Id
	JOIN weight_log AS w
	ON s.SleepDay = w.Date AND s.Id = w.Id);
 /* Finding the IDs that do not have records in either the sleep log or weight log */
 
 SELECT DISTINCT Id FROM sleep_log GROUP BY Id;
 /* Finding distinct IDs from sleep log */
 
 SELECT DISTINCT Id FROM weight_log GROUP BY Id;
/* Finding distinct IDs from weight log */
```
* There are 28 records that are either not in the sleep log or the weight log. 
* From sleep log, there were only 24 users who recorded their sleep. 
* From weight log, there were only 8 users who recorded their weight.

## 5. Share   
Here, I created visualizations using Matplotlib to communicate my findings.   

[Link to Jupyter Notebook](https://github.com/codinglovespri/BellabeatCaseStudy/blob/405b84af52ebeb1e2878b10fc213d3befb11a0c2/Bellabeat%20Visualizations.ipynb)  

### Visualizations  
![CaloriesBurned](https://user-images.githubusercontent.com/97275273/210922428-401d54f9-23d0-4007-bdc3-cbd7e8385f73.png)    
``` diff
The more steps taken in a day, the more calories a user will burn.    
```
![CaloriesBurnedMedian](https://user-images.githubusercontent.com/97275273/210922510-37de317a-567c-4977-a35e-c551c9c8abb3.png)    
``` diff
The same graph, with the median steps and median calories burned included. 
```


### Active Levels vs Total Minutes Asleep   
I plotted the line of regression in black to identify the correlation easier. 
![Sedentary](https://user-images.githubusercontent.com/97275273/210922816-8577e79a-d157-4205-bb56-9368c6cf6398.png)   
```diff
Correlation coefficient: -0.6010731396971011    
There is a pretty strong negative correlation between the two variables, showing that the more sedentary a user is, the less sleep they get.   
```
 
![LightlyActive](https://user-images.githubusercontent.com/97275273/210922804-6fcc3702-c31f-4607-aab6-380aaf782d8a.png)  
```diff
Correlation coefficient: 0.027583356789564462
There is not a strong correlation between the two variables.
```

![FairlyActive](https://user-images.githubusercontent.com/97275273/210922789-2c59341a-1d35-4546-b5b7-24985ae7ffbd.png)  
```diff
Correlation coefficient: -0.2492079302480945
There is not a strong correlation between the two variables.
```

![VeryActive](https://user-images.githubusercontent.com/97275273/210922820-3281c5de-f58f-47e9-8ab4-4c474b7f52b9.png)
```diff
Corrleation coefficient: -0.08812657953070487
There is not a strong correlation between the two variables.
```

![PercentageBreakdown](https://user-images.githubusercontent.com/97275273/211079572-e14e57b2-2338-4f8a-9375-5f06c3d123b7.png)
```diff
A breakdown of the activity level amongst the participants.
```

### Key findings:

* The more steps taken in a day, the more calories a user can burn. 
* The less time users spend being sedentary, the more sleep they get.
* Most users in the dataset spend their time in the study being sedentary. 

## 6. Act
* Conclusions:
* 

