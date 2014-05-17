library(shiny)
library(ggplot2)
library(scales)
library(wordcloud)
library(RColorBrewer)
library(reshape)
library(grid)


source('clean_data.R')

scale_units <- function(y) {
  max =  max(y, na.rm = T)
  if (max <1000){
    breaks = seq(0, max+.1*max, 200)
  }
  else if (max <= 1500){
    breaks = seq(0, max+.1*max, 500)
  }
  else{
    breaks = seq(0, max+max*.1, 1000)
  }
  return (
    scale_y_continuous(
      name = "Units (grams)",
      # set nice limits and breaks
      limits = c(0, max+max*.1),
      expand = c(0, 0),
      breaks = breaks,
      # reduce label space required
      labels = function(x) {paste0(x / 1000, 'k')}
    )    
  )
}

scale_year <- function(mini, maxi) {
  return(
    scale_x_date(
      name = " ",
      limits = c(as.Date(mini, '%Y'), as.Date(maxi, '%Y')),
      breaks = seq(as.Date(mini, '%Y'), by='5 years', length=17),
      expand = c(0, 0), 
      labels = function(x) {as.numeric(format(x, '%Y'))}
    )
  )
}

scale_prgn <- function(mini, maxi) {
  return(
    scale_fill_gradientn(
      colours = brewer_pal(
        type = "seq", 
        palette = 'RdPu')(9),
      name = "Units in Grams",
      limits = c(0, maxi),
      breaks = seq(0, maxi, 500), 
      labels = function(x) {paste0(x / 1000, 'k')}
    )
  )
}


theme_heatmap <- function() {
  return (
    theme(
      axis.text.y = element_text(size = 12.5,
        angle = 0,
        hjust = 0.5),
      legend.key.width = unit(2, "cm"), 
      legend.text = element_text(size = 11),
      legend.title = element_text(size = 12.5),
      axis.text.x = element_text(size = 12.5),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      #legend.title = element_blank(), 
      legend.direction = "horizontal",
      legend.position = "bottom",
      panel.background = element_blank()
    )
  )
}



molten_group$Food.Group <- factor(molten_group$Food.Group, levels = c('Carbohydrates', 
                                                                      'Dairy', 
                                                                      'Drinks', 
                                                                      'Fruit and Vegetables', 
                                                                      'Meat, Fish, and Eggs', 
                                                                      'Sweets and Fats', 'Other'))


linePlot <- function(localFrame, expandGroup, range) {
  localFrame <- subset(localFrame, as.numeric(variable) <= range[2] | as.numeric(variable) >= range[1])
  mini <- as.character(range[1])
  maxi <- as.character(range[2])
  if (expandGroup != 'None'){
    localFrame <- subset(localFrame, Food.Group == expandGroup & Sub.Description == ' ')
    line_plot <- ggplot(localFrame, 
                        aes(x = as.Date(variable, '%Y'), 
                            y = as.numeric(gsub(",","", value)), 
                            color = as.factor(Description))) + 
      geom_line(size = .95) + scale_year(mini, maxi) + 
      scale_units(as.numeric(gsub(",","", localFrame$value))) + 
      theme(
        legend.direction = "horizontal",
        legend.position = c(1, 1),
        legend.justification = c(1, 1),
        legend.text = element_text(size = 12.5), 
        legend.title = element_text(size = 12.5), 
        legend.background = element_blank(),
        legend.key = element_blank(),
        axis.text = element_text(size = 12.5), 
        title = element_text(size = 14), 
        panel.background = element_rect(fill = NA), 
        panel.grid.major = element_line(colour = 'gray90')) + 
      scale_color_brewer(palette = 'Dark2', name = ' ') + 
      ggtitle('UK Household Purchases per Person, 1974-2012')
    if (expandGroup == 'Drinks'){
      line_plot <- line_plot + annotate(
        "text", x = as.Date(mini, '%Y'), y = 60,
        hjust = 0, color = "grey40", size = 5,
        label = "Complete beverage data is not available before 1992.")
    }
    return(line_plot)
  }
  
  else {
    localFrame <- subset(localFrame, Food.Group != 'Drinks' | as.Date(variable, '%Y') > as.Date('1992', '%Y'))
    line_plot <- ggplot(localFrame, aes(x = as.Date(variable, '%Y'), 
                                        y = as.numeric(gsub(",","", value)), 
                                        color = as.factor(Food.Group))) + 
      geom_line(size = .9) + 
      xlab(' ') + 
      scale_units(as.numeric(gsub(",","", localFrame$value))) + scale_year(mini, maxi) +
      scale_color_brewer(palette = 'Dark2', name = ' ') + 
      ggtitle('UK Household Purchases per Person, 1974-2012') + 
      theme(
        legend.direction = "horizontal",
        legend.position = c(1, 1),
        legend.justification = c(1, 1),
        legend.text = element_text(size = 12.5), 
        legend.title = element_text(size = 12.5), 
        legend.background = element_blank(),
        legend.key = element_blank(), 
        axis.text = element_text(size = 12.5), 
        title = element_text(size = 14), 
        panel.background = element_rect(fill = NA), 
        panel.grid.major = element_line(colour = 'gray90')) + 
      annotate(
        "text", x = as.Date(mini, '%Y'), y = 60,
        hjust = 0, color = "grey40", size = 5,
        label = "Complete beverage data is not available before 1992.")

    return(line_plot)
  }

}

smPlot <- function(localFrame, expandGroup) {     
  if (expandGroup != 'None' & expandGroup != 'Other'){
    localFrame <- subset(localFrame, Food.Group == expandGroup & Sub.Description == ' ')
    line_plot <- ggplot(localFrame, aes(x = as.Date(variable, '%Y'), 
                                        y = as.numeric(gsub(",","", value)), 
                                        color = as.factor(Description))) + 
      geom_line(size = .95) + 
      facet_wrap(~country, ncol = 2) + 
      # labels
      # theme specifications
      theme(strip.text = element_text(size=14)) + 
      theme(legend.position="bottom") + 
      theme(axis.text.y = element_text(size = 12.5),
            axis.text.x = element_text(size = 12.5),  
            axis.text = element_text(size = 12.5), 
            title = element_text(size = 12.5), 
            legend.text = element_text(size = 12.5)) +  
      guides(color = guide_legend(override.aes = list(size = .95))) + 
      theme(panel.background = element_rect(fill = NA)) + 
      theme(panel.grid.major = element_line(colour = 'gray90')) + 
      theme(panel.margin = unit(.6, "lines")) + 
      scale_color_brewer(palette = 'Dark2', name = ' ') + 
      scale_units(as.numeric(gsub(",","", localFrame$value))) + 
      xlab(' ') 
    # color specification 
    return(line_plot)
  }
  else {

    line_plot <- ggplot(localFrame, aes(x = as.Date(variable, '%Y'), 
                                        y = as.numeric(gsub(",","", value)), 
                                        color = as.factor(Food.Group))) + 
        geom_line(size = .95) + 
        facet_wrap(~country, ncol = 2) + 
        # labels
        # theme specifications
        theme(axis.text.y = element_text(size = 12.5),
              axis.text.x = element_text(size = 12.5),  
              axis.text = element_text(size = 12.5), 
              title = element_text(size = 12.5), 
              legend.text = element_text(size = 12.5)) + 
        theme(legend.position="bottom") +  
        guides(color = guide_legend(override.aes = list(size = .95))) + 
        theme(panel.background = element_rect(fill = NA)) + 
        theme(panel.grid.major = element_line(colour = 'gray90')) + 
        theme(panel.margin = unit(.6, "lines")) + 
      scale_color_brewer(palette = 'Dark2', name = ' ') + 
      scale_units(as.numeric(gsub(",","", localFrame$value))) + 
      xlab(' ') 
      # color specification 
      return(line_plot)
  }
  
}


heatPlot <- function(localFrame, group, facet) {  
  if (facet == F){
    localFrame <- subset(localFrame, Food.Group == group)
    mini <- min(localFrame$value)
    maxi <- max(localFrame$value)
    my_heat_map <- ggplot(localFrame, aes(x = as.Date(variable, '%Y'), y = country)) + 
      geom_tile(aes(fill = as.numeric(value)), colour = "white") + 
      scale_prgn(mini, maxi) + 
      scale_y_discrete(expand = c(0, 0)) + 
      theme_heatmap() + 
      ggtitle(paste('Units of', group,'Purchased per person by Country, 2001 - 2012', ' ')) + 
      scale_x_date(
        name = "Year",
        limits = c(as.Date('2001', '%Y'), as.Date('2012', '%Y')),
        breaks = seq(as.Date('2001', '%Y'),as.Date('2012', '%Y'), by='1 years'),
        labels = function(x) {as.numeric(format(x, '%Y'))})
    
      
    return(my_heat_map)
  }
  else{
    localFrame <- subset(localFrame, Food.Group == group)
    mini <- min(localFrame$value)
    maxi <- max(localFrame$value)
    my_heat_map <- ggplot(localFrame, aes(x = as.Date(variable, '%Y'), y = country)) + 
      geom_tile(aes(fill = as.numeric(value)), colour = "white") + 
      scale_prgn(mini, maxi) + 
      scale_y_discrete(expand = c(0, 0)) + facet_wrap(~Description, ncol = 2) + 
      theme_heatmap() + 
      ggtitle(paste('Units of', group,'Purchased per person by Country, 2001 - 2012', ' ')) + 
      scale_x_date(
        name = "Year",
        limits = c(as.Date('2001', '%Y'), as.Date('2012', '%Y')),
        breaks = seq(as.Date('2001', '%Y'),as.Date('2012', '%Y'), by='1 years'),
        labels = function(x) {as.numeric(format(x, '%Y'))})
    
    
    return(my_heat_map)
  }
}

areaPlot <- function(localFrame, showCountry) { 
  if (showCountry != 'All UK'){
    localFrame <- subset(localFrame, country == showCountry)
  }
  
  my_area_plot <- ggplot(subset(localFrame, as.Date(as.character(variable), '%Y') >= as.Date('1992', '%Y')), 
                         aes(x = as.Date(variable, '%Y'), 
                             y = as.numeric(gsub(",","", value)))) + 
    scale_y_continuous(
      name = "Units (grams)",
      # set nice limits and breaks
      limits = c(0, 13700),
      expand = c(0, 0),
      breaks = c(seq(0, 13700, 2000)),
      # reduce label space required
      labels = function(x) {paste0(x / 1000, 'k')}) + 
    #  coord_fixed(ratio = 2 / 1000) + 
    scale_fill_brewer(palette = 'Dark2', name = 'Food Group') + 
    theme(
      legend.direction = "horizontal",
      legend.position = c(1, 1),
      legend.justification = c(1, 1),
      legend.text = element_text(size = 12.5), 
      legend.title = element_text(size = 12.5), 
      legend.background = element_blank(),
      legend.key = element_blank(), 
      axis.text = element_text(size = 12.5), 
      title = element_text(size = 14), 
      panel.background = element_rect(fill = NA), 
      panel.grid.major = element_line(colour = 'gray90')) + 
    ggtitle('Food Purchases in UK, 1974 - 2012') + 
    theme(axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12))
  if (showCountry != 'All UK'){
    my_area_plot <- my_area_plot + scale_year('2002', '2012') + coord_fixed(ratio = .75/5) + 
      geom_area(
        aes(group = Food.Group,
            fill = Food.Group,
            # not really necessary
            # swap stacking order
            order = -as.numeric(as.factor(Food.Group))), alpha = .90 
      ) 
  }
  else{
    my_area_plot <- my_area_plot + scale_year('1992', '2012') + coord_fixed(ratio = 1.5/5) + 
      geom_area(
        aes(group = Food.Group,
            fill = Food.Group,
            order = -as.numeric(as.factor(Food.Group))), alpha = .90 
      ) 
  }
  return(my_area_plot)
}

shinyServer(function(input, output) {
  
  output$linePlot <- renderPlot(
{
  localFrame <- molten_group
  if (input$expandGroup != 'None'){
    localFrame <- molten
  }
  linePlot <- linePlot(
    localFrame,
    input$expandGroup, 
    input$range
  )
  print(linePlot)
}
  )

output$multiPlot <- renderPlot(
{
  localFrame <- all_country_group
  if (input$expandGroupM != 'None'){
    localFrame <- all_country
  }
  multiPlot <- smPlot(
    localFrame, 
    input$expandGroupM
  )
  print(multiPlot)
}
)

output$heatPlot <- renderPlot(
{
  localFrame <- all_country_group
  if (input$facet == T){
    localFrame <- subset(all_country, Sub.Description == ' ')
  }
  heatPlot <- heatPlot(
    localFrame, 
    input$group, 
    input$facet
  )
  print(heatPlot)
}
)

output$areaPlot <- renderPlot(
{
  localFrame <- molten_group
  if (input$country != 'All UK'){
    localFrame <- all_country_group
  }
  areaPlot <- areaPlot(
    localFrame, 
    input$country
  )
  print(areaPlot)
}
)


})


