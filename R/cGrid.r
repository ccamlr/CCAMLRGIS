cGrid=function(Input,dlon=NA,dlat=NA,Area=NA,cuts=100,cols=c('green','yellow','red'),Blank=FALSE){
  if(Blank==TRUE){
    LatMin=Input[1]
    LatMax=Input[2]
    LonMin=Input[3]
    LonMax=Input[4]
    if(is.na(Area)==FALSE & LonMin!=(-180) & LonMax!=180){
      message('Script might struggle to reach equal area cells if longitudes do not span -180 to 180.')
    }
  }else{
    data=Input
    colnames(data)[1:2]=c("lat","lon")
    #If only Lat and Lon are provided, add a 'Count' column to simply grid counts of observations
    if(dim(data)[2]==2){data$Count=1}
    LatMin=max(-89,floor(min(data$lat))-1)
    LatMax=min(0,ceiling(max(data$lat))+1)
    LonMin=max(-180,floor(min(data$lon)-1))
    LonMax=min(180,ceiling(max(data$lon))+1)
  }
  if(is.na(Area)==TRUE){
    #Prepare Lat/Lon grid
    if(Blank==TRUE){
      tmp=expand.grid(lon=seq(LonMin,LonMax,by=dlon),lat=seq(LatMin,LatMax,by=dlat))
      GLONS=tmp$lon
      GLATS=tmp$lat
    }else{
      data$lon=(ceiling((data$lon+dlon)/dlon)*dlon-dlon)-dlon/2
      data$lat=(ceiling((data$lat+dlat)/dlat)*dlat-dlat)-dlat/2
      Glon=data$lon
      Glat=data$lat
      tmp=dplyr::distinct(data.frame(Glon,Glat))
      GLONS=tmp$Glon
      GLATS=tmp$Glat
    }
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
    StartP=cbind(0,LatMax)
    LatS=0
    while(LatS>LatMin){
      #Compute circumference at Northern latitude of cells
      NLine=st_sfc(st_linestring(cbind(seq(LonMin,LonMax,length.out=10000),rep(StartP[,2],10000))), crs = 4326)
      NLine=st_transform(x=NLine,crs=6932)
      L=as.numeric(st_length(NLine))
      #Compute number of cells
      N=floor(L/s)
      if(N<=1){stop("Desired cell area is too large to fit in that space.")}
      lx=L/N
      ly=Area/lx
      #Prepare cell boundaries
      Lons=seq(LonMin,LonMax,length.out=N)
      LatN=StartP[1,2]
      #Get preliminary LatS by buffering point
      LatSpoint=create_Points(Input=data.frame(Lat=LatN,Lon=Lons[1]),Buffer = ly/1852)
      LatSpoint=sf::st_transform(LatSpoint,4326)
      LatS=as.numeric(sf::st_bbox(LatSpoint)$ymin)
      #Refine LatS
      lons=unique(c(Lons[1],seq(Lons[1],Lons[2],by=0.1),Lons[2]))
      PLon=c(lons,rev(lons),lons[1])
      PLat=c(rep(LatN,length(lons)),rep(LatS,length(lons)),LatN)
      PRO=project_data(Input = data.frame(Lat=PLat,Lon=PLon),
                       NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = FALSE)
      Pl=st_polygon(list(cbind(PRO$x,PRO$y)))
      Pl_a=st_area(Pl)
      Res=10/10^(0:15)
      while(Area>Pl_a & length(Res)!=0){
        LatSBase=LatS
        LatS=LatS-Res[1]
        if(LatS<(-90)){
          message('____________________________________________________________________________')
          message('Southern-most grid cells extend to -90deg and might not maintain equal-area.')
          message('Reduce desired cell area, or, remove these cells from the output if desired.')
          message('____________________________________________________________________________')
          LatS=-90
          break
        }
        PLat=c(rep(LatN,length(lons)),rep(LatS,length(lons)),LatN)
        PRO=project_data(Input = data.frame(Lat=PLat,Lon=PLon),
                         NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = FALSE)
        Pl=st_polygon(list(cbind(PRO$x,PRO$y)))
        Pl_a=st_area(Pl)
        if(Area<Pl_a){
          LatS=LatSBase
          PLat=c(rep(LatN,length(lons)),rep(LatS,length(lons)),LatN)
          PRO=project_data(Input = data.frame(Lat=PLat,Lon=PLon),
                           NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = FALSE)
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
                         NamesIn = c("Lat","Lon"),NamesOut = c("y","x"),append = FALSE)
        Pl=st_polygon(list(cbind(PRO$x,PRO$y)))
        Group[[PolyIndx]] = Pl
        PolyIndx=PolyIndx+1
      }
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
                     NamesOut = c('Centrelat','Centrelon'),append = FALSE,inv=TRUE)
  Group$Centrelon=CenLL$Centrelon
  Group$Centrelat=CenLL$Centrelat
  if(Blank==F){
    #Match data to grid cells
    tmp_p=project_data(Input=data,NamesIn=c('lat','lon'),NamesOut = c('y','x'),append = FALSE,inv=FALSE)
    tmp_p=st_as_sf(x=tmp_p,coords=c(2,1),crs=6932,remove=TRUE)
    tmp=sapply(st_intersects(tmp_p,Group), function(z) if (length(z)==0) NA_integer_ else z[1]) 
    #Look for un-assigned data points (falling on an edge between cells)
    Iout=which(is.na(tmp)==TRUE) #Index of those falling out
    DegDev=0
    while(length(Iout)>0){
      tmp=tmp[-Iout]
      datatmp=data[Iout,]
      data=data[-Iout,]
      Mov=c(-(0.0001+DegDev),0.0001+DegDev)
      MovLat=Mov[sample(c(1,2),length(Iout),replace = TRUE)]
      MovLon=Mov[sample(c(1,2),length(Iout),replace = TRUE)]
      datatmp$lat=datatmp$lat+MovLat
      datatmp$lon=datatmp$lon+MovLon
      data=rbind(data,datatmp)
      tmptmp_p=project_data(Input=datatmp,NamesIn=c('lat','lon'),NamesOut = c('y','x'),append = FALSE,inv=FALSE)
      tmptmp_p=st_as_sf(x=tmptmp_p,coords=c(2,1),crs=6932,remove=TRUE)
      tmptmp=sapply(st_intersects(tmptmp_p,Group), function(z) if (length(z)==0) NA_integer_ else z[1]) 
      tmp=c(tmp,tmptmp)
      rm(datatmp,tmptmp)
      DegDev=DegDev+0.0001
      Iout=which(is.na(tmp)==TRUE) #Index of those falling out
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
        dplyr::group_by(ID)%>%
        dplyr::summarise_all(list(min=~min(.,na.rm=TRUE),
                                  max=~max(.,na.rm=TRUE),
                                  mean=~mean(.,na.rm=TRUE),
                                  sum=~sum(.,na.rm=TRUE),
                                  count=~length(.),
                                  sd=~sd(.,na.rm=TRUE),
                                  median=~median(.,na.rm=TRUE)))
      Sdata=as.data.frame(Sdata)}else{Sdata=data.frame(ID=as.character(unique(data$ID)))}
    #Merge data to Polygons
    Group$ID=as.character(Group$ID)
    Group=dplyr::left_join(Group,Sdata,by="ID")
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
  }else{ #Blank grid
    #Re-order columns
    Group=Group[,c("ID","AreaKm2","Centrex","Centrey","Centrelon","Centrelat","geometry")]
  }
  if(is.na(Area)==FALSE & length(unique(Group$AreaKm2))!=1){message('Equal-area gridding compromised. Check st_area([Output]).')}
  
  return(Group)
}
