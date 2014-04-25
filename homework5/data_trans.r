require(reshape2) # melt

# EXPLORE DATASET #####################

data(Seatbelts)

# creates x-axis for time series
times <- time(Seatbelts)
# fix years
years <- floor(times)
years <- factor(years, ordered = TRUE)

# extract months by looking at time series cycle
cycle(times)        # 1 through 12 for each year


# store month abbreviations as factor
months <- factor(
  month.abb[cycle(times)],
  levels = month.abb,
  ordered = TRUE
)

Seatbelts[, c("kms", "PetrolPrice", "law")]
# MOLTEN DATASET ######################
deaths <- data.frame(
  year   = years,
  month  = months,
  time   = as.numeric(times),
  Driver  = as.numeric(Seatbelts[,c('drivers')]),
  Front   = as.numeric(Seatbelts[,c('front')]),
  Rear = as.numeric(Seatbelts[,c('rear')]), 
  kms = as.numeric(Seatbelts[,c('kms')]), 
  PetrolPrice = as.numeric(Seatbelts[,c('PetrolPrice')]), 
  VanKilled = as.numeric(Seatbelts[,c('VanKilled')]), 
  law = as.factor(Seatbelts[,c('law')])
)

molten <- melt(
  deaths,
  id = c("year", "month", "time")
)



#COOOL. 


