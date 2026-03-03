DensifyData=function(Lon,Lat,Dlon=0.1,Dlat=0.1){
  #Disable spherical geometry
  suppressMessages(sf_use_s2(FALSE))
  #Edit 180 longitudes if present
  V180=which(Lon==180)
  if(length(V180)>0){Lon[V180]=179.99999999}
  V180=which(Lon==(-180))
  if(length(V180)>0){Lon[V180]=-179.99999999}
  
  #Step 1/2: fix antimeridian crossings
  Lon_clean=NULL
  Lat_clean=NULL
  for(i in seq(1,length(Lon)-1)){
    Lon1=Lon[i]
    Lat1=Lat[i]
    Lon2=Lon[i+1]
    Lat2=Lat[i+1]
    alpha=abs((Lon2-Lon1+180)%%360-180) #Angle
    if(alpha==180){
      warning("A line is exactly 180 degrees wide in longitude","\n",
              "Please add an intermediate point in the line","\n")
    }
    if(any(abs(c(Lon1,Lon2))>=90) & length(unique(sign(c(Lon1,Lon2))))>=2 & alpha<180){ #Antimeridian crossed
      #Set direction (clockwise or counter-clockwise) and
      #build segment to find latitude of crossing (shift negative longitudes)
      if(Lon1<Lon2){
        Dir="ccw"
        Seg=st_linestring(cbind(Lon=c(Lon1+360,Lon2),Lat=c(Lat1,Lat2)))
      }else{
        Dir="cw"
        Seg=st_linestring(cbind(Lon=c(Lon1,Lon2+360),Lat=c(Lat1,Lat2)))
      } 
      #Build antimeridian
      AM=st_linestring(cbind(Lon=c(180,180),Lat=c(-90,90)))
      #Find latitude of intersection
      LatAM=st_coordinates(st_intersection(Seg,AM))
      LatAM=LatAM[2]
      #Now add points at the antimeridian (in the right order)
      if(Dir=="ccw"){
        Lon_clean=c(Lon_clean,c(Lon1,-180,180))
        Lat_clean=c(Lat_clean,c(Lat1,LatAM,LatAM))
      }else{
        Lon_clean=c(Lon_clean,c(Lon1,180,-180))
        Lat_clean=c(Lat_clean,c(Lat1,LatAM,LatAM))
      }
    }else{ #Antimeridian not crossed
      Lon_clean=c(Lon_clean,Lon1)
      Lat_clean=c(Lat_clean,Lat1)
    }
  }
  #Append last vertex to the list
  Lon_clean=c(Lon_clean,Lon[length(Lon)])  
  Lat_clean=c(Lat_clean,Lat[length(Lat)])  
  #Go back to original names
  Lon=Lon_clean
  Lat=Lat_clean
  
  #Step 2/2: loop over individual segments and for each,
  #find the intersections with a Dlon-by-Dlat grid
  Vs=NULL #Prepare storage of dense vertices
  for(i in seq(1,length(Lon)-1)){
    Lon1=Lon[i]
    Lat1=Lat[i]
    Lon2=Lon[i+1]
    Lat2=Lat[i+1]
    
    if(Lon2==Lon1 & Lon1!=180){ #Isolongitude = no need to densify
      Vs=rbind(Vs,cbind(Lon=Lon1,Lat=Lat1))
    }else{
      
      if(abs(Lon1)==180 & abs(Lon2)==180){ #antimeridian crossed
        Vs=rbind(Vs,cbind(Lon=Lon1,Lat=Lat1))
      }else{ #antimeridian not crossed
        #Build segment
        Seg=st_linestring(cbind(Lon=c(Lon1,Lon2),Lat=c(Lat1,Lat2)))
        #Build grid
        #Get expanded ranges of Lat/Lon
        LonR=c(floor(min(c(Lon1,Lon2)))-2*Dlon,ceiling(max(c(Lon1,Lon2)))+2*Dlon)
        LatR=c(floor(min(c(Lat1,Lat2)))-2*Dlat,ceiling(max(c(Lat1,Lat2)))+2*Dlat)
        #Create Lat/Lon sequences
        Lats=seq(LatR[1],LatR[2],by=Dlat)
        Lons=seq(LonR[1],LonR[2],by=Dlon)
        #Build grid of lines
        LLats=list()
        for(j in seq(1,length(Lats))){
          LLats[[j]]=st_linestring(cbind(LonR,Lats[j]))
        }
        LLons=list()
        for(j in seq(1,length(Lons))){
          LLons[[j]]=st_linestring(cbind(Lons[j],LatR))
        }
        LL=c(LLats,LLons)
        LL=st_sfc(LL)
        LL=st_union(LL)
        #Get intersections
        Int=st_intersection(LL,Seg)
        Int=st_cast(Int,"POINT")
        Int=st_coordinates(Int)[,c(1,2)]
        #Add input points
        Int=rbind(c(X=Lon1,Y=Lat1),Int)
        Int=rbind(Int,c(X=Lon2,Y=Lat2))
        Int=st_multipoint(Int)
        Int=st_cast(x = st_sfc(Int), to = "POINT")
        #Get back to the correct order of vertices
        ord=st_line_project(st_sfc(Seg), Int)
        Int=st_coordinates(Int)
        Int=Int[order(ord),]
        Int=unique(Int[,c(1,2)])
        #Remove last vertex if needed
        if(Int[nrow(Int),1]==Lon2 & Int[nrow(Int),2]==Lat2){
          Int=Int[-nrow(Int),]
        }
        #Store dense vertices (could be a vector)
        if(is.null(dim(Int))){ #Vector
          Vs=rbind(Vs,cbind(Lon=Int[1],Lat=Int[2]))
        }else{ #Matrix
          Vs=rbind(Vs,cbind(Lon=Int[,1],Lat=Int[,2]))
        }
      }
    }
  }
  #Append last vertex to the list
  Vs=rbind(Vs,cbind(Lon=Lon[length(Lon)],Lat=Lat[length(Lat)]))
  #Enable spherical geometry
  suppressMessages(sf_use_s2(TRUE))
  return(Vs)
}

