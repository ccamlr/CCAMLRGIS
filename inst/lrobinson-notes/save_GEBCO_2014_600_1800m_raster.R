# prepare bathymetry raster file to be stored in inst/extdata
library(raster)

save_dir <- "/Users/lucy/Documents/R_workfolder/CCAMLRGIS/inst/extdata"

bathymetry_data <- raster("/Volumes/CCAMLR_WD_1/Lucy/GEBCO/GEBCO2014_final/CCAMLRGIS/GEBCO_2014_600_1800m/GEBCO_2014_geotiff_projected_cubic_resample_500_500m_depths_600_1800m2016-04-27.tif") 

# restrict to a small area for example in Research Block 48.2 

RBs <- load_RBs("GEOJSON")


RB_482_S <- RBs[RBs$GAR_Short_Label%in%"482_S",]

Bathymetry_482_S <- raster::crop(bathymetry_data, raster::extent(RB_482_S))
Bathymetry_482_S <- raster::mask(Bathymetry_482_S,RB_482_S)

# write bathymetry data to .grd and .gri

writeRaster(Bathymetry_482_S,paste(save_dir,"/GEBCO_2014_600_1800m_482_S.grd",sep=""))

rm(bathymetry_data)

file_name <- system.file("extdata","GEBCO_2014_600_1800m_482_S.grd",package = "CCAMLRGIS")

r <- raster(file_name)
