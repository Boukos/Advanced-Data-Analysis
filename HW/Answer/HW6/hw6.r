#1
#(d)
data = c(143, 164, 188, 188, 190, 192, 206, 209, 213, 216, 220, 227, 230, 234, 246, 265, 304)
result = c()
n = length(data)
for (i in 1:17){
  result[i] = 1-(i-0.5)/n
}

plot(log(-log(result))~log(data))
fit = lm(log(-log(result))~log(data))
abline(fit)
#(e)
summary(fit)


exp(-37.2330/6.8538)


result

#2
#(a)
library(survival)
time = c(1.25, 1.41, 4.98, 5.25, 5.38, 6.92, 8.89, 10.98, 11.18, 13.11, 13.21, 16.33, 19.77, 21.08, 21.84, 22.07, 31.38, 32.61, 37.18, 42.92, 1.05, 2.92, 3.61, 4.20, 4.49, 6.72, 7.31, 9.08, 9.11, 14.49, 16.85, 18.82, 26.59, 30.26, 41.34)
status = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0)
group = c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
#data = data.frame(time, status, group)
fit <- survfit(Surv(time,status)~group,type = "kaplan-meier")
plot(fit, lty=1:2 )

#(b)

summary(fit)

#(c)
survdiff(Surv(time,status)~group, rho=0)
