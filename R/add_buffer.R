add_buffer=function(Input,buf=NA,SeparateBuf=TRUE){

  buf=buf*1852
  Shp=st_buffer(x=Input,dist=buf)
  
  if(SeparateBuf==FALSE){
    Shp=st_union(Shp)
    Shp=st_set_geometry(x=data.frame(ID=1), Shp)
    }
  if("AreaKm2"%in%colnames(Shp)){
    colnames(Shp)[which(colnames(Shp)=="AreaKm2")]="Unbuffered_AreaKm2"
  }
  #Get buffered areas
  Ar=round(st_area(Shp)/1000000,1)
  Shp$Buffered_AreaKm2=as.numeric(Ar)
  return(Shp)
}