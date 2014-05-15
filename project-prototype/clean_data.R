
library(reshape)


get_data <- function(filename, minyear, ex){
  proto_data <- read.csv(filename, header = TRUE,  fileEncoding="latin1")
  if (ex == T){
    proto_data <- proto_data[, c(2:3, 6, 7:(ncol(proto_data)-5))] 
  }
  else{
    proto_data <- proto_data[, c(2:3, 6, 7:(ncol(proto_data)-2))] 
  }
  proto_data[4:(ncol(proto_data))] <- apply(proto_data[4:(ncol(proto_data))], 2, function(x){as.numeric(gsub(",","", x))})
  
  proto_data[which(proto_data$Description == 'Eggs'), 4:ncol(proto_data)] <- proto_data[which(proto_data$Description == 'Eggs'), 4:ncol(proto_data)]*57
  
  colnames(proto_data)[4:(ncol(proto_data))] <- c(seq(minyear, 2012))
  
  
  
  proto_data$Food.Group <- ifelse(proto_data$Description == 'Carcase meat' | 
                                     proto_data$Description == 'Fish' | 
                                     proto_data$Description == 'Eggs'| 
                                     proto_data$Description == "Non-carcase meat and meat products", 'Meat, Fish, and Eggs', NA)
  
  proto_data$Food.Group <- ifelse(proto_data$Description == "Biscuits and crispbreads"  | 
                                     proto_data$Description == "Bread" | 
                                     proto_data$Description == "Flour" | 
                                     proto_data$Description == "Other cereals and cereal products", 'Carbohydrates', proto_data$Food.Group)
  
  proto_data$Food.Group <- ifelse(proto_data$Description == "Soft drinks"  | 
                                     proto_data$Description == "Beverages"  | 
                                     proto_data$Description == "Alcoholic drinks", 'Drinks', proto_data$Food.Group)
  
  proto_data$Food.Group <- ifelse(proto_data$Description == "Cakes, buns and pastries"  | 
                                     proto_data$Description == "Confectionery"  | 
                                     proto_data$Description == "Sugar and preserves" |
                                     proto_data$Description == 'Fats', 'Sweets and Fats', proto_data$Food.Group)
  
  proto_data$Food.Group <- ifelse(proto_data$Description == "Cheese"  | 
                                     proto_data$Description == "Milk and milk products excluding cheese", 'Dairy', proto_data$Food.Group)
  
  proto_data$Food.Group <- ifelse(proto_data$Description == "Fresh and processed fruit"  |
                                     proto_data$Description == "Fresh and processed potatoes" |
                                     proto_data$Description ==  "Fresh and processed vegetables, excluding potatoes",
                                  'Fruit and Vegetables', proto_data$Food.Group)
  
  proto_data$Food.Group <- ifelse(proto_data$Description == 'Other food and drink', 'Other', proto_data$Food.Group)
  return(proto_data)
}

all_data <- get_data('data/clean_data.csv', 1974, T)

subsetted <- all_data[which(all_data$Sub.Description == ' '), ]
cat_data_all <- aggregate(. ~ Food.Group, data=subsetted[,4:ncol(subsetted)], FUN=sum, na.rm=TRUE, na.action = NULL)
molten <- melt(all_data, id = c('Description', 'Sub.Description', 'Units', 'Food.Group'))
molten_group <- melt(subset(cat_data_all, Food.Group != ''),id = c('Food.Group'))


eng_data <- get_data('data/england_clean.csv', 2001, F)

subsetted <- eng_data[which(eng_data$Sub.Description == ' '), ]
cat_data <- aggregate(. ~ Food.Group, data=subsetted[,4:ncol(subsetted)], FUN=sum)
molten_eng <- melt(eng_data, id = c('Description', 'Sub.Description', 'Units', 'Food.Group'))
molten_group_eng <- melt(subset(cat_data, Food.Group != ''),id = c('Food.Group'))


ire_data <- get_data('data/ireland_clean.csv', 2001, F)

subsetted <- ire_data[which(ire_data$Sub.Description == ' '), ]
cat_data <- aggregate(. ~ Food.Group, data=subsetted[,4:ncol(subsetted)], FUN=sum)
molten_ire <- melt(ire_data, id = c('Description', 'Sub.Description', 'Units', 'Food.Group'))
molten_group_ire <- melt(subset(cat_data, Food.Group != ''),id = c('Food.Group'))


wal_data <- get_data('data/wales_clean.csv', 2001, F)

subsetted <- wal_data[which(wal_data$Sub.Description == ' '), ]
cat_data <- aggregate(. ~ Food.Group, data=subsetted[,4:ncol(subsetted)], FUN=sum)
molten_wal <- melt(wal_data, id = c('Description', 'Sub.Description', 'Units', 'Food.Group'))
molten_group_wal <- melt(subset(cat_data, Food.Group != ''),id = c('Food.Group'))

scot_data <- get_data('data/scotland_clean.csv', 2001, F)

subsetted <- scot_data[which(scot_data$Sub.Description == ' '), ]
cat_data <- aggregate(. ~ Food.Group, data=subsetted[,4:ncol(subsetted)], FUN=sum)
molten_scot <- melt(scot_data, id = c('Description', 'Sub.Description', 'Units', 'Food.Group'))
molten_group_scot <- melt(subset(cat_data, Food.Group != ''),id = c('Food.Group'))

#uk <- map_data('world')
#uk <- uk[which(uk$region == 'UK'), ]

molten_group_scot$country <- 'Scotland'
molten_group_eng$country <- 'England'
molten_group_ire$country <- 'Northern Ireland'
molten_group_wal$country <- 'Wales'
molten_eng$country <- 'England'
molten_scot$country <- 'Scotland'
molten_ire$country <- 'Northern Ireland'
molten_wal$country <- 'Wales'

all_country_group <- rbind(molten_group_scot,
                     molten_group_eng, 
                     molten_group_ire, 
                     molten_group_wal)

all_country <- rbind(molten_scot,
                     molten_eng, 
                     molten_ire, 
                     molten_wal)
