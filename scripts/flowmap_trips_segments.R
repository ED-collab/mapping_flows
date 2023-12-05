#Plotting origins and destinations using coordinates and ggplot
#https://jcheshire.com/visualisation/mapping-flows/
#Note that this approach does not construct an igraph object, it is just ggplot-based segments

library(tidyverse)
library(readxl)
library(sf)
library(ggspatial) #for adding north arrow, scale bar

#our exchange input
inputAll <-
  read_excel("D:/Dropbox/Trader drafts/trader_exchange_data.xlsx")

#Add relevant shapefiles####
#National boundaries (to layer on darker)
shpLA0 <-
  read_sf(dsn = file.path(
    "D:/Geospatial_Data/Laos/Lao_Adm_2015/lao_bnd_admin0_ngd2018.shp"))
shpKH0 <-
  read_sf(dsn = file.path("D:/Geospatial_Data/Cambodia/KHM_adm0.shp"))
shpTH0 <-
  read_sf(dsn = file.path("D:/Geospatial_Data/Thailand/THA_adm0.shp"))
shpVN0 <-
  read_sf(dsn = file.path("D:/Geospatial_Data/Vietnam/VNM_adm0.shp"))

#Province boundaries (default lighter and thinner suits this application fine)
shpVN <-
  read_sf(dsn = file.path("D:/Geospatial_Data/Vietnam/VNM_adm1.shp"))
shpLA <-  read_sf(dsn = file.path("D:/Geospatial_Data/Laos/Lao_Adm_2015/lao_bnd_admin1_ngd2018.shp"))
shpKH <-
  read_sf(dsn = file.path("D:/Geospatial_Data/Cambodia/KHM_adm1.shp"))
shpTH <-
  read_sf(dsn = file.path("D:/Geospatial_Data/Thailand/THA_adm1.shp"))


#Ngoc's case ####
inputNgoc <-
  read_excel("D:/Dropbox/Trader drafts/trader_exchange_data.xlsx") %>%
  filter(case =='Ngoc')

#Plot. Set linewidths to make national boundaries pop; remove fill on province to avoid overlap
ggplot() +
  geom_sf(data = shpLA0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpKH0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpVN0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpTH0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpVN, fill = NA) +
  geom_sf(data = shpKH, fill = NA) +
  geom_sf(data = shpTH, fill = NA) +
  geom_sf(data = shpLA, fill = NA) +
  geom_curve(
    data = inputNgoc,
    aes(
      x = ox,
      y = oy,
      xend = dx,
      yend = dy,
      color = type,
      alpha = 0.95,
      size = amount
    ),
    curvature = 0.2,
    arrow = arrow(length = unit(10, "pt"), type = "open"),
  ) +
  theme_void()

#Se's case - recycle the code####
inputSe <-
  read_excel("D:/Dropbox/Trader drafts/trader_exchange_data.xlsx") %>%
  filter(case =='Se')
ggplot() +
  geom_sf(data = shpLA0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpKH0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpVN0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpTH0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpVN, fill = NA) +
  geom_sf(data = shpKH, fill = NA) +
  geom_sf(data = shpTH, fill = NA) +
  geom_sf(data = shpLA, fill = NA) +
  geom_curve(
    data = inputSe,
    aes(
      x = ox,
      y = oy,
      xend = dx,
      yend = dy,
      color = type,
      alpha = 0.95,
      size = amount
    ),
    curvature = 0.2,
    arrow = arrow(length = unit(10, "pt"), type = "open"),
  ) +
  theme_void()

#Yan's case - recycle the code####
inputYan <-
  read_excel("D:/Dropbox/Trader drafts/trader_exchange_data.xlsx") %>%
  filter(case =='Yan')
ggplot() +
  geom_sf(data = shpLA0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpKH0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpVN0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpTH0,
          linewidth = 1,
          color = 'black') +
  geom_sf(data = shpVN, fill = NA) +
  geom_sf(data = shpKH, fill = NA) +
  geom_sf(data = shpTH, fill = NA) +
  geom_sf(data = shpLA, fill = NA) +
  geom_curve(
    data = inputSe,
    aes(
      x = ox,
      y = oy,
      xend = dx,
      yend = dy,
      color = type,
      alpha = 0.95,
      size = amount
    ),
    curvature = 0.2,
    arrow = arrow(length = unit(10, "pt"), type = "open"),
  ) +
  theme_void()


#All together now####
#Let's first set up four points to represent our producers
traders <- data.frame(
  longitude = c(106.171,
                105.277,
                103.045,
                102.370),
  latitude = c(11.553,
               12.316,
               13.728,
               13.433),
  name = c('Ngoc',
           'Se',
           'Yan',
           'BCA')
)

#Trim the plotted area with coord_sf
#Make the country borders a little thicker
#Use ggspatial to add scale bar and North arrow

ggplot() +
  geom_sf(data = shpLA0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpKH0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpVN0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpTH0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpVN, fill = NA) +
  geom_sf(data = shpKH, fill = NA) +
  geom_sf(data = shpTH, fill = NA) +
  geom_sf(data = shpLA, fill = NA) +
  geom_curve(
    data = inputAll,
    aes(
      x = ox,
      y = oy,
      xend = dx,
      yend = dy,
      color = type,
      alpha = 0.95,
      size = amount
    ),
    curvature = 0.2,
    arrow = arrow(length = unit(10, "pt"), type = "open"),
  ) +
  #geom_point(data = traders, aes(x = longitude, y = latitude), size = 4,
  #          shape = 23, fill = "darkred")+
  geom_text(data = traders,
            aes(x = longitude, y = latitude, label = name),
            size = 5) +
  coord_sf(xlim = c(100, 110), ylim = c(10, 20)) + theme_void() +
  annotation_scale(
    location = "tr",
    width_hint = 0.3,
    pad_y = unit(0.25, "in")
  ) +
  annotation_north_arrow(
    location = "tr",
    which_north = "true",
    pad_x = unit(0.5, "in"),
    pad_y = unit(0.75, "in"),
    style = north_arrow_fancy_orienteering
  )

#Can use the single datasheet and facet by case####

#inputAll <-
#  read_excel("D:/Dropbox/Trader drafts/trader_exchange_data.xlsx")

#Create a plot including all the curves from all cases
P <- ggplot() +
  geom_sf(data = shpLA0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpKH0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpVN0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpTH0,
          linewidth = 1.2,
          color = 'black') +
  geom_sf(data = shpVN, fill = NA) +
  geom_sf(data = shpKH, fill = NA) +
  geom_sf(data = shpTH, fill = NA) +
  geom_sf(data = shpLA, fill = NA) +
  geom_curve(
    data = inputAll,
    aes(
      x = ox,
      y = oy,
      xend = dx,
      yend = dy,
      color = type,
      alpha = 0.95,
      size = amount
    ),
    curvature = 0.2,
    arrow = arrow(length = unit(10, "pt"), type = "open"),
  ) +
  #geom_point(data = traders, aes(x = longitude, y = latitude), size = 4,
  #          shape = 23, fill = "darkred")+
  #geom_text(data = traders, aes(x = longitude, y = latitude, label=name), size=5)+
  coord_sf(xlim = c(100, 110), ylim = c(10, 20)) + 
  theme_void() +
  annotation_scale(
    location = "tr",
    width_hint = 0.3,
    pad_y = unit(0.25, "in")
  ) +
  annotation_north_arrow(
    location = "tr",
    which_north = "true",
    pad_x = unit(0.5, "in"),
    pad_y = unit(0.75, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  theme(strip.placement = "outside",
        strip.text.x =  element_text(
          angle = 0,
          vjust = 1.5,
          size = 12
        ))

#Wrap facet
P + facet_wrap(vars(case), ncol=2)

#ggsave("D:/Dropbox/Trader drafts/traders.pdf", width = 190, height = 80, units = "mm")
