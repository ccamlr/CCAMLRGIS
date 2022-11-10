#' Clip Polygons to the Antarctic coastline
#'
#' Clip Polygons to the \link{Coast} (removes polygon parts that fall on land) and computes the area of the resulting polygon.
#' Uses an sf object as input which may be user-generated or created via buffered points (see \link{create_Points}),
#' buffered lines (see \link{create_Lines}) or polygons (see \link{create_Polys}).
#'
#' @param Input sf polygon(s) to be clipped.
#' 
#' @examples
#' 
#' MyPolys=create_Polys(PolyData,Densify=TRUE,Buffer=c(10,-15,120))
#' plot(st_geometry(MyPolys),col='red')
#' plot(st_geometry(Coast[Coast$ID=='All',]),add=TRUE)
#' MyPolysClipped=Clip2Coast(MyPolys)
#' plot(st_geometry(MyPolysClipped),col='blue',add=TRUE)
#' #View(MyPolysClipped)
#' 
#' 
#' @seealso 
#' \link{Coast}, \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_PolyGrids}}.
#' 
#' @return sf polygon carrying the same data as the \code{Input}.
#' @export

Clip2Coast=function(Input){
  Output=suppressWarnings(st_difference(Input,Coast[Coast$ID=='All',],validate=TRUE))
  #Get areas
  Ar=round(st_area(Output)/1000000,1)
  if("Buffered_AreaKm2"%in%colnames(Output)){
    Output$Buffered_and_clipped_AreaKm2=as.numeric(Ar)
  }
  if("AreaKm2"%in%colnames(Output)){
    Output$Clipped_AreaKm2=as.numeric(Ar)
  }
  return(Output)
}

