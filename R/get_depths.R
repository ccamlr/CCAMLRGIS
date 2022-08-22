#' Get depths of locations from a bathymetry raster
#'
#' Given a bathymetry raster and an input dataframe of point locations (given in decimal degrees),
#' computes the depths at these locations (values for the cell each point falls in). The accuracy is
#' dependent on the resolution of the bathymetry raster (see \code{\link{load_Bathy}} to get high resolution data).
#' 
#' @param Input dataframe with, at least, Latitudes and Longitudes.
#' If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2, ... Variable x.
#' 
#' @param NamesIn character vector of length 2 specifying the column names of Latitude and Longitude fields in
#' the \code{Input}. Latitudes name must be given first, e.g.:
#' 
#' \code{NamesIn=c('MyLatitudes','MyLongitudes')}.
#' 
#' @param Bathy bathymetry raster with the appropriate \code{\link[CCAMLRGIS:CCAMLRp]{projection}},
#' such as \code{\link[CCAMLRGIS:SmallBathy]{this one}}. It is highly recommended to use a raster of higher
#' resolution than \code{\link{SmallBathy}} (see \code{\link{load_Bathy}}).
#' @return dataframe with the same structure as the \code{Input} with an additional depth column \code{'d'}.
#' 
#' @seealso 
#' \code{\link{load_Bathy}}, \code{\link{create_Points}},
#'  \code{\link{create_Stations}}.
#' 
#' @examples
#' 
#' 
#' #Generate a dataframe
#' MyData=data.frame(Lat=PointData$Lat,
#' Lon=PointData$Lon,
#' Catch=PointData$Catch)
#' 
#' #get depths of locations
#' MyDataD=get_depths(Input=MyData,Bathy=SmallBathy)
#' #View(MyDataD)
#' plot(MyDataD$d,MyDataD$Catch,xlab='Depth',ylab='Catch',pch=21,bg='blue')
#' 
#'
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
  xy=project_data(Input,NamesIn=NamesIn,append=FALSE)
  xy=cbind(xy[,2],xy[,1])
  #extract depths
  ds=terra::extract(Bathy,xy)
  colnames(ds)="d"
  #Combine
  out=Input
  out$d=ds$d

  return(out)
}
