#' CCAMLRGIS Projection
#'
#' The CCAMLRGIS package uses the \href{http://en.wikipedia.org/wiki/Lambert_azimuthal_equal-area_projection}{Lambert azimuthal equal-area projection}.
#' Source: \url{http://gis.ccamlr.org/}
#' 
#' @docType data
#' @usage data(CCAMLRp)
#' @format Character string
#' @return "+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
#' @name CCAMLRp
NULL

#' Coast
#'
#' Coastline polygons generated from \link{load_Coastline} and sub-sampled to only contain data that falls
#' within the CCAMLR boundaries. This spatial object may be subsetted to plot the coastline for selected
#' ASDs or EEZs. Source: \url{http://gis.ccamlr.org/}
#'
#' @docType data
#' @usage data(Coast)
#' @format SpatialPolygonsDataFrame
#' @examples 
#' #Complete coastline:
#' plot(Coast[Coast$ID=='All',],col='grey')
#' 
#' #ASD 48.1 coastline:
#' plot(Coast[Coast$ID=='48.1',],col='grey')
#' @seealso \code{\link{Clip2Coast}}.
#' @name Coast
NULL

#' Bathymetry colors
#'
#' Set of standard colors to plot bathymetry, to be used in conjunction with \link{Depth_cuts}.
#'
#' @docType data
#' @usage data(Depth_cols)
#' @format Character vector
#' @examples plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=FALSE,box=FALSE)
#' @seealso \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{SmallBathy}}.
#' @name Depth_cols
NULL

#' Bathymetry depth classes
#'
#' Set of depth classes to plot bathymetry, to be used in conjunction with \link{Depth_cols}.
#'
#' @docType data
#' @usage data(Depth_cuts)
#' @format Numeric vector
#' @examples plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=FALSE,box=FALSE)
#' @seealso \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{SmallBathy}}.
#' @name Depth_cuts
NULL

#' Example dataset for create_PolyGrids
#'
#' To be used in conjunction with \link{create_PolyGrids}.
#'
#' @docType data
#' @usage data(GridData)
#' @format DataFrame
#' @examples 
#' #View(GridData)
#' 
#' MyGrid=create_PolyGrids(Input=GridData,dlon=2,dlat=1)
#' plot(MyGrid,col=MyGrid$Col_Catch_sum)
#' @seealso \code{\link{create_PolyGrids}}.
#' @name GridData
NULL

#' Example dataset for create_Lines
#'
#' To be used in conjunction with \link{create_Lines}.
#'
#' @docType data
#' @usage data(LineData)
#' @format DataFrame
#' @examples  
#' #View(LineData)
#' 
#' MyLines=create_Lines(LineData)
#' plot(MyLines,lwd=2)
#' @seealso \code{\link{create_Lines}}. 
#' @name LineData
NULL

#' Example dataset for create_Points
#'
#' To be used in conjunction with \link{create_Points}.
#'
#' @docType data
#' @usage data(PointData)
#' @format DataFrame
#' @examples 
#' #View(PointData)
#' 
#' MyPoints=create_Points(PointData)
#' plot(MyPoints)
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=TRUE)
#' plot(MyPoints[MyPoints$name=='four',],bg='red',pch=21,cex=1.5,add=TRUE)
#' @seealso \code{\link{create_Points}}.  
#' @name PointData
NULL

#' Example dataset for create_Polys
#'
#' To be used in conjunction with \link{create_Polys}.
#'
#' @docType data
#' @usage data(PolyData)
#' @format DataFrame
#' @examples 
#' #View(PolyData)
#' 
#' MyPolys=create_Polys(PolyData,Densify=TRUE)
#' plot(MyPolys,col='green',add=TRUE)
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID)
#' plot(MyPolys[MyPolys$ID=='three',],border='red',lwd=3,add=TRUE)
#' @seealso \code{\link{create_Polys}}.  
#' @name PolyData
NULL

#' Small bathymetry dataset
#'
#' Bathymetry dataset derived from the \href{http://www.gebco.net/}{GEBCO 2019} dataset.
#' Subsampled using raster's \link[raster]{resample} function, using the nearest neighbor method
#' and a 10,000m resolution. Projected using the CCAMLR standard projection (\code{\link{CCAMLRp}}).
#' \strong{To be only used for large scale illustrative purposes}. Please refer to the package's vignette
#' (\code{browseVignettes("CCAMLRGIS")}; see Section 1) to produce a higher resolution raster, suitable for analyses.
#'
#' @docType data
#' @usage data(SmallBathy)
#' @format raster
#' @examples plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=FALSE,box=FALSE)
#' @seealso \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{Depth_cols}}, \code{\link{Depth_cuts}},
#' \code{\link{get_depths}}, \code{\link{create_Stations}}.
#' @name SmallBathy
NULL

#' Polygon labels
#'
#' Labels for the layers obtained via 'load_' functions. Positions correspond to the centroids
#' of polygon parts. Can be used in conjunction with \code{\link{add_labels}}.
#' 
#' @docType data
#' @usage data(Labels)
#' @format dataframe
#' @examples 
#' \donttest{
#' 
#' 
#' #View(Labels)
#' 
#' ASDs=load_ASDs()
#' plot(ASDs)
#' add_labels(mode='auto',layer='ASDs',fontsize=1,fonttype=2)
#' 
#' }
#' 
#' @seealso \code{\link{add_labels}}, \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_EEZs}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}.
#' @name Labels
NULL