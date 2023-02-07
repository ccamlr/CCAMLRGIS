DensifyData=function(Lon,Lat){
  dlon=0.1
  GridLon=seq(0,360,by=dlon)
  Lon=Lon+180
  DenLon=NULL
  DenLat=NULL
  for (di in (1:(length(Lon)-1))){
    if(abs(diff(Lon[c(di,di+1)]))<=dlon){ #No need to densify
      DenLon=c(DenLon,c(Lon[di],Lon[di+1]))
      DenLat=c(DenLat,c(Lat[di],Lat[di+1]))
    }else{ #Need to densify
      alpha=((Lon[di+1]-Lon[di])+180)%%360-180 #Angle
      if (abs(alpha)==180){warning("A line is exactly 180 degrees wide in longitude","\n",
                                   "Please add an intermediate point in the line","\n")}
      if (alpha>0){ #Clockwise
        if (length(which(GridLon>Lon[di] & GridLon<Lon[di+1]))>0){ #Continuous
          GridLoc=GridLon[(which(GridLon>Lon[di] & GridLon<Lon[di+1]))]
        }else{ #Crossing the Antimeridian
          GridLoc=c(GridLon[which(GridLon>Lon[di])],GridLon[which(GridLon<Lon[di+1])])
        }
      }
      if (alpha<0){ #Counterclockwise
        if (length(which(GridLon<Lon[di] & GridLon>Lon[di+1]))>0){ #Continuous
          GridLoc=GridLon[rev(which(GridLon<Lon[di] & GridLon>Lon[di+1]))]
        }else{ #Crossing the Antimeridian
          GridLoc=c(GridLon[rev(which(GridLon<Lon[di]))],GridLon[rev(which(GridLon>Lon[di+1]))])
        }
      }
      if (Lat[di+1]==Lat[di]){ #Isolatitude
        DenLon=c(DenLon,c(Lon[di],GridLoc,Lon[di+1]))
        DenLat=c(DenLat,c(Lat[di],rep(Lat[di],length(GridLoc)),Lat[di+1]))
      }else{ #GetCInt
        if(all(c(360,0)%in%GridLoc)==F){ #Without crossing the Antimeridian
          Out=NULL
          for(Dl in seq(1,length(GridLoc))){
            Out=rbind(Out,
                      suppressWarnings(  get_C_intersection(Line1=c(Lon[di],Lat[di],Lon[di+1],Lat[di+1]),
                                                            Line2=c(GridLoc[Dl],Lat[di],GridLoc[Dl],Lat[di+1]),
                                                            Plot=F) )
            )
          } 
        }else{ #If Antimeridian is crossed
          if(which(GridLoc==360)<which(GridLoc==0)){ #Clockwise
            TmpInt=get_C_intersection(Line1=c(Lon[di]-180,Lat[di],Lon[di+1]+180,Lat[di+1]),
                                      Line2=c(180,Lat[di],180,Lat[di+1]),
                                      Plot=F)
            TmpInt=TmpInt[2] #Latitude of crossing
            #Then split GridLoc at crossing and get intersections for each piece
            GridLoc1=GridLoc[1:which(GridLoc==360)]
            GridLoc2=GridLoc[which(GridLoc==0):length(GridLoc)]
            
            Out=NULL
            for(Dl in seq(1,length(GridLoc1))){
              Out=rbind(Out,
                        suppressWarnings( get_C_intersection(Line1=c(Lon[di],Lat[di],360,TmpInt),
                                                             Line2=c(GridLoc1[Dl],Lat[di],GridLoc1[Dl],Lat[di+1]),
                                                             Plot=F) )
              )
            } 
            for(Dl in seq(1,length(GridLoc2))){
              Out=rbind(Out,
                        suppressWarnings(  get_C_intersection(Line1=c(0,TmpInt,Lon[di+1],Lat[di+1]),
                                                              Line2=c(GridLoc2[Dl],Lat[di],GridLoc2[Dl],Lat[di+1]),
                                                              Plot=F) )
              )
            } 
            
          }else{ #Counterclockwise
            TmpInt=get_C_intersection(Line1=c(Lon[di]+180,Lat[di],Lon[di+1]-180,Lat[di+1]),
                                      Line2=c(180,Lat[di],180,Lat[di+1]),
                                      Plot=F)
            TmpInt=TmpInt[2] #Latitude of crossing
            #Then split GridLoc at crossing and get intersections for each piece
            GridLoc1=GridLoc[1:which(GridLoc==0)]
            GridLoc2=GridLoc[which(GridLoc==360):length(GridLoc)]
            
            Out=NULL
            for(Dl in seq(1,length(GridLoc1))){
              Out=rbind(Out,
                        suppressWarnings(  get_C_intersection(Line1=c(Lon[di],Lat[di],0,TmpInt),
                                                              Line2=c(GridLoc1[Dl],Lat[di],GridLoc1[Dl],Lat[di+1]),
                                                              Plot=F) )
              )
            } 
            for(Dl in seq(1,length(GridLoc2))){
              Out=rbind(Out,
                        suppressWarnings(  get_C_intersection(Line1=c(360,TmpInt,Lon[di+1],Lat[di+1]),
                                                              Line2=c(GridLoc2[Dl],Lat[di],GridLoc2[Dl],Lat[di+1]),
                                                              Plot=F) )
              )
            } 
          }
        }
        DenLon=c(DenLon,c(Lon[di],Out[,1],Lon[di+1]))
        DenLat=c(DenLat,c(Lat[di],Out[,2],Lat[di+1]))
      }
    }
  }
  DenLon=DenLon-180
  Densified=cbind(DenLon,DenLat)
  return(Densified)
}


