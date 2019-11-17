#' CCAMLRGIS: A package to load and create spatial data, including layers and tools that are relevant to CCAMLR activities.
#'
#' The CCAMLRGIS package provides two broad categories of functions: load functions and create functions.
#' 
#' @section Load functions:
#' Load functions are used to import CCAMLR geo-referenced layers and include:
#' load_ASDs, load_SSRUs, load_RBs, load_SSMUs, load_MAs, load_Coastline, load_RefAreas, load_MPAs, and load_EEZs.
#' 
#' @section Create functions:
#' Create functions are used to create geo-referenced layers from user-generated data and include:
#' create_Points, create_Lines, create_Polys, create_PolyGrids, create_Stations and create_RefGrid
#'  
#' @section Vignette:
#' To learn more about CCAMLRGIS, start with the vignette:
#' \code{browseVignettes(package = "CCAMLRGIS")}
#' 
#' 
#' @docType package
#' @name CCAMLRGIS
#' @importFrom graticule graticule
NULL

#' ASD data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/home see information (i) under Management areas
#' @name ASD_data
NULL

#' SSRU data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/home see information (i) under Management areas
#' @name SSRU_data
NULL

#' SSMU data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/home see information (i) under Management areas
#' @name SSMU_data
NULL


#' Coastline data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/home see information (i) under Coastlines
#' @name Coastline_data
NULL

#' MA data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/home see information (i) under Management areas
#' @name MA_data
NULL


#' MPA data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/home see information (i) under Management areas
#' @name MPA_data
NULL


#' RB data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/home see information (i) under Management areas
#' @name RB_data
NULL

#' RefAreas 
#'  
#'  These were Reference Areas used in local toothfish biomass estimation (see WG-FSA-17/42 for further details)
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source see inst/lrobinson-notes/createRefAreas.R
#' @name RefAreas
NULL


#' EEZ data
#'  
#' @docType data
#' @format SpatialPolygonsDataFrame
#' @source https://gis.ccamlr.org/ see information (i) under Management areas
#' @name EEZ_data
NULL




