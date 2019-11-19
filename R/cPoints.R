#cPoints: CCAMLRGIS internal function to create SpatialPointsDataFrames
cPoints=function(Input){
  require(sp)
  Locs=SpatialPointsDataFrame(cbind(Input[,3],Input[,2]),Input,proj4string=CRS("+proj=longlat +ellps=WGS84"))
  Locs=spTransform(Locs,CRS(CCAMLRp))
  tmp=coordinates(Locs)
  Locs$x=tmp[,1]
  Locs$y=tmp[,2]
  Locs$ID=seq(1,length(Locs$x))
  return(Locs)
}