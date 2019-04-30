# Packages----
`%!in%` = Negate(`%in%`)

# Load packages at once
library(shiny)
library(shinythemes)
library(shinycssloaders)

# A: PREPROCESSING
# Load packages at once

library(tidyverse)
library(ggplot2)
library(viridis)
library(ggthemes)
library(gganimate)
library(gifski)
library(transformr)
library(lubridate)
library(janitor)
library(tidyr)
library(tidytext)
library(readr)
library(wordcloud)
library(syuzhet)

# 1 Preprocessing-----------------------
# I like to use this function

`%!in%` = Negate(`%in%`)


# UI-----
ui <-
  shinyUI(
    navbarPage(
      "Twitter in the Biggest Election in the World",
      inverse = TRUE,
      collapsible = TRUE,
      theme = shinytheme("darkly"),
      windowTitle = "Indian Elections Analysis",
      # TAB 1: About--------------------------
      tabPanel("About",
               mainPanel(
                 h1("2019 Indian Parliamentary Elections: Twitter Data Analysis"),
                 htmlOutput("about")
               )),
      # TAB 2: Sentiment Analysis--------------------------
      navbarMenu(
        "The Public Sentiment",
        
        
        
        tabPanel(
          "Wordcloud",
          sidebarPanel(
            helpText(
              "This analyzes a mixed sample of 108,000 most popular
              and most recent tweets collected from Twitter on 20 March, 2019,
              that tweeted about the BJP's #MainBhiChowkidar ('I am a guard
              of the nation') campaign. This wordcloud shows the hundred most
              tweeted meaningful words and phrases with greater font
              size indicatin greater frequency of being tweeted."
            )
            ),
          mainPanel(tabsetPanel(
            tabPanel("The Most Tweeted Words",
                     withSpinner(imageOutput("wordcloud"), type = 4))
          ))
            ),
        
        tabPanel(
          "Popular Words",
          sidebarPanel(
            helpText(
              "This analyzes a mixed sample of 108,000 most popular
              and most recent tweets collected from Twitter on 20 March, 2019,
              that tweeted about the BJP's #MainBhiChowkidar ('I am a guard
              of the nation') campaign. This plot measures words that
              expressed positive and negative sentiments about the Modi-led
              BJP's #Chowkidar Campaign that achieved the most retweets
              and favourites."
            )
            ),
          mainPanel(tabsetPanel(
            tabPanel(
              "Popular Positive and Negative Words",
              withSpinner(imageOutput("popular_words"), type = 4)
            )
          ))
            ),
        
        # TAB 3: --------------------------
        tabPanel(
          "Sentiments: Summary",
          sidebarPanel(
            helpText(
              "This analyzes a mixed sample of 108,000 most popular
              and most recent tweets collected from Twitter on 20 March, 2019,
              that tweeted about the BJP's #MainBhiChowkidar ('I am a guard
              of the nation') campaign. This measures the positive and negative sentiments about the Modi-led BJP's #Chowkidar Campaign."
            )
          ),
          mainPanel(tabsetPanel(
            tabPanel("Sentiments: Summary",
                     withSpinner(gt_output("senti_summary"), type = 4))
          ))
        )
        # TAB 4: --------------------------
        
      )
      )
    )


# SERVER-------------
# Define server logic required to draw a histogram
server <- function(input, output) {
  # 1 OUTPUT About---------
  
  output$about <- renderText({
    "The 2019 Indian general election is currently being held in seven phases
    from 11 April to 19 May 2019 to constitute the 17th Lok Sabha. The
    counting of votes will be conducted on 23 May, and on the same day
    the results will be declared. About 900 million Indian citizens are
    eligible to vote in one of the seven phases depending on the region. Find
    my code at <a href='https://github.com/b-hemanth/lok_sabha_public'>
    https://github.com/b-hemanth/lok_sabha_public</a>"
  })
  
  # 2 OUTPUT wordcloud------
  output$wordcloud <- renderImage({
    list(
      src = "static/wordcloud.png",
      contentType = 'image/png',
      width = 350,
      height = 400
    )
  })
  # 3 OUTPUT popular words-----
  output$popular_words <- renderImage({
    list(
      src = "static/popular_words.png",
      contentType = 'image/png',
      width = 400,
      height = 600
    )
  })
  # 4 OUTPUT Sentiment analysis----
  output$senti_summary <- render_gt({
    tbl <- read_rds("tbl.rds")
    tbl %>%
      select(Sentiment, Percentage) %>%
      gt() %>%
      fmt_percent(columns = vars("Percentage")) %>%
      tab_header(title = "Sentiment Analysis of Tweets About the #Chowkidar Campaign",
                 subtitle = "Analyzing a Mixed Sample of 108,000 of the Most Popular and Most Recent Tweets") %>%
      # Cite the data source
      tab_source_note(source_note = "Data from Twitter")
  })
  }

# Run the application--------
shinyApp(ui = ui, server = server)
