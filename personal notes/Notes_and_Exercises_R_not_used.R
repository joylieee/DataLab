# _____________________________________________________________

# read data

file_path <- "../data/innovation_survey/extmidp21.csv"
survey <- fread(file_path)

str(survey)

# univariate analysis
# bges18 , bges
# average number of employees

survey %>%
    #[i, j, by]
    .[, c('bges18', 'bges')] %>%
    #[i, j, by]
    # sample, sample rows
    #.N : number of rows, 5083 rows
    .[sample(.N, 5)] %>%
    kable()



survey %>%
    #[i, j, by]
    .[, c('bges')] %>%
    # get the summary of the data
    summary() %>%
    kable()

survey %>%
    # do something with the data
    #[i, j, by]
    .[, c('bges')] %>% 
    # transform the data with log
    log() %>%
    # plot the histogram
    # for continuous variables
    # with: with the data
    with(hist(bges, breaks = 10))
    # histogram is very skewed
    # we could use log transformation
    # to make it more normal


# another variable
names(survey)

# pzlv
# Logistical procedures, delivery/distribution methods.
survey %>%
    .[, c('pzlv')] %>%
    # give me the table of categorical variables
    # but showing share of each category
    with(table(pzlv)) %>%
    prop.table() %>%
    kable()


# Bivariate analysis
# pzlv - bges
# firms who introduced innovation
# in logistics/distribution
# having more employees or less employees
# or same number of employees
# maybe only big firms can afford to introduce
# innovation in logistics/distribution

survey %>%
    # [i, select columns, by]
    .[, c('pzlv', 'bges')] %>%
    # bges is continuous
    # pzlv is categorical
    # we want to see the average number of employees
    # for each category of pzlv
    # filter out missing values
    #[i-filter, j-select, by-group]
    .[pzlv != ''] %>%
    # [i, j, by a group (categorical variable)]
    .[, mean(bges), by = pzlv]

# compare distribution of bges
# for firms who introduced innovation
# in logistics/distribution

survey %>%
    .[, c('pzlv', 'bges')] %>%
    .[pzlv != ''] %>% 
    #[i-column filter, j-operation columns, by]
    .[, as.list(summary(bges)), by = pzlv] %>%
    kable()

# do boxplot for bges
# for each category of pzlv
# boxplot is a good way to compare distributions

options(repr.plot.width = 8, repr.plot.height = 6)
survey %>%
    .[, c('pzlv', 'bges')] %>%
    .[pzlv != ''] %>%
    # [i, j, by] 
    .[bges <= 600] %>%
    # boxplot with basic r function
    boxplot(bges ~ pzlv, data = .)


# compare histograms of bges for each category of pzlv
# histogram is a good way to compare distributions

options(repr.plot.width = 8, repr.plot.height = 6)
survey %>%
    .[, c('pzlv', 'bges')] %>%
    .[pzlv != ''] %>%
    # histogram with ggplot2
    # histogram with ggplot2
    ggplot(aes(x = log(bges))) +
    geom_histogram(bins = 30, alpha = 0.5) + 
    facet_wrap(~ pzlv, ncol = 2) 
    # add 


options(repr.plot.width = 8, repr.plot.height = 6)
survey %>%
    .[, c('pzlv', 'bges')] %>%
    .[pzlv != ''] %>%
    # histogram with ggplot2
    # histogram with ggplot2
    ggplot(aes(x = log(bges))) +
    geom_histogram(aes(y = ..density..), ybins = 30, alpha = 0.5) + 
    facet_wrap(~ pzlv, ncol = 2) 
    # add 




# log transformation always plus 1 
# to avoid log(0) = -Inf
x <- seq(0, 6, length = 1000)
survey %>%
    .[, c('pzlv', 'bges')] %>%
    .[pzlv != ''] %>%
    with(hist(log(1+survey$bges), breaks = 30, freq = FALSE,
                main = "Density of bges for all firms"))

curve(dnorm(x, mean = mean(log(1+survey$bges)), sd = sd(log(1+survey$bges))), 
      add = TRUE, col = "red", lwd = 2)

# plot the histogram of bges for each category of pzlv
# with density
# with log transformation

options(repr.plot.width = 8, repr.plot.height = 6)
survey %>%
    .[, c('pzlv', 'bges')] %>%
    .[pzlv != ''] %>%
    # histogram with ggplot2
    # histogram with ggplot2
    ggplot(aes(x = log(1+bges))) +
    geom_histogram(aes(y = ..density..), ybins = 30, alpha = 0.5) + 
    facet_wrap(~ pzlv, ncol = 2) +
    geom_density(alpha = 0.5) +
    geom_vline(aes(xintercept = mean(log(1+bges)), color = pzlv), 
               linetype = "dashed", size = 1) +
    scale_color_manual(values = c("red", "blue", "green", "orange", "purple")) +
    theme(legend.position = "none")


# _____________________________________________________________

# sweet data.table best practices
library(data.table)
library(magrittr)
library(dplyr)
library(knitr)
library(ggplot2)


######----------------- read and clean the data  -----------------######

# read the dataset
csv_url <- "https://shorturl.at/eixVX"
survey <- fread(csv_url)

# check the data
str(survey)
head(survey)
summary(survey)

# change names
survey %>%
    setnames("Timestamp", "timestamp") %>%
    str()

# change names from second column to the last column
survey %>%
    setnames(2:ncol(survey), paste0("q", 1:(ncol(survey) - 1))) %>%
    str()

# check NA values
sapply(survey, function(x) sum(is.na(x))) %>% kable()

# convert the data type of the first column to date and time
survey %>%
    .[, timestamp := as.POSIXct(timestamp, format = "%m/%d/%Y %H:%M:%S")] %>%
    str()

# create a new column called year
survey %>%
    .[, year := format(timestamp, "%Y")] %>%
    str()


# advanced one
# select columns that start with "q" and the data
# type of the columns are character
# query column names first 
survey %>%
    .[, .SD, .SDcols = patterns("^q")] %>%
    .[, .SD, .SDcols = is.character] %>%
    names() -> select_col_names

select_col_names

# convert string of selected columns to lower case
survey %>%
    .[, (select_col_names) := lapply(.SD, tolower),
       .SDcols = select_col_names] 

str(survey)

# save the data set
fwrite(survey, "survey_cleaned.csv")


######----------------- check duplicates and NAs -----------------######
# duplicates and NAs are tricky
# you need to check them carefully
# to check duplicates, you need to set up a criteria
# for instance q1 has two answers: yes and no
# many people might answer yes but this does not mean
# they are duplicates
str(survey)

# in our case, we can use the timestamp as the criteria
# to check duplicates

# check how many duplicates
survey %>%
    .[, .N, by = timestamp] %>%
    .[N > 1] %>%
    kable()

# check the duplicates
survey %>%
    .[timestamp == "2023-04-20 23:44:06"] %>%
    kable()

# another way to check duplicates (the best way)
survey %>%
    .[duplicated(timestamp) | duplicated(timestamp, fromLast = TRUE)] %>%
    kable()

# get unique values
survey %>%
    .[!duplicated(timestamp)] %>%
    str()

# or use unique function (the best way)
# when you use unique function, you need put by = "variable_name"
# as unique function is basic R function, whereas 
# duplicated function is data.table function
# which means you can pass variable name to duplicated function
# directly without putting quotation marks
survey %>%
    unique(by = "timestamp") %>%
    str()

# save the data set
survey %>%
    unique(by = "timestamp") %>%
    fwrite("survey_cleaned_unique.csv")


######----------------- univariate analysis -----------------######

# read the data set
survey <- fread("./data/survey_cleaned_unique.csv")

# q1: have you ever learned regression analysis before?
# q1 answer: yes, no
# it is a categorical variable
# for categorical variables, we can do following analysis:
# 1. frequency table with count or percentage
# 2. bar plot or pie chart

# frequency table with count
survey %>%
    .[, .N, by = q1] %>%
    kable()  # a function to print out the table

# frequency table with percentage
survey %>%
    .[, .N, by = q1] %>%
    .[, percent := N / sum(N) * 100] %>%
    kable(align = "c", digits = 2)

# use basic R function to get the frequency table
survey %>%
    with(table(q1)) %>%
    kable()

# using prop.table function to get the percentage
survey %>%
    with(table(q1)) %>%
    prop.table() %>%
    kable()


# plot the bar chart with table function and barplot function
# set the width and height of the plot
options(repr.plot.width = 8, repr.plot.height = 5)
survey %>%
    with(table(q1)) %>%
    barplot(main = "Did you study the regression analysis before?",
            xlab = "Answer",
            ylab = "Count",
            col = "lightblue")

# plot the pie chart with table function and pie function based on percentage
# add the percentage to the pie chart
# following code was inspired by ChatGPT, which is amazing!
# it uses rainbow color to distinguish the pie chart
# this is new to me, I will try it next time
# it also uses prob.table with a dot, which is brilliant!
survey %>%
    with(table(q1)) %>%
    pie(main = "Did you study the regression analysis before?",
        col = c("lightblue", "lightgreen"),
        labels = paste0(round(prop.table(.) * 100), "%"))

# sometimes you might need ggplot
# ggplot is a powerful package to plot the data
survey %>%
    with(table(q1)) %>%
    data.frame() %>%
    ggplot(aes(x = q1, y = Freq)) +
    geom_bar(stat = "identity", fill = "#2598bf") +
    geom_text(aes(label = Freq),
              vjust = -0.5, size = 4) +
    labs(title = "Did you study the regression analysis before?",
         x = "Answer",
         y = "Count") +
    theme_bw()

# I only use ggplot when I need to plot multiple variables
# against one variable by using facet_wrap
# or any other special plot that is not supported by base R

######----------------- Binomial Distribution -----------------######
# in question 1, we have the following probability table
survey %>%
    with(table(q1)) %>%
    prop.table() %>%
    kable()

# this means the probability of getting yes is 0.708
# the probability of getting no is 0.292
# NOW, assuming our survey data is a sample of the population
# and also representing the population
# we can use binomial distribution to calculate the probability
# of getting yes or no in the population

# binomial distribution with n = 1000
# p = 0.708
# q = 0.292
# rbinom function is used to generate random numbers
# from binomial distribution
# rbinom(1, 10, 0.5) ==  sum(rbionom(10, 1, 0.5))

rbinom(1000, 1, 0.708) %>%
    table() %>%
    prop.table() %>%
    kable()

# the above code simulate 1000 times with p = 0.708
# the simulation is to imitate our survey
# but we need to do inference to the population


# NOW, we are interested the probability of having 60
# or more yes in the population if we have 100 people?
# our parameter of interest is p = 0.708
# our inference is based on the binomial distribution
# we need to use the binomial distribution to calculate
# the probability of getting 60 or more yes in the population
# if we have 100 people
pbinom(59, 100, 0.708, lower.tail = FALSE)

# plot the binomial probability density function
# and cumulative distribution function
# using type = "h" to indicate it is discrete 
options(repr.plot.width = 9, repr.plot.height = 5)
n = 100
p = 0.708
x = 0:100
y = dbinom(x, n, p)
y_cum = pbinom(x, n, p)
par(mfrow = c(1, 2))
plot(x, y, type = "h", lwd = 2,
        xlab = "Number of Yes", ylab = "Probability",
        main = "Probability Density Function")
plot(x, y_cum, type = "h", lwd = 2,
        xlab = "Number of Yes", ylab = "Probability",
        main = "cumulative Distribution Function")


# simulate the Poisson distribution
# and plot the probability density function
# and cumulative distribution function
# with restaurant example
# lambda = 10
options(repr.plot.width = 9, repr.plot.height = 5)
lambda = 10
x = 0:30
y = dpois(x, lambda)
y_cum = ppois(x, lambda)
par(mfrow = c(1, 2))
plot(x, y, type = "h", lwd = 2,
        xlab = "Number of Customers", ylab = "Probability",
        main = "Probability Density Function")
plot(x, y_cum, type = "h", lwd = 2,
        xlab = "Number of Customers", ylab = "Probability",
        main = "cumulative Distribution Function")

# plot gaussian distribution with different mean and sd
means = c(0, -2, 2)
sds = c(1, 2, 3)
x = seq(-10, 10, length.out = 100)
dfy = data.frame(x = x)
for (i in 1:length(means)) { # nolint: seq_linter.
    dfy[, paste0("mean", i)] = dnorm(x, means[i], sds[i])
}
# plot the probability density function with basic R
# with different mean and sd and different color
options(repr.plot.width = 8, repr.plot.height = 5)
plot(x, dfy[, "mean1"], type = "l", lwd = 2,
        xlab = "x", ylab = "Probability",
        main = "Probability Density Function")
lines(x, dfy[, "mean2"], lwd = 2, col = "red")
lines(x, dfy[, "mean3"], lwd = 2, col = "green")
# add legend with mean and sd with different color
legend("topright", legend = paste0("mean=", means, ", sd=", sds),
        lty = 1, lwd = 2, col = c("black", "red", "green"))


######----------------- multivariate analysis -----------------######

# read the dataset
survey <- fread("./data/survey_cleaned_unique.csv")

# now, let's do some multivariate analysis
str(survey)

# multivariate analysis is to find the relationship between
# multiple variables

# let's start with two variables
# for two variables, we have the following possibilities
# 1. categorical vs categorical
# 2. categorical vs continuous
# 3. continuous vs continuous

# NOW, let's focus on categorical vs categorical
# q1 vs q2
# q1: have you studied regression analysis before?
# q2: what kind of language do you use for data analysis?

survey %>%
    with(table(q1, q2)) %>%
    kable()

# how could we visualize the above table?
# we can use mosaicplot
# mosaicplot is a powerful package to visualize the relationship
# between multiple variables
options(repr.plot.width = 8, repr.plot.height = 6)
mosaicplot(q2 ~ q1, data = survey, color = TRUE, shade = TRUE,
            main = "What kind of language do you use for data analysis?",
            xlab = "Answer",
            ylab = "Did you study the regression analysis before?")


# you can see that data visualization could tell us a lot
# about the relationship between multiple variables
# for cases with more than 2 categorical variables
# you need to use ggplot to visualize the relationship
# we will not cover this in this course

# since our survey does not have continuous variables
# we will simulate some data to show the relationship
# by adding three variables:
# gender dummy - female 1 / male 0 
# weight - continuous
# height - continuous

females <- rep("female", 100)
males <- rep("male", 100)

# combine the above two vectors into one vector
c(females, males) %>%
    sample(nrow(survey)) -> survey$gender

str(survey)

# create dummy variable from gender
survey %>%
    .[, gender_dummy := ifelse(gender == "female", 1, 0)] %>%
    str()

# check balance of gender
survey %>%
    with(table(gender))

# generate random weight and height
# weight is normally distributed with mean 60 and sd 5 
# height is normally distributed with mean 170 and sd 5 for female
# height is normally distributed with mean 175 and sd 6 for male
# set.seed(123)
set.seed(123)
survey %>%
    .[, weight := rnorm(nrow(.), 60, 10)] %>%
    .[, height := ifelse(gender_dummy,
                            rnorm(nrow(.), 170, 5),
                            rnorm(nrow(.), 175, 6))] %>%
    str()


# now, let's do some multivariate analysis
# with one categorical and one continuous variable
# two continuous variables

# let's start with categorical vs continuous
# gender vs weight
# we can use boxplot to visualize the relationship
# boxplot is a powerful package to visualize the relationship
# between one categorical and one continuous variable
# plot boxplot with basic R against gender and weight
options(repr.plot.width = 8, repr.plot.height = 6)
survey %>%
    with(boxplot(weight ~ gender))

survey %>%
    with(boxplot(height ~ gender))

# check histogram
survey %>%
    with(hist(weight))

# plot histogram with ggplot by filling with gender
survey %>%
    ggplot(aes(x = weight, fill = gender)) +
    geom_histogram(binwidth = 2, alpha = 0.7) +
    theme_bw()

survey %>%
    ggplot(aes(x = height, fill = gender)) +
    geom_histogram(binwidth = 2, alpha = 0.7) +
    theme_bw()

# two continuous variables
# weight vs height
survey %>%
    with(plot(weight, height))

survey %>%
    with(cor(weight, height))

# this is not aligned with our intuition
# as we know that weight and height are positively correlated

######----------------- Linear Regression -----------------######
# linear regression is a powerful tool to find the relationship
# multiple variables
# as we can see using correlation or boxplot or histogram
# over different categories
# can only tell us the relationship between two variables
# how about the relationship between multiple variables?
# we can use linear regression to find the relationship

# we will learn linear regression via simulation
# please read the notes for more details
# we will simulate 300 observations
# sample size for one group is 300
set.seed(789)
sample_size = 300
height_female <- rnorm(n = sample_size, mean = 167, sd = 2.3)
height_male <- rnorm(n = sample_size, mean = 173, sd = 3.2)
female <- rep("female", sample_size)
male <- rep("male", sample_size)

# create a data.table
sdt <- data.table(
    height = c(height_female, height_male),
    gender = c(female, male)
)

str(sdt)

# add weight
sdt %>%
    .[, weight1 := 16 + 0.32 * height + rnorm(nrow(.), 0, 2)] %>%
    .[, weight2 := ifelse(
                            gender == "female",
                            16 + 0.32 * height + rnorm(nrow(.), 0, 2),
                            16 - 0.17 * height + rnorm(nrow(.), 0, 2.5)
                        )] %>%
    str()

# choose 300 observations randomly
sdt %>%
    sample_n(300) -> simulated_data

str(simulated_data)

# plot the relationship between height and weight
simulated_data %>%
    with(plot(height, weight1))

simulated_data %>%
    with(plot(height, weight2))


# now let's run our first linear regression
# we will use lm() function
lm(weight1 ~ height, data = simulated_data) %>% summary()

simulated_data %>%
    with(plot(height, weight1))
abline(lm(weight1 ~ height, data = simulated_data), col = "red")

# with gender as a dummy variable
lm(weight1 ~ height + gender, data = simulated_data) %>% summary()

lm(weight2 ~ height, data = simulated_data) %>% summary()

simulated_data %>%
    with(plot(height, weight2))
abline(lm(weight2 ~ height, data = simulated_data), col = "red")

lm(weight2 ~ height + gender, data = simulated_data) %>% summary()


simulated_data %>%
    .[gender == "male"] %>%
    with(lm(weight2 ~ height)) %>% summary()

#_______________________________________________________________
# R script to calculate entropy of a given sequence
# install the data.table package
# install.packages("data.table")
library(data.table)

# create a data.table with one variable and 10 observations
# variable is a vector of 'hello' strings
hello <- data.table(hello = rep("hello", 10))
hello

# add another variable to the data.table, filled with integer 1
hello[, hello_int := 1]
hello

# create a new variable that calculates the cumulative sum of hello_int
hello[, hello_cumsum := cumsum(hello_int)]
hello

# create a new variable that divides hello_int by the number of observations
hello[, hello_prob := (hello_int / nrow(hello))]
hello

# Big Lesson 1: never use the same name for a variable as the name of a
# data.table

# re-create a data.table with one variable and 10 observations
# variable is a vector of 'hello' strings called dt_demo
dt_demo <- data.table(hello = rep("hello", 10))
dt_demo

# Exercise: repeat what we have done on the dt_demo data.table


entropy_example <- fread("https://docs.google.com/spreadsheets/d/1Ral3hG1AHCuiaWYtB3taCSKuWl_j1_A0aKOTb_uh43E/edit?usp=sharing")
entropy_example

entropy_fun <- function(x) {
    # x is the probability of each unique value in the vector
    return(-x * log2(x))
}
entropy_names <- entropy_example[, paste(names(.SD), "_entropy", sep = ""),
                                                .SDcols = patterns("prob")]

entropy_example[, (entropy_names) := lapply(.SD, function(x) entropy_fun(x)),
                                                .SDcols = patterns("prob")]
# cumulative entropy
entropy_example[, lapply(.SD, cumsum), .SDcols = patterns("entropy")] 

options(repr.plot.width = 8, repr.plot.height = 5)
plot(entropy_example$prob1_entropy, type = "l", col = "red", ylim = c(0, 1))
lines(entropy_example$prob2_entropy, col = "blue", ylim = c(0, 1))
lines(entropy_example$prob3_entropy, col = "#0F7F12", ylim = c(0, 1))
legend("topright", legend = c("prob1_entropy", "prob2_entropy", "prob3_entropy"),
       col = c("red", "blue", "#0F7F12"), lty = 1, cex = 0.8)


### ------------- experiment with ChatGPT ------------------ ###

# Take away:
# for small examples, excel works way better !
# you do not need any coding if you only have less than 100 observations


# create a table with 6 variables and 10 observations
# first variable is a vector of all 'hello' strings
# second variable is a vector of all 1 integers
# third variable is based on the first variable but replace one 
# observation with 'world'
# four variable is a vector of integers using 1 to represent 'hello'
# and 2 to represent 'world'
# fifth variable is a vector of 'tomorrow' 'will' 'be' 'a' 'great'
# day' strings, with 'hello' filled in for other observations
# sixth variable is a vector of integers using 1 to represent 'hello' and
# 2, 3, 4, 5, 6, 7, 8, 9, 10 to represent 'tomorrow', 'will', 'be', 'a',
# 'great', 'day'

entropy_example <- data.table(
    hello = rep("hello", 10),
    hello_int = rep(1, 10),
    hello_world = c('hello', 'world', rep('hello', 8)),
    hello_int2 = c(1, 2, rep(1, 8)),
    hello_world2 = c('hello', 'tomorrow', 'will', 'be', 'a', 'great',
                     'day', 'hello', 'hello', 'hello'),
    hello_int3 = c(1, 2, 3, 4, 5, 6, 7, 1, 1, 1)
)

str(entropy_example)
summary(entropy_example)
head(entropy_example)

# write a function to calculate entropy of a given vector
entropy <- function(x) {
    # calculate the probability of each unique value in the vector
    prob <- table(x) / length(x)
    # calculate the entropy
    entropy <- -sum(prob * log2(prob))
    # return the entropy
    return(entropy)
}

# test the function on the second variable
entropy(entropy_example$hello_int)
# test the function on the fourth variable
entropy(entropy_example$hello_int2)
# test the function on the sixth variable
entropy(entropy_example$hello_int3)


# create a vector called hello_int_prob that contains the probability of
# each unique value in the second variable
# add in to the entropy_example data.table
entropy_example[, hello_int_prob := table(hello_int) / nrow(entropy_example)]

# the above code does not work because the table function does not
# recognize the hello_int variable as a factor
# give me a hint
entropy_example[, hello_int := as.factor(hello_int)]
entropy_example[, hello_int_prob := table(hello_int) / nrow(entropy_example)]
entropy_example

# it still does not work because the table function returns a table 
# object, not a vector
# give me a hint
entropy_example[, hello_int_prob := as.vector(table(hello_int) / nrow(entropy_example))]

# table is a wrong choice of function
# use prop.table instead
entropy_example[, hello_int_prob := prop.table(hello_int)]
entropy_example

# add similar variables like hello_int_prob for the other variables
# such as hello_int2_prob, hello_int3_prob
entropy_example[, hello_int2_prob := prop.table(hello_int2)]
entropy_example[, hello_int3_prob := prop.table(hello_int3)]
entropy_example


# check whether sums of the probabilities are 1 for variables with names
# containing 'prob'
entropy_example[, lapply(.SD, sum), .SDcols = grepl('prob', names(.SD))]

# the above examples shows the limitations of ChatGPT

# the following code was searched on the internet
# based on human beings' understanding of the problem
entropy_example[, lapply(.SD, sum), .SDcols = patterns("prob")]

# the sum of the probabilities equal to 1, which is correct
entropy_example

# now we will calculate the entropy of the variables
# that contain 'prob' in their names
entropy_example[, lapply(.SD, entropy), .SDcols = grepl('prob', names(.SD))]



entropy_example
# create multiple variables to represent the probabilities of each unique
# value for variables with names containing 'int'
entropy_example[, lapply(.SD, function(x) prop.table(x)), .SDcols = patterns("int")]

entropy_example[, lapply(.SD, function(x) prop.table(x)),
                                    .SDcols = patterns("int")]

# assign those columns in place of the original columns
# the following code gives probabilties of each unique value for
# the whole talbe in .sd
# entropy_example[, prop.table(.SD), .SDcols = patterns("int")]

# a fast way to create new column names  based on the old column names

col_names_prob <- entropy_example[, paste(names(.SD), "_prob", sep=""),
                                    .SDcols = patterns("int")]
entropy_example[, (col_names_prob) := lapply(.SD, function(x) prop.table(x)),
                    .SDcols = patterns("int")]
entropy_example


# create a new variable that calculates the entropy of the probabilities
# of each unique value for variables with names containing 'prob'
entropy_prob <- function(x) {
    # x as probabilities
    return(-x * log2(x))
}
entropy_names_entropy <- entropy_example[, paste(names(.SD), "_entropy", sep=""),
                                    .SDcols = patterns("prob")]
entropy_example[, (entropy_names_entropy) := lapply(.SD, function(x) entropy_prob(x)),
                    .SDcols = patterns("prob")]
entropy_example