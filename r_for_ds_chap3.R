#import packages
library(dplyr)
library(nycflights13)
library(tidyverse)
library(ggplot2)


# Note: after loading tidyverse
# If you want to use the base version of these functions after in dplyr
# you'll need to use their full names: 
# stat::filter()
# stats::lag()

# view flights data set loaded from nycflights13
flights

# note that flights is a tibble
# tibble is a df which is more efficient for tidyverse

#distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>

# dplyr basics

# filter rows with filter()

# We can select all flights of Jan 02, 2013 with

flights %>%
  filter(year == 2013, month == 1, day == 2)

# alternate code: 
# filter(flights, year == 2013, month == 1, day == 2)

# operators
# > greater than
# >= greater than or equal to
# < less than
# <= greater than or equal to
# != not equals to
# == equal to

# logical operators
# y & !x (y and not x)
# y & x (y and x)
# x | y (x or y)
# xor (x, y) (exclusive or between x and y)
# In R, the xor() function is used to evaluate exclusive-OR between x and y 
# argument values. Exclusive-OR or shortly XOR is a boolean logical operation. 
# It takes two boolean input values and returns TRUE or FALSE. 
# If input values are the same, it returns FALSE, otherwise, it returns TRUE.

# in operator usage
# select every row where x is one of the values in y

# selecting flights in November or December
nov_dec <- filter(flights, month %in% c(11, 12))

# crosschecking unique months
nov_dec$month %>% unique()

# missing values
NA > 5 # returns NA
NA == NA # returns NA
# this is because if we don't know what NA value is on the left and we don't know
# what NA value is on the right... we simply don't know... thus we get returned NA

x_na <-NA
# if you want to determine a value is missing
# use is.na
is.na(x_na)


# filter() only includes rows where the condition is TRUE
# it excludes both False and NA values
# If you want to preserve missing values, ask ffor thhe explicitly

x <- NA
df <- tibble(x=c(1, NA, 3))
df

filter(df, x > 1) # returns only 3

filter(df, is.na(x) | x>1) # returns NA and 3

# EXCERCISE



# arrange rows with arrage()
arrange(flights, year, month, day)

# desc to get descending order
arrange(flights, desc(year, month, day)) # I initially thought there were more years other than 2013

flights$year %>% unique() # shows only unique year is 2013

# a better example for arrange desc
# trying to sort in descending order multiple columns... first by sched_arr_time and then by air_time
desc_example <- arrange(flights, desc(sched_arr_time, air_time)) # did not obtain the desired result

# this does what we wanted
desc_example2 <- arrange(flights, desc(sched_arr_time), desc(air_time)) # obtained the desired result


# EXCERCISE
# 1. How can you use arrange to sort all missing values to the start?
#  (Hint: use is.na() )
arrange(df, x) #puts NA at the end
arrange(df, desc(is.na(x)), x) # puts NA at the top

# 2.a
arrange(flights, desc(dep_delay)) # most delayed
# 2.b
arrange(flights, dep_time)

# 3
view(arrange(flights, air_time))

# 4
view(arrange(flights, distance)) # shortest
view(arrange(flights, desc(distance))) #longest

# testing is.na for multiple columns
df2 <- tibble(col1= c(1, 3, 2, NA, 9, 6),
              col2= c(NA, 2.5, 2.9, NA, 9.4, 6.1))

arrange(df2, desc(is.na(col1)), desc(is.na(col2)), col1, col2)

# select columns

# select columns by name
select(flights, year, month, day)

# select all columns between year and dep_delay (inclusive)
select(flights, year:dep_delay)

# select all columns except those from year and dep_delay (inclusive)
select(flights, -(year:dep_delay))

# helper functions within select
# starts_with("abc") matches names that begin with "abc"
select(flights, starts_with("air"))

# ends_with("abc") matches names that end with "abc"
select(flights, ends_with("time"))

# contains("abc") matches names that contain "abc"
select(flights, contains("air"))
select(flights, contains("time"))

# matches("(.)\\1"): selects variables that match regular expression (REGEX)
# this one matchhes any variables that contain repeated charaters (Regex in chap 11)

# num_range("a", 1:3) matches a1, a2, a3

# ?select for more details

# select can be used for renaming variables, but it will drop all 
# the variables not explicitly mentioned
select(flights, DEPARTUREdelaAY = dep_delay)

#instead use rename() and it will keep all the other columns
rename(flights, DEPARTUREdelaAY = dep_delay)

# to move columns to the front use everything() like this:
select(flights, dep_delay, sched_dep_time, everything()) #this moves dep_delay and sched_dep_time to the front

# EXCERCISE


# mutate()

# besides selecting existing columns sometimes its useful to add new columns
# mutate always adds columns to the end of the dataset 
# the easiest way to view data is view(dataset_name)

# selecting specific columns
flights_sml <- select(flights,
                      year:day,
                      ends_with('delay'),
                      distance,
                      air_time
                      )
# using mutate
mutate(flights_sml,
       gain = arr_delay - dep_delay, # this is a new column of data that we created
       speed = distance /air_time * 60 # another new column
       )

# note that you can refer to columns that you've just created
mutate(flights_sml,
       gain = arr_delay - dep_delay, # this is a new column of data that we created
       speed = distance /air_time * 60, # another new column
       gain_per_hour = gain/hour
)
      