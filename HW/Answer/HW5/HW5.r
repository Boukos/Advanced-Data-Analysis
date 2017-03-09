#Q1
#(a)
data = read.csv("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Question/HW5/Shuttle.csv", header = TRUE)
data
glm(ThermalDistress~Temperature, data = data, family = binomial("logit"))

#(c)
confint(glm(ThermalDistress~Temperature, data = data, family = binomial("logit")))
