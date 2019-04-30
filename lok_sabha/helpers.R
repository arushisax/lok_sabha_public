# A: PREPROCESSING

# 1 Preprocessing-----------------------
# I like to use this function
`%!in%` = Negate(`%in%`)

# Load packages at once

library(tidyverse)
library(leaflet)
library(tidycensus)
library(mapview)
library(sf)
library(tmap)
library(tmaptools)
library(tigris)
library(ggplot2)
library(viridis)
library(ggthemes)
library(gganimate)
library(gifski)
library(shinycssloaders)
library(transformr)
library(shinythemes)
library(lubridate)
library(shinythemes)
library(rtweet)
library(janitor)
library(tidyr)
library(tidytext)
library(readr)
library(wordcloud)
library(tm)
library(syuzhet)
library(gt)
# lapply(packages, require, character.only = TRUE)
# 2 Data preprocessing------------------------
# x <- read_csv("lok_sabha/twitter_data.csv", col_names = TRUE)

# write_rds(x, "x.rds")

x <- read_rds("lok_sabha/x.rds")

# FOR RUNNING THE STATIC
# Modify to orig <- read_csv("lok_sabha/twitter_data.csv", col_names = TRUE)

# Duplicate tibble in case I mess up the data
x <- orig

# 3 Text preprocessing------------------------
temp <- x %>%
  # Lose useless columns
  select(
    created_at,
    user_id,
    screen_name,
    text,
    favourites_count,
    retweet_count,
    is_quote,
    is_retweet,
    hashtags,
    location,
    description,
    place_url,
    place_name,
    place_full_name,
    place_type,
    country,
    country_code,
    geo_coords,
    coords_coords,
    bbox_coords,
    followers_count,
    friends_count
  ) %>%
  # Convert text to lower text
  mutate(text = tolower(text))
# Note:
# https://hackernoon.com/text-processing-and-sentiment-analysis-of-twitter-data-22ff5e51e14c
# is an excellent guide to text processing and sentiment analysis
# Remove Blank Spaces
temp$text <- gsub("rt", "", temp$text)
# Remove @ from usernames
temp$text <- gsub("@\\w+", "", temp$text)
# Remove punctuations
temp$text <- gsub("[[:punct:]]", "", temp$text)
# Remove links
temp$text <- gsub("http\\w+", "", temp$text)
# Remove tabs
temp$text <- gsub("[ |\t]{2,}", "", temp$text)
# Remove blank spaces from the beginning
temp$text <- gsub("^ ", "", temp$text)
# Remove blank spaces from the end
temp$text <- gsub(" $", "", temp$text)
# Remove digits
temp$text <- gsub('[[:digit:]]+', '', temp$text)

# Sentiment analysis
temp$senti <- get_nrc_sentiment(temp$text)

# WRITE INTO RDS
write_rds(temp, "temp.rds")

tbl <- temp %>%
  summarise(Positive = sum(senti$positive),
            Negative = sum(senti$negative)) %>%
  mutate(Total = Positive + Negative)
tbl <- tbl %>%
  gather(key = "Sentiment", value = "Count", Positive:Total) %>%
  mutate(Percentage = Count / 242540)

write_rds(tbl, "tbl.rds")


