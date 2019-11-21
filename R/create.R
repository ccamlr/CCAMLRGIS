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
#' Also, columns "Labx" and "Laby" may be used to add labels to polygons.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyPolygons@@data)}.
#'
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{create_RefGrid}}.
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
#' Create a polygon grid to spatially aggregate data in cells of chosen size.
#' Cell size may be specified in degrees or as a desired area in square kilometers
#' (in which case cells are of equal area).
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
#' @param Area area, in square kilometers, of the grid cells.
#' @param cuts Number of desired color classes.
#' @param cols Desired colors. If more that one color is provided, a linear color gradient is generated.
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting object contains the data provided in the \code{Input} after aggregation
#' within cells. For each Variable, the minimum, maximum, mean, sum, count, standard deviation, and, 
#' median of values in each cell is returned.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyGrid@@data)}.
#' 
#' In addition, colors are generated for each aggregated values according to the chosen \code{cuts} (numerical classes)
#' and \code{cols} (colors).
#' To generate a custom color scale, refer to \code{\link{add_col}} and \code{\link{CBar}}.
#' 
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_Stations}}, \code{\link{create_RefGrid}}, \code{\link{add_col}}, \code{\link{CBar}}.
#' 
#' @examples
#' Example 1: Simple grid, using automatic colors
#' 
#' MyGrid=create_PolyGrids(GridData,dlon=2,dlat=1)
#' View(MyGrid@@data)
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' 
#' Example 2: Equal area grid, using automatic colors
#' 
#' MyGrid=create_PolyGrids(GridData,Area=10000)
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' 
#' Example 3: Equal area grid, using custom cuts and colors
#' 
#' MyGrid=create_PolyGrids(GridData,Area=10000,cuts=c(0,50,100,500,2000,3500),cols=c('blue','red'))
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' 
#' Example 4: Equal area grid, using custom cuts and colors, and adding a color scale (CBar)
#' 
#' #Step 1: Generate your grid
#' MyGrid=create_PolyGrids(GridData,Area=10000)
#' 
#' #Step 2: Inspect your grid data (e.g. sum of Catch) to determine whether irregular cuts are required
#' hist(MyGrid$Catch_sum,100) #In this case (heterogeneously distributed data) irregular cuts would be preferable
#' 
#' #Step 3: Generate colors according to the desired classes (cuts)
#' Gridcol=add_col(MyGrid$Catch_sum,cuts=c(0,50,100,500,2000,3500),cols=c('yellow','purple'))
#' 
#' #Step 4: Plot result and add color scale
#' par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right), here giving some room for the color scale
#' plot(MyGrid,col=Gridcol$varcol) #Use the colors generated by add_col
#' CBar(title='Sum of Catch (t)',Bcuts=Gridcol$cuts,Bcols=Gridcol$cols,width=24) #Add color scale using cuts and cols generated by add_col
#' 
#' @export

create_PolyGrids=function(Input,OutputFormat="ROBJECT",OutputName=NULL,dlon=NA,dlat=NA,Area=NA,cuts=100,cols=c('green','yellow','red')){
  if (class(Input)=="character"){Input=read.csv(Input)}
  #Run cGrid
  Output=cGrid(Input,dlon=dlon,dlat=dlat,Area=Area,cuts=cuts,cols=cols)
  if(OutputFormat=="SHAPEFILE"){
    writeOGR(Output,".",OutputName,driver="ESRI Shapefile")
  }else{
    return(Output)
  }
}

#' Create Lines 
#'
#' Create Lines to display, for example, fishing line locations or tagging data.
#'
#' @param Input  the name of the \code{Input} data as a .csv file or an R dataframe.
#' If a .csv file is used as input, this file must be in your working directory and its name given in quotes
#' e.g. "DataFile.csv".
#' 
#' \strong{The columns in the \code{Input} must be in the following order:
#' 
#' Line name, Latitude, Longitude.}
#' 
#' @param OutputFormat can be an R object or an ESRI Shapefile. if \code{OutputFormat} is specified as
#' "ROBJECT" (the default), a spatial object is created in your R environment.
#' if \code{OutputFormat} is specified as "SHAPEFILE", an ESRI Shapefile is exported in
#' your working directory. 
#' @param OutputName if \code{OutputFormat} is specified as "SHAPEFILE", the name of the output
#' shapefile in quotes (e.g. "MyLines") must be provided.
#' @param Buffer Distance in nautical miles by which to expand the lines. Can be specified for
#' each line (as a numeric vector).
#' @param Densify If set to TRUE, additional points between points of equal latitude are added
#' prior to projection (see examples). 
#' @param Clip if set to TRUE, polygon parts (from buffered lines) that fall on land are removed (see \link{Clip2Coast}).
#' 
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting object contains the data provided in the \code{Input} plus
#' additional "LengthKm" and "LengthNm" columns which corresponds to the lines lengths,
#' in kilometers and nautical miles respectively.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyLines@@data)}.
#'
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Polys}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{create_RefGrid}}.
#' 
#' @examples
#' Example 1: Simple and non-densified lines
#' 
#' MyLines=create_Lines(LineData)
#' plot(MyLines,lwd=2,col=rainbow(length(MyLines)))
#'
#' Example 2: Simple and densified lines (note the curvature of the purple line)
#' 
#' MyLines=create_Lines(LineData,Densify=T)
#' plot(MyLines,lwd=2,col=rainbow(length(MyLines)))
#'
#' Example 3: Densified, buffered and clipped lines
#' 
#' MyLines=create_Lines(LineData,Densify=T,Buffer=c(10,40,50,80,100),Clip=T)
#' 
#' plot(MyLines,lwd=2,col=rainbow(length(MyLines)))
#' plot(Coast,col='grey',add=T)
#' 
#' @export

create_Lines=function(Input,OutputFormat="ROBJECT",OutputName=NULL,Buffer=0,Densify=FALSE,Clip=FALSE){
  # Load data
  if (class(Input)=="character"){Input=read.csv(Input)}
  # Run cLines
  Output=cLines(Input,Densify=Densify)
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

#' Create Points
#'
#' Create Points to display point locations. Buffering points may be used to produce bubble charts.
#'
#' @param Input the name of the \code{Input} data as a .csv file or an R dataframe.
#' If a .csv file is used as input, this file must be in your working directory and its name given in quotes
#' e.g. "DataFile.csv".
#' 
#' \strong{The columns in the \code{Input} must be in the following order:
#' 
#' Point name, Latitude, Longitude, Variable 1, Variable 2, ... Variable x}
#' 
#' @param OutputFormat can be an R object or an ESRI Shapefile. if \code{OutputFormat} is specified as
#' "ROBJECT" (the default), a spatial object is created in your R environment.
#' if \code{OutputFormat} is specified as "SHAPEFILE", an ESRI Shapefile is exported in
#' your working directory. 
#' @param OutputName if \code{OutputFormat} is specified as "SHAPEFILE", the name of the output
#' shapefile in quotes (e.g. "MyPoints") must be provided.
#' @param Buffer Radius in nautical miles by which to expand the points. Can be specified for
#' each point (as a numeric vector).
#' @param Clip if set to TRUE, polygon parts (from buffered points) that fall on land are removed (see \link{Clip2Coast}).
#' 
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting object contains the data provided in the \code{Input} plus
#' additional "x" and "y" columns which corresponds to the projected points locations 
#' and may be used to label points (see examples).
#' 
#' To see the data contained in your spatial object, type: \code{View(MyPoints@@data)}.
#'
#' @seealso 
#' \code{\link{create_Lines}}, \code{\link{create_Polys}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{create_RefGrid}}.
#' 
#' @examples
#' Example 1: Simple points with labels
#' 
#' MyPoints=create_Points(PointData)
#' plot(MyPoints)
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=T)
#' 
#' Example 2: Simple points with labels, highlighting on group of points with the same name
#' 
#' MyPoints=create_Points(PointData)
#' plot(MyPoints)
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=T)
#' plot(MyPoints[MyPoints$name=='four',],bg='red',pch=21,cex=1.5,add=T)
#' 
#' Example 3: Buffered points with radius proportional to catch
#' 
#' MyPoints=create_Points(PointData,Buffer=0.5*PointData$Catch)
#' plot(MyPoints,col='green')
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,0.5),xpd=T)
#' 
#' Example 4: Buffered points with radius proportional to catch and clipped to the Coast
#' 
#' MyPoints=create_Points(PointData,Buffer=2*PointData$Catch,Clip=T)
#' plot(MyPoints,col='cyan')
#' plot(Coast,add=T,col='grey')
#' 
#' @export

create_Points=function(Input,OutputFormat="ROBJECT",OutputName=NULL,Buffer=0,Clip=FALSE){
  # Load data
  if (class(Input)=="character"){Input=read.csv(Input)}
  # Run cLines
  Output=cPoints(Input)
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

#' Create Stations
#'
#' Create random point locations inside a polygon and within bathymetry strata constraints.
#' A distance constraint between stations may also be used if desired.
#'
#' @param Poly single polygon inside which stations will be generated. May be created using \code{\link{create_Polys}}.
#' @param Bathy bathymetry raster with the appropriate \code{\link[CCAMLRGIS:CCAMLRp]{projection}}, such as \code{\link[CCAMLRGIS:SmallBathy]{this one}}.
#' @param Depths vector of depths. For example, if the depth strata required are 600 to 1000 and 1000 to 2000,
#' \code{Depths=c(-600,-1000,-2000)}.
#' @param N vector of number of stations required in each depth strata,
#' therefore \code{length(N)} must equal \code{length(Depths)-1}.
#' @param Nauto instead of specifying \code{N}, a number of stations proportional to the areas of the depth strata
#' may be created. \code{Nauto} is the maximum number of stations required in any depth stratum.
#' @param dist if desired, a distance constraint in nautical miles may be applied. For example, if \code{dist=2},
#' stations will be at least 2 nautical miles apart.
#' @param Buf distance in meters from isobaths. Useful to avoid stations falling on strata boundaries.
#' @param ShowProgress if set to \code{TRUE}, a progress bar is shown (\code{create_Stations} may take a while).
#' @return Spatial object in your environment. Data within the resulting object contains the strata and stations
#' locations in both projected space ("x" and "y") and degrees of Latitude/Longitude.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyStations@@data)}.
#'
#' @seealso 
#' \code{\link{create_Polys}}, \code{\link{SmallBathy}}, \code{\link{create_RefGrid}}.
#' 
#' @examples
#'
#' First, create a polygon within which stations will be created
#' 
#' MyPolys=create_Polys(PolyData,Densify=T)
#' plot(MyPolys)
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID)
#' #Subsample MyPolys to only keep the polygon with ID 'one'
#' MyPoly=MyPolys[MyPolys$ID=='one',]
#' plot(MyPoly,col='green',add=T)
#' 
#' Second (optional), crop your bathymetry raster to match the extent of your polygon
#' 
#' BathyCroped=crop(SmallBathy,MyPoly)
#' 
#' 
#' Example 1: Set numbers of stations, no distance constraint
#' 
#' MyStations=create_Stations(MyPoly,BathyCroped,Depths=c(-550,-1000,-1500,-2000),N=c(20,15,10),ShowProgress=T)
#' par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right), here giving some room for the color scale
#' plot(BathyCroped,breaks=Depth_cuts, col=Depth_cols, legend=F,axes=F,box=F)
#' CBar(offset = 50,height = 90,fontsize = 0.8,width=25)
#' plot(MyPoly,add=T,border='red',lwd=2)
#' contour(BathyCroped,levels=c(-550,-1000,-1500,-2000),add=T)
#' plot(MyStations,add=T,col='orange')
#' 
#' Example 2: Set numbers of stations, with distance constraint
#' 
#' MyStations=create_Stations(MyPoly,BathyCroped,Depths=c(-550,-1000,-1500,-2000),N=c(20,15,10),dist=10,ShowProgress=T)
#' par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right), here giving some room for the color scale
#' plot(BathyCroped,breaks=Depth_cuts, col=Depth_cols, legend=F,axes=F,box=F)
#' CBar(offset = 50,height = 90,fontsize = 0.8,width=25)
#' plot(MyPoly,add=T,border='red',lwd=2)
#' contour(BathyCroped,levels=c(-550,-1000,-1500,-2000),add=T)
#' plot(MyStations[MyStations$Stratum=='550-1000',],pch=21,bg='yellow',add=T)
#' plot(MyStations[MyStations$Stratum=='1000-1500',],pch=21,bg='orange',add=T)
#' plot(MyStations[MyStations$Stratum=='1500-2000',],pch=21,bg='red',add=T)
#' 
#' Example 3: Automatic numbers of stations, with distance constraint
#' 
#' MyStations=create_Stations(MyPoly,BathyCroped,Depths=c(-550,-1000,-1500,-2000),Nauto=30,dist=10,ShowProgress=T)
#' par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right), here giving some room for the color scale
#' plot(BathyCroped,breaks=Depth_cuts, col=Depth_cols, legend=F,axes=F,box=F)
#' CBar(offset = 50,height = 90,fontsize = 0.8,width=25)
#' plot(MyPoly,add=T,border='red',lwd=2)
#' contour(BathyCroped,levels=c(-550,-1000,-1500,-2000),add=T)
#' plot(MyStations[MyStations$Stratum=='550-1000',],pch=21,bg='yellow',add=T)
#' plot(MyStations[MyStations$Stratum=='1000-1500',],pch=21,bg='orange',add=T)
#' plot(MyStations[MyStations$Stratum=='1500-2000',],pch=21,bg='red',add=T)
#' 
#' @export

create_Stations=function(Poly,Bathy,Depths,N=NA,Nauto=NA,dist=NA,Buf=1000,ShowProgress=F){
  if(is.na(sum(N))==F & is.na(Nauto)==F){
    stop('Values should not be specified for both N and Nauto.')
  }
  if(is.na(sum(N))==F & length(N)!=length(Depths)-1){
    stop('Incorrect number of stations specified.')
  }
  require(rgdal)
  require(raster)
  require(sp)
  require(rgeos)
  
  #Crop Bathy
  Bathy=crop(Bathy,extend(extent(Poly),10000))
  #Generate Isobaths polygons
  IsoDs=data.frame(top=Depths[1:(length(Depths)-1)],
                   bot=Depths[2:length(Depths)])
  IsoNames=paste0(abs(IsoDs$top),'-',abs(IsoDs$bot))
  #start with first strata, then loop over remainder
  if(ShowProgress==T){
    cat('Depth strata creation started',sep='\n')
    pb=txtProgressBar(min=0,max=dim(IsoDs)[1],style=3,char=" )>(((*> ")
  }
  Biso=cut(Bathy,breaks=c(IsoDs$top[1],IsoDs$bot[1]))
  Isos=rasterToPolygons(Biso,dissolve=T)
  Isos$Stratum=IsoNames[1]
  if(ShowProgress==T){setTxtProgressBar(pb, 1)}
  if(dim(IsoDs)[1]>1){
    for(i in seq(2,dim(IsoDs)[1])){
      Biso=cut(Bathy,breaks=c(IsoDs$top[i],IsoDs$bot[i]))
      Isotmp=rasterToPolygons(Biso,dissolve=T)
      Isotmp$layer=i
      Isotmp$Stratum=IsoNames[i]
      Isos=rbind(Isos,Isotmp)
      if(ShowProgress==T){setTxtProgressBar(pb, i)}
    }
  }
  if(ShowProgress==T){
    cat('\n')
    cat('Depth strata creation ended',sep='\n')
    close(pb)
  }
  #crop Isos by Poly
  Isos=crop(Isos,Poly)
  
  #Get number of stations per strata
  if(is.na(Nauto)==T){
    IsoDs$n=N
  }else{
    #Get area of strata
    ar=area(Isos)
    ar=ar/max(ar)
    IsoDs$n=round(ar*Nauto)
  }
  #Generate locations
  #Create a fine grid from which to sample from
  if(ShowProgress==T){
    cat('Station creation started',sep='\n')
    pb=txtProgressBar(min=0,max=dim(IsoDs)[1],style=3,char=" )>(((*> ")
  }
  Grid=raster(extent(Isos),res=1000,crs=crs(Isos))
  Grid=SpatialPoints(coordinates(Grid),proj4string=crs(Grid))
  #Remove points outside of strata
  Locs=NULL
  for(i in seq(1,dim(IsoDs)[1])){
    GridL=over(Grid,gBuffer(Isos[i,],width=-Buf))
    GridL=Grid[is.na(GridL)==F]
    Locs=rbind(Locs,cbind(coordinates(GridL),i))
  }
  Grid=SpatialPointsDataFrame(cbind(Locs[,1],Locs[,2]),data.frame(layer=Locs[,3]),proj4string=CRS(CCAMLRp))
  
  if(is.na(dist)==T){ #Random locations
    Locs=NULL
    for(i in seq(1,dim(IsoDs)[1])){
      Locs=rbind(Locs,cbind(coordinates(Grid[Grid$layer==i,])[sample(seq(1,length(which(Grid$layer==i))),IsoDs$n[i]),],i))
      if(ShowProgress==T){setTxtProgressBar(pb, i)}
    }
    Locs=data.frame(layer=Locs[,3],
                    Stratum=IsoNames[Locs[,3]],
                    x=Locs[,1],
                    y=Locs[,2])
    #Add Lat/Lon
    tmp=project(cbind(Locs$x,Locs$y),proj=CCAMLRp,inv=T)
    Locs$Lat=tmp[,2]
    Locs$Lon=tmp[,1]
    Stations=SpatialPointsDataFrame(Locs[,c('x','y')],Locs,proj4string=CRS(CCAMLRp))
    if(ShowProgress==T){
      cat('\n')
      cat('Station creation ended',sep='\n')
      close(pb)
    }
  }else{ #Pseudo-random locations
    #Get starting point
    indx=floor(dim(Grid)[1]/2)
    tmp=coordinates(Grid)
    tmpx=tmp[indx,1]
    tmpy=tmp[indx,2]
    lay=Grid$layer[indx]
    #Set buffer width
    wdth=100*ceiling(1852*dist/100)
    Locs=NULL
    while(length(Grid)>0){
      smallB=gBuffer(SpatialPoints(cbind(tmpx,tmpy),proj4string=CRS(CCAMLRp)),width=wdth,quadsegs=25)
      smallBi=over(Grid,smallB)
      smallBi=which(is.na(smallBi)==F)
      #Save central point locations
      Locs=rbind(Locs,cbind(tmpx,tmpy,lay))
      #Remove points within buffer
      Grid=Grid[-smallBi,]
      #Get new point
      if(length(Grid)>0){
        indx=as.numeric(sample(seq(1,length(Grid)),1))
        tmp=coordinates(Grid)
        tmpx=tmp[indx,1]
        tmpy=tmp[indx,2]
        lay=Grid$layer[indx]}
    }
    Locs=data.frame(layer=Locs[,3],
                    Stratum=IsoNames[Locs[,3]],
                    x=Locs[,1],
                    y=Locs[,2])
    Locs$Stratum=as.character(Locs$Stratum)
    #Report results
    cat('\n')
    for(s in sort(unique(Locs$layer))){
      ns=length(which(Locs$layer==s))
      cat(paste0('Stratum ',IsoNames[s],' may contain up to ',ns,' stations given the distance desired'),sep='\n')
    }
    cat('\n')
    for(s in sort(unique(Locs$layer))){
      ns=length(which(Locs$layer==s))
      if(ns<IsoDs$n[s]){
        stop('Cannot generate stations given the constraints. Reduce dist and/or number of stations and/or Buf.')
      }
    }
    #Randomize locs within constraints
    indx=NULL
    for(i in sort(unique(Locs$layer))){
      indx=c(indx,sample(which(Locs$layer==i),IsoDs$n[i]))
    }
    Locs=Locs[indx,]    
    #Add Lat/Lon
    tmp=project(cbind(Locs$x,Locs$y),proj=CCAMLRp,inv=T)
    Locs$Lat=tmp[,2]
    Locs$Lon=tmp[,1]
    Stations=SpatialPointsDataFrame(Locs[,c('x','y')],Locs,proj4string=CRS(CCAMLRp))
    if(ShowProgress==T){
      cat('\n')
      cat('Station creation ended',sep='\n')
      close(pb)
    }
  }
  #Check results
  ns=NULL
  for(i in sort(unique(Stations$layer))){
    ns=c(ns,length(which(Stations$layer==i)))
  }
  if(sum(ns-IsoDs$n)!=0){
    stop('Something unexpected happened. Please report the error to the CCAMLR Secretariat')
  }
  return(Stations)
}

#' Create a Reference grid
#'
#' Create a Latitude/Longitude reference grid and add it to maps.
#'
#' @param bb bounding box of the first plotted object. for example, \code{bb=bbox(SmallBathy)} or \code{bb=bbox(MyPolys)}.
#' @param ResLat Latitude resolution in decimal degrees.
#' @param ResLon Longitude resolution in decimal degrees.
#' @param LabLon Longitude at which Latitude labels should appear. if set, the resulting Reference grid will be circumpolar.
#' @param lwd Line thickness of the Reference grid.
#' @param fontsize Font size of the Reference grid's labels.
#' @param offset offset of the Reference grid's labels (distance to plot border).
#' @seealso 
#' \code{\link{SmallBathy}}
#' 
#' @examples
#'
#' Example 1: Circumpolar grid with Latitude labels at Longitude 0
#' 
#' par(mai=c(1,1.5,0.5,0)) #Figure margins as c(bottom, left, top, right)
#' plot(SmallBathy,breaks=Depth_cuts, col=Depth_cols, legend=F,axes=F,box=F)
#' create_RefGrid(bb=bbox(SmallBathy),ResLat=10,ResLon=20,LabLon = 0)
#' 
#' Example 2: Local grid around created polygons
#' 
#' MyPolys=create_Polys(PolyData,Densify=T)
#' BathyC=crop(SmallBathy,MyPolys) #crop the bathymetry to match the extent of MyPolys
#' par(mai=c(0.5,0.5,0.5,0.5)) #Figure margins as c(bottom, left, top, right)
#' plot(BathyC,breaks=Depth_cuts, col=Depth_cols, legend=F,axes=F,box=F)
#' create_RefGrid(bb=bbox(BathyC),ResLat=2,ResLon=6)
#' plot(MyPolys,add=T,col='orange',border='brown',lwd=2)
#' 
#' @export

create_RefGrid=function(bb,ResLat=1,ResLon=2,LabLon=NA,lwd=1,fontsize=1,offset=NA){
require(rgdal)
require(raster)
require(rgeos)

#Get bbox manually from raster
xmin=bb[1,1]
xmax=bb[1,2]
ymin=bb[2,1]
ymax=bb[2,2]
Locs=cbind(c(xmin,xmin,xmax,xmax,xmin),
           c(ymin,ymax,ymax,ymin,ymin))

#Get offset
if(is.na(sum(offset))==T){
  #auto offset
  xd=xmax-xmin
  offsetx=0.01*xd
  yd=ymax-ymin
  offsety=0.02*yd
}else{
  if(length(offset)==1){offsetx=offset;offsety=offset}else{offsetx=offset[1];offsety=offset[2]}
}

#Create Lat/Lon grid
x=Spatial(cbind(min=c(-180,-80),max=c(180,-45)),proj4string=CRS("+proj=longlat +ellps=WGS84"))
gr=gridlines(x,easts=seq(-180,180,by=ResLon),norths=seq(-80,-45,by=ResLat),ndiscr = 1000)


#Create box
LocsP=SpatialLines(list(Lines(list(Line(Locs)),'name')), proj4string=CRS(CCAMLRp))

#Get labels
#Circumpolar
if(is.na(LabLon)==F){
  grP=gIntersection(gr[1],gr[2])
  Cs=coordinates(grP)
  Cs=data.frame(Lat=Cs[,2],Lon=Cs[,1])
  grP=SpatialPointsDataFrame(cbind(Cs$Lon,Cs$Lat),Cs,proj4string=CRS("+proj=longlat +ellps=WGS84"))
  grP=spTransform(grP,CRS(CCAMLRp))
  tmp=coordinates(grP)
  grP$x=tmp[,1]
  grP$y=tmp[,2]
  gr=spTransform(gr,CRS(CCAMLRp))
  
  Labs=grP@data
  LatLabs=Labs[Labs$Lon==LabLon,]
  LonLabs=Labs[Labs$Lat==max(Labs$Lat),]
  #Offset Longitude labels
  Lps=SpatialPoints(cbind(seq(-180,180,by=ResLon),-43),proj4string=CRS("+proj=longlat +ellps=WGS84"))
  Lps=spTransform(Lps,CRS(CCAMLRp))
  Lps=coordinates(Lps)
  LonLabs$x=Lps[,1]
  LonLabs$y=Lps[,2]
  #Adjust
  LonLabs$xadj=0.5
  LatLabs$xadj=0.5
}else{
  grlat=spTransform(gr[1],CRS(CCAMLRp))
  grlon=spTransform(gr[2],CRS(CCAMLRp))
  
  grlat=crop(grlat,LocsP)
  grlon=crop(grlon,LocsP)
  
  gr=rbind(grlat,grlon)
  
  grPlat=gIntersection(grlat,LocsP)
  grPlon=gIntersection(grlon,LocsP)
  
  tmp=coordinates(grPlat)
  Labslat=data.frame(x=tmp[,1],y=tmp[,2])
  
  tmp=coordinates(grPlon)
  Labslon=data.frame(x=tmp[,1],y=tmp[,2])
  
  LabslatV=Labslat[Labslat$x==min(Labslat$x)|Labslat$x==max(Labslat$x),]
  LabslatH=Labslat[Labslat$y==min(Labslat$y)|Labslat$y==max(Labslat$y),]
  LabslonV=Labslon[Labslon$x==min(Labslon$x)|Labslon$x==max(Labslon$x),]
  LabslonH=Labslon[Labslon$y==min(Labslon$y)|Labslon$y==max(Labslon$y),]
  
  #Rounding thing
  DecLat=nchar(strsplit(sub('0+$', '', as.character(ResLat)), ".", fixed = TRUE)[[1]])
  DecLon=nchar(strsplit(sub('0+$', '', as.character(ResLon)), ".", fixed = TRUE)[[1]])
  if(length(DecLat)==1){DecLat=0}else{DecLat=DecLat[[2]]}
  if(length(DecLon)==1){DecLon=0}else{DecLon=DecLon[[2]]}
  
  if((dim(LabslatH)[1]+dim(LabslonV)[1])>(dim(LabslatV)[1]+dim(LabslonH)[1])){
    #go with LabslatH and LabslonV
    #Get Lat/Lon
    tmp=project(cbind(LabslatH$x,LabslatH$y),proj=CCAMLRp,inv=T)
    LabslatH$Lat=tmp[,2]
    LabslatH$Lon=tmp[,1]
    tmp=project(cbind(LabslonV$x,LabslonV$y),proj=CCAMLRp,inv=T)
    LabslonV$Lat=tmp[,2]
    LabslonV$Lon=tmp[,1]
    #Add offset
    LabslatH$y[LabslatH$y==max(LabslatH$y)]=LabslatH$y[LabslatH$y==max(LabslatH$y)]+offsety
    LabslatH$y[LabslatH$y==min(LabslatH$y)]=LabslatH$y[LabslatH$y==min(LabslatH$y)]-offsety
    LabslatH$xadj=0.5
    LabslonV$xadj=1
    LabslonV$xadj[LabslonV$x==max(LabslonV$x)]=0
    LabslonV$x[LabslonV$x==max(LabslonV$x)]=LabslonV$x[LabslonV$x==max(LabslonV$x)]+offsetx
    LabslonV$x[LabslonV$x==min(LabslonV$x)]=LabslonV$x[LabslonV$x==min(LabslonV$x)]-offsetx
    #rename Labs
    LatLabs=LabslatH
    LonLabs=LabslonV
  }else{
    #go with LabslatV and LabslonH
    #Get Lat/Lon
    tmp=project(cbind(LabslatV$x,LabslatV$y),proj=CCAMLRp,inv=T)
    LabslatV$Lat=tmp[,2]
    LabslatV$Lon=tmp[,1]
    tmp=project(cbind(LabslonH$x,LabslonH$y),proj=CCAMLRp,inv=T)
    LabslonH$Lat=tmp[,2]
    LabslonH$Lon=tmp[,1]
    #Add offset
    LabslonH$xadj=0.5
    LabslatV$xadj=1
    LabslatV$xadj[LabslatV$x==max(LabslatV$x)]=0
    LabslatV$x[LabslatV$x==max(LabslatV$x)]=LabslatV$x[LabslatV$x==max(LabslatV$x)]+offsetx
    LabslatV$x[LabslatV$x==min(LabslatV$x)]=LabslatV$x[LabslatV$x==min(LabslatV$x)]-offsetx
    LabslonH$y[LabslonH$y==max(LabslonH$y)]=LabslonH$y[LabslonH$y==max(LabslonH$y)]+offsety
    LabslonH$y[LabslonH$y==min(LabslonH$y)]=LabslonH$y[LabslonH$y==min(LabslonH$y)]-offsety
    #rename Labs
    LatLabs=LabslatV
    LonLabs=LabslonH
  }
  
  #round
  LatLabs$Lat=round(LatLabs$Lat,DecLat)
  LonLabs$Lon=round(LonLabs$Lon,DecLon)
}

#Add W/E and S
LatLabs$Lat=paste0(abs(LatLabs$Lat),'S')
tmp=LonLabs$Lon
indx=which(tmp%in%c(0,-180,180))
indxW=which(LonLabs$Lon<0 & (LonLabs$Lon%in%c(0,-180,180)==F))
indxE=which(LonLabs$Lon>0 & (LonLabs$Lon%in%c(0,-180,180)==F))
LonLabs$Lon[indxW]=paste0(abs(LonLabs$Lon[indxW]),'W')
LonLabs$Lon[indxE]=paste0(LonLabs$Lon[indxE],'E')
LonLabs$Lon[LonLabs$Lon%in%c('180','-180')]='180'

par(xpd=T)
plot(gr,lty=3,add=T,lwd=lwd)
if(0.5%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==0.5],LatLabs$y[LatLabs$xadj==0.5],LatLabs$Lat[LatLabs$xadj==0.5],
       cex=fontsize,adj=c(0.5,0.5),xpd=T)}
if(1%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==1],LatLabs$y[LatLabs$xadj==1],LatLabs$Lat[LatLabs$xadj==1],
       cex=fontsize,adj=c(1,0.5),xpd=T)}
if(0%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==0],LatLabs$y[LatLabs$xadj==0],LatLabs$Lat[LatLabs$xadj==0],
       cex=fontsize,adj=c(0,0.5),xpd=T)}

if(0.5%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==0.5],LonLabs$y[LonLabs$xadj==0.5],LonLabs$Lon[LonLabs$xadj==0.5],
       cex=fontsize,adj=c(0.5,0.5),xpd=T)}
if(0%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==0],LonLabs$y[LonLabs$xadj==0],LonLabs$Lon[LonLabs$xadj==0],
       cex=fontsize,adj=c(0,0.5),xpd=T)}
if(1%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==1],LonLabs$y[LonLabs$xadj==1],LonLabs$Lon[LonLabs$xadj==1],
       cex=fontsize,adj=c(1,0.5),xpd=T)}
}