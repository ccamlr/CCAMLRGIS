#' Calculate planimetric seabed area
#'
#' Calculate planimetric seabed area within the single depth class and/or multiple depth classes
#' @param bathymetry is data in a raster file format upon which the calculation
#' is based, it is assumed that all bathymetry values above zero have been removed. 
#' @param Polys is the polygon(s) region of interest in the SpatialPolygonsDataFrame 
#' @param fishable_area is TRUE if the planimetric seabed area in the fishable depth range (i.e. 800-1600m) will be calculated if FALSE then the total seabed area will be calculated
#' @param depth_classes is a character vector that includes the minimum and maximum depth within each depth class e.g. c("0-600","600-1800","1800-max")
#' @import raster
#' @export
seabed_area=function (Bathy, Polys, depth_classes=c(-600,-1800)){
  require(sp)
  require(raster)
  require(rgeos)
  
  if (proj4string(Bathy) != proj4string(Polys)){ 
    stop("Projection of bathymetry does not match that of Polygons")}
  
  cellarea=xres(Bathy)*yres(Bathy)
  
  colnames(Polys@data)[1]='name'
  OUT=data.frame(matrix(nrow=length(Polys$name),ncol=length(depth_classes)))
  colnames(OUT)=c("Polys", paste(depth_classes[1:length(depth_classes)-1],depth_classes[2:length(depth_classes)],sep='|'))
  OUT$Polys=Polys$name
  for(pol in OUT$Polys){
    poly=Polys[Polys$name==pol,]
    CrB=crop(Bathy, extend(extent(poly),2) )
    for(i in seq(1,(length(depth_classes)-1))){
      dtop=depth_classes[i]
      dbot=depth_classes[i+1]
      Biso=cut(CrB,breaks=c(dtop,dbot))
      Biso=mask(Biso,poly)
      cellcount=cellStats(Biso, stat='sum')
      ar=round(cellcount*cellarea/1000000,2)
      OUT[which(OUT$Polys==pol),i+1]=ar
    }
  }
  colnames(OUT)[which(colnames(OUT)=="-600|-1800")]="Fishable_area"
  return(OUT)
}