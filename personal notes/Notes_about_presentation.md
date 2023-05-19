---
marp: true
theme: default

---

# Marp for VS Code

- Markdown Presentation Ecosystem
- https://marp.app/

give me a emoji to show how amazing this is! :tada:
give me an emoji to dance with me! :dancer:

give me a big emoji llike panda :panda_face:

---
# Images in Marp

![bg right:40% 80%](https://www.wallpaperup.com/uploads/wallpapers/2014/06/05/364485/7a7bab94251a5afd39ea35b3611a2e2e.jpg)

---

# Code in Marp

```R
# R code
x <- 1:10
y <- x + rnorm(10)
lm(y ~ x)
```
---
# Install packages in Codespace

- First we need to open the terminal


---
# Summary
- what is markdown
- what is terminal

![bg right:60% 80%](../images/terminal_instruction.png)

- Once you open the terminal, you type:
    
    ```bash
    R
    ```
- After this step you install packages as you normally do in RStudio

```R
install.packages("languageserver")
install.packages("tidyverse")
...
```

---
# Celebrate
![bg right:60% 80%](https://media.giphy.com/media/3o7TKMt1VVNkHV2PaE/giphy.gif)


_____________________________

NEXT PRESENTATION

---
marp: true
theme: uncover
header: 'Practice #1: Introduction to R with AI'
paginate: true


---
# Practice #1: Introduction to R Programming with AI
- Basic R Programming
- data.table package
    - 1Gb to 100Gb
- R with AI
- Data exploration with R

---
# R Programming

- Any programming language has 3 basic components
    - Data types
    - Control structures
    - Functions

---

# Data Structure

- We will focus on `vector and data.table` in this practice.

    - Vector
    - Matrix
    - Array
    - List
    - Data Frame (Table)
    - Factor (Categorical Data)

---

## Vector

- Vector is a basic data structure in R.
- A vector is a sequence of data elements of the same basic type.
- It is a container which can hold items of __same data type__.
- To create a vector you need:
    - `c()` function
    - variable name
    - values

---

## Vector

- what is variable name?
    - it is a name of a container which holds values.
    - it is a name of a memory location.

---

### Copilot Tips

- there is a new concept called `prompt` in AI Programming.
- There is also a concept called `Chain-of-Thought` in AI Programming.  
- The idea is that you can write a code with the help of AI.
    - only if human being can understand your instructions too
    - only if your design a `good prompt`

---

## Good Prompt
- A good prompt is a prompt that can be understood by human being.
- A good prompt is a prompt that can be understood by AI.
- Examples
    - `# first colomn is a sequence of numbers from 1 to 20` --> good
    - `# third column is sample drawn from ['female', 'male']` --> bad

---

## Good Prompt

```r
# create a data.table for me with 20 rows and 4 columns
# first column is a sequence of numbers from 1 to 20
# second column is a sample drawn from a normal 
#distribution with mean 0 and sd 1
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
```

---

## Bad Prompt

The following prompt is not a good prompt because it is not clear what is the data type of the third column. It is not understandable by human being. Therefore, AI gives an error.

```r
# create a data.table for me with 20 rows and 4 columns
# first column is a sequence of numbers from 1 to 20
# second column is a sample drawn from a normal 
#distribution with mean 0 and sd 1
# third column drawn from ['female', 'male']
```

---
## Why data.table?

- data.table is a package for big data.
- Benchmarking

![bg right:60% 80%](../practice_01/images/benchmark.png)

--> very fast!

---

## Why data.table?
- it is just data.frame with more features
- data. frame is a basic data structure in R

---

# Summary
- Vector is a basic data structure in R.
- to create a vector you need:
    - `c()` function
    - variable name
    - values
- data. table is just data.frame with more features
- what is good and bad prompt?

---


## Celebrate

![bg right:60% 80%](https://th.bing.com/th/id/R.d4690dcf417e378185fd6f46e3268082?rik=msrB%2f2nU65SPxA&riu=http%3a%2f%2fgifimage.net%2fwp-content%2fuploads%2f2017%2f06%2fcelebrate-gif-4.gif&ehk=3Y7ZYqm8PbMEALgBJQ6l1zwlcLAhrVY6TKE90Ydok84%3d&risl=&pid=ImgRaw&r=0)

