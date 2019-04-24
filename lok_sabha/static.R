source("lok_sabha/helpers.R")

# B: PLOTS

# 1 Words Plot-----------------------

p_word_senti = most_pop_words %>% 
  ggplot(aes(reorder(word, new_var), new_var, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  geom_hline(yintercept = 0, colour = "black", size = 0.3) +
  geom_vline(xintercept = 14.5, colour = "black", linetype = "dotted") +
  labs(
    y = "Popularity: Favourites + Retweets (in millions)",
    x = NULL,
    title = "Most Popular Negative and Postive Words on #Chowkidar",
    subtitle = "From 108,000 Popular and Recent Tweets from 20 March, 2019"
  ) +
  theme_minimal()

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