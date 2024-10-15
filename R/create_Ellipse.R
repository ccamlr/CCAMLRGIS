#' Create Ellipse
#' 
#' Create an ellipse.
#' 
#' @param Latc numeric, latitude of the ellipse centre in decimal degrees, or Y projected 
#' coordinate if \code{yx} is set to \code{TRUE}. 
#' 
#' @param Lonc numeric, longitude of the ellipse centre in decimal degrees, or X projected 
#' coordinate if \code{yx} is set to \code{TRUE}. 
#' 
#' @param Lmaj numeric, length of major axis.
#' 
#' @param Lmin numeric, length of minor axis.
#' 
#' @param Ang numeric, angle of rotation (0-360).
#' 
#' @param Np integer, number of points on the ellipse.
#' 
#' @param dir character, either \code{"cw"} (clockwise) or \code{"ccw"} (counterclockwise). 
#' Sets the order of points, only matters for \code{\link{create_CircularArrow}}.
#' 
#' @param yx Logical, if set to \code{TRUE} the input coordinates are projected.
#' Give Y as \code{Latc} and X as \code{Lonc}.
#' 
#' @return Spatial object in your environment.
#' 
#' @seealso 
#' \code{\link{create_Arrow}}, \code{\link{create_CircularArrow}}, \code{\link{create_Polys}},
#' \code{\link{add_Legend}}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#26-create-ellipse
#' 
#' El1=create_Ellipse(Latc=-61,Lonc=-50,Lmaj=500,Lmin=250,Ang=120)
#' El2=create_Ellipse(Latc=-72,Lonc=-30,Lmaj=500,Lmin=500)
#' Hash=create_Hashes(El2,spacing=2,width=2)
#' El3=create_Ellipse(Latc=-68,Lonc=-55,Lmaj=400,Lmin=100,Ang=35)
#' 
#' terra::plot(SmallBathy(),xlim=c(-3e6,0),ylim=c(0,3e6),breaks=Depth_cuts,
#'             col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE)
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',add=TRUE)
#' plot(st_geometry(El1),col=rgb(0,1,0.5,alpha=0.5),add=TRUE,lwd=2)
#' plot(st_geometry(El3),col=rgb(0,0.5,0.5,alpha=0.5),add=TRUE,border="orange",lwd=2)
#' plot(st_geometry(Hash),add=TRUE,col="red",border=NA)
#' 
#' @export

create_Ellipse=function(Latc,Lonc,Lmaj,Lmin,Ang=0,Np=100,dir="cw",yx=FALSE){
  #Project centre
  if(yx==FALSE){
    Cen=project_data(data.frame(Lat=Latc,Lon=Lonc),NamesIn=c("Lat","Lon"))
  }else{
    Cen=data.frame(Y=Latc,X=Lonc)
  }
  Lmaj=Lmaj*1000
  Lmin=Lmin*1000
  Ang=Ang*(pi/180)
  if(dir=="ccw"){
    Th=seq(0,2*pi,length.out=Np)
  }else{
    Th=seq(2*pi,0,length.out=Np)
  }
  x=Lmaj*cos(Ang)*cos(Th)+Lmin*sin(Ang)*sin(Th)+Cen$X
  y=Lmin*cos(Ang)*sin(Th)-Lmaj*sin(Ang)*cos(Th)+Cen$Y
  xy=cbind(x,y)
  if(x[1]!=x[length(x)] | y[1]!=y[length(y)]){#close loop if needed
    xy=rbind(xy,xy[1,])
  }
  Pl=st_polygon(list(xy))
  Pl=st_sfc(Pl, crs = 6932)
  Pl=st_set_geometry(Cen,Pl)
  return(Pl)
}
