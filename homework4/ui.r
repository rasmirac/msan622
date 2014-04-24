library(shiny)

shinyUI(
  pageWithSidebar(  
    titlePanel("Comparing screenplays and novels"),
    sidebarPanel(
      # Add a drop-down box for sort columns.
      radioButtons(
        "book",
        'Which text do you want? ', 
        choices = c('Fight Club' = 'fightclub', 
                    "No Country for Old Men" = 'nocountry', 
                    "Pride and Prejudice" = 'prideandprej'
        )
      ), 
      br(),
      radioButtons(
        "whichtoshow",
        'Verion of Text: ', 
        choices = c("Screenplay", "Novel")
      ), 
      br(), 
      radioButtons(
        "wordsBar",
        'Number of words in bar plot: ', 
        choices = c(10, 15, 20)
      ), width = 3, height = 8
      ),
    mainPanel(
      # Create a tab panel.
      tabsetPanel(
        # Add a tab for displaying the histogram.
        tabPanel("Bar Plot", plotOutput("barPlot", height = 700, width = 1000)),
        tabPanel("Word Cloud", plotOutput("wordCloud", height = 700, width = 1000)), 
        tabPanel("Scatter Plot", plotOutput("scatterPlot", height = 700, width = 900))
      )
    )
  )
)