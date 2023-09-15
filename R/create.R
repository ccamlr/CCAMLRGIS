#' Create Polygons 
#'
#' Create Polygons such as proposed Research Blocks or Marine Protected Areas.
#'
#' @param Input input dataframe.
#' 
#' If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Polygon name, Latitude, Longitude.
#' 
#' Latitudes and Longitudes must be given clockwise.
#' 
#' @param NamesIn character vector of length 3 specifying the column names of polygon identifier, Latitude
#' and Longitude fields in the \code{Input}.
#' 
#' Names must be given in that order, e.g.:
#' 
#' \code{NamesIn=c('Polygon ID','Poly Latitudes','Poly Longitudes')}.
#' 
#' @param Buffer numeric, distance in nautical miles by which to expand the polygons. Can be specified for
#' each polygon (as a numeric vector).
#' @param SeparateBuf logical, if set to FALSE when adding a \code{Buffer},
#' all spatial objects are merged, resulting in a single spatial object.
#' @param Densify logical, if set to TRUE, additional points between extremities of lines spanning more
#' than 0.1 degree longitude are added at every 0.1 degree of longitude prior to projection
#' (compare examples 1 and 2 below). 
#' @param Clip logical, if set to TRUE, polygon parts that fall on land are removed (see \link{Clip2Coast}).
#' 
#' @return Spatial object in your environment.
#' Data within the resulting spatial object contains the data provided in the \code{Input} after aggregation
#' within polygons. For each numeric variable, the minimum, maximum, mean, sum, count, standard deviation, and, 
#' median of values in each polygon is returned. In addition, for each polygon, its area (AreaKm2) and projected 
#' centroid (Labx, Laby) are given (which may be used to add labels to polygons).
#' 
#' To see the data contained in your spatial object, type: \code{View(MyPolygons)}.
#'
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{add_RefGrid}}.
#' 
#' @examples
#' \donttest{
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#create-polygons
#' 
#'
#' #Densified polygons (note the curvature of lines)
#' 
#' MyPolys=create_Polys(Input=PolyData)
#' plot(st_geometry(MyPolys),col='red')
#' text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID,col='white')
#'
#' 
#' }
#' 
#' @export

create_Polys=function(Input,NamesIn=NULL,Buffer=0,Densify=TRUE,Clip=FALSE,SeparateBuf=TRUE){
  # Load data
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==FALSE){
    if(length(NamesIn)!=3){stop("'NamesIn' should be a character vector of length 3")}
    if(any(NamesIn%in%colnames(Input)==FALSE)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  # Run cPolys
  Output=cPolys(Input,Densify=Densify)
  # Run add_buffer
  if(length(Buffer)==1){
    if(Buffer>0){Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)}
  }else{
    Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)
  }
  # Run Clip2Coast
  if(Clip==TRUE){Output=Clip2Coast(Output)}
  return(Output)
}

#' Create a Polygon Grid 
#'
#' Create a polygon grid to spatially aggregate data in cells of chosen size.
#' Cell size may be specified in degrees or as a desired area in square kilometers
#' (in which case cells are of equal area).
#'
#' @param Input input dataframe.
#' 
#' If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2 ... Variable x.
#' 
#' @param NamesIn character vector of length 2 specifying the column names of Latitude and Longitude fields in
#' the \code{Input}. Latitudes name must be given first, e.g.:
#' 
#' \code{NamesIn=c('MyLatitudes','MyLongitudes')}.
#' 
#' @param dlon numeric, width of the grid cells in decimal degrees of longitude.
#' @param dlat numeric, height of the grid cells in decimal degrees of latitude.
#' @param Area numeric, area in square kilometers of the grid cells. The smaller the \code{Area}, the longer it will take.
#' @param cuts numeric, number of desired color classes.
#' @param cols character, desired colors. If more that one color is provided, a linear color gradient is generated.
#' @return Spatial object in your environment.
#' Data within the resulting spatial object contains the data provided in the \code{Input} after aggregation
#' within cells. For each Variable, the minimum, maximum, mean, sum, count, standard deviation, and, 
#' median of values in each cell is returned. In addition, for each cell, its area (AreaKm2), projected 
#' centroid (Centrex, Centrey) and unprojected centroid (Centrelon, Centrelat) is given.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyGrid)}.
#' 
#' Also, colors are generated for each aggregated values according to the chosen \code{cuts} 
#' and \code{cols}.
#' 
#' To generate a custom color scale after the grid creation, refer to \code{\link{add_col}} and 
#' \code{\link{add_Cscale}}. See Example 4 below.
#' 
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_Stations}}, \code{\link{create_Pies}}, \code{\link{add_col}}, \code{\link{add_Cscale}}.
#' 
#' @examples
#' \donttest{
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#create-grids
#' 
#' #Simple grid, using automatic colors
#' 
#' MyGrid=create_PolyGrids(Input=GridData,dlon=2,dlat=1)
#' #View(MyGrid)
#' plot(st_geometry(MyGrid),col=MyGrid$Col_Catch_sum)
#' 
#' 
#' }
#' 
#' @export

create_PolyGrids=function(Input,NamesIn=NULL,dlon=NA,dlat=NA,Area=NA,cuts=100,cols=c('green','yellow','red')){
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==FALSE){
    if(length(NamesIn)!=2){stop("'NamesIn' should be a character vector of length 2")}
    if(any(NamesIn%in%colnames(Input)==FALSE)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  #Run cGrid
  Output=cGrid(Input,dlon=dlon,dlat=dlat,Area=Area,cuts=cuts,cols=cols)
  return(Output)
}

#' Create Lines 
#'
#' Create lines to display, for example, fishing line locations or tagging data.
#'
#' @param Input input dataframe.
#' 
#' If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Line name, Latitude, Longitude.
#' 
#' If a given line is made of more than two points, the locations of points
#' must be given in order, from one end of the line to the other.
#' 
#' @param NamesIn character vector of length 3 specifying the column names of line identifier, Latitude
#' and Longitude fields in the \code{Input}.
#' 
#' Names must be given in that order, e.g.:
#' 
#' \code{NamesIn=c('Line ID','Line Latitudes','Line Longitudes')}.
#' 
#' @param Buffer numeric, distance in nautical miles by which to expand the lines. Can be specified for
#' each line (as a numeric vector).
#' @param Densify logical, if set to TRUE, additional points between extremities of lines spanning more
#' than 0.1 degree longitude are added at every 0.1 degree of longitude prior to projection (see examples). 
#' @param Clip logical, if set to TRUE, polygon parts (from buffered lines) that fall on land are removed (see \link{Clip2Coast}).
#' @param SeparateBuf logical, if set to FALSE when adding a \code{Buffer},
#' all spatial objects are merged, resulting in a single spatial object.
#' 
#' @return Spatial object in your environment.
#' Data within the resulting spatial object contains the data provided in the \code{Input} plus
#' additional "LengthKm" and "LengthNm" columns which corresponds to the lines lengths,
#' in kilometers and nautical miles respectively. If additional data was included in the \code{Input},
#' any numerical values are summarized for each line (min, max, mean, median, sum, count and sd).
#' 
#' To see the data contained in your spatial object, type: \code{View(MyLines)}.
#'
#' @seealso 
#' \code{\link{create_Points}}, \code{\link{create_Polys}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{create_Pies}}.
#' 
#' @examples
#' \donttest{
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#create-lines
#' 
#' #Densified lines (note the curvature of the lines)
#' 
#' MyLines=create_Lines(Input=LineData,Densify=TRUE)
#' plot(st_geometry(MyLines),lwd=2,col=rainbow(nrow(MyLines)))
#'
#' }
#' 
#' @export

create_Lines=function(Input,NamesIn=NULL,Buffer=0,Densify=FALSE,Clip=FALSE,SeparateBuf=TRUE){
  # Load data
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==FALSE){
    if(length(NamesIn)!=3){stop("'NamesIn' should be a character vector of length 3")}
    if(any(NamesIn%in%colnames(Input)==FALSE)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  # Run cLines
  Output=cLines(Input,Densify=Densify)
  # Run add_buffer
  if(length(Buffer)==1){
    if(Buffer>0){Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)}
  }else{
    Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)
  }
  # Run Clip2Coast
  if(Clip==TRUE){Output=Clip2Coast(Output)}

  return(Output)
  
}

#' Create Points
#'
#' Create Points to display point locations. Buffering points may be used to produce bubble charts.
#'
#' @param Input input dataframe.
#' 
#' If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2, ... Variable x.
#' 
#' @param NamesIn character vector of length 2 specifying the column names of Latitude and Longitude fields in
#' the \code{Input}. Latitudes name must be given first, e.g.:
#' 
#' \code{NamesIn=c('MyLatitudes','MyLongitudes')}.
#' 
#' @param Buffer numeric, radius in nautical miles by which to expand the points. Can be specified for
#' each point (as a numeric vector).
#' @param Clip logical, if set to TRUE, polygon parts (from buffered points) that fall on land are removed (see \link{Clip2Coast}).
#' @param SeparateBuf logical, if set to FALSE when adding a \code{Buffer},
#' all spatial objects are merged, resulting in a single spatial object.
#' 
#' @return Spatial object in your environment.
#' Data within the resulting spatial object contains the data provided in the \code{Input} plus
#' additional "x" and "y" columns which corresponds to the projected points locations 
#' and may be used to label points (see examples).
#' 
#' To see the data contained in your spatial object, type: \code{View(MyPoints)}.
#'
#' @seealso 
#' \code{\link{create_Lines}}, \code{\link{create_Polys}}, \code{\link{create_PolyGrids}},
#' \code{\link{create_Stations}}, \code{\link{create_Pies}}.
#' 
#' @examples
#' \donttest{
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#create-points
#' 
#' #Simple points with labels
#' 
#' MyPoints=create_Points(Input=PointData)
#' plot(st_geometry(MyPoints))
#' text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=TRUE)
#' 
#' 
#' 
#' }
#' 
#' @export

create_Points=function(Input,NamesIn=NULL,Buffer=0,Clip=FALSE,SeparateBuf=TRUE){
  # Load data
  Input=as.data.frame(Input)
  #Use NamesIn to reorder columns
  if(is.null(NamesIn)==FALSE){
    if(length(NamesIn)!=2){stop("'NamesIn' should be a character vector of length 2")}
    if(any(NamesIn%in%colnames(Input)==FALSE)){stop("'NamesIn' do not match column names in 'Input'")}
    Input=Input[,c(NamesIn,colnames(Input)[which(!colnames(Input)%in%NamesIn)])]
  }
  # Run cPoints
  Output=cPoints(Input)
  # Run add_buffer
  if(all(Buffer>0)){Output=add_buffer(Output,buf=Buffer,SeparateBuf=SeparateBuf)}
  if(any(Buffer<0)){stop("'Buffer' should be positive")}
  # Run Clip2Coast
  if(Clip==TRUE){Output=Clip2Coast(Output)}
  return(Output)
}

#' Create Stations
#'
#' Create random point locations inside a polygon and within bathymetry strata constraints.
#' A distance constraint between stations may also be used if desired.
#'
#' @param Poly single polygon inside which stations will be generated. May be created using \code{\link{create_Polys}}.
#' @param Bathy bathymetry raster with the appropriate \code{\link[CCAMLRGIS:CCAMLRp]{projection}}, such as \code{\link[CCAMLRGIS:SmallBathy]{this one}}.
#' @param Depths numeric, vector of depths. For example, if the depth strata required are 600 to 1000 and 1000 to 2000,
#' \code{Depths=c(-600,-1000,-2000)}.
#' @param N numeric, vector of number of stations required in each depth strata,
#' therefore \code{length(N)} must equal \code{length(Depths)-1}.
#' @param Nauto numeric, instead of specifying \code{N}, a number of stations proportional to the areas of the depth strata
#' may be created. \code{Nauto} is the maximum number of stations required in any depth stratum.
#' @param dist numeric, if desired, a distance constraint in nautical miles may be applied. For example, if \code{dist=2},
#' stations will be at least 2 nautical miles apart.
#' @param Buf numeric, distance in meters from isobaths. Useful to avoid stations falling on strata boundaries.
#' @param ShowProgress logical, if set to \code{TRUE}, a progress bar is shown (\code{create_Stations} may take a while).
#' @return Spatial object in your environment. Data within the resulting object contains the strata and stations
#' locations in both projected space ("x" and "y") and decimal degrees of Latitude/Longitude.
#' 
#' To see the data contained in your spatial object, type: \code{View(MyStations)}.
#'
#' @seealso 
#' \code{\link{create_Polys}}, \code{\link{SmallBathy}}.
#' 
#' @examples
#' \donttest{
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#22-create-stations
#' 
#' #First, create a polygon within which stations will be created
#' MyPoly=create_Polys(
#'  data.frame(Name="mypol",
#'             Latitude=c(-75,-75,-70,-70),
#'             Longitude=c(-170,-180,-180,-170))
#'  ,Densify=TRUE)
#'
#' par(mai=c(0,0,0,0))
#' plot(st_geometry(Coast[Coast$ID=='88.1',]),col='grey')
#' plot(st_geometry(MyPoly),col='green',add=TRUE)
#' text(MyPoly$Labx,MyPoly$Laby,MyPoly$ID)
#'
#' #Create a set numbers of stations, without distance constraint:
#' library(terra)
#' #optional: crop your bathymetry raster to match the extent of your polygon
#' BathyCroped=crop(SmallBathy(),ext(MyPoly))
#'
#' #Create stations
#' MyStations=create_Stations(MyPoly,BathyCroped,Depths=c(-2000,-1500,-1000,-550),N=c(20,15,10))
#'
#' #add custom colors to the bathymetry to indicate the strata of interest
#' MyCols=add_col(var=c(-10000,10000),cuts=c(-2000,-1500,-1000,-550),cols=c('blue','cyan'))
#' plot(BathyCroped,breaks=MyCols$cuts,col=MyCols$cols,legend=FALSE,axes=FALSE)
#' add_Cscale(height=90,fontsize=0.75,width=16,lwd=0.5,
#' offset=-130,cuts=MyCols$cuts,cols=MyCols$cols)
#' plot(st_geometry(MyPoly),add=TRUE,border='red',lwd=2,xpd=TRUE)
#' plot(st_geometry(MyStations),add=TRUE,col='orange',cex=0.75,lwd=1.5,pch=3)
#'
#' 
#' }
#' 
#' @export

create_Stations=function(Poly,Bathy,Depths,N=NA,Nauto=NA,dist=NA,Buf=1000,ShowProgress=FALSE){
  if(is.na(sum(N))==FALSE & is.na(Nauto)==FALSE){
    stop('Values should not be specified for both N and Nauto.')
  }
  if(is.na(sum(N))==FALSE & length(N)!=length(Depths)-1){
    stop('Incorrect number of stations specified.')
  }
  if(class(Poly)[1]!="sf"){
    stop("'Poly' must be an sf object")
  }
  if(class(Bathy)[1]!="SpatRaster"){
    Bathy=terra::rast(Bathy)
  }

  #Crop Bathy
  Bathy=terra::crop(Bathy,terra::extend(ext(Poly),10000))
  
  #Generate Isobaths polygons
  IsoDs=data.frame(top=Depths[1:(length(Depths)-1)],
                   bot=Depths[2:length(Depths)])
  IsoNames=paste0(abs(IsoDs$top),'-',abs(IsoDs$bot))
  #start with first strata, then loop over remainder
  if(ShowProgress==TRUE){
    message('Depth strata creation started',sep='\n')
    pb=txtProgressBar(min=0,max=dim(IsoDs)[1],style=3,char=" )>(((*> ")
  }
  Biso=terra::clamp(Bathy,lower=IsoDs$top[1], upper=IsoDs$bot[1],values=FALSE)
  Biso=terra::classify(Biso,cbind(IsoDs$top[1],IsoDs$bot[1],1),include.lowest=TRUE)
  Isos=terra::as.polygons(Biso,values=FALSE)
  
  Isos$Stratum=IsoNames[1]
  if(ShowProgress==TRUE){setTxtProgressBar(pb, 1)}
  if(dim(IsoDs)[1]>1){
    for(i in seq(2,dim(IsoDs)[1])){
      Biso=terra::clamp(Bathy,lower=IsoDs$top[i], upper=IsoDs$bot[i],values=FALSE)
      Biso=terra::classify(Biso,cbind(IsoDs$top[i],IsoDs$bot[i],1),include.lowest=TRUE)
      Isotmp=terra::as.polygons(Biso,values=FALSE)
      Isotmp$Stratum=IsoNames[i]
      Isos=rbind(Isos,Isotmp)
      
      if(ShowProgress==TRUE){setTxtProgressBar(pb, i)}
    }
  }
  if(ShowProgress==TRUE){
    message('\n')
    message('Depth strata creation ended',sep='\n')
    close(pb)
  }
  #crop Isos by Poly
  Isos=sf::st_as_sf(Isos)
  Poly=sf::st_as_sf(Poly)
  st_crs(Isos)=6932
  Poly=st_transform(Poly,crs=6932)
  Isos=st_make_valid(Isos)
  Isos=sf::st_intersection(st_geometry(Poly),Isos)
  
  #Get number of stations per strata
  if(is.na(Nauto)==TRUE){
    IsoDs$n=N
  }else{
    #Get area of strata
    ar=as.numeric(st_area(Isos))
    ar=ar/max(ar)
    IsoDs$n=round(ar*Nauto)
  }
  #Generate locations
  #Create a fine grid from which to sample from
  if(ShowProgress==TRUE){
    message('Station creation started',sep='\n')
    pb=txtProgressBar(min=0,max=dim(IsoDs)[1],style=3,char=" )>(((*> ")
  }
  Grid=st_make_grid(x=Isos,cellsize = 1000,what="centers")
  
  #Remove points outside of strata
  Gridtmp=NULL
  for(i in seq(1,dim(IsoDs)[1])){
    tmp=st_buffer(Isos[[i]],dist=-Buf)
    tmp=st_sfc(tmp, crs = 6932)
    GridL=unlist(sf::st_intersects(tmp,Grid))
    Gridtmp=rbind(Gridtmp,cbind(st_coordinates(Grid)[GridL,],i))
  }
  Grid=as.data.frame(Gridtmp)
  Grid=st_as_sf(x=Grid,coords=c(1,2),crs=6932,remove=FALSE)
  
  if(is.na(dist)==TRUE){ #Random locations
    Locs=NULL
    for(i in seq(1,dim(IsoDs)[1])){
      Locs=rbind(Locs,cbind(Grid[Grid$i==i,][sample(seq(1,length(which(Grid$i==i))),IsoDs$n[i]),]))
      if(ShowProgress==TRUE){setTxtProgressBar(pb, i)}
    }
    Locs$Stratum=IsoNames[Locs$i]
    
    #Add Lat/Lon
    Locs=project_data(Input=Locs,NamesIn = c('Y','X'),NamesOut = c('Lat','Lon'),append = TRUE,inv=TRUE)
    
    Stations=st_as_sf(x=Locs,coords=c('X','Y'),crs=6932,remove=FALSE)
    if(ShowProgress==TRUE){
      message('\n')
      message('Station creation ended',sep='\n')
      close(pb)
    }
  }else{ #Pseudo-random locations      
    #Get starting point
    indx=floor(dim(Grid)[1]/2)
    tmpx=Grid$X[indx]
    tmpy=Grid$Y[indx]
    lay=Grid$i[indx]
    
    #Set buffer width
    wdth=100*ceiling(1852*dist/100)
    
    Locs=NULL
    while(nrow(Grid)>0){
      smallB=st_buffer(st_as_sf(x=data.frame(tmpx,tmpy),coords=c(1,2),crs=6932),dist = wdth,nQuadSegs=25)
      smallBi=unlist(st_intersects(smallB,Grid))
      #Save central point locations
      Locs=rbind(Locs,cbind(tmpx,tmpy,lay))
      #Remove points within buffer
      Grid=Grid[-smallBi,]
      #Get new point
      if(nrow(Grid)>0){
        indx=as.numeric(sample(seq(1,nrow(Grid)),1))
        tmpx=Grid$X[indx]
        tmpy=Grid$Y[indx]
        lay=Grid$i[indx]
        }
    }
    Locs=data.frame(layer=Locs[,3],
                    Stratum=IsoNames[Locs[,3]],
                    x=Locs[,1],
                    y=Locs[,2])
    Locs$Stratum=as.character(Locs$Stratum)
    #Report results 
    message('\n')
    for(s in sort(unique(Locs$layer))){
      ns=length(which(Locs$layer==s))
      message(paste0('Stratum ',IsoNames[s],' may contain up to ',ns,' stations given the distance desired'),sep='\n')
    }
    message('\n')
    for(s in sort(unique(Locs$layer))){
      ns=length(which(Locs$layer==s))
      if(ns<IsoDs$n[s]){
        stop('Cannot generate stations given the constraints. Reduce dist and/or number of stations and/or Buf.')
      }
    }
    
    #Sample locs within constraints 
    indx=NULL
    for(i in sort(unique(Locs$layer))){
      indx=c(indx,sample(which(Locs$layer==i),IsoDs$n[i]))
    }
    Locs=Locs[indx,]    
    #Add Lat/Lon
    Locs=project_data(Input=Locs,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = TRUE,inv=TRUE)
    Stations=st_as_sf(x=Locs,coords=c('x','y'),crs=6932,remove=FALSE)
    
    if(ShowProgress==TRUE){
      message('\n')
      message('Station creation ended',sep='\n')
      close(pb)
    }
  }
  #Check results
  ns=NULL
  for(i in sort(unique(Stations$layer))){
    ns=c(ns,length(which(Stations$layer==i)))
  }
  if(sum(ns-IsoDs$n)!=0){
    stop('Something unexpected happened. Please report the error to the package maintainer')
  }
  return(Stations)
}
