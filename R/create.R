#' Create Polygons 
#'
#' Create Polygons such as proposed Research Blocks or Marine Protected Areas.
#'
#' @param Input  the name of the \code{Input} data as a .csv file or an R dataframe.
#' If a .csv file is used as input, this file must be in your working directory and its name given in quotes
#' e.g. "DataFile.csv".
#' 
#' \strong{The columns in the \code{Input} must be in the following order:
#' 
#' Polygon name, Latitude, Longitude.
#' 
#' Latitudes and Longitudes must be given clockwise.}
#' @param OutputFormat can be an R object or an ESRI Shapefile. if \code{OutputFormat} is specified as
#' "ROBJECT" (the default), a SpatialPolygonDataFrame is created in your R environment.
#' if \code{OutputFormat} is specified as "SHAPEFILE", an ESRI Shapefile is exported in
#' your working directory. 
#' @param OutputName if \code{OutputFormat} is specified as "SHAPEFILE", the name of the output
#' shapefile in quotes (e.g. "MyPolygons") must be provided.
#' @param Buffer Distance in nautical miles by which to expand the polygons. Can be specified for
#' each polygon (as a numeric vector).
#' @param Densify If set to TRUE, additional points between points of equal latitude are added
#' prior to projection (see examples). 
#' @param Clip if set to TRUE, polygon parts that fall on land are removed (see \link{Clip2Coast}).
#' 
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting object contains the data provided in the \code{Input} plus
#' and additional "AreaKm2" column which corresponds to the areas, in square kilometers, of your polygons.
#' Also, columns "Labx" and "Laby" may be used to add labels to polygons. The data contained in a Spatial 
#' Polygon may be accessed via View(MyPolygon@@data)
#'
#' @examples
#' Example 1: Simple and non-densified polygons
#' 
#' MyPolys=create_Polys(PolyData,Densify=F)
#' plot(MyPolys,col='blue')
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID,col='white')
#'
#' Example 2: Simple and densified polygons (note the curvature of iso-latitude lines)
#' 
#' MyPolys=create_Polys(PolyData)
#' plot(MyPolys,col='red')
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID,col='white')
#'
#' Example 3: Buffered and clipped polygons
#' 
#' MyPolysBefore=create_Polys(PolyData,Buffer=c(10,-15,120))
#' MyPolysAfter=create_Polys(PolyData,Buffer=c(10,-15,120),Clip=T)
#' plot(MyPolysBefore,col='green')
#' plot(Coast,add=T)
#' plot(MyPolysAfter,col='red',add=T)
#' text(MyPolysAfter$Labx,MyPolysAfter$Laby,MyPolysAfter$ID,col='white')
#' 
#' @export

create_Polys=function(Input,OutputFormat="ROBJECT",OutputName=NULL,Buffer=0,Densify=TRUE,Clip=FALSE){
  # Load data
  if (class(Input)=="character"){Input=read.csv(Input)}
  # Run cPolys
  Output=cPolys(Input,Densify=Densify)
  # Run add_buffer
  if(length(Buffer)==1){
    if(Buffer>0){Output=add_buffer(Output,buf=Buffer)}
  }else{
    Output=add_buffer(Output,buf=Buffer)
  }
  # Run Clip2Coast
  if(Clip==T){Output=Clip2Coast(Output)}
  # Export to shapefile if desired
  if(OutputFormat=="SHAPEFILE"){
    writeOGR(Output,".",OutputName,driver="ESRI Shapefile")}else{
    return(Output)
  }
}

#' Create a Polygon Grid 
#'
#' Create a Polygon Grid to spatially aggregate data in cells of chosen size.
#' Cell size may be specified in degrees or as a desired area in square kilometers
#' (in which case all cells are of equal area).
#'
#' @param Input the name of the \code{Input} data as a .csv file or an R dataframe.
#' If a .csv file is used as input, this file must be in your working directory and its name given in quotes
#' e.g. "DataFile.csv".
#' 
#' \strong{The columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2 ... Variable x.}
#' @param OutputFormat can be an R object or an ESRI Shapefile. if \code{OutputFormat} is specified as
#' "ROBJECT" (the default), a SpatialPolygonDataFrame is created in your R environment.
#' if \code{OutputFormat} is specified as "SHAPEFILE", an ESRI Shapefile is exported in
#' your working directory. 
#' @param OutputName if \code{OutputFormat} is specified as "SHAPEFILE", the name of the output
#' shapefile in quotes (e.g. "MyGrid") must be provided.
#' @param dlon width of the grid cells in decimal degrees of longitude.
#' @param dlat height of the grid cells in decimal degrees of latitude.
#' @param Area Area, in square kilometers, of the grid cells.
#' @param cuts Number of desired color classes.
#' @param cols Desired colors.
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting object contains the data provided in the \code{Input} after aggregation
#' within cells. For each Variable, the minimum, maximum, mean, sum, count, standard deviation, and, 
#' median of values in each cell is returned (see View(MyGrid@@data)).
#' 
#' In addition, colors are generated for each aggregatted values according the chosen \code{cuts} and \code{cols}.
#' To generate a color scale, refer to \link{CBar}.
#' @export

create_PolyGrids=function(Input,OutputFormat="ROBJECT",OutputName=NULL,dlon,dlat){
  if (class(Input)=="character"){
    data=read.csv(Input)}else{
      data=Input  
    }
  lat=data[,1]
  lon=data[,2]
  Val=data[,3]
  # Define CRS projection
  CRSProj="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
  # Prepare Group, the output file which will contain all polygons
  Group=list()
  GroupData=NULL
  # Prepare Grid
  Glon=(ceiling((lon+dlon)/dlon)*dlon-dlon)-dlon/2
  Glat=(ceiling((lat+dlat)/dlat)*dlat-dlat)-dlat/2
  
  GVal=Val
  GriddedData=as.data.frame(cbind(Glon,Glat,GVal))
  
  GriddedData_Mean=aggregate(GVal~Glon+Glat,data=GriddedData,mean)
  
  GLONS=GriddedData_Mean[,1]
  GLATS=GriddedData_Mean[,2]
  MEANS=GriddedData_Mean[,3]
  
  GriddedData_Sum=aggregate(GVal~Glon+Glat,data=GriddedData,sum)
  SUMS=GriddedData_Sum[,3]
  GriddedData_Median=aggregate(GVal~Glon+Glat,data=GriddedData,median)
  MEDIANS=GriddedData_Median[,3]
  GriddedData_Max=aggregate(GVal~Glon+Glat,data=GriddedData,max)
  MAXS=GriddedData_Max[,3]
  GriddedData_Min=aggregate(GVal~Glon+Glat,data=GriddedData,min)
  MINS=GriddedData_Min[,3]
  GriddedData_StDev=aggregate(GVal~Glon+Glat,data=GriddedData,sd)
  STDEVS=GriddedData_StDev[,3]
  GriddedData_Count=aggregate(rep(1,length(Glon))~Glon+Glat,data=GriddedData,sum)
  COUNTS=GriddedData_Count[,3]
  
  for (i in (1:length(GLONS))){ #Loop over polygons
    
    PLon=c(GLONS[i]-dlon/2,
           GLONS[i]+dlon/2,
           GLONS[i]+dlon/2,
           GLONS[i]-dlon/2)
    PLat=c(GLATS[i]+dlat/2,
           GLATS[i]+dlat/2,
           GLATS[i]-dlat/2,
           GLATS[i]-dlat/2)
    Pmean=round(MEANS[i],2)
    Psum=round(SUMS[i],2)
    Pmed=round(MEDIANS[i],2)
    Pmax=round(MAXS[i],2)
    Pmin=round(MINS[i],2)
    Pstdev=round(STDEVS[i],2)
    Pcount=COUNTS[i]
    
    #Project Lat/Lon
    PRO=project(cbind(PLon,PLat),CRSProj)
    PLon=c(PRO[,1],PRO[1,1])
    PLat=c(PRO[,2],PRO[1,2])
    rm(PRO)
    
    #Create individual Polygons
    Pl=Polygon(cbind(PLon,PLat))
    Pls=Polygons(list(Pl), ID=i)
    SPls=SpatialPolygons(list(Pls))
    
    df=data.frame(name=names(data)[3],row.names=i,Pcount,Pmax,Pmin,Pmean,Pstdev,Pmed,Psum)
    colnames(df)[2:8]=c("Count","Max","Min","Mean","StdDev","Median","Sum")
    
    SPDF=SpatialPolygonsDataFrame(SPls, df)
    proj4string(SPDF)=CRS(CRSProj)
    
    #Add each polygon to the Group
    Group[[i]]=Pls
    GroupData=rbind(GroupData,df)
  }
  
  #Collate Group
  Group=SpatialPolygons(Group)
  Group=SpatialPolygonsDataFrame(Group,GroupData)
  proj4string(Group)=CRS(CRSProj)
  if(OutputFormat=="SHAPEFILE"){
    writeOGR(Group,".",OutputName,driver="ESRI Shapefile")
  }else{
    return(Group)
  }
}


#' Create Lines 
#'
#' Create Lines that are compatible with CCAMLR online GIS 
#'
#' @param Input  the name of the input data as a .csv file or an R dataframe. If .csv input then ensure this file is in your set work directory in quotes e.g. "DataFile.csv".  The columns of the input should be in the following order: Name, Latitude,Longitude 
#' @param OutputFormat can be an R object or ESRI Shapefile. R object is specified as "ROBJECT" and returns a SpatialLinesDataFrame to your R work enviornment (if this parameter is not specified this is the default). The ESRI Shapefile output is specified as "SHAPEFILE" will write an ESRI Shapefile to your work directory or set file path.
#' @param OutputName  if "SHAPEFILE" format is specified then supply the name of the output shapefile in quotes e.g."MyShape", the default is NULL and assumes an "ROBJECT" format 
#' @param Buffer is the value in nautical miles to apply to the line. The default value is 0, assuming no Buffer
#' @param Densify is set to 1 as a default, which will add additional points between points of equal latitude when data are projected. If set to 0 then no additional points will be added 
#' @param Clip is TRUE will clip a line that intersect with the coastline to remove the land and keep only the ocean area, the default is set to FLASE which assumes no clipping is required
#' @return Returns line(s) in R or output to ESRI shapefile format with Attributes "name" and "LengthKm" and "LengthNm. LengthKm is calculated using the LineLength function in the sp package based on the geometry created in the function. If a buffer is applied then an additional attribute of "AreaKm2" is also returned. This planimetric area value is calculated using the gArea function from the sp package
#' @import rgeos rgdal raster sp
#' @export
#' @examples 
#' ## specify the name of the line
#' 
#' Name <- rep("Set_1",2)
#' 
#' ## specify the Longitude coordinates in decimal degrees
#' 
#' Lon <- c(-120,-122)
#' 
#' ## specify the Latitude coordinates in decimal degrees
#' 
#' Lat<- c(-65,-65)
#' 
#' ## bind information together into a dataframe 
#' 
#' Coords<- data.frame(Name=Name,Lat=Lat,Lon=Lon)
#' 
#' ## create lines 
#' 
#' New_Lines <- create_Lines(Coords)

create_Lines=function(Input,OutputFormat="ROBJECT",OutputName=NULL,Buffer=0,Densify=1,Clip=FALSE){
  if (class(Input)=="character"){
    data=utils::read.csv(Input)}else{
      data=Input  
    }
  IDs=as.character(data[,1])
  ListIDs=sort(unique(IDs))
  Lats=data[,2]
  Lons=data[,3]
  if (dim(data)[2]>3){XtraFields=data[,(4:(dim(data)[2]))]}
  # Prepare Group, the output file which will contain all polygons
  Group=list()
  GroupData=NULL
  # Define CRS projection
  CRSProj="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
  # Set Buffer (Convert Nautical miles to meters)
  Buffer=Buffer*1852
  
  if (Densify==1){
    if (Buffer==0){
      for (i in (1:length(ListIDs))){ #Loop over Lines
        
        PID=ListIDs[i]
        PLon=Lons[IDs==PID]
        PLat=Lats[IDs==PID]
        
        if ((dim(data)[2])==3){PVal=NULL}
        if ((dim(data)[2])==4){PVal=unique(XtraFields[IDs==PID])
        if(length(PVal)>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
        if ((dim(data)[2])>4){PVal=unique(XtraFields[IDs==PID,])
        if(dim(PVal)[1]>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
        
        
        #Densify line
        Densified=DensifyData(Lon=PLon,Lat=PLat)
        PLon=Densified[,1]
        PLat=Densified[,2]
        rm(Densified)
        
        #Project Lat/Lon
        PRO=project(cbind(PLon,PLat),CRSProj)
        PLon=PRO[,1]
        PLat=PRO[,2]
        rm(PRO)
        
        #Create individual Lines
        Pl=Line(cbind(PLon,PLat)) 
        Pls=Lines(list(Pl), ID=PID)
        SPls=SpatialLines(list(Pls))
        Length=round(LineLength(Pl, longlat=FALSE, sum=TRUE)/1000,2)
        Lengthnm=round(LineLength(Pl, longlat=FALSE, sum=TRUE)*0.000539956803,2)
        
        if ((dim(data)[2])==3){df=data.frame(name=PID,row.names=PID,LengthKm=Length,LengthNm=Lengthnm)}
        if ((dim(data)[2])==4){df=data.frame(name=PID,row.names=PID,PVal,LengthKm=Length,LengthNm=Lengthnm);colnames(df)[2]=names(data)[4]}
        if ((dim(data)[2])>4){df=data.frame(name=PID,row.names=PID,PVal,LengthKm=Length,LengthNm=Lengthnm)}
        SPDF=SpatialLinesDataFrame(SPls, df)
        proj4string(SPDF)=CRS(CRSProj)
        #Add each Line to the Group
        Group[[i]]=Pls
        GroupData=rbind(GroupData,df)
        
      }
      Group=SpatialLines(Group)
      Group=SpatialLinesDataFrame(Group,GroupData)
      proj4string(Group)=CRS(CRSProj)
      if(OutputFormat=="SHAPEFILE"){
        writeOGR(Group,".",OutputName,driver="ESRI Shapefile")
      }else{
        return(Group)
      }
    }
    else #Add BUFFER
    {for (i in (1:length(ListIDs))){ #Loop over Lines
      
      PID=ListIDs[i]
      PLon=Lons[IDs==PID]
      PLat=Lats[IDs==PID]
      
      if ((dim(data)[2])==3){PVal=NULL}
      if ((dim(data)[2])==4){PVal=unique(XtraFields[IDs==PID])
      if(length(PVal)>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
      if ((dim(data)[2])>4){PVal=unique(XtraFields[IDs==PID,])
      if(dim(PVal)[1]>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
      
      #Densify line
      Densified=DensifyData(Lon=PLon,Lat=PLat)
      PLon=Densified[,1]
      PLat=Densified[,2]
      rm(Densified)
      
      #Project Lat/Lon
      PRO=project(cbind(PLon,PLat),CRSProj)
      PLon=PRO[,1]
      PLat=PRO[,2]
      rm(PRO)
      
      #Create individual Lines
      Pl=Line(cbind(PLon,PLat)) 
      Pls=Lines(list(Pl), ID=PID)
      SPls=SpatialLines(list(Pls))
      Length=round(LineLength(Pl, longlat=FALSE, sum=TRUE)/1000,2)
      Lengthnm=round(LineLength(Pl, longlat=FALSE, sum=TRUE)*0.000539956803,2)
      
      #Add Buffer
      Buffered=gBuffer(SPls,width=Buffer)
      PLon=Buffered@polygons[[1]]@Polygons[[1]]@coords[,1]
      PLat=Buffered@polygons[[1]]@Polygons[[1]]@coords[,2]
      rm(Buffered)
      
      #Clip or not
      Pl=Polygon(cbind(PLon,PLat))
      if (Clip==FALSE){
        Pls=Polygons(list(Pl), ID=PID)
      }else{
        cat(paste("Start clipping polygon",PID),"\n")
        Pls=Clip2Coast(Pl,Coastline=Clip,ID=PID)
        cat(paste("End clipping polygon",PID),"\n") 
      }
      
      SPls=SpatialPolygons(list(Pls))
      PArea=round(gArea(SPls, byid=F)/1000000)
      if ((dim(data)[2])==3){df=data.frame(name=PID,row.names=PID,AreaKm2=PArea,LengthKm=Length,LengthNm=Lengthnm)}
      if ((dim(data)[2])==4){df=data.frame(name=PID,row.names=PID,PVal,AreaKm2=PArea,LengthKm=Length,LengthNm=Lengthnm);colnames(df)[2]=names(data)[4]}
      if ((dim(data)[2])>4){df=data.frame(name=PID,row.names=PID,PVal,AreaKm2=PArea,LengthKm=Length,LengthNm=Lengthnm)}
      SPDF=SpatialPolygonsDataFrame(SPls, df)
      proj4string(SPDF)=CRS(CRSProj)
      #Add each polygon to the Group
      Group[[i]]=Pls
      GroupData=rbind(GroupData,df)
      
    }
      Group=SpatialPolygons(Group)
      Group=SpatialPolygonsDataFrame(Group,GroupData)
      proj4string(Group)=CRS(CRSProj)
      if(OutputFormat=="SHAPEFILE"){
        writeOGR(Group,".",OutputName,driver="ESRI Shapefile")
      }else{
        return(Group)
      }
    }
  } #end of yes densify
  
  if (Densify==0){
    if (Buffer==0){
      for (i in (1:length(ListIDs))){ #Loop over Lines
        
        PID=ListIDs[i]
        PLon=Lons[IDs==PID]
        PLat=Lats[IDs==PID]
        
        if ((dim(data)[2])==3){PVal=NULL}
        if ((dim(data)[2])==4){PVal=unique(XtraFields[IDs==PID])
        if(length(PVal)>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
        if ((dim(data)[2])>4){PVal=unique(XtraFields[IDs==PID,])
        if(dim(PVal)[1]>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
        
        #Project Lat/Lon
        PRO=project(cbind(PLon,PLat),CRSProj)
        PLon=PRO[,1]
        PLat=PRO[,2]
        rm(PRO)
        
        #Create individual Lines
        Pl=Line(cbind(PLon,PLat)) 
        Pls=Lines(list(Pl), ID=PID)
        SPls=SpatialLines(list(Pls))
        Length=round(LineLength(Pl, longlat=FALSE, sum=TRUE)/1000,2)
        Lengthnm=round(LineLength(Pl, longlat=FALSE, sum=TRUE)*0.000539956803,2)
        
        if ((dim(data)[2])==3){df=data.frame(name=PID,row.names=PID,LengthKm=Length,LengthNm=Lengthnm)}
        if ((dim(data)[2])==4){df=data.frame(name=PID,row.names=PID,PVal,LengthKm=Length,LengthNm=Lengthnm);colnames(df)[2]=names(data)[4]}
        if ((dim(data)[2])>4){df=data.frame(name=PID,row.names=PID,PVal,LengthKm=Length,LengthNm=Lengthnm)}
        SPDF=SpatialLinesDataFrame(SPls, df)
        proj4string(SPDF)=CRS(CRSProj)
        #Add each Line to the Group
        Group[[i]]=Pls
        GroupData=rbind(GroupData,df)
        
      }
      Group=SpatialLines(Group)
      Group=SpatialLinesDataFrame(Group,GroupData)
      proj4string(Group)=CRS(CRSProj)
      if(OutputFormat=="SHAPEFILE"){
        writeOGR(Group,".",OutputName,driver="ESRI Shapefile")
      }else{
        return(Group)
      }
    }
    else #Add BUFFER
    {for (i in (1:length(ListIDs))){ #Loop over Lines
      
      PID=ListIDs[i]
      PLon=Lons[IDs==PID]
      PLat=Lats[IDs==PID]
      
      if ((dim(data)[2])==3){PVal=NULL}
      if ((dim(data)[2])==4){PVal=unique(XtraFields[IDs==PID])
      if(length(PVal)>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
      if ((dim(data)[2])>4){PVal=unique(XtraFields[IDs==PID,])
      if(dim(PVal)[1]>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
      
      #Project Lat/Lon
      PRO=project(cbind(PLon,PLat),CRSProj)
      PLon=PRO[,1]
      PLat=PRO[,2]
      rm(PRO)
      
      #Create individual Lines
      Pl=Line(cbind(PLon,PLat)) 
      Pls=Lines(list(Pl), ID=PID)
      SPls=SpatialLines(list(Pls))
      Length=round(LineLength(Pl, longlat=FALSE, sum=TRUE)/1000,2)
      Lengthnm=round(LineLength(Pl, longlat=FALSE, sum=TRUE)*0.000539956803,2)
      
      #Add buffer
      Buffered=gBuffer(SPls,width=Buffer)
      PLon=Buffered@polygons[[1]]@Polygons[[1]]@coords[,1]
      PLat=Buffered@polygons[[1]]@Polygons[[1]]@coords[,2]
      rm(Buffered)
      
      #Clip or not
      Pl=Polygon(cbind(PLon,PLat))
      if (Clip==0){
        Pls=Polygons(list(Pl), ID=PID)
      }else{
        cat(paste("Start clipping polygon",PID),"\n")
        Pls=Clip2Coast(Pl,Coastline=Clip,ID=PID)
        cat(paste("End clipping polygon",PID),"\n") 
      }
      
      SPls=SpatialPolygons(list(Pls))
      PArea=round(gArea(SPls, byid=F)/1000000)
      if ((dim(data)[2])==3){df=data.frame(name=PID,row.names=PID,AreaKm2=PArea,LengthKm=Length,LengthNm=Lengthnm)}
      if ((dim(data)[2])==4){df=data.frame(name=PID,row.names=PID,PVal,AreaKm2=PArea,LengthKm=Length,LengthNm=Lengthnm);colnames(df)[2]=names(data)[4]}
      if ((dim(data)[2])>4){df=data.frame(name=PID,row.names=PID,PVal,AreaKm2=PArea,LengthKm=Length,LengthNm=Lengthnm)}
      SPDF=SpatialPolygonsDataFrame(SPls, df)
      proj4string(SPDF)=CRS(CRSProj)
      #Add each polygon to the Group
      Group[[i]]=Pls
      GroupData=rbind(GroupData,df)
      
    }
      Group=SpatialPolygons(Group)
      Group=SpatialPolygonsDataFrame(Group,GroupData)
      proj4string(Group)=CRS(CRSProj)
      if(OutputFormat=="SHAPEFILE"){
        writeOGR(Group,".",OutputName,driver="ESRI Shapefile")
      }else{
        return(Group)
      }
    }
  } #end of no densify
  
}


#' Create Points that are compatible with CCAMLR online GIS 
#'
#' Create Points that are compatible with CCAMLR online GIS 
#'
#' @param Input  the name of the input data as a .csv file or an R dataframe. If .csv input then ensure this file is in your set work directory in quotes e.g. "DataFile.csv".  The columns of the input should be in the following order: Name, Latitude,Longitude 
#' @param OutputFormat can be an R object or ESRI Shapefile. R object is specified as "ROBJECT" and returns a SpatialPointsDataFrame to your R work enviornment (if this parameter is not specified this is the default). The ESRI Shapefile output is specified as "SHAPEFILE" will write an ESRI Shapefile to your work directory or set file path.
#' @param OutputName  if "SHAPEFILE" format is specified then supply the name of the output shapefile in quotes e.g."MyShape", the default is NULL and assumes an "ROBJECT" format 
#' @param Buffer is the value in nautical miles to apply to the line. The default value is 0, assuming no Buffer
#' @param Clip is TRUE will clip a polygon that intersect with the coastline to remove the land and keep only the ocean area, the default is set to FLASE which assumes no clipping is required
#' @return Returns points with attributed "Name", "Lat" and "Long". If a buffer is applied then an additional attribute of "AreaKm2" is also returned. This planimetric area value is calculated using the gArea function from the sp package
#' @import rgeos rgdal raster sp
#' @export
#' @examples 
#' ## specify the name of the points
#' 
#' Name <- c("Point_1","Point_2","Point_3")
#' 
#' ## specify the Latitude coordinates in decimal degrees
#' 
#' Lat<- c(-70.2,-70.1,-69.9)
#' 
#' ## specify the Longitude coordinates in decimal degrees
#' 
#' Lon <- c(-160,-161,-159)
#' 
#' ## bind information together into a dataframe 
#' 
#' Coords<- data.frame(Name=Name,Lat=Lat,Lon=Lon)
#' 
#' ## create points 
#' 
#' New_Points <- create_Points(Coords)


create_Points=function(Input,OutputFormat="ROBJECT",OutputName=NULL,Buffer=0,Clip=FALSE){
  if (class(Input)=="character"){
    data=read.csv(Input)}else{
      data=Input  
    }
  IDs=as.character(data[,1])
  ListIDs=sort(unique(IDs))
  Lats=data[,2]
  Lons=data[,3]
  if (dim(data)[2]>3){XtraFields=data[,(4:(dim(data)[2]))]}
  # Prepare Group, the output file which will contain all polygons
  Group=list()
  GroupData=NULL
  # Define CRS projection
  CRSProj="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
  # Set Buffer (Convert Nautical miles to meters)
  Buffer=Buffer*1852
  
  if (Buffer==0){
    Group=NULL
    for (i in (1:length(ListIDs))){ #Loop over Lines
      
      PID=ListIDs[i]
      PLon=Lons[IDs==PID]
      PLat=Lats[IDs==PID]
      LLon=PLon
      LLat=PLat
      
      if ((dim(data)[2])==3){PVal=NULL}
      if ((dim(data)[2])==4){PVal=unique(XtraFields[IDs==PID])
      if(length(PVal)>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
      if ((dim(data)[2])>4){PVal=unique(XtraFields[IDs==PID,])
      if(dim(PVal)[1]>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
      
      #Project Lat/Lon
      PRO=project(cbind(PLon,PLat),CRSProj)
      PLon=PRO[,1]
      PLat=PRO[,2]
      rm(PRO)
      
      #Create individual Points
      SPls=SpatialPoints(cbind(PLon,PLat))
      
      if ((dim(data)[2])==3){df=data.frame(name=PID,row.names=PID,Lat=LLat,Lon=LLon)}
      if ((dim(data)[2])==4){df=data.frame(name=PID,row.names=PID,PVal,Lat=LLat,Lon=LLon);colnames(df)[2]=names(data)[4]}
      if ((dim(data)[2])>4){df=data.frame(name=PID,row.names=PID,PVal,Lat=LLat,Lon=LLon)}
      SPDF=SpatialPointsDataFrame(SPls, df)
      proj4string(SPDF)=CRS(CRSProj)
      #Add each Line to the Group
      Group=rbind(Group,c(PLon,PLat))
      GroupData=rbind(GroupData,df)
      
    }
    Group=SpatialPoints(Group)
    Group=SpatialPointsDataFrame(Group,GroupData)
    proj4string(Group)=CRS(CRSProj)
    if(OutputFormat=="SHAPEFILE"){
      writeOGR(Group,".",OutputName,driver="ESRI Shapefile")
    }else{
      return(Group)
    }
  }
  else #Add BUFFER
  {for (i in (1:length(ListIDs))){ #Loop over Lines
    
    PID=ListIDs[i]
    PLon=Lons[IDs==PID]
    PLat=Lats[IDs==PID]
    LLon=PLon
    LLat=PLat
    
    if ((dim(data)[2])==3){PVal=NULL}
    if ((dim(data)[2])==4){PVal=unique(XtraFields[IDs==PID])
    if(length(PVal)>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
    if ((dim(data)[2])>4){PVal=unique(XtraFields[IDs==PID,])
    if(dim(PVal)[1]>1){cat(paste("ERROR: There is more than one value in metadata associated with polygon",PID),"\n");break}}
    
    #Project Lat/Lon
    PRO=project(cbind(PLon,PLat),CRSProj)
    PLon=PRO[,1]
    PLat=PRO[,2]
    rm(PRO)
    
    #Create individual Points
    SPls=SpatialPoints(cbind(PLon,PLat))
    
    Buffered=gBuffer(SPls,width=Buffer)
    PLon=Buffered@polygons[[1]]@Polygons[[1]]@coords[,1]
    PLat=Buffered@polygons[[1]]@Polygons[[1]]@coords[,2]
    rm(Buffered)
    
    #Clip or not
    Pl=Polygon(cbind(PLon,PLat))
    if (Clip==FALSE){
      Pls=Polygons(list(Pl), ID=PID)
    }else{
      cat(paste("Start clipping polygon",PID),"\n")
      # need to fix when Coastline data on the online GIS has been clarified 
      Pls=Clip2Coast(Pl,Coastline=Clip,ID=PID)
      cat(paste("End clipping polygon",PID),"\n") 
    }
    
    SPls=SpatialPolygons(list(Pls))
    PArea=round(gArea(SPls, byid=F)/1000000)
    if ((dim(data)[2])==3){df=data.frame(name=PID,row.names=PID,AreaKm2=PArea,Lat=LLat,Lon=LLon)}
    if ((dim(data)[2])==4){df=data.frame(name=PID,row.names=PID,PVal,AreaKm2=PArea,Lat=LLat,Lon=LLon);colnames(df)[2]=names(data)[4]}
    if ((dim(data)[2])>4){df=data.frame(name=PID,row.names=PID,PVal,AreaKm2=PArea,Lat=LLat,Lon=LLon)}
    SPDF=SpatialPolygonsDataFrame(SPls, df)
    proj4string(SPDF)=CRS(CRSProj)
    #Add each polygon to the Group
    Group[i]=Pls
    GroupData=rbind(GroupData,df)
    
  }
    Group=SpatialPolygons(Group)
    Group=SpatialPolygonsDataFrame(Group,GroupData)
    proj4string(Group)=CRS(CRSProj)
    if(OutputFormat=="SHAPEFILE"){
      writeOGR(Group,".",OutputName,driver="ESRI Shapefile")
    }else{
      return(Group)
    }
  }
  
}

