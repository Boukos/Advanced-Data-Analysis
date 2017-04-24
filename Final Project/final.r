library(dplyr)
data = read.table("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/Final Project/APPENC02.txt")
is.na(data[,2])
sample_n(data,220)


dim(data)
dim(data)
head(data)
filter(data,data$V2=="Kings", data$V3=="NY")
slice(data,1:10)
arrange(data, V2, V1)mutate(data, V18=V4/V5)

filter(summarise(group_by(data, V2), number=n()), number==1)

sapply(data, function(x) sum(is.na(x)))



# 计算cook‘s distance, 寻找training data 中的outlier并去掉
# correlation matrix
# logistic regression plot
# QQ plot
# 
