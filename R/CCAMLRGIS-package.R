utils::globalVariables(c('CCAMLRp','Coast','Depth_cols','Depth_cuts','Depth_cols2','Depth_cuts2',
'GridData','Labels','LineData','PointData','PolyData','ID','PieData','PieData2',
'Lat','Lon','N','Tot','p','Ass_Ar_Key','Min','Max','Iso','AreaKm2','Latitude','Longitude','Pwidth'))
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
#'   \item \link{create_Arrow}
#' }
#' 
#' @section Vignette:
#' To learn more about CCAMLRGIS, start with the GitHub ReadMe (see \url{https://github.com/ccamlr/CCAMLRGIS#table-of-contents}).
#' Some basemaps are given here \url{https://github.com/ccamlr/CCAMLRGIS/blob/master/Basemaps/Basemaps.md}
#' 
#' @seealso 
#' The CCAMLRGIS package relies on several other package which users may want to familiarize themselves with,
#' namely sf (\url{https://CRAN.R-project.org/package=sf}) and 
#' terra (\url{https://CRAN.R-project.org/package=terra}).
#' 
#'  
#' @keywords internal 
"_PACKAGE"

## usethis namespace: start
#' @import sf
#' @importFrom dplyr distinct filter group_by left_join select summarise summarise_all 
#' @importFrom grDevices colorRampPalette recordPlot replayPlot chull col2rgb rgb
#' @importFrom graphics abline legend lines par plot rect segments text  
#' @importFrom stats median quantile sd
#' @importFrom terra as.polygons clamp classify click crop expanse ext extend extract mask plot project rast vect
#' @importFrom utils download.file edit globalVariables menu read.csv setTxtProgressBar txtProgressBar   
#' @importFrom magrittr %>%
#' @importFrom stars st_as_stars st_contour
#' @importFrom bezier bezier
#' @importFrom lwgeom st_transform_proj
## usethis namespace: end
NULL