library(ggplot2)
require(reshape2)
require(grid)
require(scales)
library(ggplot2)


source("data_trans.r")
source("make_pretty.r")

my_palette <- 'Dark2'

area_data <- subset(molten, 
                    variable != "kms" & 
                      variable != 'law' & 
                      variable != 'VanKilled' & 
                      variable != 'PetrolPrice')
law_enacted <- min(molten$year[which(molten$variable=='law' & molten$value == 1)])
my_pallete <- brewer_pal(type = "qual", palette = my_palette)(5)


# looks good. check if its possible to change height of vline
my_area_plot <- ggplot(area_data, aes(x = time, y = as.numeric(value))) + 
  geom_area(
    aes(group = variable,
      fill = variable,
      # not really necessary
      # swap stacking order
      order = -as.numeric(variable)
      ) 
  ) + 
  geom_vline(x = 1983, color =  my_pallete[4], size = 1) +
  scale_year() + 
  scale_deaths() + 
  theme_legend() + 
  coord_fixed(ratio = 2 / 1000) + 
  scale_fill_brewer(palette = my_palette, name = 'Position in Vehicle') + 
  annotate(
    "text", x = 1969.5 , y = 4400 ,
    hjust = 0, color = "grey40", size = 5,
    label = "Vertical bar indicates when seatbelt law was enacted.") + 
  ggtitle('Automobile Deaths in UK, 1969 - 1985') + 
  theme(axis.text.x = element_text(size = 12), axis.text.y = element_text(size = 12)) + 
  ggsave(filename = 'area.png', width = 13, height = 10)


deaths$Total <- deaths$Driver + deaths$Front + deaths$Rear
heat_data <- melt(
  deaths,
  id = c("year", "month", "time")
)

heat_data <- subset(heat_data, variable == 'Total')

my_heat_map <- ggplot(
  subset(heat_data, variable == "Total"), 
  aes(x = year, y = month)
) + geom_tile(
  aes(fill = as.numeric(value)), 
  colour = "white"
) + scale_prgn() + 
  scale_months() + 
  scale_y_discrete(expand = c(0, 0)) + 
  theme_heatmap() + coord_fixed(ratio = 1) + 
  ggtitle('Automobile Deaths in the UK, 1969 - 1984') + 
  ggsave(filename = 'heatmap.png', height = 7, width = 9)



names(deaths)[4:8] <- c('Driver Deaths', 
                        'Front Passenger Deaths', 
                        'Rear Passenger Deaths', 
                        'Kilometers Traveled', 
                        'Petrol Price')
names(deaths)[11] <- c('Total Deaths')

multi_data <- melt(
  deaths,
  id = c("year", "month", "time", 'law')
)

multi_data <- subset(multi_data, variable != 'VanKilled' & variable != 'law')
multi_data$variable <- factor(multi_data$variable, levels = c('Total Deaths', 
                                                              'Driver Deaths', 
                                                              'Front Passenger Deaths', 
                                                              'Rear Passenger Deaths', 
                                                              'Kilometers Traveled', 
                                                              'Petrol Price'))

p <- ggplot(subset(multi_data, variable != 'Kilometers Traveled' & variable != 'Petrol Price'), 
  aes(
    x = time, 
    y = as.numeric(value), 
    #group = variable, 
    color = variable
  )) +
  facet_wrap(~variable, ncol = 2) +
  geom_line(alpha = 0.8, size = .8) +
  scale_colour_brewer(palette = my_palette) + 
  coord_fixed(ratio = 2 / 1000) + 
  scale_year() + scale_deaths() + guides(color=FALSE) + theme(panel.margin = unit(.6, "lines")) + 
  ggtitle('Breakdown of Automobile Deaths by Vehicle Position') + 
  ggsave(filename = 'small_multi.png', height = 10, width = 14)

