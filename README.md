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

[Link to SQL script](https://github.com/codinglovespri/BellabeatCaseStudy/blob/89f5566c740876ef5a602267910f980a7c6295de/bellabeat.sql)  

[Link to Jupyter Notebook](https://github.com/codinglovespri/BellabeatCaseStudy/blob/89f5566c740876ef5a602267910f980a7c6295de/Bellabeat%20Analysis%20-%20Google%20Data%20Analytics%20Capstone.ipynb)  


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

### Frequency users record sleep and weight data		

![sleepdata](https://user-images.githubusercontent.com/97275273/211120242-d19a5f40-37ae-4522-8298-91b74b991abf.png)		

* Users were least likely to record sleep data during Sunday and Monday. 

![weightdata](https://user-images.githubusercontent.com/97275273/211120245-68194ea6-6cb2-464b-aeaa-85d32309273e.png)			

* Users were least likely to record weight data during Friday and Saturday. 


## 5. Share   
Here, I created visualizations using Matplotlib to communicate my findings.   

[Link to Jupyter Notebook](https://github.com/codinglovespri/BellabeatCaseStudy/blob/89f5566c740876ef5a602267910f980a7c6295de/Bellabeat%20Analysis%20-%20Google%20Data%20Analytics%20Capstone.ipynb)  

![avgsteps](https://user-images.githubusercontent.com/97275273/211120742-243f087b-21f2-4e6f-b3e7-bcc65a60c9df.png)

![avgcalories (1)](https://user-images.githubusercontent.com/97275273/211120754-e0a163be-2670-494c-9c1d-6a501cb22d52.png)

![avgsedentaryminutes](https://user-images.githubusercontent.com/97275273/211120763-971f356b-1680-4907-a7d0-7150279e3436.png)

### Sleep

![avgsleep](https://user-images.githubusercontent.com/97275273/211120866-21c29374-c4d9-464c-8fab-8dab9c3778ca.png)

![timetosleep](https://user-images.githubusercontent.com/97275273/211120858-a4f186fb-7eca-4fa5-9ded-24d355c555ca.png)

### Calories vs Sleep

![CaloriesBurned](https://user-images.githubusercontent.com/97275273/211120386-6ad15d54-0d91-430f-83de-00e9d0a55884.png)

``` diff!
The more steps taken in a day, the more calories a user will burn.    
```
![CaloriesBurnedMedian](https://user-images.githubusercontent.com/97275273/211120426-4091f6a2-4ed6-4585-aa0b-5e7ac0e33621.png)

``` diff
The same graph, with the median steps and median calories burned included. 
```		
### Activity Level vs Sleep 
 
I plotted the line of regression in black to identify the correlation easier. 
![sedentaryandsleep](https://user-images.githubusercontent.com/97275273/211120940-1f334f5e-74dd-415c-bcdd-664bd57bb862.png)

```diff
Correlation coefficient: -0.6010731396971011    
There is a pretty strong negative correlation between the two variables, showing that the more sedentary a user is, the less sleep they get.   
```
 
![lightlyactiveandsleep](https://user-images.githubusercontent.com/97275273/211120962-7ba8278e-7f95-4258-a70d-db4595f815cc.png)

```diff
Correlation coefficient: 0.027583356789564462
There is not a strong correlation between the two variables.
```

![fairlyactiveandsleep](https://user-images.githubusercontent.com/97275273/211120971-08cea67b-c669-465d-8a3a-9fabe7f535bf.png)

```diff
Correlation coefficient: -0.2492079302480945
There is not a strong correlation between the two variables.
```
![veryactiveandsleep](https://user-images.githubusercontent.com/97275273/211120974-2f6aafa7-dbd5-4e52-965e-7a0175208f6e.png)

```diff
Corrleation coefficient: -0.08812657953070487
There is not a strong correlation between the two variables.
```

![PercentageBreakdown](https://user-images.githubusercontent.com/97275273/211120986-ff54ab4c-92ff-472b-8852-4ddaed82ea8b.png)
```diff
A breakdown of the activity level amongst the participants.
```
****
### Key findings: 
* Users recorded weight data the least on Friday and Saturday (the beginning of the weekend). 
* Users recorded sleep data the least during Sunday and Monday (the end of the weekend). 
* Most people in the study were sedentary, 81%.
* Saturday is the most active day, people take the most steps and burn the most calories and have the least amount of sedentary activity as well. 
* People have the hardest time falling asleep on Sunday, however they also get the most amount of sleep on that day. 
* Users burned more calories the more steps they took.
* There is a strong correlation between amount of time spent being sedentary and amount of sleep → the more time people spent being sedentary, the less sleep they got. 

## 6. Act
Recommendations:
* I would encourage Bellabeat to market that their device is comfortable to wear throughout the day, especially during the night or when going out (due to the lack of data on weekends).
* I would encourage Bellabeat to promote body-positivity and inclusivity in their marketing campaigns as the data shows there are more missing weight data than sleep data. 
* I would suggest Bellabeat to create an award system that rewards users with a digital badge or trophy when they hit 10,000 steps, which is the recommended daily average to boost health. Any sort of motivation to encourage users to increase daily steps, as the average daily steps in the dataset was about 7,600, significantly lower than 10,00. 

