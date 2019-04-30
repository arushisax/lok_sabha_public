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
          "The #Chowkidar Campaign",
          mainPanel(tabsetPanel(
            htmlOutput("chowkidar")
          ))
          ),
        
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
        ),
        # TAB 4: --------------------------
        tabPanel("Sentiments as the Day Unravelled",
                 sidebarPanel(
                   helpText(
                     "As I expected, sentiments have been pretty stable though they seem to have 
                     been more positive on the 19th. What's interesting about this plot is the 
                     increased negativity and backlash against the campaign starting around
                     6 am on the 20th in American time. This is interesting because this roughly
                     coincides with when the news about Nirav Modi's arrest in London was released. 
                     As you can see from the above wordcloud, words like Nirav Modi and arrest 
                     immediately become some of the most tweeted words. Now, I expected a generally
                     positive reaction to Nirav Modi's arrest. However, the data shows that Nirav 
                     Modi's arrest actually caused an increase in negative tweets
                     about the #Chowkidar aka #MainBhiChowkidar campaign. A lot of tweeters seemed 
                     to believe that this is an election stunt and suspected the convenient timing 
                     of the arrest for the BJP. "
                   )
                 ),
                 mainPanel(tabsetPanel(
                   tabPanel("Sentiments as the Day Unravelled",
                            withSpinner(plotOutput("hourly"), type = 4))
                 ))
        )
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
    eligible to vote in one of the seven phases depending on the region. <br><br>Find
    my code at <a href='https://github.com/b-hemanth/lok_sabha_public'>
    https://github.com/b-hemanth/lok_sabha_public</a>.<br><br>What is the data?<br>A mixed sample of the 
    most popular and most recent one hundred and eight thousand tweets in English from the last 
    three days (as of 20 March, 2019, 10:07 pm EST) on the Bharatiya Janata Party's 
    #MainBhiChowkidar campaign.<br><br>A Final Developer's Note:<br> 
    Unfortunately, there seem to be no existing machine learning based APIs or CRAN packages to
    deal with Hindi Tweets, so I'm ignoring them. I considered translating and then analyzing, 
    but this seems to have too broad a confidence interval and Google Translate API is too expensive 
    for me. This obviously makes this analysis biased to some extent. Furthermore, even for English 
    sentiment analysis, there is a non-zero margin of error. However, given my rather large sample size, 
    this margin should be adjusted for. My analysis also does not account for paid tweets. So, 
    the positive skew might be caused in some party by the BJP tech cell's tweeting. However, 
    given that I scraped a mixed sample of popular and recent tweets and given that paid tweets 
    are unlikely to be the most popular ones, this skew should be mitigated. Read more about the skew
    <a href='https://www.theatlantic.com/international/archive/2019/04/india-misinformation-election-fake-news/586123/'>
    here</a>."
  })
  
  # 1 OUTPUT about chowkidar
  output$chowkidar <- renderText({
    "The incumbent BJP party through the use of the slogan, 'Main bhi Chowkidar' (translated: 'I too am a guard'), began a campaign for the 2019 elections wherein the leaders of the party, by saying that they were a guard of the nation, created a movement wherin lakhs of citizens pledged their support towards the PM's integrity by implying that if the PM is an honest guardian, so will all of them be. This was primarily a twitter campaigns with party leaders inserting 'Guard' in front of their twitter names, tweeting #MainBhiChowkidar, and pushing supporters to do so as well.<br><br> This led to both an increase in public support and mockery of the BJP. In response, the Congress, the opposition party, started a Twitter campaign, 'Chowkidar Chor Hai,' i.e., the guard is the thief."
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
  output$hourly <- renderPlot({
    plot <- read_rds("plot_1.4.rds")
    temp_plot %>% 
      ggplot(aes(x = Hour, y = Percentage, fill = Sentiment)) +
      geom_bar(stat = "identity", alpha = 0.6, color = "black") +
      labs(
        title = "Positive and Negative Tweets by Hour",
        subtitle = "From 6 pm on 19 March to 10 pm on 20 March",
        x = "Day and Hour of Day in Eastern Standard Time"
      ) +
      theme_solarized_2(light = FALSE) +
      scale_x_discrete(labels = c("19th-6pm", "", "",  "9pm", "", "", "20th-12am", "", "", "3am", "", "", "6am", "", "", "9am", "",  "", "12pm", "", "", "3pm", "", "", "6pm", "", "",  "9pm", ""))
  })
}

# Run the application--------
shinyApp(ui = ui, server = server)
