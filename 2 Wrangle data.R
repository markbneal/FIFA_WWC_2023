# 2 Wrangle data to combine events and ranks

library(tidyr)
library(dplyr)
library(purrr)
library(stringr)
library(readxl)


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
  mutate(game = str_c(match_hometeam_name, " v\n", match_awayteam_name))

data_df$match_awayteam_score
data_df$match_hometeam_score
data_df$point_diff

data_df$rank_diff

data_df <- data_df %>% 
  mutate(rel_point_diff = case_when(rank_diff >= 0 ~ point_diff,
                                    rank_diff < 0 ~ -point_diff,
                                    TRUE ~ point_diff)) %>% 
  mutate(abs_rank_diff = abs(rank_diff))


saveRDS(data_df, "data_df_join.RDS")
