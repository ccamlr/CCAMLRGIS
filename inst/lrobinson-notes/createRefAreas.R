# create a new spatial polygon dataframe for Reference Areas for toothfish local biomass estimation

library(rgeos)
library(rgdal)
library(maptools)
library(CCAMLRGIS)


SSRUs<- load_SSRUs("GEOJSON")

RSR_open <- SSRUs[SSRUs$GAR_Short_Label%in%c("881B","881C","881G","881H","881I","881J","881K","881L"),] 

# # Generate IDs for grouping
RSR_open_id<- rep(1,length(RSR_open$id))

RSR_open_merge=unionSpatialPolygons(RSR_open,IDs=RSR_open_id)
RSR_open<- RSR_open_merge
RSR_open$name <- "RSR_open"

# add HIMI ref area

EEZs<-load_EEZs("GEOJSON")
HIMI <- EEZs[EEZs$GAR_Short_Label%in%"HIMI",]

ASDs<- load_ASDs("GEOJSON")
ASD_5852<- ASDs[ASDs$GAR_Short_Label%in%"5852",]

HIMI_EEZ_ASD_intersection <- gIntersection(HIMI,ASD_5852)
HIMI_EEZ_ASD_intersection$name <-"HIMI"
RefAreas=rbind(RSR_open,HIMI_EEZ_ASD_intersection,makeUniqueIDs=TRUE)


save(RefAreas,file="data/RefAreas.rda")
# updated data in package
devtools::use_data(RefAreas, overwrite = TRUE)

# - size of data reduced, not enough
tools::resaveRdaFiles("data", compress = "auto")


