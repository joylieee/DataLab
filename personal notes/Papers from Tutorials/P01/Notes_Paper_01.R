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

