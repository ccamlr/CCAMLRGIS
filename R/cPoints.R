cPoints=function(Input){
  Locs=SpatialPointsDataFrame(cbind(Input[,2],Input[,1]),Input,proj4string=CRS("+proj=longlat +ellps=WGS84"))
  Locs=spTransform(Locs,CRS(CCAMLRp))
  tmp=coordinates(Locs)
  Locs$x=tmp[,1]
  Locs$y=tmp[,2]
  Locs$ID=seq(1,length(Locs$x))
  return(Locs)
}