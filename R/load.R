#' Load CCAMLR statistical Areas, Subareas and Divisions
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#'
#' @seealso 
#' \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' ASDs=load_ASDs()
#' plot(ASDs)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' ASDs=load_ASDs()
#' EEZs=load_EEZs()
#' save(list=c('ASDs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(ASDs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }

load_ASDs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:statistical_areas_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}

#' Load CCAMLR Small Scale Research Units
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' SSRUs=load_SSRUs()
#' plot(SSRUs)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' SSRUs=load_SSRUs()
#' EEZs=load_EEZs()
#' save(list=c('SSRUs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(SSRUs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_SSRUs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:ssrus_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}

#' Load the full CCAMLR Coastline
#' 
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#' Note that this coastline expands further north than \link{Coast}.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' Coastline=load_Coastline()
#' plot(Coastline)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' Coastline=load_Coastline()
#' EEZs=load_EEZs()
#' save(list=c('Coastline','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(Coastline,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_Coastline=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:coastline_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}

#' Load CCAMLR Research Blocks
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' RBs=load_RBs()
#' plot(RBs)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' RBs=load_RBs()
#' EEZs=load_EEZs()
#' save(list=c('RBs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(RBs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_RBs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:research_blocks_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}

#' Load CCAMLR Small Scale Management Units
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' SSMUs=load_SSMUs()
#' plot(SSMUs)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' SSMUs=load_SSMUs()
#' EEZs=load_EEZs()
#' save(list=c('SSMUs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(SSMUs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_SSMUs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:ssmus_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}

#' Load CCAMLR Management Areas
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_Coastline}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' MAs=load_MAs()
#' plot(MAs)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' MAs=load_MAs()
#' EEZs=load_EEZs()
#' save(list=c('MAs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(MAs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_MAs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:omas_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}

#' Load CCAMLR Marine Protected Areas
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' MPAs=load_MPAs()
#' plot(MPAs)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' MPAs=load_MPAs()
#' EEZs=load_EEZs()
#' save(list=c('MPAs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(MPAs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 

load_MPAs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:mpas_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}

#' Load Exclusive Economic Zones
#' 
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (EPSG:6932; CRS:+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs)
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_MPAs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' EEZs=load_EEZs()
#' plot(EEZs)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' MPAs=load_MPAs()
#' EEZs=load_EEZs()
#' save(list=c('MPAs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(MPAs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 

load_EEZs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:eez_6932&outputFormat=json"
  CCAMLR_data=suppressWarnings(readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",verbose = FALSE))
  CCAMLR_data=spTransform(CCAMLR_data,CRS("+init=epsg:6932"))
  return(CCAMLR_data)
}
