cLines=function(Input,Densify=F){
  require(sp)
  require(dplyr)
  #Build Line list
  Ll=list()
  Input[,1]=as.character(Input[,1])
  ids=unique(Input[,1])
  Llengths=NULL
  for(i in seq(1,length(ids))){
    indx=which(Input[,1]==ids[i])
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
    Ll[[i]]=Lines(list(Line(cbind(lons,lats))),as.character(ids[i]))
    Llengths=rbind(Llengths,cbind(id=as.character(ids[i]),
                                  L=LinesLength(Ll[[i]],longlat=T)))
  }
  Locs=SpatialLines(Ll, proj4string=CRS("+proj=longlat +ellps=WGS84"))
  #Format lengths
  Llengths=as.data.frame(Llengths)
  Llengths$id=as.character(Llengths$id)
  Llengths$L=as.numeric(as.character(Llengths$L))
  Llengths$LengthKm=round(Llengths$L/1000,4)
  Llengths$LengthNm=round(Llengths$L/1852,4)
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
  #add line lengths
  Sdata=as.data.frame(Sdata)}else{Sdata=data.frame(ID=as.character(unique(Input$ID)))}
  indx=match(Sdata$ID,Llengths$id)
  Sdata$LengthKm=Llengths$LengthKm[indx]
  Sdata$LengthNm=Llengths$LengthNm[indx]
  #Merge data to SpatialLines
  row.names(Sdata)=Sdata$ID
  Locs=SpatialLinesDataFrame(Locs,Sdata)
  #Project
  Locs=spTransform(Locs,CRS(CCAMLRp))
  return(Locs)
}