cPolys=function(Input,Densify=F){
  require(sp)
  require(dplyr)
  require(rgeos)
  #Build Poly list
  Pl=list()
  Input[,1]=as.character(Input[,1])
  ids=unique(Input[,1])
  for(i in seq(1,length(ids))){
    indx=which(Input[,1]==ids[i])
    indx=c(indx,indx[1])
    lons=Input[indx,3]
    lats=Input[indx,2]
    diflons=abs(diff(lons))
    if(length(diflons)>1){diflons=min(abs(diflons[diflons!=0]))}
    if(length(diflons)==0){diflons=0}
    if(diflons>0.1 & Densify==T){
      tmp=DensifyData(lons,lats)
      lons=tmp[,1]
      lats=tmp[,2]
    }
    Pl[[i]]=Polygons(list(Polygon(cbind(lons,lats),hole=F)),as.character(ids[i]))
  }
  Locs=SpatialPolygons(Pl, proj4string=CRS("+proj=longlat +ellps=WGS84"))
  #Summarise data
  Input=as.data.frame(Input[,-c(2,3)])
  colnames(Input)[1]='ID'
  nums = which(unlist(lapply(Input, is.numeric))==T)
  if(length(nums)>0){
  Input=Input[,c(1,nums)]
  Sdata=Input%>%
    group_by(ID)%>%
    summarise_all(list(min=~min(.,na.rm=T),
                       max=~max(.,na.rm=TRUE),
                       mean=~mean(.,na.rm=TRUE),
                       sum=~sum(.,na.rm=TRUE),
                       count=~length(.),
                       sd=~sd(.,na.rm=TRUE),
                       median=~median(.,na.rm=TRUE)))
  Sdata=as.data.frame(Sdata)}else{Sdata=data.frame(ID=as.character(unique(Input$ID)))}
  #Merge data to SpatialLines
  row.names(Sdata)=Sdata$ID
  Locs=SpatialPolygonsDataFrame(Locs,Sdata)
  #Project
  Locs=spTransform(Locs,CRS(CCAMLRp))
  #Get areas
  Ar=round(gArea(Locs,byid=T)/1000000,1)
  Locs$AreaKm2=as.numeric(Ar)[match(Locs$ID,names(Ar))]
  #Get labels locations
  labs=coordinates(gCentroid(Locs,byid=T))
  Locs$Labx=labs[match(Locs$ID,row.names(labs)),'x']
  Locs$Laby=labs[match(Locs$ID,row.names(labs)),'y']
  return(Locs)
}