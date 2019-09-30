#' Densify line or polygon data when projecting 
#'
#' A geoprocessing function that densifies a line or polygon data when projecting. This function is called in create_Polys
#'
#' @param Lon Longitude coordinates (in Decimal Degrees)
#' @param Lat Latitude coordinates (in Decimal Degrees)
#' @keywords Densify
#' @import rgeos rgdal raster sp
#' @export

DensifyData=function(Lon,Lat){
  dlon=0.1
  GridLon=seq(dlon,360,by=dlon)
  Lon=Lon+180
  DenLon=NULL
  DenLat=NULL
  for (di in (1:(length(Lon)-1))){
    if ((Lat[di+1]==Lat[di]) & (Lon[di+1]!=Lon[di])){
      alpha=((Lon[di+1]-Lon[di])+180)%%360-180
      if (abs(alpha)==180){cat("WARNING: a line of isolatitude is exactly 180 degrees wide in longitude","\n","Please add an intermediate point in the line","\n")}
      if (alpha>0){if (length(which(GridLon>Lon[di] & GridLon<Lon[di+1]))>0){GridLoc=GridLon[(which(GridLon>Lon[di] & GridLon<Lon[di+1]))]}
        else{GridLoc=c(GridLon[which(GridLon>Lon[di])],GridLon[which(GridLon<Lon[di+1])])}
      }
      if (alpha<0){if (length(which(GridLon<Lon[di] & GridLon>Lon[di+1]))>0){GridLoc=GridLon[rev(which(GridLon<Lon[di] & GridLon>Lon[di+1]))]}
        else{GridLoc=c(GridLon[rev(which(GridLon<Lon[di]))],GridLon[rev(which(GridLon>Lon[di+1]))])}
      }
      DenLon=c(DenLon,c(Lon[di],GridLoc,Lon[di+1]))
      DenLat=c(DenLat,c(Lat[di],rep(Lat[di],length(GridLoc)),Lat[di+1]))
    }else{
      DenLon=c(DenLon,c(Lon[di],Lon[di+1]))
      DenLat=c(DenLat,c(Lat[di],Lat[di+1]))
    }
  }
  DenLon=DenLon-180
  Densified=cbind(DenLon,DenLat)
  return(Densified)
}
