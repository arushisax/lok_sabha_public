# WORKFLOW 
# There is one main file that powers the app: `app.R` in `/lok_sabha/`.
# (github.com/b-hemanth/lok_sabha_public/lok_sabha/app.R) There are two other R
# script files in this same folder, namely: `helpers.R` and `static.R`.
# `helpers.R` contains much of the preprocessing for the app. It reads in the
# data, cleans it, does a lot of the text-mining, and does some preliminary
# sentiment analysis. It pushes out some `.Rds` files and dataframes that are
# then used in `static.R` to produce the static images. These are those plots
# that do not employ reactive variables and are not interactive on the final
# interface. Finally, `../lok_sabha/static/` is the folder that contains the
# static images produced in the R script files. These static images are then
# rendered in the Shiny App.

# BEFORE RUNNING THE STATIC, you must switch the datafile in helpers.R to work
# out of the right directory. This is because when the Shiny App is run, it
# assumes that the folder of the app.R file is the working directory whereas the
# regular R script assumes that the upper root directory is the pwd.

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

# 2 Data preprocessing------------------------
# x <- read_csv("lok_sabha/twitter_data.csv", col_names = TRUE)
# 
# write_rds(x, "x.rds")

x <- read_rds("lok_sabha/x.rds")

# FOR RUNNING THE STATIC
# Modify to orig <- read_csv("lok_sabha/twitter_data.csv", col_names = TRUE)

# Duplicate tibble in case I mess up the data
orig <- x

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

# PLOT 1.4
temp_plot <- temp %>% 
  mutate(pos = senti$positive, neg = senti$negative) %>% 
  select(created_at, pos, neg) %>% 
  gather(key = "Sentiment", value = "Count", pos:neg)

temp_plot$hour <- as.POSIXct(temp_plot$created_at, format="%Y%m%d %H%M%S")
temp_plot$hour <- format(temp_plot$hour,format='%d.%H')

temp_plot <- aggregate(temp_plot$Count, by=list(Hour=temp_plot$hour, Sentiment=temp_plot$Sentiment), FUN=sum)

temp_plot <- as_tibble(temp_plot) %>% 
  arrange(Hour) %>% 
  mutate(Hour = as.numeric(Hour))

temp_plot <- temp_plot %>% 
  spread(Sentiment, x) %>% 
  mutate(total = pos + neg) %>% 
  mutate(Positive = (pos*100)/total, Negative = (neg*100)/total) %>% 
  select(Hour, Positive, Negative) %>% 
  gather(key = "Sentiment", value = "Percentage", Positive:Negative)

temp_plot <- temp_plot %>% 
  mutate(Hour = as.character(Hour)) %>% 
  filter(Hour != "19.14", Hour != "19.16")

write_rds(temp_plot, "plot_1.4.rds")


