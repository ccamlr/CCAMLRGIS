#' Rotate object
#' 
#' Rotate a spatial object by setting the longitude that should point up.
#' 
#' @param Input Spatial object of class \code{sf}, \code{sfc} or \code{SpatRaster (terra)}.
#' 
#' @param Lon0 numeric, longitude that will point up in the resulting map.
#' 
#' @return Spatial object in your environment to only be used for plotting, not for analysis.
#' 
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_PolyGrids}}, \code{\link{create_Stations}}, \code{\link{create_Pies}},
#' \code{\link{create_Arrow}}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#47-rotate_obj
#' # and:
#' # https://github.com/ccamlr/CCAMLRGIS/blob/master/Basemaps/Basemaps.md
#' 
#' RotB=Rotate_obj(SmallBathy(),Lon0=-180)
#' terra::plot(RotB,breaks=Depth_cuts,col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE)
#' add_RefGrid(bb=st_bbox(RotB),ResLat=10,ResLon=20,LabLon = -180,offset = 3)
#' 
#' @export

Rotate_obj=function(Input,Lon0=NULL){
  
  if(any(class(Input)%in%c("sf","sfc","SpatRaster"))==FALSE){
    stop("The input must be an object of class sf, sfc or SpatRaster.")
  }
  if(is.numeric(Lon0)==FALSE){
    stop("Lon0 must be numeric.")
  }
  CRSto=paste0("+proj=laea +lat_0=-90 +lon_0=",Lon0," +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs")
  
  if(any(class(Input)%in%c("sf","sfc"))){
    Robj=st_transform(Input,crs=CRSto)
  }
  
  if(any(class(Input)=="SpatRaster")){
    Robj=terra::project(Input,CRSto)
  }
  
  return(Robj)
}
