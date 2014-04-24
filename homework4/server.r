library(shiny)
library(ggplot2)
library(scales)
library(wordcloud)
library(RColorBrewer)

source('text.r')

my_pallete <- brewer_pal(type = "qual", palette = 'Dark2')(1)

getPlot <- function(text_data, whichtoshow, wordsBar, book) {
  text_data <- head(text_data, wordsBar)
  text_data$word <- factor(text_data$word, 
                        levels = text_data$word, 
                        ordered = TRUE)
  p <- ggplot(text_data, aes(x = word, y = value)) +
    geom_bar(stat = "identity", fill = my_pallete, alpha = .85) +
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, max(text_data$value) + 50)) + 
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          panel.grid.major.x = element_blank(), 
          panel.grid.minor.y = element_blank(), 
          axis.ticks.x = element_blank(), 
          axis.text.y = element_text(size = 14),
          axis.text.x = element_text(size = 13), 
          title = element_text(size = 16)) 
  if (book == 'nocountry'){
    p <- p + ggtitle(paste('Word Frequencies for No Country for Old Men', paste('(', whichtoshow,')', sep =''), sep = ' '))
  }
  else if (book == 'prideandprej'){
    p <- p + ggtitle(paste('Word Frequencies for Pride and Prejudice', paste('(', whichtoshow,')', sep =''), sep = ' '))
  }
  else if (book == 'fightclub'){
    p <- p + ggtitle(paste('Word Frequencies for Fight Club', paste('(', whichtoshow,')', sep =''), sep = ' '))
  }
  
  return(p) 
}


getScPlot <- function(text_data, whichtoshow, book) {
  text_data <- data.frame(
    novel = text_data[which(text_data$variable == 'book'),],
    screenplay = text_data[which(text_data$variable == 'screenplay'),],
    stringsAsFactors = FALSE)
  
  text_data <- text_data[(text_data$novel.value > 75 & text_data$screenplay.value > 75),]
  p <- ggplot(text_data, aes(novel.value, screenplay.value))
  
  p <- p + geom_text(
    aes(label = novel.word), size = 7,
    position = position_jitter(
      width = 10,
      height = 10), color = my_pallete)
  
  p <- p + xlab("Novel") + ylab("Screenplay")
  p <- p + ggtitle("Screenplay vs. Novel")
  p <- p + scale_x_continuous(expand = c(0, 25))
  p <- p + scale_y_continuous(expand = c(0, 25))
  p <- p + theme(title = element_text(size = 16), 
                 panel.grid.major.x = element_blank(), 
                 panel.grid.major.y = element_blank())
  if (book == 'nocountry') {
    p <- p + ggtitle('No Country for Old Men: Screenplay vs. Novel')
  }
  else if (book == 'prideandprej') {
    p <- p + ggtitle('Pride and Prejudice: Screenplay vs. Novel')
  }
  else if (book == 'fightclub') {
    p <- p + ggtitle('Fight Club: Screenplay vs. Novel')
  }

  
  return(p)
  
}


shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  my_data <- reactive({
    if (input$book == 'nocountry'){
    localFrame <- text_n
    }
    else if (input$book == 'prideandprej'){
      localFrame <- text_p
    }
    else if (input$book == 'fightclub'){
      localFrame <- text_f
    }
    if (input$whichtoshow == 'Screenplay'){
      text_data <- localFrame[which(localFrame$variable == 'screenplay'),]
    }
    else if (input$whichtoshow == 'Novel'){
      text_data <- localFrame[which(localFrame$variable == 'book'),]
    }
    return(text_data)
  })

  output$barPlot <- renderPlot(
{

  data <- my_data()
  # Use our function to generate the plot.
  barPlot <- getPlot(
    data,
    input$whichtoshow, 
    input$wordsBar, 
    input$book
  )
  # Output the plot
  print(barPlot)
}
  )

output$scatterPlot <- renderPlot(
{
  
  if (input$book == 'nocountry'){
    localFrame <- text_n
  }
  else if (input$book == 'prideandprej'){
    localFrame <- text_p
  }
  else if (input$book == 'fightclub'){
    localFrame <- text_f
  }
  # Use our function to generate the plot.
  scatterPlot <- getScPlot(
    localFrame,
    input$whichtoshow, 
    input$book
  )
  # Output the plot
  print(scatterPlot)
}
)

output$wordCloud <- renderPlot({
  
  wordcloud(
    my_data()$word,
    my_data()$value,
    scale = c(8, 2),      # size of words
    min.freq = 25,          # drop infrequent
    max.words = 75, # max words in plot
    random.order = FALSE,   # plot by frequency
    rot.per = 0,          # percent rotated
    # set colors
    # colors = brewer.pal(9, "GnBu")
    colors = brewer.pal(8, "Dark2"),
    # color random or by frequency
    random.color = FALSE

  )
})

})