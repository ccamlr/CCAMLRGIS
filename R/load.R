#' Load CCAMLR statistical Areas, Subareas and Divisions
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
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

load_ASDs=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:statistical_areas&outputFormat=json"
  ASD_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose = FALSE)
  return(ASD_data)
}

#' load CCAMLR Small Scale Research Units
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
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
load_SSRUs=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:ssrus&outputFormat=json"
  SSRU_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose = FALSE)
  return(SSRU_data)
}

#' load the full CCAMLR Coastline
#' 
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use. Note that this coastline expands further north than \link{Coast}.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
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
load_Coastline=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:coastline&outputFormat=json"
  Coastline_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose = FALSE)
  return(Coastline_data)
}

#' Load CCAMLR Research Blocks
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
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
load_RBs=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:research_blocks&maxFeatures=50&outputFormat=json"
  RB_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON",p4s=p4s, verbose = FALSE)
  return(RB_data)
}

#' Load CCAMLR Small Scale Management Units
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
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
load_SSMUs=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:ssmus&outputFormat=json"
  SSMU_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose=FALSE)
  return(SSMU_data)
}

#' Load CCAMLR Management Areas
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_Coastline}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
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
load_MAs=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:omas&outputFormat=json"
  MA_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose = FALSE)
  return(MA_data)
}

#' Load CCAMLR Reference Areas
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #When online:
#' RefAreas=load_RefAreas()
#' plot(RefAreas)
#' 
#' #If going offline in the future: load and save as RData when online,
#' # then reload RData when offline:
#' RefAreas=load_RefAreas()
#' EEZs=load_EEZs()
#' save(list=c('RefAreas','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(RefAreas,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 

load_RefAreas=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:omas&outputFormat=json"
  RA_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose = FALSE)
  return(RA_data)
}

#' load CCAMLR Marine Protected Areas
#'
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_RefAreas}}, \code{\link{load_EEZs}}.
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

load_MPAs=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:mpas&outputFormat=json"
  MPA_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose = FALSE)
  return(MPA_data)
}

#' Load Exclusive Economic Zones
#' 
#' Download the up-to-date spatial layer from the \href{http://gis.ccamlr.org/}{online CCAMLRGIS} and load it to your environment.
#' The layer's Metadata is accessible by clicking on the red 'i' in the list of layers available on the \href{http://gis.ccamlr.org/}{online CCAMLRGIS}.
#' See examples for offline use.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}.
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

load_EEZs=function(p4s="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:eez&outputFormat=json"
  EEZ_data=readOGR(dsn=ccamlrgisurl,layer="OGRGeoJSON", p4s=p4s, verbose = FALSE)
  return(EEZ_data)
}
