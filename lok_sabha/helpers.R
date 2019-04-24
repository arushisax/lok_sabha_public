# A: PREPROCESSING

# 1 Preprocessing----------------------- 
# I like to use this function
`%!in%` = Negate(`%in%`)

# Load packages at once
packages <- c(
  "tidyverse", "leaflet", "tidycensus", "mapview", "sf", "tmap", "tmaptools", 
  "tigris", "ggplot2", "viridis", "ggthemes", "gganimate", "gifski", "shinycssloaders", 
  "transformr", "shinythemes", "lubridate", "shinythemes", "rtweet", "janitor", "tidyr",
  "tidytext", "readr", "wordcloud", "tm", "syuzhet", "gt"
  )
lapply(packages, require, character.only = TRUE)
# 2 Data preprocessing------------------------
orig <- read_csv("twitter_data.csv", col_names = TRUE)

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
# Remove stopwords
data("stop_words")
# get a list of words
words <- temp %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  filter(!word %in% c("rt", "t.co")) 
## Joining, by = "word"

most_pop_words <- words %>%
  mutate(likes = favourites_count + retweet_count) %>% 
  # Removing leftover "&" converted to "amp" from gsub from being counted in the top words
  filter(word %!in% c(
    "amp",
    "airtel",
    "vodafone",
    "mobile",
    "dial",
    "sms",
    "users",
    "caller",
    "hai",
    "pe",
    "aiel",
    "send",
    "im",
    "jio",
    "phone",
    "ke",
    "tune",
    "main",
    "ive"
  )) %>% 
  group_by(word) %>% 
  summarise(n = sum(likes)) %>% 
  arrange(desc(n)) %>% 
  top_n(120) 

senti <- get_nrc_sentiment(most_pop_words$word)

senti <- tibble::rowid_to_column(senti, "ID")
most_pop_words <- tibble::rowid_to_column(most_pop_words, "ID")

most_pop_words <- most_pop_words %>% 
  left_join(senti, by = "ID") %>% 
  select(-ID)

wordcloud_df <- most_pop_words




