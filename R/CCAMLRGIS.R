utils::globalVariables(c('CCAMLRp','Coast','Depth_cols','Depth_cuts','Depth_cols2','Depth_cuts2',
'GridData','Labels','LineData','PointData','PolyData','SmallBathy','ID','PieData','PieData2',
'Lat','Lon','N','Tot','p'))
#' 
#' Loads and creates spatial data, including layers and tools that are relevant to CCAMLR activities.
#' All operations use the Lambert azimuthal equal-area projection (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs).
#'
#' This package provides two broad categories of functions: load functions and create functions.
#' 
#' @section Load functions:
#' Load functions are used to import CCAMLR geo-referenced layers and include:
#' \itemize{
#'   \item \link{load_ASDs}
#'   \item \link{load_SSRUs}
#'   \item \link{load_RBs}
#'   \item \link{load_SSMUs}
#'   \item \link{load_MAs}
#'   \item \link{load_Coastline}
#'   \item \link{load_MPAs}
#'   \item \link{load_EEZs}
#'   \item \link{load_Bathy}
#' }
#' 
#' @section Create functions:
#' Create functions are used to create geo-referenced layers from user-generated data and include:
#' \itemize{
#'   \item \link{create_Points}
#'   \item \link{create_Lines}
#'   \item \link{create_Polys}
#'   \item \link{create_PolyGrids}
#'   \item \link{create_Stations}
#'   \item \link{create_Pies}
#' }
#' 
#' @section Vignette:
#' To learn more about CCAMLRGIS, start with the vignette:
#' \code{browseVignettes(package = "CCAMLRGIS")}
#' 
#' @seealso 
#' The CCAMLRGIS package relies on several other package which users may want to familiarize themselves with,
#' namely \href{https://CRAN.R-project.org/package=sf}{sf} and
#' \href{https://CRAN.R-project.org/package=terra}{terra}.
#' 
#'  
#' @docType package
#' @import sf
#' @import geosphere
#' @importFrom dplyr distinct group_by summarise_all left_join
#' @importFrom grDevices colorRampPalette recordPlot replayPlot
#' @importFrom graphics par rect segments text
#' @importFrom stats quantile median
#' @importFrom utils read.csv setTxtProgressBar txtProgressBar edit menu download.file
#' @importFrom magrittr %>%
#' @importFrom terra rast crop ext mask vect classify expanse extract extend clamp as.polygons plot
#' @name CCAMLRGIS
NULL