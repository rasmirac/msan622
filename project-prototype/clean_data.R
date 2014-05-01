
library(reshape)

proto_data <- read.csv('clean_data.csv', header = TRUE,  fileEncoding="latin1")



proto_data <- proto_data[, c(2:3, 6, 13:(ncol(proto_data)-5))]

proto_data[4:(ncol(proto_data))] <- apply(proto_data[4:(ncol(proto_data))], 2, function(x){as.numeric(gsub(",","", x))})

colnames(proto_data)[4:(ncol(proto_data))] <- c(seq(1980, 2012))


proto_data$Food.Group <- ifelse((proto_data$Description == 'Carcase meat' | 
                                   proto_data$Description == 'Fish' | 
                                   proto_data$Description == 'Eggs'| 
                                   proto_data$Description == "Non-carcase meat and meat products") & proto_data$Sub.Description == ' ', 'Meat, Fish, and Eggs', NA)

proto_data$Food.Group <- ifelse((proto_data$Description == "Biscuits and crispbreads"  | 
                                   proto_data$Description == "Bread" | 
                                   proto_data$Description == "Flour" | 
                                   proto_data$Description == "Other cereals and cereal products") & proto_data$Sub.Description == ' ', 'Carbohydrates', proto_data$Food.Group)

proto_data$Food.Group <- ifelse((proto_data$Description == "Soft drinks"  | 
                                   proto_data$Description == "Beverages"  | 
                                   proto_data$Description == "Alcoholic drinks" ) & proto_data$Sub.Description == ' ', 'Drinks', proto_data$Food.Group)

proto_data$Food.Group <- ifelse((proto_data$Description == "Cakes, buns and pastries"  | 
                                   proto_data$Description == "Confectionery"  | 
                                   proto_data$Description == "Sugar and preserves" |
                                   proto_data$Description == 'Fats') & proto_data$Sub.Description == ' ', 'Sweets and Fats', proto_data$Food.Group)

proto_data$Food.Group <- ifelse((proto_data$Description == "Cheese"  | 
                                   proto_data$Description == "Milk and milk products excluding cheese") & proto_data$Sub.Description == ' ', 'Dairy', proto_data$Food.Group)

proto_data$Food.Group <- ifelse((proto_data$Description == "Fresh and processed fruit"  |
                                   proto_data$Description == "Fresh and processed potatoes" |
                                   proto_data$Description ==  "Fresh and processed vegetables, excluding potatoes" ) & proto_data$Sub.Description == ' ',
                                'Fruit and Vegetables', proto_data$Food.Group)

proto_data$Food.Group <- ifelse(proto_data$Description == 'Other food and drink' & proto_data$Sub.Description == ' ', 'Other', proto_data$Food.Group)


cat_data <- aggregate(. ~ Food.Group, data=proto_data[,4:ncol(proto_data)], FUN=sum)

molten <- melt(
  proto_data,
  id = c('Description', 'Sub.Description', 'Units', 'Food.Group')
)

molten_group <- melt(
  subset(cat_data, Food.Group != ''),
  id = c('Food.Group')
)

category_data <- subset(molten, Sub.Description == ' ')
