library(shiny)

# Create a simple shiny page.
shinyUI(
  # We will create a page with a sidebar for input.
  pageWithSidebar(  
    # Add title panel.
    titlePanel("Understanding State Data"),
    
    # Setup sidebar widgets.
    sidebarPanel(
      checkboxGroupInput(
        inputId = "regionsToShow", 
        label = "Regions:", 
        choices = c('Northeast', 'South', 'North Central', 'West')
      ),  
      br(),
      selectInput(
        inputId = "xAxis", 
        label = "X-axis Variable: ",
        choices = c("Population",
                    "Income", 
                    "Illiteracy Rate", 
                    "Life Expectancy" , 
                    "Murder Rate" ,  
                    "High School Graduates" , 
                    "Frost", 
                    'Area'),
        selected = 'Frost'
      ), 
      selectInput(
        inputId = "yAxis", 
        label = "Y-axis Variable: ",
        choices = c("Population",
                     "Income", 
                     "Illiteracy Rate", 
                     "Life Expectancy",  
                     "Murder Rate",  
                     "High School Graduates", 
                     "Frost", 
                     'Area'), 
        selected = 'Murder Rate'
      ), 
      selectInput(
        inputId = "size_var", 
        label = "Size Variable: ",
        choices = c("Population",
                   "Income", 
                   "Illiteracy Rate", 
                   "Life Expectancy" , 
                   "Murder Rate" ,  
                   "High School Graduates", 
                   "Frost", 
                   'Area'),
        selected = 'Illiteracy Rate'
      ), 
      checkboxInput(
        "show_labels", 
        "Show State Labels", 
        FALSE
      ),
      br(),
      selectInput(
        inputId = "colorScheme", 
        label = "Color Scheme:",
        choices = c("Dark 2", 
                    "Accent", 
                    "Set 1", 
                    "Set 2", 
                    "Set 3", 
                    "Pastel 1", 
                    "Pastel 2")
      ), width = 3, height = 8
    ),
    
    # Setup main panel.
    mainPanel(
      # Create a tab panel.
      tabsetPanel(
        # Add a tab for displaying the histogram.
        tabPanel("Bubble Plot", plotOutput("bubblePlot", height = 700, width = 900)), 
        tabPanel("Small Multiples Plot", plotOutput("scatterPlot", height = 650, width = 900)),
        tabPanel("Parallel Coordinates Plot", plotOutput("parrPlot", height = 700, width = 1100))
      )
    )
  )
)