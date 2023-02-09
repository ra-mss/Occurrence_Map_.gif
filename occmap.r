library(tidyverse)
library(maptools)
library(gganimate)
library(gifski)


oysterc <- read.delim("../ra_mss/Desktop/R_Projects/HPALLIATUS/OSTRERO.csv", row.names = NULL)

#Quitar columnas sin uso
oysterc[, 1:9] <- list(NULL)
oysterc[, 25:41] <- list(NULL)
oysterc[, 15:21] <- list(NULL)
oysterc[, 1:12] <- list(NULL)

#Mapa mundial
data("wrld_simpl")
plot(wrld_simpl)
points(oysterc$decimalLongitude, oysterc$decimalLatitude, col="red", pch=2, cex=0.3)

#Zoom MX
plot(wrld_simpl, xlim=c(-120,-85), ylim=c(14,33), axes=T)
points(oysterc$decimalLongitude, oysterc$decimalLatitude, col="red", pch=2, cex=0.3)

###Mapa de avistamientos 
library(rnaturalearthdata)
library(rnaturalearth)
library(lubridate)
world <- ne_countries(scale = 'medium', type = 'map_units', returnclass = 'sf')

ggplot() +
  geom_sf(data = world) + theme_dark() +
  geom_point(data=oysterc, 
             aes(x = decimalLongitude, y = decimalLatitude, col=year), pch=19, size=0.8) + 
  ggtitle("World Map (rnaturalearth)")+
  coord_sf(xlim = c(-30,-170), ylim = c(-57,74)) 

