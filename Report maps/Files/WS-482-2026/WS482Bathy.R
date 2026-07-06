library(CCAMLRGIS)
library(terra)

#Script to clip the bathymetry to the region of interest, and generate a polygon from an isobath
Bathy=rast("I:/Science/Projects/GEBCO/2025/Processed/GEBCO2025_500.tif") #Download the bathymetry file from https://github.com/ccamlr/data

#Get Subareas
ASDs=load_ASDs()
ASDs=ASDs[ASDs$GAR_Long_Label%in%c("48.1","48.2","48.3","48.4","48.5"),]
#Get bounding box (x/y limits)
bb=st_bbox(ASDs) 
#Crop bathy to region of interest
bathy=crop(Bathy,ext(bb))
#Export file
writeRaster(bathy, "Report maps/ExternalFiles/Bathy482.tif",overwrite=TRUE)

#Get contour
Iso400=get_iso_polys(bathy,Cuts=c(-400,10000))
Iso400=st_union(Iso400)
#Export file
st_write(Iso400,"Report maps/Files/WS-482-2026/Iso400.gpkg")


plot(bathy)
plot(st_geometry(Iso400),add=T,border='red')
