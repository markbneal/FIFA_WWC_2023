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

library(tidyr)
library(dplyr)
library(purrr)
library(stringr)
library(readxl)
library(ggplot2)
library(ggrepel)
library(httr)
library(jsonlite)

# Note, can skip to "read in preprocessed data" unless update is required

# # Alternative Source of Data, requires signup, not used
# # https://live-score-api.com/
# res = GET("http://livescore-api.com/api-client/scores/history.json?key=demo_key&secret=demo_secret")


# Source of Data, also requires signup
# https://apifootball.com/documentation/#Events

API_football <- readLines("creds.txt")

res = GET(paste0("apiv3.apifootball.com/?action=get_countries&APIkey=", API_football))
res

# Get game data (note date is hardcoded in url)
# From documentation, League #20 is Womens World Cup
res2 <- GET(paste0("https://apiv3.apifootball.com/?action=get_events&from=2023-07-01&to=2023-07-30&league_id=20&APIkey=",
                   API_football))


saveRDS(res2, "res2.RDS")
res2 <- readRDS("res2.RDS")

# Make a list from result        
data_list <- httr::content(res2, encoding = "UTF-8", as = "parsed")
# class(data_list)
# data_list[1][1]
# class(data_list[1][1])

# Convert list to data frame, 1 game per row
# some options - https://stackoverflow.com/a/38860890/4927395
data_df <- map(data_list, unlist, recursive = TRUE) %>% bind_rows() # Messy, makes 3500 columns!

saveRDS(data_df, "data_df.RDS")

# Read in preprocessed data ####
data_df <- readRDS("data_df.RDS")

# Read and join ranks ####
# (as of June 6 2023, https://www.fifa.com/fifa-world-ranking/women?dateId=ranking_20230609)
ranks <- read_excel("FIFA Womens Ranking.xlsx", sheet = "rank")

# Create Rank difference and point difference ####
# Check country names first
data_df$match_awayteam_name
data_df$match_hometeam_name
country_names <- as_tibble(unique(c(data_df$match_awayteam_name, data_df$match_hometeam_name)))
class(country_names)

write.csv(country_names, "country_names.csv")

country_names <- country_names %>% 
  mutate(end_w = str_ends(value, "W")) %>% 
  mutate(short_country = case_when(end_w == TRUE ~ str_sub(value, 1, -3),
                                   end_w == FALSE ~ value))

# now first fix " W" after some team names!!
data_df <- data_df %>% 
  mutate(end_w = str_ends(match_hometeam_name, "W")) %>% 
  mutate(match_hometeam_name = case_when(end_w == TRUE ~ str_sub(match_hometeam_name, 1, -3),
                                   end_w == FALSE ~ match_hometeam_name))
data_df <- data_df %>% 
  mutate(end_w = str_ends(match_awayteam_name, "W")) %>% 
  mutate(match_awayteam_name = case_when(end_w == TRUE ~ str_sub(match_awayteam_name, 1, -3),
                                         end_w == FALSE ~ match_awayteam_name))

sort(data_df$match_awayteam_name)
sort(data_df$match_hometeam_name)
country_names <- as_tibble(sort(unique(c(data_df$match_awayteam_name, data_df$match_hometeam_name))))
write.csv(country_names, "country_names2.csv")


#still not fixed!

# 6,"China PR"		5,"China"
# 18,"Korea Republic"		29,"South Korea"
# 27,"Republic of Ireland"		14,"Ireland"
# 34,"USA"		33,"United States"

data_df <- data_df %>% 
  mutate(match_hometeam_name = case_when(match_hometeam_name == "China" ~ "China PR",
                                         match_hometeam_name == "South Korea" ~ "Korea Republic",
                                         match_hometeam_name == "Ireland" ~ "Republic of Ireland",
                                         match_hometeam_name == "United States" ~ "USA",
                                         TRUE ~ match_hometeam_name
                                          ))

data_df <- data_df %>% 
  mutate(match_awayteam_name = case_when(match_awayteam_name == "China" ~ "China PR",
                                         match_awayteam_name == "South Korea" ~ "Korea Republic",
                                         match_awayteam_name == "Ireland" ~ "Republic of Ireland",
                                         match_awayteam_name == "United States" ~ "USA",
                                         TRUE ~ match_awayteam_name
                                          ))

sort(data_df$match_awayteam_name)
sort(data_df$match_hometeam_name)
country_names <- as_tibble(sort(unique(c(data_df$match_awayteam_name, data_df$match_hometeam_name))))
# now do ranks etc

data_df <- left_join(data_df, ranks, by = c("match_hometeam_name" = "Team"))
data_df <- left_join(data_df, ranks, by = c("match_awayteam_name" = "Team"))

data_df <- data_df %>% 
  mutate(rank_diff = RK.y - RK.x) %>% 
  mutate(point_diff = as.numeric(match_hometeam_score) - as.numeric(match_awayteam_score)) %>% 
  mutate(game = str_c(match_hometeam_name, " v ", match_awayteam_name))

data_df$match_awayteam_score
data_df$match_hometeam_score
data_df$point_diff

data_df$rank_diff

# Plot results ####
# geom repel error
# https://stackoverflow.com/a/68084961/4927395
# x11()
ggplot(data = data_df, aes(x = rank_diff, y = point_diff))+
  geom_jitter() +
  geom_smooth(method = "lm", formula = "y ~ x") +
  xlab("Rank Difference (Away - Home)")+
  ylab("Point Difference (Home - Away)")+
  ggtitle("Greater rank differences typically lead to \ngreater point differences")+
  geom_text(aes(label = game), size=3 )
  #geom_text_repel(aes(label = game)) # caused error

ggsave("rank difference vs point difference.png")
