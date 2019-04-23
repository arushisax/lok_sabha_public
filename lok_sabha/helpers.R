# 1: PREPROCESSING

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

# Data preprocessing
orig <- read_csv("lok_sabha/twitter_data.csv", col_names = TRUE)

# Duplicate tibble in case I mess up the data
x <- orig

# Text preprocessing
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
  top_n(60) 

senti <- get_nrc_sentiment(most_pop_words$word)

senti <- tibble::rowid_to_column(senti, "ID")
most_pop_words <- tibble::rowid_to_column(most_pop_words, "ID")

most_pop_words <- most_pop_words %>% 
  left_join(senti, by = "ID") %>% 
  select(-ID)

# NOTE
# syuzhet does not work for Hindi words. Though I only downloaded tweets in
# English, it's a common practice to write Hindi tweets using English
# characters. So, I'm intervening in the tibble here: this is unconventional and
# perhaps even inappropriate but in the absence of a ML library of any kind to
# perform sentiment analysis on Hindi words, this is the best bet to maintain
# the tradeoff between being objective and representing the reality of the
# political climate. So, you can run the code till here and check out the
# natural produced tibble and compare with the changes I make. Feel free to
# contact me to challenge any of my interpretations.

# write_csv(most_pop_words, "most-pop.csv")

most_pop_words <- read_csv("most-pop.csv", col_names = TRUE) %>% 
  select(word, n, positive, negative)

# Generate wordcloud
wordcloud(most_pop_words$word, most_pop_words$n, colors=brewer.pal(8, "Dark2"), color, max.words = 60)