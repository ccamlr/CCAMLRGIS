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
