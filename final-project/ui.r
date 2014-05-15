library(shiny)

shinyUI(
  pageWithSidebar(  
    titlePanel("UK Household Food Purchases"),
    sidebarPanel(width=3,
      conditionalPanel(condition = "input.plotType == 'Multiline Plot'",
                       selectInput(
                         inputId = "expandGroup", 
                         label = "Expand Group: ",
                         choices = c('None',
                                     "Carbohydrates",
                                     "Dairy",
                                     "Drinks", 
                                     "Fruit and Vegetables", 
                                     "Meat, Fish, and Eggs",  
                                     "Sweets and Fats", 
                                     "Other"), 
                         selected = NULL
                         ), 
                       br(),
                       sliderInput("range", 
                                   "Year Range:",
                                   min = 1974, 
                                   max = 2012, 
                                   step = 1, 
                                   value = c(1974, 2012), 
                                   format = '####'
                                   )
                       ), 
      conditionalPanel(condition = "input.plotType == 'Small Multiples Plot'",
                       selectInput(
                         inputId = "expandGroupM", 
                         label = "Expand Group: ",
                         choices = c('None',
                                     "Carbohydrates",
                                     "Dairy",
                                     "Drinks", 
                                     "Fruit and Vegetables", 
                                     "Meat, Fish, and Eggs",  
                                     "Sweets and Fats", 
                                     "Other"), 
                         selected = NULL
                       )
                       ),
      conditionalPanel(condition = "input.plotType == 'Heat Map'",
                       selectInput(
                         inputId = "group", 
                         label = "Food Group to Color by: ",
                         choices = c("Carbohydrates",
                                     "Dairy",
                                     "Drinks", 
                                     "Fruit and Vegetables", 
                                     "Meat, Fish, and Eggs",  
                                     "Sweets and Fats", 
                                     "Other")
                       )
      ), 
      conditionalPanel(condition = "input.plotType == 'Stacked'",
                       checkboxInput(
                         "facet", 
                         "Break up by food group", 
                         FALSE
                       )
      )
      ),
    mainPanel(
      tabsetPanel(
        tabPanel("Multiline Plot", 
                 plotOutput("linePlot", 
                            height = 700, 
                            width =1000)),
        tabPanel("Small Multiples Plot", 
                 plotOutput("multiPlot", 
                            height = 700, 
                            width =1000)),
        tabPanel("Heat Map", 
                 plotOutput("heatPlot", 
                            height = 700, 
                            width =1000)),
        tabPanel("Stacked", 
                 plotOutput("areaPlot", 
                            height = 700, 
                            width =1200)),
        id="plotType"
      )
    )
  )
)


#selectInput(
#  inputId = "regions", 
#  label = "Show by Region: ",
#  choices = c('All',
#              "England",
#              "Northern Ireland", 
#              "Wales", 
#              "Scotland"), 
#  selected = NULL
#), 