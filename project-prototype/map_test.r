
countries.sp <- readOGR(dsn='map', layer='map')

require(RColorBrewer)
shape2@data$id <- rownames(shape2@data)
sh.df <- as.data.frame(shape2)
sh.fort <- fortify(shape2 , region = "id" )
sh.line<- join(sh.fort, sh.df , by = "id" )


mapdf <- merge( sh.line , data.2 , by.x= "NAME", by.y="NAME" , all=TRUE)
mapdf <- mapdf[ order( mapdf$order ) , ]

ggplot( mapdf , aes( long , lat ) )+
  geom_polygon( aes( fill = cans , group = id ) , colour = "black" )+
  scale_fill_gradientn( colours = brewer.pal( 9 , "Reds" ) )+
  coord_equal()