library(shiny)
library(ggplot2)
library(scales)
library(wordcloud)
library(RColorBrewer)

source('Prototype.r')


shinyServer(function(input, output) {
  
  
  output$barPlot <- renderPlot(
{
  print(my_area_plot)
}
  )


})