utils::globalVariables(c('CCAMLRp','Coast','Depth_cols','Depth_cuts','Depth_cols2','Depth_cuts2',
'GridData','Labels','LineData','PointData','PolyData','SmallBathy','ID','PieData','PieData2',
'Lat','Lon','N','Tot','p','Ass_Ar_Key','Min','Max','Iso','AreaKm2'))
#' 
#' Loads and creates spatial data, including layers and tools that are relevant to CCAMLR activities.
#' All operations use the Lambert azimuthal equal-area projection (via EPSG:6932).
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
#' To learn more about CCAMLRGIS, start with the GitHub ReadMe (see \url{https://github.com/ccamlr/CCAMLRGIS#table-of-contents}).
#' 
#' @seealso 
#' The CCAMLRGIS package relies on several other package which users may want to familiarize themselves with,
#' namely sf (\url{https://CRAN.R-project.org/package=sf}) and 
#' terra (\url{https://CRAN.R-project.org/package=terra}).
#' 
#'  
#' @docType package
#' @import sp
#' @import sf
#' @import geosphere
#' @importFrom dplyr distinct group_by summarise_all left_join
#' @importFrom grDevices colorRampPalette recordPlot replayPlot
#' @importFrom graphics par rect segments text lines abline legend
#' @importFrom stats quantile median
#' @importFrom utils read.csv setTxtProgressBar txtProgressBar edit menu download.file
#' @importFrom magrittr %>%
#' @importFrom terra rast crop ext mask vect classify expanse extract extend clamp as.polygons plot click
#' @importFrom raster raster plot
#' @importFrom stars st_as_stars st_contour
#' @name CCAMLRGIS
NULL