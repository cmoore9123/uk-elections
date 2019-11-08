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


date_selection <- filter(con_borders, election == 2017)
  

pal <- colorNumeric(palette = viridis(n = 30),
                    domain = date_selection$electorate,
                    na.color = 'white')

leaflet(date_selection) %>% 
  addTiles() %>% 
  addPolygons(color = ~pal(electorate),
              fillOpacity = 0.4,
              stroke = FALSE,
              highlightOptions = highlightOptions(fillOpacity = 0.5),
              popup = ~paste0(pcon17nm, '<br>',
                              electorate)) %>% 
  addLegend(values = ~electorate,
            pal = pal)
