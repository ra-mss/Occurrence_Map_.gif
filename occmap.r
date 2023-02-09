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

##Animar mapa de ocurrencias
##Elige el año, en este caso 2019 y agrega una columna para crear la fecha en formato 'date'
oyster2019<- oysterc %>% 
  filter(year==2019)
oyster2019$date <- as.Date(with(oyster2019, paste(day, month, year, sep = "-")), "%d-%m-%Y")  
oyster2019 %>% 
  arrange(month, day)

#Crea el mapa con las características deseadas, y agrega los puntos utilizando los valores de 'x' y 'y' para las columnas de longitud y latitud, respect 
p <- ggplot()+
  geom_sf(data = world) + theme_dark() + 
  geom_point(data=oyster2019, 
             aes(x = decimalLongitude, y = decimalLatitude, col=month), 
             pch=20, size=2.5) +
  theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
  coord_sf(xlim = c(-30,-170), ylim = c(-57,74)) +
  scale_color_gradient(low = "blue", high = "red") +
  transition_time(date) + 
  labs(title = "Haematopus palliatus ocurrence   ||   Date: {frame_time}")

#Configurar los frames y fps del gif  
animate(p, nframes=365, fps=3)
