## middle

## plot normal distribution
# i have collected 1000 restaurant data
# mean is 60 and sd is 10
# plot the normal distribution

# generate 1000 random numbers
# mean is 60 and sd is 10

set.seed(123)   
x <- rnorm(1000, mean = 60, sd = 10)

# plot the normal distribution
hist(x, freq = FALSE, main = "Normal Distribution", xlab = "Restaurant Data", ylab = "Density") 

# add a line of normal distribution
curve(dnorm(x, mean = 60, sd = 10), add = TRUE, col = "red", lwd = 2)

## right

## plot the poisson distribution 
# parameter lambda is 60
# plot the poisson distribution

# generate 1000 random numbers
# parameter lambda is 60

set.seed(123)
x <- rpois(1000, lambda = 60)

# plot the poisson distribution with plot function
plot(table(x), type = "h", main = "Poisson Distribution", xlab = "Restaurant Data", ylab = "Density")

