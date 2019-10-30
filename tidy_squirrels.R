library(tidyverse)
library(readr)

squirrels <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-29/nyc_squirrels.csv")


bravest_colour <- squirrels[!is.na(squirrels$primary_fur_color),] %>% 
  filter(approaches==T|indifferent==T|runs_from==T)

bravest_colour$runs_from <- gsub(T, "runs_from",bravest_colour$runs_from)
bravest_colour$runs_from <- gsub(F, "",bravest_colour$runs_from)
bravest_colour$indifferent <- gsub(T, "indifferent",bravest_colour$indifferent)
bravest_colour$indifferent <- gsub(F, "",bravest_colour$indifferent)
bravest_colour$approaches <- gsub(T, "approaches",bravest_colour$approaches)
bravest_colour$approaches <- gsub(F, "",bravest_colour$approaches)


bravest_colour <- bravest_colour %>% 
  mutate(behaviour=paste(bravest_colour$approaches,bravest_colour$indifferent,bravest_colour$runs_from))
bravest_colour$behaviour <- str_trim(bravest_colour$behaviour, side="left")
bravest_colour$behaviour<- gsub(' .*', '',bravest_colour$behaviour)

only_approach <- bravest_colour %>% 
  filter(behaviour=="approaches")

library(leaflet)

squirrel_icon <- makeIcon(
  iconUrl = "https://cdn0.iconfinder.com/data/icons/mammals-3/50/Animals_Colored-44-512.png",
  iconWidth = 38, iconHeight = 60,
  iconAnchorX = 20, iconAnchorY = 30)


map <- leaflet(data = only_approach) %>%
  addTiles() %>%
  addMarkers(~long, ~lat, icon = squirrel_icon, label=~primary_fur_color)
map
