# API to get data for FIFA Women's World Cup 2023

# Setup (some issues with packages on workbench) ####
# install.packages("tidyverse") # didn't work on workbench
# install.packages("ragg") #didn't work on workbench
# install.packages("fribidi") #didn't work on workbench, raised assist
# ggplot2, for data visualisation.
# dplyr, for data manipulation.
# tidyr, for data tidying.
# readr, for data import.
# purrr, for functional programming.
# tibble, for tibbles, a modern re-imagining of data frames.
# stringr, for strings.
# forcats, for factors.
# lubridate, for date/times.

# install.packages("tidyr")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("purrr")
# install.packages("ggExtra")

library(tidyr)
library(dplyr)
library(purrr)

library(httr)
library(jsonlite)

# Note, can skip to "read in preprocessed data" unless update is required

# # Alternative Source of Data, requires signup, not used
# # https://live-score-api.com/
# res = GET("http://livescore-api.com/api-client/scores/history.json?key=demo_key&secret=demo_secret")


# Source of Data, also requires signup
# https://apifootball.com/documentation/#Events

API_football <- readLines("creds.txt")

countries <-  GET(paste0("apiv3.apifootball.com/?action=get_countries&APIkey=", API_football))
countries

# Get game data (note date is hardcoded in url for pool games)
# From documentation, League #20 is Womens World Cup
results <- GET(paste0("https://apiv3.apifootball.com/?action=get_events&from=2023-07-01&to=2023-08-14&league_id=20&APIkey=",
                   API_football))


saveRDS(results, "results.RDS")
results <- readRDS("results.RDS")

# Make a list from result        
data_list <- httr::content(results, encoding = "UTF-8", as = "parsed")
# class(data_list)
# data_list[1][1]
# class(data_list[1][1])

# Convert list to data frame, 1 game per row
# some options - https://stackoverflow.com/a/38860890/4927395
data_df <- map(data_list, unlist, recursive = TRUE) %>% bind_rows() # Messy, makes 3500 columns!

saveRDS(data_df, "data_df.RDS")



