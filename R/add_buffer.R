add_buffer=function(Input,buf=NA,SeparateBuf=T){
  require(rgeos)
  buf=buf*1852
  if(SeparateBuf==F){
    Shp=gBuffer(Input,byid=F,width=buf,quadsegs=25)
    id=sapply(slot(Shp, "polygons"), function(x) slot(x, "ID"))
    Dat=data.frame(ID=id)
    row.names(Dat)=id
    Shp=SpatialPolygonsDataFrame(Shp,data=Dat)
  }else{
    Shp=gBuffer(Input,byid=T,width=buf,quadsegs=25)}
  if("AreaKm2"%in%colnames(Shp@data)){
    colnames(Shp@data)[which(colnames(Shp@data)=="AreaKm2")]="Unbuffered_AreaKm2"
  }
  #Get buffered areas
  Ar=round(gArea(Shp,byid=T)/1000000,1)
  Shp$Buffered_AreaKm2=as.numeric(Ar)[match(Shp$ID,names(Ar))]
  return(Shp)
}