#' Calculate planimetric seabed area
#'
#' Calculate planimetric seabed area within polygons and depth strata in square kilometers.
#' 
#' @param Bathy bathymetry raster with the appropriate \code{\link[CCAMLRGIS:CCAMLRp]{projection}}.
#' It is highly recommended to use a raster of higher
#' resolution than \code{\link{SmallBathy}}, see \code{\link{load_Bathy}}.
#' @param Poly polygon(s) within which the areas of depth strata are computed.
#' @param PolyNames character, column name (from the polygon object) to be used in the output. 
#' @param depth_classes numeric vector of strata depths. for example, \code{depth_classes=c(-600,-1000,-2000)}.
#' If the values \code{-600,-1800} are given within \code{depth_classes}, the computed area will be labelled as 'Fishable_area'.
#' @return dataframe with the name of polygons in the first column and the area for each strata in the following columns.
#' 
#' @seealso 
#' \code{\link{load_Bathy}}, \code{\link{SmallBathy}}, \code{\link{create_Polys}}, \code{\link{load_RBs}}.
#' 
#' @examples
#' \donttest{
#' 
#'#create some polygons
#'MyPolys=create_Polys(PolyData,Densify=TRUE)
#'#compute the seabed areas
#'FishDepth=seabed_area(SmallBathy,MyPolys,PolyNames="ID",
#'depth_classes=c(0,-200,-600,-1800,-3000,-5000))
#'#Result looks like this (note that the 600-1800 stratum is renamed 'Fishable_area')
#'#View(FishDepth)
#' 
#' 
#' }
#' 
#' @export

seabed_area=function (Bathy, Poly, PolyNames=NULL, depth_classes=c(-600,-1800)){

  if(class(Poly)[1]!="sf"){
    stop("'Poly' must be an sf object")
  }
  if(is.null(PolyNames)){
    stop("'PolyNames' is missing")
  }else{
    if(PolyNames%in%colnames(Poly)==FALSE){
      stop("'PolyNames' does not match column names in 'Poly'")  
    }
  }
  #Coerce Bathy
  if(class(Bathy)[1]!="SpatRaster"){
  Bathy=terra::rast(Bathy)
  }
  
  OUT=data.frame(matrix(nrow=nrow(Poly),ncol=length(depth_classes)))
  colnames(OUT)=c(PolyNames, paste(depth_classes[1:length(depth_classes)-1],depth_classes[2:length(depth_classes)],sep='|'))
  for(i in seq(1,nrow(Poly))){
    poly=Poly[i,]
    OUT[i,1]=as.character(st_drop_geometry(poly[,PolyNames]))
    #crop bathymetry data to the extent of the polygon
    CrB=terra::crop(Bathy,terra::ext(poly))
    #Turn bathy cells that are not inside the polygon into NAs
    CrB=terra::mask(CrB,terra::vect(poly))
    
    for(j in seq(1,(length(depth_classes)-1))){
      dtop=depth_classes[j]
      dbot=depth_classes[j+1]
      #Turn cells outside depth classes into NAs
      Btmp = terra::classify(CrB, cbind(-100000, dbot, NA), right=TRUE)
      Btmp = terra::classify(Btmp, cbind(dtop, 100000, NA), right=FALSE)
      #Compute the area covered by cells that are not NA
      Ar=round(terra::expanse(Btmp, unit="km"),2)$area
      OUT[i,j+1]=Ar
    }
  }
  colnames(OUT)[which(colnames(OUT)=="-600|-1800")]="Fishable_area"
  return(OUT)
}
