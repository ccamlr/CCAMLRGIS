#' Get depths of locations from bathymetry raster
#'
#' Given a bathymetry raster and an input dataframe of point locations (given in decimal degrees),
#' computes the depths at these locations using bilinear interpolation (using \code{\link[raster]{extract}}).
#' Optionally can also compute the horizontal distance of locations to chosen isobaths.
#' 
#' @param Input dataframe with, at least, Latitudes and Longitudes.
#' \strong{The columns in the \code{Input} must be in the following order:
#' 
#' Latitude, Longitude, Variable 1, Variable 2, ... Variable x}
#' @param Bathy bathymetry raster with the appropriate \code{\link[CCAMLRGIS:CCAMLRp]{projection}},
#' such as \code{\link[CCAMLRGIS:SmallBathy]{this one}}. It is recommended to use a raster of higher
#' resolution than \code{\link{SmallBathy}}.
#' @param d distance in meters, used to group locations by distance and speed up computations (by cutting
#' the bathymetry raster into small pieces matching the extent of grouped locations). Lower values
#' make computations faster but at the risk of not finding distances to isobaths (when desired).
#' @param Isobaths Depths to which the horizontal distances to locations are computed, if required.
#' @param IsoLocs If \code{TRUE}, the locations on the \code{Iosbaths} that are closest to the
#' locations given in the \code{Input} are added to the exported dataframe.
#' @param ShowProgress if set to \code{TRUE}, a progress bar is shown (\code{get_depths} may take a while).
#' @return dataframe with the same structure as the \code{Input} with additional columns, where 
#' \code{'x'} and \code{'y'} are the projected locations, \code{'d'} is the depth,
#' \code{'D_iso'}, \code{'X_iso'} and \code{'Y_iso'} are the horizontal distances and 
#' closest point location on \code{'Isobaths'}. All units are in meters.
#' 
#' @seealso 
#' \code{\link{SmallBathy}}, \code{\link{create_Points}}, \code{\link{create_Stations}}, \code{\link[raster]{extract}}.
#' 
#' @examples
#' 
#' #Generate a dataframe
#' MyData=data.frame(Lat=PointData$Lat,
#' Lon=PointData$Lon,
#' Catch=PointData$Catch)
#' 
#' #Example 1: get depths of locations
#' MyDataD=get_depths(MyData,SmallBathy)
#' #View(MyDataD)
#' plot(MyDataD$d,MyDataD$Catch,xlab='Depth',ylab='Catch',pch=21,bg='blue') #Plot of catch vs depth
#' 
#' #Example 2: get depths of locations and distance to isobath -3000m
#' 
#' MyDataD=get_depths(MyData,SmallBathy,Isobaths=-3000,IsoLocs=TRUE,d=200000,ShowProgress=TRUE)
#' plot(MyDataD$x,MyDataD$y,pch=21,bg='green')
#' contour(SmallBathy,levels=-3000,add=TRUE,col='blue',maxpixels=10000000)
#' segments(x0=MyDataD$x,
#'          y0=MyDataD$y,
#'          x1=MyDataD$X_3000,
#'          y1=MyDataD$Y_3000,col='red')
#'
#' @export

get_depths=function(Input,Bathy,d=10000,Isobaths=NA,IsoLocs=FALSE,ShowProgress=FALSE){

  if(ShowProgress==TRUE){cat('Bathymetry computation started',sep='\n')}
    
  #Project Lat/Lon
  xy=project(cbind(Input[,2],Input[,1]), CCAMLRp)
  #Create output dataframe
  out=data.frame(X=xy[,1],Y=xy[,2])
  #Create spatial points
  Sp=SpatialPoints(out,CRS(CCAMLRp))
  #grid locations to create groups of locations
  ra=raster(extent(Sp),res=d,crs=crs(Sp))
  ra=extend(ra,2)
  values(ra)=1:ncell(ra)
  gr=extract(ra,Sp)
  gr=match(gr,unique(gr))
  out$gr=gr
  
  #Prepare matrix of Distance to isobaths
  if(is.na(sum(Isobaths))==FALSE & IsoLocs==FALSE){
  IsoD=matrix(nrow=dim(out)[1],ncol=length(Isobaths))
  colnames(IsoD)=Isobaths
  options(max.contour.segments=1000000000)
  }
  if(is.na(sum(Isobaths))==FALSE & IsoLocs==TRUE){
    IsoD=matrix(nrow=dim(out)[1],ncol=3*length(Isobaths))
    colnames(IsoD)=paste0(c('','x','y'),rep(Isobaths,each=3))
    options(max.contour.segments=1000000000)
  }
  #Loop over groups to get bathy data
  out$z=NA
  if(ShowProgress==TRUE){pb=txtProgressBar(min=0,max=length(unique(out$gr)),style=3,char=" )>(((*> ")}
  for(g in sort(unique(out$gr))){
    #Get point locations
    indx=which(out$gr==g)
    Px=out$X[indx]
    Py=out$Y[indx]
    #Crop bathymetry
    Bi=raster::crop(Bathy,extent(min(Px)-d,
                         max(Px)+d,
                         min(Py)-d,
                         max(Py)+d))
    out$z[indx]=extract(Bi,cbind(Px,Py),method='bilinear')
    #Get distances to Isobaths (only)
    if(is.na(sum(Isobaths))==FALSE & IsoLocs==FALSE){
      Isobathsok=Isobaths[Isobaths>minValue(Bi) & Isobaths<maxValue(Bi)]
      if(length(Isobathsok)>0){
      Isos=rasterToContour(Bi,levels=Isobathsok,maxpixels = 10000000)
      #Loop over isobaths
      for(i in seq(1,length(Isos))){
        Iso=Isos[i,]
        #Densify Iso and get locations
        Lint=50 #add points every 50m on isobath
        L=gLength(Iso)
        L=ceiling(L)+Lint
        int=gInterpolate(Iso, d=seq(0,L,by=Lint))
        IsoP=coordinates(int)
        #Compute distances to coastline
        Ds=pointDistance(cbind(Px,Py), IsoP,lonlat=FALSE)
        if(is.null(dim(Ds))==TRUE){
          IsoD[indx,match(Iso$level,colnames(IsoD))]=min(Ds)
          }else{
        IsoD[indx,match(Iso$level,colnames(IsoD))]=apply(Ds,1,min)
        }
      }}
    }
    #Get distances to Isobaths (and locations on isobath)
    if(is.na(sum(Isobaths))==FALSE & IsoLocs==TRUE){
      Isobathsok=Isobaths[Isobaths>minValue(Bi) & Isobaths<maxValue(Bi)]
      if(length(Isobathsok)>0){
        Isos=rasterToContour(Bi,levels=Isobathsok,maxpixels = 10000000)
      #Loop over isobaths
      for(i in seq(1,length(Isos))){
        Iso=Isos[i,]
        #Densify Iso and get locations
        Lint=50 #add points every 50m on isobath
        L=gLength(Iso)
        L=ceiling(L)+Lint
        int=gInterpolate(Iso, d=seq(0,L,by=Lint))
        IsoP=coordinates(int)
        #Compute distances to coastline
        Ds=pointDistance(cbind(Px,Py), IsoP,lonlat=FALSE)
        if(is.null(dim(Ds))==TRUE){
          indi=which(Ds==min(Ds,na.rm=TRUE))[1]
          IsoD[indx,match(paste0('x',Iso$level),colnames(IsoD))]=IsoP[indi,1]
          IsoD[indx,match(paste0('y',Iso$level),colnames(IsoD))]=IsoP[indi,2]
          IsoD[indx,match(Iso$level,colnames(IsoD))]=min(Ds)
        }else{
          Mins=apply(Ds,1,which.min)
          IsoD[indx,match(paste0('x',Iso$level),colnames(IsoD))]=IsoP[Mins,1]
          IsoD[indx,match(paste0('y',Iso$level),colnames(IsoD))]=IsoP[Mins,2]
          IsoD[indx,match(Iso$level,colnames(IsoD))]=apply(Ds,1,min)
        }
      }}
    }
    if(ShowProgress==TRUE){setTxtProgressBar(pb, g)}
  }
  out=out[,c("X","Y","z")]
  colnames(out)=c('x','y','d')
  #Merge depths and distances to isobaths
  if(is.na(sum(Isobaths))==FALSE & IsoLocs==FALSE){
    IsoD=as.data.frame(IsoD)
    colnames(IsoD)=paste0('D_',abs(as.numeric(colnames(IsoD))))
    out=cbind(out,IsoD)
  }
  if(is.na(sum(Isobaths))==FALSE & IsoLocs==TRUE){
    IsoD=as.data.frame(IsoD)
    Xnames=grep('x',colnames(IsoD))
    Ynames=grep('y',colnames(IsoD))
    Onames=seq(1,dim(IsoD)[2])[-c(Xnames,Ynames)]
    colnames(IsoD)[Onames]=paste0('D_',abs(as.numeric(colnames(IsoD)[Onames])))
    colnames(IsoD)[Xnames]=paste0('X_',substr(colnames(IsoD)[Xnames],3,20))
    colnames(IsoD)[Ynames]=paste0('Y_',substr(colnames(IsoD)[Ynames],3,20))
    
    
    out=cbind(out,IsoD)
  }
  #Merge with Inputs
  out=cbind(Input,out)
  if(ShowProgress==TRUE){
    cat('\n')
    cat('Bathymetry computation ended',sep='\n')
    close(pb)
  }

  return(out)
}