add_buffer=function(Input,buf=NA){
  require(rgeos)
  buf=buf*1852
  Shp=gBuffer(Input,byid=T,width=buf,quadsegs=25)
  if("AreaKm2"%in%colnames(Shp@data)){
    colnames(Shp@data)[which(colnames(Shp@data)=="AreaKm2")]="Unbuffered_AreaKm2"
  }
  #Get buffered areas
  Ar=round(gArea(Shp,byid=T)/1000000,1)
  Shp$Buffered_AreaKm2=as.numeric(Ar)[match(Shp$ID,names(Ar))]
  return(Shp)
}