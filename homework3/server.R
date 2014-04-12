library(ggplot2)
library(shiny)
library(GGally)
library(scales)
library(grid)

# read in dataframe
df <- data.frame(state.x77, 
                 State = state.name, 
                 Abbrev = state.abb, 
                 Region = as.factor(state.region), 
                 Division = state.division)

# make the column names nice-r
colnames(df)[1:8] <- c("Population",
                          "Income", 
                          "Illiteracy Rate", 
                          "Life Expectancy", 
                          "Murder Rate",  
                          "High School Graduates", 
                          "Frost", 
                          'Area')

# Label formatter for percentages (illiteracy, hs grads)
percentage_formatter <- function(x) {
  return(sprintf("%.1f%%", round(x, 1)))
}

# Create plotting function.
firstPlot <- function(localFrame, colorScheme, xAxis, yAxis) {
  
  # rename columns for use in aes
  localFrame$xAxis <- localFrame[, c(xAxis)]
  localFrame$yAxis <- localFrame[, c(yAxis)]
    
  # find max and mins of specified axis
  minX <- min(localFrame$xAxis) - .02 * min(localFrame$xAxis)
  maxX <- max(localFrame$xAxis) + .02 * max(localFrame$xAxis)
  minY <- min(localFrame$yAxis) - .02 * min(localFrame$yAxis)
  maxY <- max(localFrame$yAxis) + .03 * max(localFrame$yAxis)

  p <- ggplot(localFrame, aes(
    x = xAxis,
    y = yAxis,
    color = Region)) + 
    geom_point(alpha = 0.6, size = 5) + 
    scale_size_continuous(range = c(5,15), guide = 'none') + 
    facet_wrap(~Region, ncol = 2) + 
    # labels
    labs( title = paste(as.character(xAxis),'and',
                        as.character(yAxis),
                        sep = ' '),
          x =  as.character(xAxis),
          y = as.character(yAxis)) + 
    # theme specifications
    theme(strip.text = element_text(size=14)) + 
    theme(legend.position="none") + 
    theme(axis.text.y = element_text(size = 14)) + 
    theme(axis.text.x = element_text(size = 14)) +  
    guides(colour = guide_legend(override.aes = list(size = 8))) + 
    theme(panel.background = element_rect(fill = NA)) + 
    theme(panel.grid.major = element_line(colour = 'gray90')) + 
    theme(panel.margin = unit(.6, "lines"))
  
  # formatting axes
  if (xAxis == 'Illiteracy Rate' | xAxis == 'High School Graduates'){
    p <- p + scale_x_continuous(limits = c(minX, maxX), 
                                expand = c(0, .08* (maxX - minX)), 
                                label = percentage_formatter)
  }
  else{
    p <- p + scale_x_continuous(limits = c(minX, maxX), 
                                expand = c(0, .08* (maxX - minX)))
  }
  
  if (yAxis == 'Illiteracy Rate' | yAxis == 'High School Graduates'){
    p <- p + scale_y_continuous(limits = c(minY, maxY), 
                                label = percentage_formatter)
  }
  else{
    p <- p + scale_y_continuous(limits = c(minY, maxY))
  }
  
  # color specification
  regions <- levels(localFrame$Region)
  my_palette <- brewer_pal(type = "qual", palette = colorScheme)(length(regions))
  p <- p + scale_color_manual(values = my_palette, name = 'Region', limits = regions)
  
  return(p)
}


secondPlot <- function(localFrame, colorScheme, regionsToShow, show_labels, xAxis, yAxis, size_var){
  # all regions for limits
  all_regions <- levels(localFrame$Region)[which(levels(localFrame$Region)!='')]
  
  # rename vars for use in aes()
  localFrame$xAxis <- localFrame[, c(xAxis)]
  localFrame$yAxis <- localFrame[, c(yAxis)]
  localFrame$size_var <- localFrame[, c(size_var)]

  # max and mins for plot axis range
  minX <- min(localFrame$xAxis) - .02 * min(localFrame$xAxis)
  maxX <- max(localFrame$xAxis) + .02 * max(localFrame$xAxis)
  minY <- min(localFrame$yAxis) - .02 * min(localFrame$yAxis)
  maxY <- max(localFrame$yAxis) + .03 * max(localFrame$yAxis)
  
  # subset based on region choice
  if (length(regionsToShow) != 0){
    localFrame <- localFrame[which(localFrame$Region %in% regionsToShow),]
  }
  if (nrow(localFrame) == 0){
    return('Data is empty.')
  }
  
  p <- ggplot(localFrame, aes(
    x = xAxis,
    y = yAxis,
    color = Region,
    size = size_var)) + 
    geom_point(aes(label=Abbrev), alpha = 0.6) + 
    scale_size_continuous(range = c(5,15), guide = 'none') + 
    # labels
    labs( title = paste(as.character(xAxis),
                       as.character(yAxis),
                       paste('and', as.character(size_var), sep = ' '),
                            sep = ', '),
    x = as.character(xAxis),
    y =  as.character(yAxis)) + 
    # theme specifications
    theme(legend.title = element_blank()) + 
    theme(legend.background = element_blank()) + 
    theme(legend.key = element_blank()) + 
    theme(axis.text.y = element_text(size = 14)) + 
    theme(axis.text.x = element_text(size = 14)) + 
    theme(legend.text = element_text(size = 12)) +
    theme(legend.position = 'bottom') + 
    guides(colour = guide_legend(override.aes = list(size = 8))) +
    # add note about circle size
    annotate(
    "text", x = minX + .001*minX , y = maxY ,
    hjust = 0, color = "grey40",
    label = paste("Circle area is proportional to ", tolower(as.character(size_var)), '.', sep = '')) + 
    theme(panel.background = element_rect(fill = NA)) + 
    theme(panel.grid.major = element_line(colour = 'gray90'))  
  
  # add in state labels 
  if (show_labels == TRUE){
    p <- p + geom_text(aes(label=Abbrev), hjust=0, vjust=0, show_guide  = F)
  }
  # formatting axes
  if (xAxis == 'Illiteracy Rate' | xAxis == 'High School Graduates'){
    p <- p + scale_x_continuous(limits = c(minX, maxX), 
                                expand = c(0, .08* (maxX - minX)), 
                                label = percentage_formatter)
  }
  else{
    p <- p + scale_x_continuous(limits = c(minX, maxX), 
                                expand = c(0, .08* (maxX - minX)))
  }
  if (yAxis == 'Illiteracy Rate' | yAxis == 'High School Graduates'){
    p <- p + scale_y_continuous(limits = c(minY, maxY), 
                                label = percentage_formatter)
  }
  else{
    p <- p + scale_y_continuous(limits = c(minY, maxY))
  }
  
  # coloring
  regions <- levels(localFrame$Region)
  my_palette <- brewer_pal(type = "qual", palette = colorScheme)(length(regions))
  p <- p + scale_color_manual(values = my_palette, name = 'Region', limits = all_regions)
  
  return(p)
  
}


last_plot <- function(localFrame, colorScheme, regionsToShow){  
  all_regions <- levels(localFrame$Region)[which(levels(localFrame$Region)!='')]
  p <- ggparcoord(localFrame, 
                  # use all numeric columns
                  columns = 1:8, 
                  # group by Region
                  groupColumn = 11, 
                  # order by order in dataset
                  order = seq(1, 8),
                  showPoints = FALSE,
                  alphaLines = 0.6,
                  shadeBox = NULL,
                  scale = "uniminmax"
  )
  
  # Start with a basic theme
  p <- p + theme_minimal()
  
  # Decrease amount of margin around x, y values
  p <- p + scale_y_continuous(expand = c(0.02, 0.02))
  p <- p + scale_x_discrete(expand = c(0.05, 0.05))
  
  # Remove axis ticks and labels
  p <- p + theme(axis.ticks = element_blank())
  p <- p + theme(axis.title = element_blank())
  p <- p + theme(axis.text.y = element_blank())
  
  # Clear axis lines
  p <- p + theme(panel.grid.minor = element_blank())
  p <- p + theme(panel.grid.major.y = element_blank())
  
  # Darken vertical lines
  p <- p + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))
  
  # Move label to bottom
  p <- p + theme(legend.position = "bottom")
  
  # Figure out y-axis range after GGally scales the data
  min_y <- min(p$data$value)
  max_y <- max(p$data$value)
  pad_y <- (max_y - min_y) * 0.1
  
  # Calculate label positions for each veritcal bar
  lab_x <- rep(1:8, times = 2) # 2 times, 1 for min 1 for max
  lab_y <- rep(c(min_y - pad_y, max_y + pad_y), each = 8)
  
  # Get min and max values from original dataset
  lab_z <- c(sapply(localFrame[, 1:8], min), sapply(localFrame[, 1:8], max))
  
  # Convert to character for use as labels
  lab_z <- as.character(lab_z)
  
  # Add labels to plot
  p <- p + annotate("text", x = lab_x, y = lab_y, label = lab_z, size = 3)
  
  regions <- levels(localFrame$Region) 
  my_palette <- brewer_pal(type = "qual", palette = colorScheme)(length(regions))
  
  if (length(regionsToShow) != 0){
    my_palette[which(!(levels(localFrame$Region) %in% regionsToShow))] <- "gray85"
  }
  
  p <- p + scale_color_manual(values = my_palette, name = 'Region', limits = all_regions)
  
  return(p)
}

##### SHINY SERVER #####

# Create shiny server. Input comes from the UI input
# controls, and the resulting output will be displayed on
# the page.
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  
  localFrame <- df
  
  # subsetting for data table 
  my_data <- reactive({
    if (length(input$regionsToShow) != 0){
      localFrame <- localFrame[which(localFrame$Region %in% input$regionsToShow),]
    }
    if (nrow(localFrame) == 0){
      return('Data is empty.')
    }
    return(localFrame)
  })
    
    
# Output scatter plot small multiples
output$scatterPlot <- renderPlot(
{
  scatterPlot <- firstPlot(
    localFrame,
    input$colorScheme,
    input$xAxis, 
    input$yAxis
  )
  
  print(scatterPlot)
}
)

output$bubblePlot <- renderPlot(
{
  bubblePlot <- secondPlot(
    localFrame, 
    input$colorScheme, 
    input$regionsToShow, 
    input$show_labels, 
    input$xAxis, 
    input$yAxis, 
    input$size_var
  )
  
  print(bubblePlot)
}
)

output$parrPlot <- renderPlot(
{
  parrPlot <- last_plot(
    localFrame, 
    input$colorScheme,
    input$regionsToShow
    
  )
  print(parrPlot)
}
)

output$table <- renderDataTable({
  my_data()}, 
  options = list(sPaginationType = "two_button",
                 sScrollY = "400px",
                 bScrollCollapse = 'true'))
})

