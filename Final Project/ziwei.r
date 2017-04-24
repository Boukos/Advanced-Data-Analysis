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
my_df <- df[index[1:300],]
head(my_df)

# Heatmap for correlation matrix

numeric_features <- c('area','population','perc.young','perc.old','physicians','hospital.beds','n.crimes','perc.hs','perc.bs','perc.poor','unemployment','per.income','tot.income','pop.density','physician.per.1000','beds.per.1000','crime.rate.per.1000')
cormat <- round(cor(my_df[numeric_features]),2)
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

library(stats)
# https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.html
m1 <- glm( n.crimes/(population/1000)~ area+perc.young+perc.old+perc.hs+perc.bs+perc.poor+unemployment+per.income+region+pop.density+physician.per.1000+beds.per.1000 ,
    family=quasipoisson, data=my_df, weights=(population/1000))
summary(m1)


# Select most important variables and fit again
m2 <- glm( n.crimes/(population/1000)~ perc.young+perc.poor+per.income+factor(region)+pop.density+physician.per.1000+beds.per.1000+perc.bs ,
    family=quasipoisson, data=my_df, weights=(population/1000))
summary(m2)


# Outliers
outliers <- which(hatvalues(m2)>0.25)
temp <- data.frame(hat.values=hatvalues(m2),res=residuals(m2))
ggplot(data=temp,aes(hat.values,res)) +
  geom_point(alpha=0.8)+
  geom_text(data=temp[outliers,],aes(hat.values,res, label=my_df$county[outliers]),size=5,hjust=1,alpha=0.8)


# Predict and examine
newdata <- df[index[301:440],]
y_hat <- predict(m2, newdata, type="response")
y <- newdata$crime.rate.per.1000
t1 <- lm(y~y_hat)
outliers <- which(abs(residuals(t1))>70)
temp <- data.frame(hat.values=hatvalues(t1),res=residuals(t1),y=y,y.hat=y_hat)
ggplot(data=temp,aes(y.hat,y)) +
  geom_point(alpha=0.8)+
  geom_text(data=temp[outliers,],aes(y.hat,y, label=newdata$county[outliers]),size=5,hjust=1,alpha=0.8)+
  geom_abline(slope=1)



# Fit Random Forest/XGboost Model

# Plot most important variables and interpret
