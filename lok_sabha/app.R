library(shiny)
library(shinythemes)
source("helpers.R")

ui <-
  navbarPage(title = "2019 Indian Parliamentary Elections: Analysis",
             value = "home",
             footer = "Built by Hemanth Bharatha Chakravarthy. hemanthbharathachakravarthy@college.harvard.edu",
             inverse = TRUE,
             collapsible = TRUE,
             theme = shinytheme("sandstone"),
             windowTitle = "Indian Elections Analysis")

    
# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

