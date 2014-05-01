library(shiny)

shinyUI(
  pageWithSidebar(  
    titlePanel("Comparing screenplays and novels"),
    sidebarPanel(
      # Add a drop-down box for sort columns.
      selectInput(
        inputId = "expandGroup", 
        label = "Expand Group: ",
        choices = c('None',
                    "Carbohydrates",
                    "Dairy", 
                    "Drinks", 
                    "Fruit and Vegetables" , 
                    "Meat, Fish, and Eggs" ,  
                    "Sweets and Fats" , 
                    "Other"), 
        selected = NULL
      ), 
      selectInput(
        inputId = "expandGroup", 
        label = "Show by Region: ",
        choices = c('All',
                    "England",
                    "Norhern Ireland", 
                    "Wales", 
                    "Scotland"), 
        selected = NULL
      ), 
      br(),
      sliderInput("range", "Year Range:",
                  min = 1980, max = 2012, step = 1, value = c(1980, 2012)
      ), width = 3, height = 8
    ),
    mainPanel(
      # Create a tab panel.
      tabsetPanel(
        # Add a tab for displaying the histogram.
        tabPanel("Multiline Plot", plotOutput("barPlot", height = 700, width =1000))
      )
    )
  )
)