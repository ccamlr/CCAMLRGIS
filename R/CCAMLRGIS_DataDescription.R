#' CCAMLRGIS Projection
#'
#' The CCAMLRGIS package uses the Lambert azimuthal equal-area projection (see \url{https://en.wikipedia.org/wiki/Lambert_azimuthal_equal-area_projection}).
#' Source: \url{http://gis.ccamlr.org/}.
#' In order to align with recent developments within Geographic Information Software, this projection
#' will be accessed via EPSG code 6932 (see \url{https://epsg.org/crs_6932/WGS-84-NSIDC-EASE-Grid-2-0-South.html}).
#' 
#' @docType data
#' @usage data(CCAMLRp)
#' @format character string
#' @return "+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"
#' @name CCAMLRp
NULL

#' Simplified and subsettable coastline
#'
#' Coastline polygons generated from \link{load_Coastline} and sub-sampled to only contain data that falls
#' within the boundaries of the Convention Area. This spatial object may be subsetted to plot the coastline for selected
#' ASDs or EEZs (see examples). Source: \url{http://gis.ccamlr.org/}
#'
#' @docType data
#' @usage data(Coast)
#' @format sf
#' @examples 
#' #Complete coastline:
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey')
#' 
#' #ASD 48.1 coastline:
#' plot(st_geometry(Coast[Coast$ID=='48.1',]),col='grey')
#' @seealso \code{\link{Clip2Coast}}, \code{\link{load_Coastline}}.
#' @name Coast
NULL

#' Bathymetry colors
#'
#' Set of standard colors to plot bathymetry, to be used in conjunction with \link{Depth_cuts}.
#'
#' @docType data
#' @usage data(Depth_cols)
#' @format character vector
#' @examples terra::plot(SmallBathy(),breaks=Depth_cuts,col=Depth_cols,axes=FALSE)
#' @seealso \code{\link{Depth_cols2}}, \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{SmallBathy}}.
#' @name Depth_cols
NULL

#' Bathymetry depth classes
#'
#' Set of depth classes to plot bathymetry, to be used in conjunction with \link{Depth_cols}.
#'
#' @docType data
#' @usage data(Depth_cuts)
#' @format numeric vector
#' @examples terra::plot(SmallBathy(),breaks=Depth_cuts,col=Depth_cols,axes=FALSE,box=FALSE)
#' @seealso  \code{\link{Depth_cuts2}}, \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{SmallBathy}}.
#' @name Depth_cuts
NULL

#' Bathymetry colors with Fishable Depth range
#'
#' Set of colors to plot bathymetry and highlight Fishable Depth range (600-1800), to be used in conjunction with \link{Depth_cuts2}.
#'
#' @docType data
#' @usage data(Depth_cols2)
#' @format character vector
#' @examples terra::plot(SmallBathy(),breaks=Depth_cuts2,col=Depth_cols2,axes=FALSE,box=FALSE)
#' @seealso \code{\link{Depth_cols}}, \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{SmallBathy}}.
#' @name Depth_cols2
NULL

#' Bathymetry depth classes with Fishable Depth range
#'
#' Set of depth classes to plot bathymetry and highlight Fishable Depth range (600-1800), to be used in conjunction with \link{Depth_cols2}.
#'
#' @docType data
#' @usage data(Depth_cuts2)
#' @format numeric vector
#' @examples terra::plot(SmallBathy(),breaks=Depth_cuts2,col=Depth_cols2,axes=FALSE,box=FALSE)
#' @seealso  \code{\link{Depth_cuts}}, \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{SmallBathy}}.
#' @name Depth_cuts2
NULL

#' Example dataset for create_PolyGrids
#'
#' To be used in conjunction with \link{create_PolyGrids}.
#'
#' @docType data
#' @usage data(GridData)
#' @format data.frame
#' @examples 
#' #View(GridData)
#' 
#' MyGrid=create_PolyGrids(Input=GridData,dlon=2,dlat=1)
#' plot(st_geometry(MyGrid),col=MyGrid$Col_Catch_sum)
#' @seealso \code{\link{create_PolyGrids}}.
#' @name GridData
NULL

#' Example dataset for create_Lines
#'
#' To be used in conjunction with \link{create_Lines}.
#'
#' @docType data
#' @usage data(LineData)
#' @format data.frame
#' @examples  
#' #View(LineData)
#' 
#' MyLines=create_Lines(LineData)
#' plot(st_geometry(MyLines),lwd=2,col=rainbow(5))
#' @seealso \code{\link{create_Lines}}. 
#' @name LineData
NULL

#' Example dataset for create_Points
#'
#' To be used in conjunction with \link{create_Points}.
#'
#' @docType data
#' @usage data(PointData)
#' @format data.frame
#' @examples 
#' #View(PointData)
#' 
#' MyPoints=create_Points(PointData)
#' plot(st_geometry(MyPoints))
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=TRUE)
#' plot(st_geometry(MyPoints[MyPoints$name=='four',]),bg='red',pch=21,cex=1.5,add=TRUE)
#' @seealso \code{\link{create_Points}}.  
#' @name PointData
NULL

#' Example dataset for create_Polys
#'
#' To be used in conjunction with \link{create_Polys}.
#'
#' @docType data
#' @usage data(PolyData)
#' @format data.frame
#' @examples 
#' #View(PolyData)
#' 
#' MyPolys=create_Polys(PolyData,Densify=TRUE)
#' plot(st_geometry(MyPolys),col='green')
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID)
#' plot(st_geometry(MyPolys[MyPolys$ID=='three',]),border='red',lwd=3,add=TRUE)
#' @seealso \code{\link{create_Polys}}.  
#' @name PolyData
NULL

#' Polygon labels
#'
#' Labels for the layers obtained via 'load_' functions. Positions correspond to the centroids
#' of polygon parts. Can be used in conjunction with \code{\link{add_labels}}.
#' 
#' @docType data
#' @usage data(Labels)
#' @format data.frame
#' @examples 
#' \donttest{
#' 
#' 
#' #View(Labels)
#' 
#' ASDs=load_ASDs()
#' plot(st_geometry(ASDs))
#' add_labels(mode='auto',layer='ASDs',fontsize=1,fonttype=2)
#' 
#' 
#' }
#' 
#' @seealso \code{\link{add_labels}}, \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_EEZs}},
#' \code{\link{load_MPAs}}.
#' @name Labels
NULL

#' Example dataset for create_Pies
#'
#' To be used in conjunction with \link{create_Pies}. Count and catch of species per location.
#'
#' @docType data
#' @usage data(PieData)
#' @format data.frame
#' @examples 
#' #View(PieData)
#' 
#' #Create pies
#' MyPies=create_Pies(Input=PieData,
#'                    NamesIn=c("Lat","Lon","Sp","N"),
#'                    Size=50
#' )
#' #Plot Pies
#' plot(st_geometry(MyPies),col=MyPies$col)
#' #Add Pies legend
#' add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1.6,Boxexp=c(0.5,0.45,0.12,0.45),
#'               PieTitle="Species")
#' 
#' @seealso \code{\link{create_Pies}}.  
#' @name PieData
NULL

#' Example dataset for create_Pies
#'
#' To be used in conjunction with \link{create_Pies}. Count and catch of species per location.
#'
#' @docType data
#' @usage data(PieData2)
#' @format data.frame
#' @examples 
#' #View(PieData2)
#' 
#'MyPies=create_Pies(Input=PieData2,
#'                   NamesIn=c("Lat","Lon","Sp","N"),
#'                   Size=5,
#'                   GridKm=250
#')
#'#Plot Pies
#'plot(st_geometry(MyPies),col=MyPies$col)
#'#Add Pies legend
#'add_PieLegend(Pies=MyPies,PosX=-0.8,PosY=-0.3,Boxexp=c(0.5,0.45,0.12,0.45),
#'              PieTitle="Species")
#' 
#' @seealso \code{\link{create_Pies}}.  
#' @name PieData2
NULL