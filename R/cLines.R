cLines=function(Input,Densify=FALSE){
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
    if(diflons>0.1 & Densify==TRUE){
      tmp=DensifyData(lons,lats)
      lons=tmp[,1]
      lats=tmp[,2]
    }
    Ll[[i]]=st_linestring(cbind(lons,lats))
    Llengths=rbind(Llengths,cbind(id=as.character(ids[i]),
                                  L=as.numeric(st_length(st_sfc(Ll[[i]], crs = 4326)))/1000))
  }
  Locs=st_sfc(Ll, crs = 4326)
  #Format lengths
  Llengths=as.data.frame(Llengths)
  Llengths$id=as.character(Llengths$id)
  Llengths$L=as.numeric(as.character(Llengths$L))
  Llengths$LengthKm=round(Llengths$L,4)
  Llengths$LengthNm=round(Llengths$L/1.852,4)
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
    #add line lengths
    Sdata=as.data.frame(Sdata)}else{Sdata=data.frame(ID=as.character(unique(Input$ID)))}
  if(length(ids)>1){
    Sdata=Sdata[match(ids,Sdata$ID),]
  }
  indx=match(Sdata$ID,Llengths$id)
  Sdata$LengthKm=Llengths$LengthKm[indx]
  Sdata$LengthNm=Llengths$LengthNm[indx]
  #Merge data to SpatialLines
  row.names(Sdata)=Sdata$ID
  Locs=st_set_geometry(Sdata,Locs)
  #Project
  Locs=st_transform(x=Locs,crs=6932)
  return(Locs)
}
