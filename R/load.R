#' Load CCAMLR statistical Areas, Subareas and Divisions
#'
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(ASDs))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' ASDs=load_ASDs()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('ASDs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(ASDs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }

load_ASDs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:statistical_areas_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load CCAMLR Small Scale Research Units
#'
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(SSRUs))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' SSRUs=load_SSRUs()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('SSRUs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(SSRUs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_SSRUs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:ssrus_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load the full CCAMLR Coastline
#' 
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(Coastline))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' Coastline=load_Coastline()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('Coastline','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(Coastline,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_Coastline=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:coastline_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load CCAMLR Research Blocks
#'
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(RBs))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' RBs=load_RBs()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('RBs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(RBs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_RBs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:research_blocks_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load CCAMLR Small Scale Management Units
#'
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(SSMUs))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' SSMUs=load_SSMUs()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('SSMUs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(SSMUs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_SSMUs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:ssmus_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load CCAMLR Management Areas
#'
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(MAs))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' MAs=load_MAs()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('MAs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(MAs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 
load_MAs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:omas_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load CCAMLR Marine Protected Areas
#'
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(MPAs))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' MPAs=load_MPAs()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('MPAs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(MPAs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 

load_MPAs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:mpas_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load Exclusive Economic Zones
#' 
#' Download the up-to-date spatial layer from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' See examples for offline use. All layers use the Lambert azimuthal equal-area projection
#'  (\code{\link{CCAMLRp}})
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
#' plot(st_geometry(EEZs))
#' 
#' #If going offline in the future: load and save as RData when online,
#' #then reload RData when offline:
#' MPAs=load_MPAs()
#' EEZs=load_EEZs()
#' #N.B.: replace tempdir() with folder location of your choice
#' save(list=c('MPAs','EEZs'), file = file.path(tempdir(), "CCAMLRLayers.RData"))
#' rm(MPAs,EEZs)
#' load(file.path(tempdir(), "CCAMLRLayers.RData"))
#' 
#' }
#' 

load_EEZs=function(){
  #NB: use http not https
  ccamlrgisurl="http://gis.ccamlr.org/geoserver/gis/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gis:eez_6932&outputFormat=json"
  CCAMLR_data = st_read(ccamlrgisurl,quiet = TRUE)
  CCAMLR_data = st_transform(CCAMLR_data,6932)
  return(CCAMLR_data)
}

#' Load Bathymetry data
#' 
#' Download the up-to-date projected GEBCO data from the online CCAMLRGIS (\url{http://gis.ccamlr.org/}) and load it to your environment.
#' This functions can be used in two steps, to first download the data and then use it. If you keep the downloaded data, you can then
#' re-use it in all your scripts.
#' 
#' To download the data, you must either have set your working directory using \code{\link[base]{setwd}}, or be working within an Rproject.
#' In any case, your file will be downloaded to the folder path given by \code{\link[base]{getwd}}.
#' 
#' It is strongly recommended to first download the lowest resolution data (set \code{Res=5000}) to ensure it is working as expected.
#' 
#' To re-use the downloaded data, you must provide the full path to that file, for example:
#' 
#' \code{LocalFile="C:/Desktop/GEBCO2021_5000.tif"}.
#' 
#' This data was reprojected from the original GEBCO Grid after cropping at 40 degrees South. Projection was made using the Lambert
#' azimuthal equal-area projection (\code{\link{CCAMLRp}}),
#' and the data was aggregated at several resolutions.
#' 
#' @param LocalFile To download the data, set to \code{FALSE}. To re-use a downloaded file, set to the full path of the file 
#' (e.g., \code{LocalFile="C:/Desktop/GEBCO2021_5000.tif"}).
#' @param Res Desired resolution in meters. May only be one of: 500, 1000, 2500 or 5000.
#' @return Bathymetry raster.
#' 
#' @seealso
#' \code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{Depth_cols}}, \code{\link{Depth_cuts}},
#' \code{\link{Depth_cols2}}, \code{\link{Depth_cuts2}}, \code{\link{get_depths}},
#' \code{\link{create_Stations}},
#' \code{\link{SmallBathy}}.
#' 
#' @references GEBCO Compilation Group (2021) GEBCO 2021 Grid (doi:10.5285/c6612cbe-50b3-0cff-e053-6c86abc09f8f) 
#' 
#' @export
#' @examples  
#' \donttest{
#' 
#' #The examples below are commented. To test, remove the '#'.
#' 
#' ##Download the data. It will go in the folder given by getwd():
#' #Bathy=load_Bathy(LocalFile = FALSE,Res=5000)
#' #plot(Bathy, breaks=Depth_cuts,col=Depth_cols,axes=FALSE)
#' 
#' ##Re-use the downloaded data (provided it's here: "C:/Desktop/GEBCO2021_5000.tif"):
#' #Bathy=load_Bathy(LocalFile = "C:/Desktop/GEBCO2021_5000.tif")
#' #plot(Bathy, breaks=Depth_cuts,col=Depth_cols,axes=FALSE)
#' 
#' }
#' 

load_Bathy=function(LocalFile,Res=5000){
  if(LocalFile==FALSE){
    if(Res%in%c(500,1000,2500,5000)==FALSE){stop("'Res' should be one of: 500, 1000, 2500 or 5000")}
    Fname=paste0("GEBCO2021_",Res,".tif")
    url=paste0("https://gis.ccamlr.org/geoserver/www/",Fname)
    download.file(url, destfile=paste0(getwd(),"/",Fname),mode="wb")
    Bathy=terra::rast(paste0(getwd(),"/",Fname))
  }else{
    if(file.exists(LocalFile)==FALSE){stop("File not found. Either the file is missing or 'LocalFile' is not properly set.")}
    Bathy=terra::rast(LocalFile)
  }
  return(Bathy)
}
