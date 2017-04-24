library(dplyr)
data = read.table("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/Final Project/APPENC02.txt")
is.na(data[,2])
sample_n(data,220)

dim(data)
dim(data)
head(data)
filter(data,data$V3=="NY")
slice(data,1:10)
arrange(data, V2, V1)mutate(data, V18=V4/V5)

filter(summarise(group_by(data, V2), number=n()), number==1)

sapply(data, function(x) sum(is.na(x)))



# 计算 leverage and cook‘s distance, 寻找 training data 中的 outlier 和 influential points 并去掉
# 检测 lack of fit, multicollinearity
# scatter plot matrix
# do the regression to 330 rows of data and remove the insignificant variables
# logistic regression plot
# estimate the parameters and the confidence intervals for the logistic regression
# interpret the parameters of logistic regression function
# fit the 110 rows of data to the logistic regression model, and calculate the accuracy
# suggestions and improvements
#
