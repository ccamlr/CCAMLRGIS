#' Clip Polygons to the Antarctic coastline
#'
#' Clip Polygons to the Antarctic CCAMLR Coastline data
#'
#' @param Pl polygon(s) to be clipped
#' @param Coastline calls CCAMLR Coastline_data stored in the package
#' @param ID unique IDs for polygons, but think I will get rid of this as polys should have unique IDs
#' @keywords Clip Coastline
#' @import rgeos rgdal raster
#' @importFrom methods slot
#' @importFrom maptools checkPolygonsHoles
#' @export


Clip2Coast=function(Pl,Coastline,ID){
  PID=ID
  # Define CRS projection
  CRSProj="+proj=laea +lat_0=-90 +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
  #Convert Pl to SpatialPolygon
  Pl=Polygons(list(Pl), ID=PID)
  Pl=SpatialPolygons(list(Pl))
  # check Pl has proj4string and if not assign
  if(is.na(proj4string(Pl))){
    proj4string(Pl) <-  CRSProj
  }
  
  
  #Read isolines shapefile
  coastshp=CCAMLRGIS::Coastline_data
  
  Indx=(1:length(coastshp))
  
  Plholes=list() #to store holes
  # Clip / drill coastline
  for (is in Indx){ #is=1681 is coastline

    Plc=coastshp[is,]
    
    
    if (Plc@polygons[[1]]@area>0){
      

      Plc=gBuffer(Plc,width=0,id=PID)
      
      #If any contact: clip or drill
      if (gIntersects(Pl,Plc)==T){
        
        if (gContainsProperly(Pl,Plc)==T){ # If internal: get hole and store it
          Pltmph=Polygon(Plc@polygons[[1]]@Polygons[[1]]@coords,hole=T)
          Plholes=c(Plholes,Pltmph)
        }else{  # If crossing, check intersection (drill or hole)
          
          #Get intersection
          Inter=gIntersection(Pl,Plc, byid=F)
          #Check each polygon contained in Inter
          for (int in Inter@polygons[[1]]@plotOrder){
            intpol=Polygon(Inter@polygons[[1]]@Polygons[[int]]@coords)
            intpol=Polygons(list(intpol), ID=PID)
            intpol=SpatialPolygons(list(intpol))
            proj4string(intpol) <- CRSProj
            #Check if intpol should be clipped or drilled
            In=point.in.polygon(intpol@polygons[[1]]@Polygons[[1]]@coords[,1],
                                intpol@polygons[[1]]@Polygons[[1]]@coords[,2],
                                Plc@polygons[[1]]@Polygons[[1]]@coords[,1],
                                Plc@polygons[[1]]@Polygons[[1]]@coords[,2],mode.checked=F)
            
            if(3%in%In & slot(intpol@polygons[[1]],"area")>0){
              tmpIn=In[seq(which(In==3)[1],which(In==3)[length(which(In==3))])]          
              if (length(unique(tmpIn))==1){
                #Clip
                Pl=gDifference(Pl,gBuffer(intpol,width=0.00001,id=PID), byid=F, id=NULL)
              }else{
                #Drill
                Pltmph=Polygon(intpol@polygons[[1]]@Polygons[[1]]@coords,hole=T)
                Plholes=c(Plholes,Pltmph)
              }
            }
          }
        }#End if crossing
      }#End if any contact
    }#End if area of isoline=0
  }#End loop over isolines
  
  
  #Check holes
  if(length(Plholes)>0){
    holesok=list()
    for (h in (1:length(Plholes))){
      hole=Plholes[[h]]
      hole=Polygons(list(hole), ID=PID)
      hole=SpatialPolygons(list(hole))
      proj4string(hole) <- CRSProj
      if (gDisjoint(Pl,hole)==F){
        hole=gBuffer(hole,width=-0.00001,id=h)
        hole=Polygon(hole@polygons[[1]]@Polygons[[1]]@coords,hole=T)
        holesok=c(holesok,hole)}
    }
    Plholes=holesok
  }
  if(length(Plholes)>0){
    #Drill holes
    Pls=Pl@polygons[[1]]@Polygons[[1]]
    Pls=c(Pls,Plholes) 
    Pls= maptools::checkPolygonsHoles(Polygons(Pls, ID=PID), properly=TRUE, avoidGEOS=FALSE, useSTRtree=FALSE)
  }else{
    Pls=Pl@polygons[[1]]@Polygons[[1]]
    Pls=Polygons(list(Pls), ID=PID)
  }
  return(Pls)
}

