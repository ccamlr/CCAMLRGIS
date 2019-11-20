#' Clip Polygons to the Antarctic coastline
#'
#' Clip Polygons to the \link{Coast} (removes polygon parts that fall on land) and computes the area of the resulting polygon.
#' Uses a SpatialPolygon as input which may be user-generated or created via buffered points (see \link{create_Points}),
#' buffered lines (see \link{create_Lines}) or polygons (see \link{create_Polys}).
#'
#' @param Input Polygon(s) to be clipped.
#' 
#' @examples
#' Example 1: Use Clip2Coast on a pre-generated polygon
#' 
#' MyPolys=create_Polys(PolyData,Densify=T,Buffer=c(10,-15,120))
#' plot(MyPolys,col='red')
#' plot(Coast,col='grey',add=T)
#' MyPolysClipped=Clip2Coast(MyPolys)
#' plot(MyPolysClipped,col='blue',add=T)
#' View(MyPolysClipped)
#' 
#' Example 2: Use Clip2Coast while creating a polygon, with Clip=T in create_Polys().
#' 
#' MyPolysBefore=create_Polys(PolyData,Buffer=c(10,-15,120))
#' MyPolysAfter=create_Polys(PolyData,Buffer=c(10,-15,120),Clip=T)
#' plot(MyPolysBefore,col='green')
#' plot(Coast,add=T)
#' plot(MyPolysAfter,col='red',add=T)
#' 
#' @seealso 
#' \link{Coast}, \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_PolyGrids}}.
#' 
#' @return SpatialPolygon carrying the same data as the \code{Input}.
#' @export

Clip2Coast=function(Input){
  require(rgeos)
  tmp=gDifference(Input,Coast,byid=T,checkValidity=2,id=as.character(Input$ID))
  #Get areas
  Ar=round(gArea(tmp,byid=T)/1000000,1)
  if("Buffered_AreaKm2"%in%colnames(Input@data)){
    Input$Buffered_and_clipped_AreaKm2=as.numeric(Ar)[match(Input$ID,names(Ar))]
  }
  if("AreaKm2"%in%colnames(Input@data)){
    Input$Clipped_AreaKm2=as.numeric(Ar)[match(Input$ID,names(Ar))]
  }
  #Get data back
  pdata=Input@data
  row.names(pdata)=Input$ID
  Output=SpatialPolygonsDataFrame(tmp,pdata)
  return(Output)
}

