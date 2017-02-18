
#what the heck is this
read.csv("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Answer/HW3/CompUSys.csv")

read.csv("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Answer/HW3/mileage.csv")


data <- read.csv("/Users/lleiou/Google Drive/😳 Courses/4th term/Advanced-Data-Analysis/HW/Answer/HW2/HW2DATA.csv")
fertilizer <- c(rep("A",12),rep("B",12))
wheat <- data[,2]
response <- data[,3]
interaction.plot(fertilizer,wheat,response)
