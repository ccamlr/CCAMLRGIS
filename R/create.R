#' Create Polygons 
#'
#' Create Polygons such as proposed Research Blocks or Marine Protected Areas.
#'
#' @param Input  the name of the \code{Input} data as a .csv file or an R dataframe.
#' If a .csv file is used as input, this file must be in your working directory and its name given in quotes
#' e.g. "DataFile.csv".
#' 
#' \strong{If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Polygon name, Latitude, Longitude.
#' 
#' Latitudes and Longitudes must be given clockwise.}
#' 
#' @param NamesIn character vector of length 3 specifying the column names of polygon identifier, Latitude
#' and Longitude fields in the \code{Input}.
#' 
#' \strong{Names must be given in that order, e.g.:
#' 
#' \code{NamesIn=c('Polygon ID','Poly Latitudes','Poly Longitudes')}}.
#' 
#' @param OutputFormat can be an R object or an ESRI Shapefile. if \code{OutputFormat} is specified as
#' "ROBJECT" (the default), a SpatialPolygonDataFrame is created in your R environment.
#' if \code{OutputFormat} is specified as "SHAPEFILE", an ESRI Shapefile is exported in
#' your working directory. 
#' @param OutputName if \code{OutputFormat} is specified as "SHAPEFILE", the name of the output
#' shapefile in quotes (e.g. "MyPolygons") must be provided.
#' @param Buffer Distance in nautical miles by which to expand the polygons. Can be specified for
#' each polygon (as a numeric vector).
#' @param SeparateBuf If set to FALSE when adding a \code{Buffer},
#' all spatial objects are merged, resulting in a single spatial object.
#' @param Densify If set to TRUE, additional points between points of equal latitude are added
#' prior to projection (see examples). 
#' @param Clip if set to TRUE, polygon parts that fall on land are removed (see \link{Clip2Coast}).
#' 
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting spatial object contains the data provided in the \code{Input} plus
#' an additional "AreaKm2" column which corresponds to the areas, in square kilometers, of your polygons.
#' Also, columns "Labx" and "Laby" which may be used to add labels to polygons.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyPolygons@@data)}.
#'
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{add_RefGrid}}.
#' 
#' @examples
#' \donttest{
#' 
#' 
#' #Example 1: Simple and non-densified polygons
#' 
#' MyPolys=create_Polys(Input=PolyData,Densify=FALSE)
#' plot(MyPolys,col='blue')
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID,col='white')
#'
#' #Example 2: Simple and densified polygons (note the curvature of iso-latitude lines)
#' 
#' MyPolys=create_Polys(Input=PolyData)
#' plot(MyPolys,col='red')
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID,col='white')
#'
#' #Example 3: Buffered and clipped polygons
#' 
#' MyPolysBefore=create_Polys(Input=PolyData,Buffer=c(10,-15,120))
#' MyPolysAfter=create_Polys(Input=PolyData,Buffer=c(10,-15,120),Clip=TRUE)
#' plot(MyPolysBefore,col='green')
#' plot(Coast[Coast$ID=='All',],add=TRUE)
#' plot(MyPolysAfter,col='red',add=TRUE)
#' text(MyPolysAfter$Labx,MyPolysAfter$Laby,MyPolysAfter$ID,col='white')
#' 
#' #Example 4: Buffered and grouped polygons
#' MyPolys=create_Polys(Input=PolyData,Buffer=80,SeparateBuf=FALSE)
#' plot(MyPolys,border='blue',lwd=3)
#' 
#' 
#' }
#' 
#' @export

create_Polys=function(Input,Buffer=0,Densify=TRUE,Clip=FALSE,SeparateBuf=TRUE,NamesIn=NULL){
  # Load data
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==F){
    if(length(NamesIn)!=3){stop("'NamesIn' should be a character vector of length 3")}
    if(any(NamesIn%in%colnames(Input)==F)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  # Run cPolys
  Output=cPolys(Input,Densify=Densify)
  # Run add_buffer
  if(length(Buffer)==1){
    if(Buffer>0){Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)}
  }else{
    Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)
  }
  # Run Clip2Coast
  if(Clip==TRUE){Output=Clip2Coast(Output)}
  return(Output)
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
#' \strong{If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2 ... Variable x.}
#' 
#' @param NamesIn character vector of length 2 specifying the column names of Latitude and Longitude fields in
#' the \code{Input}. \strong{Latitudes name must be given first, e.g.:
#' 
#' \code{NamesIn=c('MyLatitudes','MyLongitudes')}}.
#' 
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
#' Data within the resulting spatial object contains the data provided in the \code{Input} after aggregation
#' within cells. For each Variable, the minimum, maximum, mean, sum, count, standard deviation, and, 
#' median of values in each cell is returned. In addition, for each cell, its area (AreaKm2), projected 
#' centroid (Centrex, Centrey) and unprojected centroid (Centrelon, Centrelat) is given.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyGrid@@data)}.
#' 
#' Finally, colors are generated for each aggregated values according to the chosen \code{cuts} 
#' (numerical classes) and \code{cols} (colors).
#' 
#' To generate a custom color scale after the grid creation, refer to \code{\link{add_col}} and 
#' \code{\link{add_Cscale}}. See Example 4 below.
#' 
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_Stations}}, \code{\link{add_RefGrid}}, \code{\link{add_col}}, \code{\link{add_Cscale}}.
#' 
#' @examples
#' \donttest{
#' 
#' 
#' #Example 1: Simple grid, using automatic colors
#' 
#' MyGrid=create_PolyGrids(Input=GridData,dlon=2,dlat=1)
#' #View(MyGrid@@data)
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' 
#' #Example 2: Equal area grid, using automatic colors
#' 
#' MyGrid=create_PolyGrids(Input=GridData,Area=10000)
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' 
#' #Example 3: Equal area grid, using custom cuts and colors
#' 
#' MyGrid=create_PolyGrids(Input=GridData,
#'        Area=10000,cuts=c(0,50,100,500,2000,3500),cols=c('blue','red'))
#' 
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' 
#' #Example 4: Equal area grid, using custom cuts and colors, and adding a color scale (add_Cscale)
#' 
#' #Step 1: Generate your grid
#' MyGrid=create_PolyGrids(Input=GridData,Area=10000)
#' 
#' #Step 2: Inspect your gridded data (e.g. sum of Catch) to
#' #determine whether irregular cuts are required
#' hist(MyGrid$Catch_sum,100) 
#' #In this case (heterogeneously distributed data) irregular cuts would be preferable
#' 
#' #Step 3: Generate colors according to the desired classes (cuts)
#' Gridcol=add_col(MyGrid$Catch_sum,cuts=c(0,50,100,500,2000,3500),cols=c('yellow','purple'))
#' 
#' #Step 4: Plot result and add color scale
#' Mypar=par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right)
#' plot(MyGrid,col=Gridcol$varcol) #Use the colors generated by add_col
#' #Add color scale using cuts and cols generated by add_col
#' add_Cscale(title='Sum of Catch (t)',cuts=Gridcol$cuts,cols=Gridcol$cols,width=24) 
#' par(Mypar)
#' 
#' }
#' 
#' @export

create_PolyGrids=function(Input,dlon=NA,dlat=NA,Area=NA,cuts=100,cols=c('green','yellow','red'),NamesIn=NULL){
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==F){
    if(length(NamesIn)!=2){stop("'NamesIn' should be a character vector of length 2")}
    if(any(NamesIn%in%colnames(Input)==F)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  #Run cGrid
  Output=cGrid(Input,dlon=dlon,dlat=dlat,Area=Area,cuts=cuts,cols=cols)
  return(Output)
}

#' Create Lines 
#'
#' Create Lines to display, for example, fishing line locations or tagging data.
#'
#' @param Input  the name of the \code{Input} data as a .csv file or an R dataframe.
#' If a .csv file is used as input, this file must be in your working directory and its name given in quotes
#' e.g. "DataFile.csv".
#' 
#' \strong{If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Line name, Latitude, Longitude.
#' 
#' If a given line is made of more than two points, the locations of points
#' must be given in order, from one end of the line to the other.}
#' 
#' @param NamesIn character vector of length 3 specifying the column names of line identifier, Latitude
#' and Longitude fields in the \code{Input}.
#' 
#' \strong{Names must be given in that order, e.g.:
#' 
#' \code{NamesIn=c('Line ID','Line Latitudes','Line Longitudes')}}.
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
#' @param SeparateBuf If set to FALSE when adding a \code{Buffer},
#' all spatial objects are merged, resulting in a single spatial object.
#' 
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting spatial object contains the data provided in the \code{Input} plus
#' additional "LengthKm" and "LengthNm" columns which corresponds to the lines lengths,
#' in kilometers and nautical miles respectively.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyLines@@data)}.
#'
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Polys}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{add_RefGrid}}.
#' 
#' @examples
#' \donttest{
#' 
#' 
#' #If your data contains line end locations in separate columns, you may reformat it as follows:
#' 
#' #Example data:
#' MyData=data.frame(
#'   Line=c(1,2),
#'   Lat_Start=c(-60,-65),
#'   Lon_Start=c(-10,5),
#'   Lat_End=c(-61,-66),
#'   Lon_End=c(-2,2)
#' )
#' 
#' #Reformat to us as input as:
#' Input=data.frame(
#'   Line=c(MyData$Line,MyData$Line),
#'   Lat=c(MyData$Lat_Start,MyData$Lat_End),
#'   Lon=c(MyData$Lon_Start,MyData$Lon_End)
#' )
#' 
#' #Create lines and plot them
#' plot(create_Lines(Input=Input))
#' 
#' 
#' #Example 1: Simple and non-densified lines
#' 
#' MyLines=create_Lines(Input=LineData)
#' plot(MyLines,lwd=2,col=rainbow(length(MyLines)))
#'
#' #Example 2: Simple and densified lines (note the curvature of the purple line)
#' 
#' MyLines=create_Lines(Input=LineData,Densify=TRUE)
#' plot(MyLines,lwd=2,col=rainbow(length(MyLines)))
#'
#' #Example 3: Densified, buffered and clipped lines
#' 
#' MyLines=create_Lines(Input=LineData,Densify=TRUE,Buffer=c(10,40,50,80,100),Clip=TRUE)
#' 
#' plot(MyLines,lwd=2,col=rainbow(length(MyLines)))
#' plot(Coast[Coast$ID=='All',],col='grey',add=TRUE)
#' 
#' #Example 4: Buffered and grouped lines
#' MyLines=create_Lines(Input=LineData,Densify=TRUE,Buffer=30,SeparateBuf=FALSE)
#' plot(MyLines,lwd=2,border='blue')
#' 
#' }
#' 
#' @export

create_Lines=function(Input,Buffer=0,Densify=FALSE,Clip=FALSE,SeparateBuf=TRUE,NamesIn=NULL){
  # Load data
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==F){
    if(length(NamesIn)!=3){stop("'NamesIn' should be a character vector of length 3")}
    if(any(NamesIn%in%colnames(Input)==F)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  # Run cLines
  Output=cLines(Input,Densify=Densify)
  # Run add_buffer
  if(length(Buffer)==1){
    if(Buffer>0){Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)}
  }else{
    Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)
  }
  # Run Clip2Coast
  if(Clip==TRUE){Output=Clip2Coast(Output)}

  return(Output)
  
}

#' Create Points
#'
#' Create Points to display point locations. Buffering points may be used to produce bubble charts.
#'
#' @param Input the name of the \code{Input} data as a .csv file or an R dataframe.
#' If a .csv file is used as input, this file must be in your working directory and its name given in quotes
#' e.g. "DataFile.csv".
#' 
#' \strong{If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2, ... Variable x}
#' 
#' @param NamesIn character vector of length 2 specifying the column names of Latitude and Longitude fields in
#' the \code{Input}. \strong{Latitudes name must be given first, e.g.:
#' 
#' \code{NamesIn=c('MyLatitudes','MyLongitudes')}}.
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
#' @param SeparateBuf If set to FALSE when adding a \code{Buffer},
#' all spatial objects are merged, resulting in a single spatial object.
#' 
#' @return Spatial object in your environment or ESRI shapefile in your working directory.
#' Data within the resulting spatial object contains the data provided in the \code{Input} plus
#' additional "x" and "y" columns which corresponds to the projected points locations 
#' and may be used to label points (see examples).
#' 
#' To see the data contained in your spatial object, type: \code{View(MyPoints@@data)}.
#'
#' @seealso 
#' \code{\link{create_Lines}}, \code{\link{create_Polys}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{add_RefGrid}}.
#' 
#' @examples
#' \donttest{
#' 
#' 
#' #Example 1: Simple points with labels
#' 
#' MyPoints=create_Points(Input=PointData)
#' plot(MyPoints)
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=TRUE)
#' 
#' #Example 2: Simple points with labels, highlighting one group of points with the same name
#' 
#' MyPoints=create_Points(Input=PointData)
#' plot(MyPoints)
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=TRUE)
#' plot(MyPoints[MyPoints$name=='four',],bg='red',pch=21,cex=1.5,add=TRUE)
#' 
#' #Example 3: Buffered points with radius proportional to catch
#' 
#' MyPoints=create_Points(Input=PointData,Buffer=0.5*PointData$Catch)
#' plot(MyPoints,col='green')
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,0.5),xpd=TRUE)
#' 
#' #Example 4: Buffered points with radius proportional to catch and clipped to the Coast
#' 
#' MyPoints=create_Points(Input=PointData,Buffer=2*PointData$Catch,Clip=TRUE)
#' plot(MyPoints,col='cyan')
#' plot(Coast[Coast$ID=='All',],add=TRUE,col='grey')
#' 
#' 
#' }
#' 
#' @export

create_Points=function(Input,Buffer=0,Clip=FALSE,SeparateBuf=TRUE,NamesIn=NULL){
  # Load data
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==F){
    if(length(NamesIn)!=2){stop("'NamesIn' should be a character vector of length 2")}
    if(any(NamesIn%in%colnames(Input)==F)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  # Run cPoints
  Output=cPoints(Input)
  # Run add_buffer
  if(all(Buffer>0)){Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)}
  if(any(Buffer<0)){stop("'Buffer' should be positive")}
  # Run Clip2Coast
  if(Clip==TRUE){Output=Clip2Coast(Output)}
  return(Output)
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
#' \code{\link{create_Polys}}, \code{\link{SmallBathy}}, \code{\link{add_RefGrid}}.
#' 
#' @examples
#' \donttest{
#' 
#'
#' #First, create a polygon within which stations will be created
#' 
#' MyPolys=create_Polys(Input=PolyData,Densify=TRUE)
#' plot(MyPolys)
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID)
#' #Subsample MyPolys to only keep the polygon with ID 'one'
#' MyPoly=MyPolys[MyPolys$ID=='one',]
#' plot(MyPoly,col='green',add=TRUE)
#' 
#' #Second (optional), crop your bathymetry raster to match the extent of your polygon
#' 
#' BathyCroped=raster::crop(SmallBathy,MyPoly)
#' 
#' 
#' #Example 1: Set numbers of stations, no distance constraint
#' 
#' MyStations=create_Stations(Poly=MyPoly,
#'            Bathy=BathyCroped,Depths=c(-550,-1000,-1500,-2000),N=c(20,15,10))
#' Mypar=par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right)
#' plot(BathyCroped,breaks=Depth_cuts, col=Depth_cols, legend=FALSE,axes=FALSE,box=FALSE)
#' add_Cscale(offset = 50,height = 90,fontsize = 0.8,width=25)
#' plot(MyPoly,add=TRUE,border='red',lwd=2)
#' raster::contour(BathyCroped,levels=c(-550,-1000,-1500,-2000),add=TRUE)
#' plot(MyStations,add=TRUE,col='orange')
#' par(Mypar)
#' 
#' #Example 2: Set numbers of stations, with distance constraint
#'  
#' MyStations=create_Stations(Poly=MyPoly,
#'            Bathy=BathyCroped,Depths=c(-550,-1000,-1500,-2000),N=c(20,15,10),dist=10)
#' Mypar=par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right)
#' plot(BathyCroped,breaks=Depth_cuts, col=Depth_cols, legend=FALSE,axes=FALSE,box=FALSE)
#' add_Cscale(offset = 50,height = 90,fontsize = 0.8,width=25)
#' plot(MyPoly,add=TRUE,border='red',lwd=2)
#' raster::contour(BathyCroped,levels=c(-550,-1000,-1500,-2000),add=TRUE)
#' plot(MyStations[MyStations$Stratum=='550-1000',],pch=21,bg='yellow',add=TRUE)
#' plot(MyStations[MyStations$Stratum=='1000-1500',],pch=21,bg='orange',add=TRUE)
#' plot(MyStations[MyStations$Stratum=='1500-2000',],pch=21,bg='red',add=TRUE)
#' par(Mypar)
#' 
#' #Example 3: Automatic numbers of stations, with distance constraint
#' 
#' MyStations=create_Stations(Poly=MyPoly,
#'            Bathy=BathyCroped,Depths=c(-550,-1000,-1500,-2000),Nauto=30,dist=10)
#' Mypar=par(mai=c(0,0,0,2)) #Figure margins as c(bottom, left, top, right)
#' plot(BathyCroped,breaks=Depth_cuts, col=Depth_cols, legend=FALSE,axes=FALSE,box=FALSE)
#' add_Cscale(offset = 50,height = 90,fontsize = 0.8,width=25)
#' plot(MyPoly,add=TRUE,border='red',lwd=2)
#' raster::contour(BathyCroped,levels=c(-550,-1000,-1500,-2000),add=TRUE)
#' plot(MyStations[MyStations$Stratum=='550-1000',],pch=21,bg='yellow',add=TRUE)
#' plot(MyStations[MyStations$Stratum=='1000-1500',],pch=21,bg='orange',add=TRUE)
#' plot(MyStations[MyStations$Stratum=='1500-2000',],pch=21,bg='red',add=TRUE)
#' par(Mypar)
#' 
#' }
#' 
#' @export

create_Stations=function(Poly,Bathy,Depths,N=NA,Nauto=NA,dist=NA,Buf=1000,ShowProgress=FALSE){
  if(is.na(sum(N))==FALSE & is.na(Nauto)==FALSE){
    stop('Values should not be specified for both N and Nauto.')
  }
  if(is.na(sum(N))==FALSE & length(N)!=length(Depths)-1){
    stop('Incorrect number of stations specified.')
  }

  #Crop Bathy
  Bathy=raster::crop(Bathy,extend(extent(Poly),10000))
  #Generate Isobaths polygons
  IsoDs=data.frame(top=Depths[1:(length(Depths)-1)],
                   bot=Depths[2:length(Depths)])
  IsoNames=paste0(abs(IsoDs$top),'-',abs(IsoDs$bot))
  #start with first strata, then loop over remainder
  if(ShowProgress==TRUE){
    message('Depth strata creation started',sep='\n')
    pb=txtProgressBar(min=0,max=dim(IsoDs)[1],style=3,char=" )>(((*> ")
  }
  Biso=cut(Bathy,breaks=c(IsoDs$top[1],IsoDs$bot[1]))
  Isos=suppressWarnings(rasterToPolygons(Biso,dissolve=TRUE))
  Isos$Stratum=IsoNames[1]
  if(ShowProgress==TRUE){setTxtProgressBar(pb, 1)}
  if(dim(IsoDs)[1]>1){
    for(i in seq(2,dim(IsoDs)[1])){
      Biso=cut(Bathy,breaks=c(IsoDs$top[i],IsoDs$bot[i]))
      Isotmp=suppressWarnings(rasterToPolygons(Biso,dissolve=TRUE))
      Isotmp$layer=i
      Isotmp$Stratum=IsoNames[i]
      Isos=rbind(Isos,Isotmp)
      if(ShowProgress==TRUE){setTxtProgressBar(pb, i)}
    }
  }
  if(ShowProgress==TRUE){
    message('\n')
    message('Depth strata creation ended',sep='\n')
    close(pb)
  }
  #crop Isos by Poly
  Isos=suppressWarnings(raster::crop(Isos,Poly))
  
  #Get number of stations per strata
  if(is.na(Nauto)==TRUE){
    IsoDs$n=N
  }else{
    #Get area of strata
    ar=suppressWarnings(area(Isos))
    ar=ar/max(ar)
    IsoDs$n=round(ar*Nauto)
  }
  #Generate locations
  #Create a fine grid from which to sample from
  if(ShowProgress==TRUE){
    message('Station creation started',sep='\n')
    pb=txtProgressBar(min=0,max=dim(IsoDs)[1],style=3,char=" )>(((*> ")
  }
  Grid=suppressWarnings(raster(extent(Isos),res=1000,crs=crs(Isos)))
  Grid=SpatialPoints(coordinates(Grid),proj4string=crs(Grid))
  #Remove points outside of strata
  Locs=NULL
  for(i in seq(1,dim(IsoDs)[1])){
    GridL=over(Grid,gBuffer(Isos[i,],width=-Buf))
    GridL=Grid[is.na(GridL)==FALSE]
    Locs=rbind(Locs,cbind(coordinates(GridL),i))
  }
  Grid=SpatialPointsDataFrame(cbind(Locs[,1],Locs[,2]),data.frame(layer=Locs[,3]),proj4string=CRS("+init=epsg:6932"))
  
  if(is.na(dist)==TRUE){ #Random locations
    Locs=NULL
    for(i in seq(1,dim(IsoDs)[1])){
      Locs=rbind(Locs,cbind(coordinates(Grid[Grid$layer==i,])[sample(seq(1,length(which(Grid$layer==i))),IsoDs$n[i]),],i))
      if(ShowProgress==TRUE){setTxtProgressBar(pb, i)}
    }
    Locs=data.frame(layer=Locs[,3],
                    Stratum=IsoNames[Locs[,3]],
                    x=Locs[,1],
                    y=Locs[,2])
    #Add Lat/Lon
    Locs=project_data(Input=Locs,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = T,inv=T)
    
    Stations=SpatialPointsDataFrame(Locs[,c('x','y')],Locs,proj4string=CRS("+init=epsg:6932"))
    if(ShowProgress==TRUE){
      message('\n')
      message('Station creation ended',sep='\n')
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
      smallB=gBuffer(SpatialPoints(cbind(tmpx,tmpy),proj4string=CRS("+init=epsg:6932")),width=wdth,quadsegs=25)
      smallBi=over(Grid,smallB)
      smallBi=which(is.na(smallBi)==FALSE)
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
    message('\n')
    for(s in sort(unique(Locs$layer))){
      ns=length(which(Locs$layer==s))
      message(paste0('Stratum ',IsoNames[s],' may contain up to ',ns,' stations given the distance desired'),sep='\n')
    }
    message('\n')
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
    Locs=project_data(Input=Locs,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = T,inv=T)
    
    Stations=SpatialPointsDataFrame(Locs[,c('x','y')],Locs,proj4string=CRS("+init=epsg:6932"))
    if(ShowProgress==TRUE){
      message('\n')
      message('Station creation ended',sep='\n')
      close(pb)
    }
  }
  #Check results
  ns=NULL
  for(i in sort(unique(Stations$layer))){
    ns=c(ns,length(which(Stations$layer==i)))
  }
  if(sum(ns-IsoDs$n)!=0){
    stop('Something unexpected happened. Please report the error to the package maintainer')
  }
  return(Stations)
}
