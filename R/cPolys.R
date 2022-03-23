cPolys=function(Input,Densify=FALSE){
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
    if(diflons>0.1 & Densify==TRUE){
      tmp=DensifyData(lons,lats)
      lons=tmp[,1]
      lats=tmp[,2]
    }
    Pl[[i]]=st_polygon(list(cbind(lons,lats)))
  }
  Locs=st_sfc(Pl, crs = 4326)
  #Summarise data
  Input=as.data.frame(Input[,-c(2,3)])
  colnames(Input)[1]='ID'
  nums = which(unlist(lapply(Input, is.numeric))==TRUE)
  if(length(nums)>0){
    Input=Input[,c(1,nums)]
    Sdata=Input%>%
      group_by(ID)%>%
      summarise_all(list(min=~min(.,na.rm=TRUE),
                         max=~max(.,na.rm=TRUE),
                         mean=~mean(.,na.rm=TRUE),
                         sum=~sum(.,na.rm=TRUE),
                         count=~length(.),
                         sd=~sd(.,na.rm=TRUE),
                         median=~median(.,na.rm=TRUE)))
    Sdata=as.data.frame(Sdata)}else{Sdata=data.frame(ID=as.character(unique(Input$ID)))}
  #Merge data to polys
  row.names(Sdata)=Sdata$ID
  Sdata=Sdata[match(Sdata$ID,ids),]
  Locs=st_set_geometry(Sdata,Locs)
  #Project
  Locs=st_transform(x=Locs,crs=6932)
  #Get areas
  Ar=round(st_area(Locs)/1000000,1)
  Locs$AreaKm2=as.numeric(Ar)
  #Get labels locations
  labs=st_coordinates(st_centroid(st_geometry(Locs)))
  Locs$Labx=labs[,1]
  Locs$Laby=labs[,2]
  return(Locs)
}