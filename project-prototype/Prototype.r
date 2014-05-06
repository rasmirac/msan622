library(ggplot2) 
library(scales)
library(reshape)
library(grid)

source('clean_data.R')

scale_units <- function() {
  return (
    scale_y_continuous(
      name = "Units in Grams, average per person",
      # set nice limits and breaks
      limits = c(0, 3750),
      expand = c(0, 0),
      breaks = seq(0, 3750, 1000),
      # reduce label space required
      labels = function(x) {paste0(x / 1000, 'k')}
    )    
  )
}

scale_year <- function() {
  return(
    scale_x_date(
      name = "Year",
      # using 1980 will result in gap
      limits = c(as.Date('1974', '%Y'), as.Date('2012', '%Y')),
      breaks = seq(as.Date('1974', '%Y'),by='5 years', length=17),
      expand = c(0, 0), 
      labels = function(x) {as.numeric(format(x, '%Y'))}
    )
  )
}


molten_group$Food.Group <- factor(molten_group$Food.Group, levels = c('Carbohydrates', 
                                                              'Dairy', 
                                                              'Drinks', 
                                                              'Fruit and Vegetables', 
                                                              'Meat, Fish, and Eggs', 
                                                              'Sweets and Fats', 'Other'))

my_area_plot <- ggplot(molten_group, aes(x = as.Date(variable, '%Y'), y = as.numeric(gsub(",","", value)), color = as.factor(Food.Group))) + 
  geom_line(size = .9) + 
  xlab('Year') + 
  scale_year() + scale_units() + 
  scale_color_brewer(palette = 'Dark2', name = 'Food Group') + 
  ggtitle('UK Household Purchases by Food Group, 1980-2012')
