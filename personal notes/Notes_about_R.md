# R Programming

- Any programming language has 3 basic components
    - Data types
    - Control structures
    - Functions

## Data Structure

- We will focus on `vector and data.table` in this practice.

    - Vector
    - Matrix
    - Array
    - List
    - Data Frame (Table)
    - Factor (Categorical Data)


### Vector

- Vector is a basic data structure in R.
- A vector is a sequence of data elements of the same basic type.
- It is a container which can hold items of __same data type__.
- To create a vector you need:
    - `c()` function
    - variable name
    - values
- what is variable name?
    - it is a name of a container which holds values.
    - it is a name of a memory location.


### Copilot Tips

- there is a new concept called `prompt` in AI Programming.
- There is also a concept called `Chain-of-Thought` in AI Programming.  
- The idea is that you can write a code with the help of AI.
    - only if human being can understand your instructions too
    - only if your design a `good prompt`

#### Good Prompt
- A good prompt is a prompt that can be understood by human being.
- A good prompt is a prompt that can be understood by AI.
- Examples
    - `# first colomn is a sequence of numbers from 1 to 20` --> good
    - `# third column is sample drawn from ['female', 'male']` --> bad

#### Bad Prompt

The following prompt is not a good prompt because it is not clear what is the data type of the third column. It is not understandable by human being. Therefore, AI gives an error.

```r
# create a data.table for me with 20 rows and 4 columns
# first column is a sequence of numbers from 1 to 20
# second column is a sample drawn from a normal 
#distribution with mean 0 and sd 1
# third column drawn from ['female', 'male']
```

## Why data.table?

- data.table is a package for big data.
- Benchmarking
--> very fast!
- it is just data.frame with more features
- data. frame is a basic data structure in R

_____________________________


# Set up R working environment

```bash
# update first 
sudo apt-get update
sudo apt-get install r-base
```

How to install packages in R?

- data.table
- ggplot2
- dplyr
- magrittr
- knitr

```r
install.packages("data.table")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("magrittr")
install.packages("knitr")
```

library(data.table) 
library(ggplot2)
library(dplyr)
library(knitr)
library(magrittr)

## Install R kernel for Jupyter notebook

```bash
# install jupyter notebook
sudo apt-get install jupyter-notebook
```

```r
# install R kernel for jupyter notebook
install.packages('IRkernel')
IRkernel::installspec()
```

Test (Shift+ Enter in R. Datei):
print("Hello World!") 
_____________________________

# Playing aroung with R

Show me the code in R to simulate a normal distribution with mean 0 and standard deviation 1

```{r}
rnorm(100, mean = 0, sd = 1)
```

_

```R
# R code
x <- 1:10
y <- 2*x + 3 + rnorm(10)
plot(x, y)
```	

