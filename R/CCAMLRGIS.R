#' A package to load and create spatial data, including layers and tools that are relevant to CCAMLR activities.
#'
#' The CCAMLRGIS package provides two broad categories of functions: load functions and create functions.
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
#'   \item \link{load_RefAreas}
#'   \item \link{load_MPAs}
#'   \item \link{load_EEZs}
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
#'   \item \link{create_RefGrid}
#' }
#' 
#' @section Vignette:
#' To learn more about CCAMLRGIS, start with the vignette:
#' \code{browseVignettes(package = "CCAMLRGIS")}
#' 
#' @seealso 
#' The CCAMLRGIS package relies on several other package which users may want to familiarize themselves with,
#' namely \link[=sp]{sp}, \link[=raster]{raster}, \link[=rgeos]{rgeos} and \link[=rgdal]{rgdal}.
#' 
#' 
#' @docType package
#' @name CCAMLRGIS
NULL