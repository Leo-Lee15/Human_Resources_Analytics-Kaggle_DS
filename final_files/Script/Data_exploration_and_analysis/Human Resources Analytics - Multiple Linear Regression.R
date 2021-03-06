#####MULTIPLE LINEAR REGRESSION#####
  
###LOAD DATABASE### 

library(readr)
HR_comma_sep_v2 <- read_csv("~/Human_Resources_Analytics-Kaggle_DS/final_files/databases/HR_comma_sep_v2.csv")


###MULTIPLE LINEAR REGRESSION###

#We are going to do a linear regression with the satisfaction level as the dependant variable. We are going to remove the left variable, because if someone left is a consequence and does not have influence in the satisfaction level of the employee.

require(dplyr)
datalr<-select(HR_comma_sep_v2, -left)

# 1.- Multiple Linear Regression Example 

#Now we do the linear model wih our data.

mlr <- lm(satisfaction_level ~., data=datalr)
summary(mlr) # show results


#We can see the significant variables of the model.

#Other useful functions# 

coefficients(mlr) # model coefficients

#Here we can see the coefficients of each variable in our model.

###DIAGNOSTIC PLOTS###

#Diagnostic plots provide checks for heteroscedasticity, normality, and influential observerations.
  
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(mlr)

#We can see that the data is more or less homogenuous in our first plot, so we have (more or less) homocedastic data and we can use this model. In the plot of below we can see that the data is more or less normal too. 

###CROSS VALIDATION###

require(caret)
train_control <- trainControl(method="repeatedcv", number=10, repeats=3)
model <- train(satisfaction_level~., data=datalr, trControl=train_control, method="lm")
print(model)
model$finalModel
model$results

#Here we can see the coefficients in our model with the Cross Validation and the Rsquare coefficient, that shows us the fit in our data. It is a value of 0.12, so it is a very bad model. Anyway, we are going to do it to learn.

###REMOVING NOT SIGNIFICANT VARIABLES###

#Now we are going to remove the not significant variables, to see if our model can improve.

datalr1<-select(datalr, -c(promotion_last_5years, average_montly_hours))

# 2.- Multiple Linear Regression Example 

mlr1 <- lm(satisfaction_level ~., data=datalr1)
summary(mlr1) # show results

# Other useful functions 

coefficients(mlr1) # model coefficients

# diagnostic plots 

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(mlr1)

#These plots are more or less the same.
###CROSS VALIDATION###

require(caret)
train_control <- trainControl(method="repeatedcv", number=10, repeats=3)
model1 <- train(satisfaction_level~., data=datalr1, trControl=train_control, method="lm")
print(model1)
model1$finalModel

#The Rsquared is lower, so the model is worse.

#See if there are differences between the first and the second model

anova(mlr, mlr1)

#With an ANOVA, we can see if there are significant differences between our models. Here it is seen that in fact, there are.

###REMOVE ANOTHER VARIABLE###

datalr2<-select(datalr1, -department)

# 3.- Multiple Linear Regression Example 

mlr2<- lm(satisfaction_level ~., data=datalr2)
summary(mlr2) # show results

# Other useful functions 

coefficients(mlr2) # model coefficients

# diagnostic plots 

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(mlr1)

###CROSS VALIDATION###

require(caret)
train_control <- trainControl(method="repeatedcv", number=10, repeats=3)
model2 <- train(satisfaction_level~., data=datalr2, trControl=train_control, method="lm")
print(model2)
model2$finalModel

#Here we can see that our last model is the worst. 

#The multiple linear regression does not work well with this data, but we are going to do more stuff.

###PREDICTION###

##SPLIT TRAIN AND TEST DATABASE##

## load the libraries

require(caret)
require(klaR)

##define an 80%/20% train/test split of the dataset##

split<-0.80
trainIndex <- createDataPartition(datalr$satisfaction_level, p=split, list=FALSE)
train <- datalr[ trainIndex,]
test <- datalr[-trainIndex,]

#Now we make the predictions of our model and we save them.

predictions <- predict.lm(mlr, test)

#And now we can do a plot with the real satisfaction level and the predicted satisfaction level.

plot(test$satisfaction_level, predictions, xlab = "Real Satisfaction level", ylab = "Predicted satisfaction level")

######Change the measures of both axis#####

#EXAMPLE

#We are going to do an example of graphic representation of a linear regression, but we only stay with one predictive variable and two predictors. We stay with time spend in the company and the projects per year.

detach("package:dplyr", unload=TRUE)
require(dplyr)
finaldata<-select(datalr, c(satisfaction_level, time_spend_company, projects_per_year))

# 4.- Multiple Linear Regression Example 

mlr3<- lm(satisfaction_level ~., data=finaldata)
summary(mlr3) # show results

# Other useful functions 

coefficients(mlr3) # model coefficients

# diagnostic plots 

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(mlr3)

###CROSS VALIDATION###

require(caret)
train_control <- trainControl(method="repeatedcv", number=10, repeats=3)
model3 <- train(satisfaction_level~., data=finaldata, trControl=train_control, method="lm")
print(model3)
model3$finalModel

#The Rsquared is of 0.01, but it does not matter us this time.

##SCATTERPLOT ONE VARIABLE AT TIME

#Now, we are going to do scatterplots with the predictive variable and one predictor, like a simple linear regression.

plot(test$satisfaction_level, test$last_evaluation)
abline(lm(test$satisfaction_level~test$last_evaluation), col="blue")


#3D PLOT

#Now we are going to do the same as before, but with the two predictors and the predictive variable.Because we have three variables, we need a 3D plot.

require(car)
scatter3d(x=test$satisfaction_level, z=test$time_spend_company, y=test$projects_per_year)


######FIND HOW TO REPRESENT IN ONE AXIS THE PREDICTIVE VARIABLE AND IN THE OTHER AXIS THE MODEL#####