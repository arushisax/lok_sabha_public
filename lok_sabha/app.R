# Packages----
`%!in%` = Negate(`%in%`)

# Load packages at once
packages <- c(
  "tidyverse", "leaflet", "tidycensus", "mapview", "sf", "tmap", "tmaptools", 
  "tigris", "ggplot2", "viridis", "ggthemes", "gganimate", "gifski", "shinycssloaders", 
  "transformr", "shinythemes", "lubridate", "shinythemes", "rtweet", "janitor", "tidyr",
  "tidytext", "readr", "wordcloud", "tm", "syuzhet", "gt", "shiny", "shinythemes", "shinyjs"
)
lapply(packages, require, character.only = TRUE)

source("helpers.R")


# UI-----
ui <-
  shinyUI(
    navbarPage(
      "Twitter in the Biggest Election in the World",
      # TAB 1: About--------------------------
      tabPanel("About",
               mainPanel(
                 h1("2019 Indian Parliamentary Elections: Twitter Data Analysis"),
                 htmlOutput("about")
               )), 
      # TAB 2: Sentiment Analysis--------------------------
      navbarMenu("The Public Sentiment",
                 
                 
                 
                 tabPanel("Wordcloud",
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
                          mainPanel(
                            tabsetPanel(
                              tabPanel("The Most Tweeted Words",
                                       withSpinner(plotOutput("wordcloud"), type = 4)
                                       )
                              )
                          )
                 ),
                 
                 tabPanel("Popular Words",
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
                          mainPanel(
                            tabsetPanel(
                              tabPanel("Popular Positive and Negative Words",
                                       withSpinner(plotOutput("p_word_senti"), type = 4)
                              )
                            )
                          )
                          ),
                 
      # TAB 3: --------------------------
      
      # TAB 4: --------------------------
      
      # Remaining UI-------
      inverse = TRUE,
      collapsible = TRUE,
      theme = shinytheme("darkly"),
      windowTitle = "Indian Elections Analysis"
    )
  ))







# SERVER-------------   
# Define server logic required to draw a histogram
server <- function(input, output) {
  # 1 Ouput About---------
  output$about <- renderText({"demo"})
  output$wordcloud <- renderPlot({
    
  })
}

# Run the application--------
shinyApp(ui = ui, server = server)

