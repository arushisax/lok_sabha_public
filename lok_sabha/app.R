# Packages----
library(shiny)
library(shinythemes)
library(shinyjs)
# source("helpers.R")
# UI-----
ui <-
  shinyUI(
    navbarPage(
      "The Biggest Election in the World",
      # TAB 1: About--------------------------
      tabPanel("About",
               mainPanel(
                 h1("2019 Indian Parliamentary Elections: Analysis"),
                 htmlOutput("about")
               )),
      # TAB 2: --------------------------
      
      # TAB 3: --------------------------
      
      # TAB 3: --------------------------
      
      # Remaining UI-------
      inverse = TRUE,
      collapsible = TRUE,
      theme = shinytheme("darkly"),
      windowTitle = "Indian Elections Analysis"
    )
  )

# SERVER-------------   
# Define server logic required to draw a histogram
server <- function(input, output) {
  # 1 Ouput About---------
  output$about <- renderText({"demo"})
}

# Run the application--------
shinyApp(ui = ui, server = server)

