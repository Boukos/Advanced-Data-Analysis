#Q1
#(a)
data = read.csv("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Question/HW5/Shuttle.csv", header = TRUE)
data
glm(ThermalDistress~Temperature, data = data, family = binomial("logit"))

#(c)
confint(glm(ThermalDistress~Temperature, data = data, family = binomial("logit")))

exp(15.0429-0.2322*31)/(1+exp(15.0429-0.2322*31))
15.0429/0.2322

#Q2
#(a)
data = read.csv("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Question/HW5/adolescent.csv")
data
logit = glm(cbind(Yes,No)~factor(Gender)+factor(Race), data = data, family = binomial)
logit
summary(logit)
confint  = confint(glm(cbind(Yes,No)~factor(Gender)+factor(Race), data = data, family = binomial))
exp(confint)


exp(15.0429-0.2322*31)/(1+exp(15.0429-0.2322*31))
