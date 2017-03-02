#Q1
#(b)
data = read.table("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Question/HW4/DATACIGARETTE.txt", header = TRUE)
mat.data <- data.matrix(data[,2:8])
mat.data
cor((mat.data))
#scatter plot matrix:
pairs(data[,2:8])

#(c)
results = lm(Sales ~ Age+HS+Income+Black+Female+Price , data=data)
# install.packages('car')
results
library(car)
vif(results)

#(d)
r = rstudent(results)
data[abs(r)>3,]

#(e)
lev = hat(model.matrix(results))
lev
# length(lev)
# 51
data[lev>12/51]
data[which(lev>12/51),1]

#(f)
cook = cooks.distance(results)
cook

#(g)
#(gd)
results = lm(ln(Sales) ~ Age+HS+Income+Black+Female+Price , data=data)
results
r = rstudent(results)
data[abs(r)>3,]


#(ge)
lev = hat(model.matrix(results))
lev
# length(lev)
# 51
data[which(lev>12/51),1]

#(gf)
cook = cooks.distance(results)
cook

# just wonder why the results doesn't change anything after taking the log(Sales)

data[ ,'Sales']
log(data[,'Sales'])



# Q2
# (a)
data = read.csv("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Question/HW4/Oildata.csv")

colnames(data)

full = lm(Mileage ~ factor(Rgasoline) + factor(GasolineAd), data = data)
reduce1 = lm(Mileage ~ factor(GasolineAd), data = data)
reduce2 = lm(Mileage ~ factor(Rgasoline), data = data)
anova(reduce1, full)
anova(reduce2, full)
