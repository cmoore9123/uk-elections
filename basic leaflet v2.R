library(CmooreFunctions)
library(rgdal)
library(leaflet)
library(sf)
library(viridis)

basicSetup()

results_raw <- read.csv("C:\\Users\\C6728215\\Documents\\WBI\\UK election data\\cleaned results data.csv",
                        stringsAsFactors = FALSE)

con_borders <- readOGR(dsn = 'C:\\Users\\C6728215\\Documents\\WBI\\UK election data\\constituency_borders',
                       'Westminster_Parliamentary_Constituencies_December_2017_Generalised_Clipped_Boundaries_in_the_UK') %>% 
  st_as_sf() %>% 
  st_transform(crs = '+proj=longlat +datum=WGS84 +no_defs') %>% 
  select(constituency_id = pcon17cd, pcon17nm, geometry) %>% 
  merge(results_raw)

con_borders[is.na(con_borders)] <- 0

date_selection <- filter(con_borders, election == 2001) %>% 
  mutate(winner = pmax(con_votes, lib_votes, lab_votes, natSW_votes, oth_votes, na.rm = TRUE),
         winner = ifelse(winner == con_votes, 'conservative',
                         ifelse(winner == lab_votes, 'labour',
                                ifelse(winner == lib_votes, 'lib dem',
                                       ifelse(winner == natSW_votes, 'nationalist',
                                              ifelse(winner == oth_votes, 'other', NA))))))
custpal <-  c('blue', 'red', 'yellow', 'black', 'grey', 'orange')

unique(date_selection$winner)

factpal <- colorFactor(palette = c('blue', 'red', 'yellow', 'black', 'grey', 'orange'),
                      levels =  c("conservative","labour","lib dem",NA, 'other',"nationalist"))

leaflet(date_selection) %>% 
  addTiles() %>% 
  addPolygons(color = ~factpal(winner),
              fillOpacity = 0.7,
              stroke = FALSE,
              highlightOptions = highlightOptions(fillOpacity = 0.8),
              popup = ~paste0(pcon17nm, '<br>',
                              winner)) 
