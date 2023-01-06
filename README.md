# BellabeatCaseStudy    
### Scenario   


hi 
--- 
## 1. Ask    

Task: Analyze Fitbit data to gain insight and help guide marketing strategy for Bellabeat to grow as a global player.   
Stakeholders: Urška Sršen and Sando Mur (executive team members), and the Bellabeat marketing analytics team
## 2. Prepare   
Data Source: 30 participants FitBit Fitness Tracker Data from Mobius: https://www.kaggle.com/arashnic/fitbit    

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
* Explore and examine data
* Check for duplicate or NA values    


[Link to SQL script](https://github.com/codinglovespri/BellabeatCaseStudy/blob/10b3f80493b8cf798b5e74c78243bbe4ab34a2ea/bellabeat.sql)

## 4. Analyze    



## 5. Share   
Here, I created visualizations using Matplotlib to communicate my findings.   

[Link to Jupyter Notebook](https://github.com/codinglovespri/BellabeatCaseStudy/blob/405b84af52ebeb1e2878b10fc213d3befb11a0c2/Bellabeat%20Visualizations.ipynb)  

### Visualizations
![CaloriesBurned](https://user-images.githubusercontent.com/97275273/210922428-401d54f9-23d0-4007-bdc3-cbd7e8385f73.png)    
The more steps taken in a day, the more calories a user will burn.    

![CaloriesBurnedMedian](https://user-images.githubusercontent.com/97275273/210922510-37de317a-567c-4977-a35e-c551c9c8abb3.png)    
The same graph, with the median included. 

### Active Levels vs Total Minutes Asleep   

I plotted the line of regression in black to identify the correlation easier. 
![Sedentary](https://user-images.githubusercontent.com/97275273/210922816-8577e79a-d157-4205-bb56-9368c6cf6398.png)   
> Correlation coefficient: -0.6010731396971011    
> There is a pretty strong correlation between the two variables, showing that the more sedentary a user is, the less sleep they get.   

 
![LightlyActive](https://user-images.githubusercontent.com/97275273/210922804-6fcc3702-c31f-4607-aab6-380aaf782d8a.png)

![FairlyActive](https://user-images.githubusercontent.com/97275273/210922789-2c59341a-1d35-4546-b5b7-24985ae7ffbd.png)

![VeryActive](https://user-images.githubusercontent.com/97275273/210922820-3281c5de-f58f-47e9-8ab4-4c474b7f52b9.png)


Key findings:

* The more steps taken in a day, the more calories a user can burn. 
* The less time users spend being sedentary, the more sleep they get.
* Most users in the dataset spend their time in the study being sedentary. 

## 6. Act
