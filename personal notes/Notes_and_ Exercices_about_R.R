# Playing aroung with R on Jupiter notebook

#  ------------------ Vector ------------------
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
y <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

print(x)
print(y)

z = c(0.35, 12.239, -129.0)
print(z)

x1 <- c("hello", "world", "!")
print (x1) # nolint

hel <- c("hell", "A", "B", "C")
print(hel)

# ------------------ Matrix ------------------
# create a matrix for me with 5 rows and 4 columns  # nolint
# name it my_matrix
# fill it with numbers from 1 to 20
# print it

my_matrix <- matrix(1:20, nrow = 5, ncol = 4)
print(my_matrix)


# ------------------ Data Frame ------------------
# create a data frame for me with 5 rows and 4 columns
# name it my_df
# fill it with numbers from 1 to 20
# print it

my_df <- data.frame(matrix(1:20, nrow = 5, ncol = 4))
print(my_df)

# ------------------ data.table ------------------
# create a data.table for me with 20 rows and 4 columns
# first column is a sequence of numbers from 1 to 20
# second column is a sample drawn from a normal 
# distribution with mean 0 and sd 1
# third column should be filled with two values: "1" and
# "0" in a random fashion
# fourth column should be filled with 20 random 
# characters from the alphabet
# name it my_dt

my_dt <- data.table(
  x = 1:20,
  y = rnorm(20, mean = 0, sd = 1),
  z = sample(c(0, 1), 20, replace = TRUE),
  w = sample(letters, 20, replace = TRUE)
)
print(my_dt)

str(my_dt)

my_dt2 <- data.table(
  'cl' = 1:20,
  'nl' = rnorm(20, mean = 0, sd = 1),
  'binary_col' = sample(c(0, 1), 20, replace = TRUE),
  'letter' = sample(letters, 20, replace = TRUE)
)
print(my_dt)

str(my_dt2)
head(my_dt2)

# create a dataframe like my_dt2
# name it my_df2
# print it

my_df2 <- data.frame(
  'cl' = 1:20,
  'nl' = rnorm(20, mean = 0, sd = 1),
  'binary_col' = sample(c(0, 1), 20, replace = TRUE),
  'letter' = sample(letters, 20, replace = TRUE)
)
print(my_df2)

# _________________________________________________________________________

# generate 100 random numbers for x and y 
# plot it with basic R plot function

x <- rnorm(100)
y <- rnorm(100)

plot(x, y)

# run regression y on x and print the summary
reg <- lm(y ~ x)
summary(reg)


# use data.table create a 3 rows and 2 columns data table

my_data <- data.table(x = 1:3, y = 4:6) 
# with different name you don't put in dt but the other name like my_data

str(my_data)
head(my_data) 
summarize(my_data)

# create a data.table with 3 colomns and 10 rows
# one column is a sequence of numbers
# one column is hello repeated 10 times
# third column is drawn from a normal distribution 

my_data <- data.table(
    x = 1:10, 
    y = rep("hello", 10), 
    z = rnorm(10)
    )

str(my_data)
head(my_data)

# create a vector with 5 elements all 'female'

xfm <- rep("female", 5)

#  create another one filled with 'male'

xml <- rep("male", 5)

# combine the two vectors into a single vector

gender <- c(xfm, xml)

# add gender to my_data
my_data$gender <- gender

str(my_data)
head(my_data)

# select y column
my_data$y

# filter out z>0
my_data %>% 
    .[z>0] %>%
    # filter out gender female
    . [gender == "female"] %>%
    kable()

# select z and gender columns
my_data %>%
    .[, .(z, gender)] %>% 
    .[z>0, ] %>%
    kable()


# ______________________________________________________________________


# Data importieren

# read the data into a data frame and call it my_data
my_data <- fread("./demo/survey_responses.csv")
head(my_data)

# change all columns names into q1, q2, q3 etc
colnames(my_data) <- paste0("q", 1:ncol(my_data)) # nolint
head(my_data)


#______________________________________________________________________


# Tabellen erstellen wie auf dem Blatt (auch durch Import)

# read the dataset
csv_url <- "https://shorturl.at/bclM4"
install.packages('curl')
survey <- fread(csv_url)

# check the data
str(survey)
head(survey)
summary(survey)


# ______________________________________________________________________

# read in the data
# data is from our class
url <- "https://shorturl.at/eixVX"
survey <- fread(url)

# check the data

str(survey)
head(survey)

# change variable names in the format of "q1", "q2",
# starting from the second column

# get the column names
colnames(survey)

# change the column names starting from the second column
colnames(survey)[2:ncol(survey)] <- paste0("q", 1:(ncol(survey)-1))

# check the data
head(survey)

### --- Univariate Analysis --- ###
# q1 is about have you ever studied Regression before

# how many people have studied Regression before
table(survey$q1)

# barplot

# make a barplot of q1
barplot(table(survey$q1))

# make a pie chart 
pie(table(survey$q1))

# make a better pie chart
pie(table(survey$q1), labels = c("No", "Yes"), main = "Have you studied Regression before?")

# make a bar plot with ggplo2
# install.packages("ggplot2")

library(ggplot2)

library(ggplot2)

# make a bar plot with ggplot2

ggplot(survey, aes(x = q1)) + geom_bar() + labs(x = "Have you studied Regression before?")  + theme_bw()    

str(survey)

# analyze q5
# q5 is about how many hours you spend on studying per week

# variable of q5 is character
# use this information to analyze q5

# how many people spend 0 hours on studying per week

table(survey$q5)

# extract number of hours from q5

# get the first character of q5
substr(survey$q5, 1, 1)

# get the second character of q5
substr(survey$q5, 2, 2)

# get the third character of q5
substr(survey$q5, 3, 3)

# how many people spend 0 hours on studying per week
# extract any character that is before "hour" or "hours"
# use gsub() function

table(gsub("[^0-9]", "", survey$q5))

# install the package that has %>%
install.packages("magrittr")
library(magrittr)

# use %>%

table(gsub("[^0-9]", "", survey$q5)) %>% 
    mean()

str(survey)

# practice [i, j, by] logic of data.table

# i: subset the data
# j: select the columns
# by: group by

# select q1 as a column out of survey
survey[, q1]

survey%>%
    .[, .(q1)]

str(survey)

# select q1 and q2 as columns out of survey
survey[, .(q1, q2)]

survey[, .(q1, q2)] %>% 
    # give me a table of q1 and q2
    table()
    # visualize the table with mosaic plot with basic R plot
    mosaicplot(table(survey[, .(q1, q2)]))

str(survey)

# select all columns that type is character
# convert them to lower case

survey %>%
   .[, lapply(.SD, tolower), .SDcols = sapply(survey, is.character)] %>%
    str(survey)


#______________________________________________________________________

### library dataset from MASS package
# install.packages("MASS")
library(MASS)

# check the dataset
?Boston    #text editor shows what the names mean
names(Boston)

# medv is the median value of owner-occupied homes in $1000s
# plot the histogram of medv
hist(Boston$medv, main = "Median Value of Owner-Occupied Homes", xlab = "Median Value of Owner-Occupied Homes in $1000s", ylab = "Frequency")


# check lstat
# lstat is the lower status of the population
# plot the histogram of lstat
hist(Boston$lstat, main = "Lower Status of the Population", xlab = "Lower Status of the Population", ylab = "Frequency") 
# result: 40% poor

# bivariate analysis
# medv vs. lstat
# correlation between medv and lstat
cor(Boston$medv, Boston$lstat) 
# result: is negative

# plot medv as y and lstat as x
plot(Boston$lstat, Boston$medv, main = "Median Value of Owner-Occupied Homes vs. Lower Status of the Population", xlab = "Lower Status of the Population", ylab = "Median Value of Owner-Occupied Homes in $1000s") 
# result: the higher the number of poor people, the lower the median value of owner-occupied homes


### --- multivariate analysis --- ###

# what kind of factors affect medv?
# first run a linear regression model
# medv ~ lstat

# fit a linear regression model
fit <- lm(medv ~ lstat, data = Boston)

# check the summary of the model
summary(fit)

# print out a better summary of the model
install.packages("stargazer")
library(stargazer)
stargazer(fit, type = "text")

# run another regression model
# medv ~ lstat + age    
fit2 <- lm(medv ~ lstat + age, data = Boston)
summary(fit2)
stargazer(fit2, type = "text")

# plot medv vs. age
plot(Boston$age, Boston$medv, main = "Median Value of Owner-Occupied Homes vs. Age", xlab = "Age", ylab = "Median Value of Owner-Occupied Homes in $1000s")

# by checking the figure I notice that
# medv increases when age is less than 50
# medv decreases when age is greater than 50

# run another regression model
fit3 <- lm(medv ~ lstat + age + rm, data = Boston)
summary(fit3)
stargazer(fit3, type = "text")
# result: the higher the age and the lower the number of rooms, the lower the median value of owner-occupied homes

# plot the relationship y = 10 * 0.3 * x + 0.1 * x^2
x <- seq(-10, 10, by = 0.1)
y <- 10 + 0.3 * x - 0.1 * x^2
plot(x, y, type = "l", main = "y = 10 + 0.3 * x - 0.1 * x^2", xlab = "x", ylab = "y")

