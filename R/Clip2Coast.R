#' Clip Polygons to the Antarctic coastline
#'
#' Clip Polygons to the \link{Coast} (removes polygon parts that fall on land) and computes the area of the resulting polygon.
#' Uses a SpatialPolygon as input which may be user-generated or created via buffered points (see \link{create_Points}),
#' buffered lines (see \link{create_Lines}) or polygons (see \link{create_Polys}).
#'
#' @param Input Polygon(s) to be clipped.
#' 
#' @examples
#' #Example 1: Use Clip2Coast on a pre-generated polygon
#' 
#' MyPolys=create_Polys(PolyData,Densify=TRUE,Buffer=c(10,-15,120))
#' plot(MyPolys,col='red')
#' plot(Coast[Coast$ID=='All',],col='grey',add=TRUE)
#' MyPolysClipped=Clip2Coast(MyPolys)
#' plot(MyPolysClipped,col='blue',add=TRUE)
#' #View(MyPolysClipped)
#' 
#' #Example 2: Use Clip2Coast while creating a polygon, with Clip=TRUE in create_Polys().
#' 
#' MyPolysBefore=create_Polys(PolyData,Buffer=c(10,-15,120))
#' MyPolysAfter=create_Polys(PolyData,Buffer=c(10,-15,120),Clip=TRUE)
#' plot(MyPolysBefore,col='green')
#' plot(Coast[Coast$ID=='All',],add=TRUE)
#' plot(MyPolysAfter,col='red',add=TRUE)
#' 
#' @seealso 
#' \link{Coast}, \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_PolyGrids}}.
#' 
#' @return SpatialPolygon carrying the same data as the \code{Input}.
#' @export

Clip2Coast=function(Input){
  tmp=suppressWarnings(gDifference(Input,Coast[Coast$ID=='All',],byid=TRUE,checkValidity=2,id=as.character(Input$ID)))
  #Get areas
  Ar=round(gArea(tmp,byid=TRUE)/1000000,1)
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

