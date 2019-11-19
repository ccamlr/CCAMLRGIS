#' Calculate planimetric seabed area
#'
#' Calculate planimetric seabed area within polygons and depth strata in square kilometers.
#' 
#' @param Bathy bathymetry raster with the appropriate \code{\link[CCAMLRGIS:CCAMLRp]{projection}},
#' such as \code{\link[CCAMLRGIS:SmallBathy]{this one}}. It is recommended to use a raster of higher
#' resolution than \code{\link{SmallBathy}}.
#' @param Polys polygon(s) within which the areas of depth strata are computed. 
#' @param depth_classes numeric vector of strata depths. for example, \code{depth_classes=c(-600,-1000,-2000)}.
#' If the values \code{-600,-1800} are given within \code{depth_classes}, the computed area will be labelled as 'Fishable_area'.
#' @return dataframe with the name of polygons in the first column and the area for each strata in the following columns.
#' Note that polygon names are taken from the first column in the data of the input SpatialPolygonDataframe.
#' 
#' @seealso 
#' \code{\link{SmallBathy}}, \code{\link{create_Polys}}, \code{\link{load_RBs}}.
#' 
#' @examples
#'
#' Example 1: Compute fishable area in Research Blocks using the SmallBathy (not recommended)
#' 
#' RBs=load_RBs() 
#' RBs@@data[,1]=RBs$GAR_Short_Label #Take the 'GAR_Short_Label' as polygon names
#' FishDepth=seabed_area(SmallBathy,RBs)
#' View(FishDepth)
#' 
#' Example 2: Compute various strata areas within user-generated polygons
#' 
#' MyPolys=create_Polys(PolyData,Densify=T)
#' FishDepth=seabed_area(SmallBathy,MyPolys,depth_classes=c(0,-200,-600,-1800,-3000,-5000))
#' View(FishDepth)
#' 
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