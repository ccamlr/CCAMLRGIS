#' CCAMLRGIS Projection
#'
#' The CCAMLRGIS package uses the \href{https://en.wikipedia.org/wiki/Lambert_azimuthal_equal-area_projection}{Lambert azimuthal equal-area projection}.
#'
#' @docType data
#' @format Character string
#' @return "+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
#' @source \url{https://gis.ccamlr.org/}
#' @name CCAMLRp
NULL

#' Coast
#'
#' Coastline polygons generated from \link{load_Coastline} and sub-sampled to only contain data that falls
#' within the CCAMLR boundaries (contour of ASDs + EEZs).
#'
#' @docType data
#' @format SpatialPolygons
#' @usage plot(Coast,col='grey')
#' @source \url{https://gis.ccamlr.org/}
#' @name Coast
NULL

#' Bathymetry colors
#'
#' Set of standard colors to plot bathymetry, to be used in conjunction with \link{Depth_cuts}.
#'
#' @docType data
#' @format Character vector
#' @usage plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=F,box=F)
#' @name Depth_cols
NULL

#' Bathymetry depth classes
#'
#' Set of depth classes to plot bathymetry, to be used in conjunction with \link{Depth_cols}.
#'
#' @docType data
#' @format Numeric vector
#' @usage plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=F,box=F)
#' @name Depth_cuts
NULL

#' Example dataset for create_PolyGrids
#'
#' To be used in conjunction with \link{create_PolyGrids}.
#'
#' @docType data
#' @format DataFrame
#' @usage 
#' View(GridData)
#' 
#' MyGrid=create_PolyGrids(Input=GridData,dlon=2,dlat=1)
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' @name GridData
NULL

#' Example dataset for create_Lines
#'
#' To be used in conjunction with \link{create_Lines}.
#'
#' @docType data
#' @format DataFrame
#' @usage 
#' View(LineData)
#' 
#' MyLines=create_Lines(LineData)
#' plot(MyLines,lwd=2)
#' @name LineData
NULL

#' Example dataset for create_Points
#'
#' To be used in conjunction with \link{create_Points}.
#'
#' @docType data
#' @format DataFrame
#' @usage 
#' View(PointData)
#' 
#' MyPoints=create_Points(PointData)
#' plot(MyPoints)
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=T)
#' plot(MyPoints[MyPoints$name=='four',],bg='red',pch=21,cex=1.5,add=T)
#' @name PointData
NULL

#' Example dataset for create_Polys
#'
#' To be used in conjunction with \link{create_Polys}.
#'
#' @docType data
#' @format DataFrame
#' @usage 
#' View(PolyData)
#' 
#' MyPolys=create_Polys(PolyData,Densify=T)
#' plot(MyPolys,col='green',add=T)
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID)
#' plot(MyPolys[MyPolys$ID=='three',],border='red',lwd=3,add=T)
#' @name PolyData
NULL

#' Small bathymetry dataset
#'
#' Bathymetry dataset derived from the \href{https://www.gebco.net/}{GEBCO 2019} dataset.
#' Subsampled using raster's \link[raster]{resample} function, using the nearest neighbor method
#' and a 2500m resolution. \strong{Not to be used for accurate bathymetry analyses}.
#'
#' @docType data
#' @format raster
#' @usage plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=F,box=F)
#' @name SmallBathy
NULL