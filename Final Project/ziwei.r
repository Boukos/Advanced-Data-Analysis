---
title: "ADA Final Project"
author: "Ziwei Meng, zm2245"
Date: "24 April, 2017"
output:
    html_notebook:
      theme: journal
---


# Read Data

#setwd('/Users/Zoe/Documents/Spring2017/GR5291/FinalProject/')
df <- read.table('/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/Final Project/APPENC02.txt',sep = "", header = FALSE)
colnames(df) <- c("id","county","state","area","population","perc.young","perc.old","physicians","hospital.beds","n.crimes","perc.hs","perc.bs","perc.poor","unemployment","per.income","tot.income","region")
head(df)
#sapply(df, function(x) sum(is.na(x))) no missing value


# Transform variables

df['pop.density'] = df$population/df$area
df['physician.per.1000'] = df$physicians/(df$population/1000)
df['beds.per.1000'] = df$hospital.beds/(df$population/1000)
df['crime.rate.per.1000'] = df$n.crimes/(df$population/1000)


# Split into train and test

UNI <- 2245
set.seed(UNI)
index <- sample(c(1:440))
train_df <- df[index[1:300],]
head(train_df)


# Heatmap for correlation matrix

numeric_features <- c('area','population','perc.young','perc.old','physicians','hospital.beds','n.crimes','perc.hs','perc.bs','perc.poor','unemployment','per.income','tot.income','pop.density','physician.per.1000','beds.per.1000','crime.rate.per.1000')
cormat <- round(cor(train_df[numeric_features]),2)
library(reshape2)
melted_cormat <- melt(cormat)
library(ggplot2)
ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
 geom_tile(color = "white")+
 scale_fill_gradient2(low = "blue", high = "red", mid = "white",
   midpoint = 0, limit = c(-1,1), space = "Lab",
   name="Pearson\nCorrelation") +
  theme_minimal()+
 theme(axis.text.x = element_text(angle = 45, vjust = 1,
    size = 12, hjust = 1))+
 coord_fixed()



# Fit Poisson Regression Model with Offset and Quasi-likelihood

m1 <- glm( n.crimes/(population/1000)~ area+perc.young+perc.old+perc.hs+perc.bs+perc.poor+unemployment+per.income+region+pop.density+physician.per.1000+beds.per.1000 ,
    family=quasipoisson, data=train_df, weights=(population/1000))
summary(m1)


# Select most important variables and fit again

m2 <- glm( n.crimes/(population/1000)~ perc.young+perc.poor+per.income+factor(region)+log(pop.density)+physician.per.1000+beds.per.1000+perc.bs + unemployment ,
    family=quasipoisson, data=train_df, weights=(population/1000))
summary(m2)

# Outliers

outliers <- which(hatvalues(m2)>0.25)
temp <- data.frame(hat.values=hatvalues(m2),res=residuals(m2))
ggplot(data=temp,aes(hat.values,res)) +
  geom_point(alpha=0.8)+
  geom_text(data=temp[outliers,],aes(hat.values,res, label=train_df$county[outliers]),size=5,hjust=1,alpha=0.8)

# Predict and examine

#library("Metrics")
test_df <- df[index[301:440],]
y_hat <- predict(m2, test_df, type="response")
y <- test_df$crime.rate.per.1000
y_ex <- y[-82]
y_hat_ex <- predict(m2,test_df[-82,],type = "response")
t1 <- lm(y~y_hat)
#print(rmse(y,y_hat))
outliers <- which(abs(residuals(t1))>50)
temp <- data.frame(hat.values=hatvalues(t1),res=residuals(t1),y=y,y.hat=y_hat)
ggplot(data=temp,aes(y.hat,y)) +
  geom_point(alpha=0.8)+
  geom_text(data=temp[outliers,],aes(y.hat,y, label=test_df$county[outliers]),size=5,hjust=1,alpha=0.8)+
  geom_abline(slope=1)


# Compare Kings in NY and CA

df[c(6,433),]



# Fit Random Forest/XGboost Model

library("xgboost")
f_to_use <- c('area','perc.young','perc.old','perc.hs','perc.bs','perc.poor','unemployment','per.income','region','pop.density','physician.per.1000','beds.per.1000')
dtrain <- xgb.DMatrix(data = as.matrix(train_df[f_to_use]),label=train_df$crime.rate.per.1000)
dtest <- xgb.DMatrix(data = as.matrix(test_df[f_to_use]),label=test_df$crime.rate.per.1000)
ex.dtest <- xgb.DMatrix(data = as.matrix(test_df[-82,f_to_use]),label=test_df$crime.rate.per.1000[-82])

cv <- xgb.cv(data = dtrain, nrounds = 300, nfold = 5, metrics = "rmse", max_depth=2, eta=0.03, objective = "reg:linear",early_stopping_rounds = 20)
#print(cv)
bst <- xgboost(data = dtrain, max_depth = 2, eta = 0.03, nrounds = 300, objective = "reg:linear")

pred <- predict(bst,dtest)
pred_ex <- predict(bst,ex.dtest)
#print(rmse(y,pred))

# plot
t2 <- lm(y~pred)
#print(rmse(y,y_hat))
outliers <- which(abs(residuals(t2))>50)
temp <- data.frame(hat.values=hatvalues(t2),res=residuals(t2),y=y,y.hat=pred)
ggplot(data=temp,aes(y.hat,y)) +
  geom_point(alpha=0.8)+
  geom_text(data=temp[outliers,],aes(y.hat,y, label=test_df$county[outliers]),size=5,hjust=1,alpha=0.8)+
  geom_abline(slope=1)


# Plot most important variables and interpret

importance_matrix <- xgb.importance(model = bst)
print(importance_matrix)
importance_matrix$Feature <- f_to_use[as.integer(importance_matrix$Feature)+1]
xgb.plot.importance(importance_matrix = importance_matrix)


# Compare RMSE for two models

library("Metrics")
met <- data.frame(Poisson=c(rmse(y,y_hat),rmse(y_ex,y_hat_ex)),GBM=c(rmse(y,pred),rmse(y_ex,pred_ex)))
row.names(met) <- c('with Kings','without Kings')
met


# Compare Kings with other counties in US

Kings <- test_df[82,f_to_use]
row.names(Kings) <- 'Kings'
country_avg <- colMeans(df[-6,f_to_use])
diff_country <- data.frame(feature=f_to_use)
diff_country$diff.value <- t(Kings - country_avg)
colnames(diff_country) <- c("feature","diff.value")

diff_country$colour <- ifelse(diff_country$diff.value < 0, "negative","positive")
ggplot(diff_country,aes(feature,diff.value))+
  geom_bar(stat="identity",position="identity",aes(fill = colour))+
  scale_fill_manual(values=c(positive="firebrick1",negative="steelblue")) + coord_flip()


# Compare Kings with other counties in NY

Kings <- test_df[82,f_to_use]
row.names(Kings) <- 'Kings'
NY <- df[df$state=='NY',]
NY_avg <- colMeans(NY[-6,f_to_use])

diff_country <- data.frame(feature=f_to_use)
diff_country$diff.value <- t(Kings - NY_avg)
colnames(diff_country) <- c("feature","diff.value")

diff_country$colour <- ifelse(diff_country$diff.value < 0, "negative","positive")
ggplot(diff_country,aes(feature,diff.value))+
  geom_bar(stat="identity",position="identity",aes(fill = colour))+
  scale_fill_manual(values=c(positive="firebrick1",negative="steelblue")) + coord_flip()


# Regress on counties including Kings

cv <- xgb.cv(data = ex.dtest, nrounds = 150, nfold = 5, metrics = "rmse", max_depth=2, eta=0.03, objective = "reg:linear",early_stopping_rounds = 20)
#print(cv)
bst <- xgboost(data = ex.dtest, max_depth = 2, eta = 0.03, nrounds = 150, objective = "reg:linear")

pred <- predict(bst,ex.dtest)

# plot
t3 <- lm(y[-82]~pred)

outliers <- which(abs(residuals(t3))>40)
temp <- data.frame(hat.values=hatvalues(t3),res=residuals(t3),y=y[-82],y.hat=pred)
ggplot(data=temp,aes(y.hat,y)) +
  geom_point(alpha=0.8)+
  geom_text(data=temp[outliers,],aes(y.hat,y, label=test_df$county[outliers]),size=5,hjust=1,alpha=0.8)+
  geom_abline(slope=1)


# Important features

importance_matrix <- xgb.importance(model = bst)
print(importance_matrix)
importance_matrix$Feature <- f_to_use[as.integer(importance_matrix$Feature)+1]
xgb.plot.importance(importance_matrix = importance_matrix)


# Population density

outliers <- which(df$pop.density>10000)
ggplot(data=df,aes(id,pop.density)) +
  geom_point(alpha=0.8)+
  geom_text(data=df[outliers,],aes(id,pop.density, label=df$county[outliers]),size=3.5,hjust=0.1,vjust=3,alpha=0.8,angle=30)+
  geom_abline(slope=1)
data$region
