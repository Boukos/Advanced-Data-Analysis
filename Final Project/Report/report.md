1 Overview
Goal and Procedure
2 Model Building Data Overview
Data Processing
Regression Model
Interpretation of Variables Effect on Crime Rate Prediction
Discoveries from the Testing Result
3 Suggestions and Further Thoughts


### Goal and Procedure
Using the data given to create a regression model.
Based on the model, give suggestions on the reduction of the number of serious crimes in their county.
Further thoughts about the findings.

### data Overview
Geographic Data: Land Area, Geographic Region Demographic Data: Total population, Percent of population
aged 18-34, Percent Bachelor’s Degree
Economics Data: Percent Below Poverty Level, Total Personal Income, Per Capita Income

### Data Processing
Check for missing values (and substitute them with mean values) Calculate more variables that cater to our needs:
(1) Population Density = Population Area
(2) Physician Per 1000 Population = Physician
P opulation/1000
(3) Hospital Beds Per 1000 Population = HospitalBeds P opulation/1000
     (4) Crime Rate Per 1000 Population =
Crimes
P opulation/1000
 Randomly Select 330 rows of data to train the regression model, and the remaining 110 rows are used for testing the accuracy of our model


### Heatmap
First we explore the correlation of variables:

Given 16 predictor variables, some of them are strongly correlated with each other, which will cause us to get some potentially false conclusion, thus we remove these variables.
The remaining variables are:
Area, Percentage of Young People, Percentage of Old People, Percentage of High School, Percentage of Bachelor, Percentage of Poor, Unemployment, Income, Region, Population Density, Physician Per 1000 Population, Beds Per 1000 Population

### Regression Model
Given the fact that crime rate is a count value, in this question we fit the data to Poisson Regression Model, to reduce the effect of region size, we add offset to the model, and also use quasi-likelihood in order to prevent over dispersion.

Then we do the significant test for each variable.
Through the resulting output table from Poisson Regression, the following variables are insignificant:
area, percent of old people, percent of people with high school education.
After removing the insignificant variables, we build the Poisson Regression Model again using only the most important variables.

### Outliers
Check Outliers

### Interpretation of Variables Effect on Crime Rate
Here we interpret the meaning of each parameters in our model:
percent young: If we decrease the percent of young people by 1 unit while holding all other variables the same, the crime rate would decrease by a multiplicative factor of 1.017847 on average.
percent poor: If we decrease the percent on poor people by 1 unit while holding all other variables the same, the crime rate would decrease by a multiplicative factor of 1.024423 on average
population density: If we decrease the log of the population density by 1 unit while holding all other variables the same, the crime rate would decrease by a multiplicative factor of 1.085662 on average.

### Interpretation of Variables Effect on Crime Rate
