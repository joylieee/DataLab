# recap 02 
# linear regression with R
 library(data.table)
 library(MASS)
 library(ISLR)
 library(magrittr)
 library(knitr)
 install.packages("stargazer")
 library(stargazer)
# install.packages("ISLR")

# load data
data("Boston")
head(Boston)

# convert to data.table
Boston <- data.table(Boston)

head(Boston)

# medv = median value of owner-occupied homes in $1000s
# lstat = % lower status of the population
#       = % of people with lower status 
#         (lower status = lower class)
# age = proportion of owner-occupied units built prior to 1940

# understand the data one variable at a time
# plot the data
plot(Boston$medv) # continuous variable

# distribution of medv
hist(Boston$medv) #no typical normal distribution!

# some normality

# check lsat
plot(Boston$lstat) # continuous variable
# distribution of lstat
hist(Boston$lstat)

# log transformation # because strong tendency to one side
hist(log(Boston$lstat+1))

# put the above two plots together
options(repr.plot.width=10, repr.plot.height=5)
par(mfrow=c(1,2))
hist(Boston$lstat, main="lstat")
hist(log(Boston$lstat+1), main="log(lstat+1)")



# bivariate analysis
# medv vs lstat
options(repr.plot.width=7, repr.plot.height=5)
plot(Boston$medv, Boston$lstat)


# This is important! 
Boston %>%
    with(plot(medv, lstat))

# correlation
Boston %>%
    with(cor(medv, lstat)) # negative correlation


# age
Boston %>%
    with(plot(age))

# plot(age, medv)
options(repr.plot.width=7, repr.plot.height=5)
Boston %>%
    with(plot(age, medv))

# correlation
Boston %>%
    with(cor(age, medv)) # negative correlation (but not that strong)


# run our first regression
# medv = b0 + b1*lstat + b2*age + e

# fit the model
lr1 <- lm(medv ~ lstat + age, data=Boston)

lr1 %>% 
    stargazer(type="text")

Boston %>%
    with(plot(age, medv)) #price goes up even with old house (outliners) --> efectualize the positive correlation

# add age^2 to the model #add a quadratic term to get a down linearity
lr2 <- lm(medv ~ lstat + age + I(age^2), data=Boston)

lr2 %>% 
    stargazer(type="text")


# let's plot the model
# coefficient for age = -0.045
# coefficient for age^2 = 0.001
# simulate the model

# create a sequence of age values
age_seq <- seq(min(Boston$age), max(Boston$age), length.out=100)

# create a data.frame with age_seq
df <- data.frame(age=age_seq)
df$lstat <- mean(Boston$lstat)

# predict medv
df$medv <- predict(lr2, newdata=df)

head(df)

plot(medv ~ age, data=df)

lr3 <- lm(medv ~ age + I(age^2), data=Boston)

lr3 %>% 
    stargazer(type="text")

# plot the model
Boston %>%
    with(plot(age, medv))

# simulate the model

age_sim <- seq(0, 100, 1)
age_sim2 <- age_sim^2

# create a data frame
sim_data <- data.frame(age_sim, age_sim2)

# predict
names(sim_data) <- c("age", "I(age^2)")

pred <- predict(lr2, newdata=sim_data)

# plot the original data
plot(Boston$age, Boston$medv)
# add the predicted values
lines(age_sim, pred, col="red", lwd=2)


# the other interesting thing is that
# when we add lstat to the model
# the coefficient of age and age^2 changes
# this is called confounding
# why?
# because age and lstat are correlated
# and we are trying to explain medv
# with age and lstat
# but age and lstat are correlated
# so we cannot tell which one is the real driver

cor(Boston$age, Boston$lstat)

plot(Boston$age, Boston$lstat)

# we need to check the correlation between
# the independent variables
# this is called multicollinearity


# _____________________________________________________________________________

# import packages
# each code block is a chain of commands/thinking
{
library(data.table)
library(ggplot2)
library(knitr)
library(magrittr)
library(MASS)
}


# read in data and explore
{
data(Boston)
str(Boston)

# convert to data.table
Boston <- data.table(Boston)
str(Boston)
# what does crim mean?
# what does zn mean? 
help(Boston)
head(Boston)
}


# univariate analysis
{
# dependent variable - medv
# what is the medv?
# it is the median value of owner-occupied homes in $1000s
# histogram
hist(Boston$medv)
# boxplot
boxplot(Boston$medv)


# independent variables
# crim
hist(Boston$crim)
boxplot(Boston$crim)
}

# bivariate analysis
{
# correlation between medv and crim
cor(Boston$medv, Boston$crim)

# scatterplot between crim and medv
plot(Boston$crim, Boston$medv)

# fiter out the outliers
# subset the data
Boston %>%
    # [i, j, by] - i: row, j: column, by: group
    # & - and
    .[crim >= 5 & crim < 30] %>% 
    .[medv <= 40] %>%
    with(plot(crim, medv))
}


# bivariate analysis
{
# correlation between medv and age
cor(Boston$medv, Boston$age)

# scatterplot between age and medv
plot(Boston$age, Boston$medv)

hist(Boston$age)
}


# bivariate analysis between medv and lstat
{
plot(Boston$lstat, Boston$medv)

hist(Boston$lstat)
}

# multivariate analysis
{
head(Boston)
# give me correlation plot
library(corrplot)
# install.packages("corrplot")
corrplot(cor(Boston))
help(Boston)
}

# quantifying the relationship
{
# develop a linear regression model
# for Mr Phil Dunphy so that he can predict the price of a house
# dependent variable - medv
# independent variables - rm, lstat, age, crim
plot(Boston$rm, Boston$medv)

# fit a linear regression model
# between medv and rm
lm.fit <- lm(medv ~ rm, data = Boston)

# summary of the model
summary(lm.fit)

# give me a good table
install.packages("stargazer")
library(stargazer)
stargazer(lm.fit, type = "text")
}

# fit regression model between medv and lstat
{
lm.fit <- lm(medv ~ lstat, data = Boston)

stargazer(lm.fit, type = "text")

# fit regression model between medv and age
lm.fit <- lm(medv ~ age, data = Boston)

stargazer(lm.fit, type = "text")
}

# age and rm
{
# two graph side by side
options(repr.plot.width = 10, repr.plot.height = 5)
par(mfrow = c(1, 2))
plot(Boston$rm, Boston$medv)
plot(Boston$age, Boston$medv)
}

# fit regression model between medv and age and age^2
{
lm.fit <- lm(medv ~ age + I(age^2), data = Boston)

# print the summary
stargazer(lm.fit, type = "text")

# want to plot the fitted line
# plot the data
plot(Boston$age, Boston$medv)
# add the fitted line
abline(lm.fit)

# plot non-linear relationship
# plot the data
# plot the data side by side
options(repr.plot.width = 10, repr.plot.height = 5)
par(mfrow = c(1, 2))
plot(Boston$age, Boston$medv)
# add the fitted line 
# set the limits of the y-axis
# ylim = c(0, 60)
plot(Boston$age, predict(lm.fit),
                col = "red", ylim = c(0, 50))
}


# put everything together
# medv = lsat + age + age^2
{
lm.fit <- lm(medv ~ lstat + age + I(age^2), data = Boston)

# print the summary
stargazer(lm.fit, type = "text")
}

# _____________________________________________________________________________