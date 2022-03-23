cGrid=function(Input,dlon=NA,dlat=NA,Area=NA,cuts=100,cols=c('green','yellow','red')){

if(is.na(sum(c(dlon,dlat,Area)))==FALSE){
  stop('Values should not be specified for dlon/dlat and Area.')
}  
if(all(is.na(c(dlon,dlat,Area)))){
    stop('Values should be specified for either dlon/dlat or Area.')
}  
  
  data=Input
  colnames(data)[1:2]=c("lat","lon")
  #If only Lat and Lon are provided, add a 'Count' column to simply grid counts of observations
  if(dim(data)[2]==2){data$Count=1}
  
if(is.na(Area)==TRUE){
  #Prepare Lat/Lon grid
  data$lon=(ceiling((data$lon+dlon)/dlon)*dlon-dlon)-dlon/2
  data$lat=(ceiling((data$lat+dlat)/dlat)*dlat-dlat)-dlat/2
  
  Glon=data$lon
  Glat=data$lat
  
  tmp=distinct(data.frame(Glon,Glat))
  GLONS=tmp$Glon
  GLATS=tmp$Glat
  
  #Loop over cells to generate SpatialPolygon
  Pl=list()
  for (i in (1:length(GLONS))){ #Loop over polygons
    xmin=GLONS[i]-dlon/2
    xmax=GLONS[i]+dlon/2
    ymin=GLATS[i]-dlat/2
    ymax=GLATS[i]+dlat/2
    if(dlon<=0.1){ #don't fortify
      lons=c(xmin,xmax,xmax,xmin)
      lats=c(ymax,ymax,ymin,ymin)
    }else{ #do fortify
      lons=c(xmin,seq(xmin,xmax,by=0.1),xmax)
      lons=unique(lons)
      lats=c(rep(ymax,length(lons)),rep(ymin,length(lons)))
      lons=c(lons,rev(lons))
    }
    #close polygons
    lons=c(lons,lons[1])
    lats=c(lats,lats[1])
    
    Pl[[i]]=st_polygon(list(cbind(lons,lats)))
  }
  Group=st_sfc(Pl, crs = 4326)
  #project
  Group=st_transform(x=Group,crs=6932)
  #Get area
  tmp=round(st_area(Group)/1000000,1)
  tmp=data.frame(ID=seq(1,length(tmp)),AreaKm2=as.numeric(tmp))

  Group=st_set_geometry(tmp,Group)
  
}else{
  #Equal-area grid
  Area=Area*1e6  #Convert area to sq m
  s=sqrt(Area)   #first rough estimate of length of cell side
  PolyIndx=1     #Index of polygon (cell)
  Group = list() #Initialize storage of cells
  
  # StartP=SpatialPoints(cbind(0,ceiling(max(data$lat))),CRS("+init=epsg:4326"))
  StartP=cbind(0,ceiling(max(data$lat)))
  LatS=0
  
  while(LatS>min(data$lat)){
    
    #Compute circumference at Northern latitude of cells
    NLine=st_sfc(st_linestring(cbind(seq(-180,180,length.out=10000),rep(StartP[,2],10000))), crs = 4326)
    NLine=st_transform(x=NLine,crs=6932)
    L=as.numeric(st_length(NLine))
    
    #Compute number of cells
    N=floor(L/s)
    lx=L/N
    ly=Area/lx
    #Prepare cell boundaries
    Lons=seq(-180,180,length.out=N)
    LatN=StartP[1,2]
    LatS=as.numeric(geosphere::destPoint(cbind(Lons[1],LatN), 180, d=ly)[,2])
    #Refine LatS
    lons=unique(c(Lons[1],seq(Lons[1],Lons[2],by=0.1),Lons[2]))
    PLon=c(lons,rev(lons),lons[1])
    PLat=c(rep(LatN,length(lons)),rep(LatS,length(lons)),LatN)
    
    PRO=project_data(Input = data.frame(Lat=PLat,Lon=PLon),
                     NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = F)
    Pl=st_polygon(list(cbind(PRO$x,PRO$y)))
    Pl_a=st_area(Pl)

    Res=10/10^(0:15)
    while(Area>Pl_a & length(Res)!=0){
      LatSBase=LatS
      LatS=LatS-Res[1]
      if(LatS<(-90)){
        message('______________________________________________________________________________','\n')
        message('Southern-most grid cells should not extend below -90deg to maintain equal-area','\n')
        message('Reduce desired area of cells to avoid this issue','\n')
        message('______________________________________________________________________________','\n')
        LatS=-90
        break}
      PLat=c(rep(LatN,length(lons)),rep(LatS,length(lons)),LatN)
      
      PRO=project_data(Input = data.frame(Lat=PLat,Lon=PLon),
                       NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = F)
      Pl=st_polygon(list(cbind(PRO$x,PRO$y)))
      Pl_a=st_area(Pl)
      
      if(Area<Pl_a){
        LatS=LatSBase
        PLat=c(rep(LatN,length(lons)),rep(LatS,length(lons)),LatN)
        
        PRO=project_data(Input = data.frame(Lat=PLat,Lon=PLon),
                         NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = F)
        Pl=st_polygon(list(cbind(PRO$x,PRO$y)))
        Pl_a=st_area(Pl)
        
        Res=Res[-1]
      }
    }
    
    #Build polygons at a given longitude
    for (i in seq(1,length(Lons)-1)) {
      lons=unique(c(Lons[i],seq(Lons[i],Lons[i+1],by=0.1),Lons[i+1]))
      PLon=c(lons,rev(lons),lons[1])
      PLat=c(rep(LatN,length(lons)),rep(LatS,length(lons)),LatN)
      
      PRO=project_data(Input = data.frame(Lat=PLat,Lon=PLon),
                       NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = F)
      Pl=st_polygon(list(cbind(PRO$x,PRO$y)))
      
      Group[[PolyIndx]] = Pl
      PolyIndx=PolyIndx+1
    }
    
    rm(NLine,Pl,PRO,StartP,i,L,LatSBase,Lons,lons,lx,ly,N,PLat,PLon,Res)
    
    StartP=cbind(0,LatS)
  }
  Group=st_sfc(Group, crs = 6932)

  #Get area
  tmp=round(st_area(Group)/1000000,1)
  tmp=data.frame(ID=seq(1,length(tmp)),AreaKm2=as.numeric(tmp))
  Group=st_set_geometry(tmp,Group)  
}

  #Add cell labels centers
  #Get labels locations
  labs=st_coordinates(st_centroid(st_geometry(Group)))
  Group$Centrex=labs[,1]
  Group$Centrey=labs[,2]
  
  #project to get Lat/Lon of centres
  CenLL=project_data(Input=st_drop_geometry(Group),NamesIn=c('Centrey','Centrex'),
                     NamesOut = c('Centrelat','Centrelon'),append = F,inv=T)
  Group$Centrelon=CenLL$Centrelon
  Group$Centrelat=CenLL$Centrelat
  rm(CenLL)
  #Match data to grid cells
  tmp_p=project_data(Input=data,NamesIn=c('lat','lon'),NamesOut = c('y','x'),append = F,inv=F)
  tmp_p=st_as_sf(x=tmp_p,coords=c(2,1),crs=6932,remove=TRUE)
  tmp=sapply(st_intersects(tmp_p,Group), function(z) if (length(z)==0) NA_integer_ else z[1]) #sp::over replacement
  
  #Look for un-assigned data points (falling on an edge between cells)
  Iout=which(is.na(tmp)==T) #Index of those falling out
  while(length(Iout)>0){
    tmp=tmp[-Iout,]
    datatmp=data[Iout,]
    data=data[-Iout,]
    DegDev=0
    Mov=c(-(0.0001+DegDev),0.0001+DegDev)
    MovLat=Mov[sample(c(1,2),length(Iout),replace = T)]
    MovLon=Mov[sample(c(1,2),length(Iout),replace = T)]
    datatmp$lat=datatmp$lat+MovLat
    datatmp$lon=datatmp$lon+MovLon
    data=rbind(data,datatmp)
    tmptmp_p=project_data(Input=datatmp,NamesIn=c('lat','lon'),NamesOut = c('y','x'),append = F,inv=F)
    tmptmp_p=st_as_sf(x=tmptmp_p,coords=c(2,1),crs=6932,remove=TRUE)
    tmptmp=sapply(st_intersects(tmptmp_p,Group), function(z) if (length(z)==0) NA_integer_ else z[1]) #sp::over replacement

    tmp=rbind(tmp,tmptmp)
    rm(datatmp,tmptmp)
    DegDev=DegDev+0.0001
    Iout=which(is.na(tmp)==T) #Index of those falling out
    }
  #Append cell ID to data
  data$ID=as.character(tmp)
  rm(tmp)
  Group=Group[Group$ID%in%unique(data$ID),]
  #Summarise data
  data=as.data.frame(data[,-c(1,2)])
  nums = which(unlist(lapply(data, is.numeric))==TRUE)
  if(length(nums)>0){
    data=data[,c(which(colnames(data)=='ID'),nums)]
    Sdata=data%>%
      group_by(ID)%>%
      summarise_all(list(min=~min(.,na.rm=TRUE),
                         max=~max(.,na.rm=TRUE),
                         mean=~mean(.,na.rm=TRUE),
                         sum=~sum(.,na.rm=TRUE),
                         count=~length(.),
                         sd=~sd(.,na.rm=TRUE),
                         median=~median(.,na.rm=TRUE)))
    Sdata=as.data.frame(Sdata)}else{Sdata=data.frame(ID=as.character(unique(data$ID)))}
  #Merge data to Polygons
  Group$ID=as.character(Group$ID)
  Group=left_join(Group,Sdata,by="ID")

  #Add colors
  GroupData=st_drop_geometry(Group)
  VarToColor=which(unlist(lapply(GroupData, class))%in%c("integer","numeric"))
  VarNotToColor=which(colnames(GroupData)%in%c("Centrex","Centrey","Centrelon","Centrelat"))
  VarToColor=VarToColor[-which(VarToColor%in%VarNotToColor)]
  for(i in VarToColor){
    coldata=GroupData[,i]
    if(all(is.na(coldata))){
      Group[,paste0('Col_',colnames(GroupData)[i])]=NA
    }else{
      tmp=add_col(var=coldata,cuts=cuts,cols=cols)
      Group[,paste0('Col_',colnames(GroupData)[i])]=tmp$varcol
    }
  }
  
return(Group)
}
