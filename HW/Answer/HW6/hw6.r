library(survival)
time = c(1.25, 1.41, 4.98, 5.25, 5.38, 6.92, 8.89, 10.98, 11.18, 13.11, 13.21, 16.33, 19.77, 21.08, 21.84, 22.07, 31.38, 32.61, 37.18, 42.92, 1.05, 2.92, 3.61, 4.20, 4.49, 6.72, 7.31, 9.08, 9.11, 14.49, 16.85, 18.82, 26.59, 30.26, 41.34)
status = c(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0)
group = c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2)
length(time)
data = data.frame(time, status, group)
data

km1 <- survfit(Surv(time,status)~1,type = "kaplan-meier")
km2 <- survfit(Surv(time,status)~0,type = "kaplan-meier")
fit <- survfit(Surv(time,status)~group,type = "kaplan-meier")
km$surv
plot(km1$time,km1$surv,type="s",xlab="time",ylab="survival")
plot(km2$time,km2$surv,type="s",xlab="time",ylab="survival")
plot(fit, lty=1:2 )
summary(fit)
