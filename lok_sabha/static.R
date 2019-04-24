source("lok_sabha/helpers.R")

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

most_pop_words <- read_csv("lok_sabha/most-pop.csv", col_names = TRUE) %>% 
  select(word, n, positive, negative) %>% 
  gather(key = "sentiment", value = "sent_n", positive:negative) %>% 
  filter(sent_n == 1) %>% 
  mutate(new_var = ifelse(sentiment == "negative", -n/1000000, n/1000000))

most_pop_words %>% 
  ggplot(aes(reorder(word, new_var), new_var, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  geom_hline(yintercept = 0, colour = "white", size = 0.5) +
  geom_vline(xintercept = 14.5, colour = "white", linetype = "dotted") +
  labs(
    y = "Popularity: Favourites + Retweets (in millions)",
    x = NULL,
    # title = "Most Popular Negative & Postive \nWords on the #Chowkidar Campaign",
    # subtitle = "From 108,000 Popular and Recent Tweets \nfrom 20 March, 2019",
    caption = "*translated from Hinglish"
  ) +
  theme_solarized_2(light = FALSE, base_size = 13)

ggsave("lok_sabha/popular_words.png", plot = last_plot())
# Generate wordcloud
# 2 Worlcloud-------------------------

wordcloud(
  wordcloud_df$word,
  wordcloud_df$n,
  colors = brewer.pal(8, "Dark2"),
  random.color = TRUE,
  random.order = FALSE,
  max.words = 100
)

# This generates wordcloud.png