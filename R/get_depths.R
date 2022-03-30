#' Get depths of locations from bathymetry raster
#'
#' Given a bathymetry raster and an input dataframe of point locations (given in decimal degrees),
#' computes the depths at these locations (values for the cell each point falls in). The accuracy is
#' dependent on the resolution of the bathymetry raster (see \code{\link{load_Bathy}} to get high resolution).
#' 
#' @param Input dataframe with, at least, Latitudes and Longitudes.
#' \strong{If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2, ... Variable x}
#' 
#' @param NamesIn character vector of length 2 specifying the column names of Latitude and Longitude fields in
#' the \code{Input}. \strong{Latitudes name must be given first, e.g.:
#' 
#' \code{NamesIn=c('MyLatitudes','MyLongitudes')}}.
#' 
#' @param Bathy bathymetry raster with the appropriate \code{\link[CCAMLRGIS:CCAMLRp]{projection}},
#' such as \code{\link[CCAMLRGIS:SmallBathy]{this one}}. It is recommended to use a raster of higher
#' resolution than \code{\link{SmallBathy}} (see \code{\link{load_Bathy}}).
#' @param d distance in meters, used to group locations by distance and speed up computations (by cutting
#' the bathymetry raster into small pieces matching the extent of grouped locations). Lower values
#' make computations faster but at the risk of not finding distances to isobaths (when desired).
#' @param Isobaths Depths to which the horizontal distances to locations are computed, if required.
#' @param IsoLocs If \code{TRUE}, the locations on the \code{Iosbaths} that are closest to the
#' locations given in the \code{Input} are added to the exported dataframe.
#' @param ShowProgress if set to \code{TRUE}, a progress bar is shown (\code{get_depths} may take a while).
#' @return dataframe with the same structure as the \code{Input} with additional columns, where 
#' \code{'x'} and \code{'y'} are the projected locations, \code{'d'} is the depth,
#' \code{'D_iso'}, \code{'X_iso'} and \code{'Y_iso'} are the horizontal distances and 
#' closest point location on \code{'Isobaths'}. All units are in meters.
#' 
#' @seealso 
#' \code{\link{load_Bathy}}, \code{\link{SmallBathy}}, \code{\link{create_Points}},
#'  \code{\link{create_Stations}}, \code{\link[raster]{extract}}.
#' 
#' @examples
#' \donttest{
#' 
#' 
#' #Generate a dataframe
#' MyData=data.frame(Lat=PointData$Lat,
#' Lon=PointData$Lon,
#' Catch=PointData$Catch)
#' 
#' #Example 1: get depths of locations
#' MyDataD=get_depths(Input=MyData,Bathy=SmallBathy)
#' #View(MyDataD)
#' plot(MyDataD$d,MyDataD$Catch,xlab='Depth',ylab='Catch',pch=21,bg='blue') #Plot of catch vs depth
#' 
#' #Example 2: get depths of locations and distance to isobath -3000m
#' 
#' MyDataD=get_depths(Input=MyData,Bathy=SmallBathy,
#'         Isobaths=-3000,IsoLocs=TRUE,d=200000,ShowProgress=TRUE)
#' plot(MyDataD$x,MyDataD$y,pch=21,bg='green')
#' raster::contour(SmallBathy,levels=-3000,add=TRUE,col='blue',maxpixels=10000000)
#' segments(x0=MyDataD$x,
#'          y0=MyDataD$y,
#'          x1=MyDataD$X_3000,
#'          y1=MyDataD$Y_3000,col='red')
#'
#'
#'}
#'
#' @export

get_depths=function(Input,Bathy,NamesIn=NULL){
  Input = as.data.frame(Input)
  
  #Check NamesIn
  if (is.null(NamesIn) == FALSE) {
    if (length(NamesIn) != 2) {
      stop("'NamesIn' should be a character vector of length 2")
    }
    if (any(NamesIn %in% colnames(Input) == FALSE)) {
      stop("'NamesIn' do not match column names in 'Input'")
    }
  }else{
    NamesIn=colnames(Input)[1:2]
  }
  
  #Coerce Bathy
  if(class(Bathy)[1]!="SpatRaster"){
    Bathy=terra::rast(Bathy)
  }
  
  #Project Lat/Lon
  xy=project_data(Input,NamesIn=NamesIn,append=F)
  xy=cbind(xy[,2],xy[,1])
  #extract depths
  ds=terra::extract(Bathy,xy)
  colnames(ds)="d"
  #Combine
  out=Input
  out$d=ds$d

  return(out)
}
