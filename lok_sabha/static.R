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

source("lok_sabha/helpers.R")

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
  
  filter(
    word %!in% c(
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
    )
  ) %>%
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

# B: PLOTS

# 1 Words Plot-----------------------
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

# write_csv(most_pop_words, "temp.csv")
# Word graph

# Rewrite most_pop_words

most_pop_words <-
  read_csv("lok_sabha/most-pop.csv", col_names = TRUE) %>%
  select(word, n, positive, negative) %>%
  gather(key = "sentiment", value = "sent_n", positive:negative) %>%
  filter(sent_n == 1) %>%
  mutate(new_var = ifelse(sentiment == "negative", -n / 1000000, n / 1000000))

most_pop_words %>%
  ggplot(aes(reorder(word, new_var), new_var, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  geom_hline(yintercept = 0,
             colour = "white",
             size = 0.5) +
  geom_vline(xintercept = 14.5,
             colour = "white",
             linetype = "dotted") +
  labs(y = "Popularity: Favourites + Retweets (in millions)",
       x = NULL,
       
       # title = "Most Popular Negative & Postive \nWords on the #Chowkidar Campaign",
       # subtitle = "From 108,000 Popular and Recent Tweets \nfrom 20 March, 2019",
       
       caption = "*translated from Hinglish") +
  theme_solarized_2(light = FALSE, base_size = 13)

ggsave("lok_sabha/popular_words.png", plot = last_plot())

# A plot created through the above pipeline is attached in the shiny app

# Generate wordcloud
# 2 Worlcloud-------------------------

png("wordcloud.png")
wordcloud(
  wordcloud_df$word,
  wordcloud_df$n,
  colors = brewer.pal(8, "Dark2"),
  random.color = TRUE,
  random.order = FALSE,
  max.words = 100
)

dev.off()

# This generates wordcloud.png