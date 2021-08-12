#' Add a Reference grid
#'
#' Add a Latitude/Longitude reference grid to maps.
#'
#' @param bb bounding box of the first plotted object. for example, \code{bb=bbox(SmallBathy)} or \code{bb=bbox(MyPolys)}.
#' @param ResLat Latitude resolution in decimal degrees.
#' @param ResLon Longitude resolution in decimal degrees.
#' @param LabLon Longitude at which Latitude labels should appear. if set, the resulting Reference grid will be circumpolar.
#' @param lwd Line thickness of the Reference grid.
#' @param fontsize Font size of the Reference grid's labels.
#' @param offset offset of the Reference grid's labels (distance to plot border).
#' @seealso 
#' \code{\link{load_Bathy}}, \code{\link{SmallBathy}}.
#' 
#' @examples
#'
#' #Example 1: Circumpolar grid with Latitude labels at Longitude 0
#' 
#' Mypar=par(mai=c(1,1.5,0.5,0)) #Figure margins as c(bottom, left, top, right)
#' par(Mypar)
#' plot(SmallBathy,breaks=Depth_cuts, col=Depth_cols, legend=FALSE,axes=FALSE,box=FALSE)
#' add_RefGrid(bb=bbox(SmallBathy),ResLat=10,ResLon=20,LabLon = 0)
#' 
#' #Example 2: Local grid around created polygons
#' 
#' MyPolys=create_Polys(PolyData,Densify=TRUE)
#' BathyC=raster::crop(SmallBathy,MyPolys) #crop the bathymetry to match the extent of MyPolys
#' Mypar=par(mai=c(0.5,0.5,0.5,0.5)) #Figure margins as c(bottom, left, top, right)
#' par(Mypar)
#' plot(BathyC,breaks=Depth_cuts, col=Depth_cols, legend=FALSE,axes=FALSE,box=FALSE)
#' add_RefGrid(bb=bbox(BathyC),ResLat=2,ResLon=6)
#' plot(MyPolys,add=TRUE,col='orange',border='brown',lwd=2)
#' 
#' @export

add_RefGrid=function(bb,ResLat=1,ResLon=2,LabLon=NA,lwd=1,fontsize=1,offset=NA){

#Get bbox manually from raster
xmin=bb[1,1]
xmax=bb[1,2]
ymin=bb[2,1]
ymax=bb[2,2]
Locs=cbind(c(xmin,xmin,xmax,xmax,xmin),
           c(ymin,ymax,ymax,ymin,ymin))

#Get offset
if(is.na(sum(offset))==TRUE){
  #auto offset
  xd=xmax-xmin
  offsetx=0.01*xd
  yd=ymax-ymin
  offsety=0.02*yd
  if(is.na(LabLon)==FALSE){offsetx=0}
}else{
  if(length(offset)==1){offsetx=offset;offsety=offset}else{offsetx=offset[1];offsety=offset[2]}
}

#Create Lat/Lon grid
x=Spatial(cbind(min=c(-180,-80),max=c(180,-45)),proj4string=CRS("+init=epsg:4326"))
if(is.na(LabLon)==FALSE){
  gr=gridlines(x,easts=sort(unique(c(seq(-180,180,by=ResLon),LabLon))),norths=seq(-80,-45,by=ResLat),ndiscr = 1000) 
}else{
  gr=gridlines(x,easts=seq(-180,180,by=ResLon),norths=seq(-80,-45,by=ResLat),ndiscr = 1000)
}

#Create box
LocsP=SpatialLines(list(Lines(list(Line(Locs)),'name')), proj4string=CRS("+init=epsg:6932"))

#Get labels
#Circumpolar
if(is.na(LabLon)==FALSE){
  grP=gIntersection(gr[1],gr[2])
  Cs=coordinates(grP)
  Cs=data.frame(Lat=Cs[,2],Lon=Cs[,1])
  grP=SpatialPointsDataFrame(cbind(Cs$Lon,Cs$Lat),Cs,proj4string=CRS("+init=epsg:4326"))
  grP=spTransform(grP,CRS("+init=epsg:6932"))
  tmp=coordinates(grP)
  grP$x=tmp[,1]
  grP$y=tmp[,2]
  gr=spTransform(gr,CRS("+init=epsg:6932"))
  
  Labs=grP@data
  LatLabs=Labs[Labs$Lon==LabLon,]
  LonLabs=Labs[Labs$Lat==max(Labs$Lat),]
  #Offset Longitude labels
  Lps=SpatialPoints(cbind(sort(unique(c(seq(-180,180,by=ResLon),LabLon))),-43+offsetx),proj4string=CRS("+init=epsg:4326"))
  Lps=spTransform(Lps,CRS("+init=epsg:6932"))
  Lps=coordinates(Lps)
  LonLabs$x=Lps[,1]
  LonLabs$y=Lps[,2]
  #Adjust
  LonLabs$xadj=0.5
  LatLabs$xadj=0.5
}else{
  grlat=spTransform(gr[1],CRS("+init=epsg:6932"))
  grlon=spTransform(gr[2],CRS("+init=epsg:6932"))
  
  grlat=raster::crop(grlat,LocsP)
  grlon=raster::crop(grlon,LocsP)
  
  gr=rbind(grlat,grlon)
  
  grPlat=gIntersection(grlat,LocsP)
  grPlon=gIntersection(grlon,LocsP)
  
  tmp=coordinates(grPlat)
  Labslat=data.frame(x=tmp[,1],y=tmp[,2])
  
  tmp=coordinates(grPlon)
  Labslon=data.frame(x=tmp[,1],y=tmp[,2])
  
  LabslatV=Labslat[Labslat$x==min(Labslat$x)|Labslat$x==max(Labslat$x),]
  LabslatH=Labslat[Labslat$y==min(Labslat$y)|Labslat$y==max(Labslat$y),]
  LabslonV=Labslon[Labslon$x==min(Labslon$x)|Labslon$x==max(Labslon$x),]
  LabslonH=Labslon[Labslon$y==min(Labslon$y)|Labslon$y==max(Labslon$y),]
  
  #Rounding thing
  DecLat=nchar(strsplit(sub('0+$', '', as.character(ResLat)), ".", fixed = TRUE)[[1]])
  DecLon=nchar(strsplit(sub('0+$', '', as.character(ResLon)), ".", fixed = TRUE)[[1]])
  if(length(DecLat)==1){DecLat=0}else{DecLat=DecLat[[2]]}
  if(length(DecLon)==1){DecLon=0}else{DecLon=DecLon[[2]]}
  
  if((dim(LabslatH)[1]+dim(LabslonV)[1])>(dim(LabslatV)[1]+dim(LabslonH)[1])){
    #go with LabslatH and LabslonV
    #Get Lat/Lon
    LabslatH=project_data(Input=LabslatH,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = T,inv=T)
    LabslonV=project_data(Input=LabslonV,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = T,inv=T)
    #Add offset
    LabslatH$y[LabslatH$y==max(LabslatH$y)]=LabslatH$y[LabslatH$y==max(LabslatH$y)]+offsety
    LabslatH$y[LabslatH$y==min(LabslatH$y)]=LabslatH$y[LabslatH$y==min(LabslatH$y)]-offsety
    LabslatH$xadj=0.5
    LabslonV$xadj=1
    LabslonV$xadj[LabslonV$x==max(LabslonV$x)]=0
    LabslonV$x[LabslonV$x==max(LabslonV$x)]=LabslonV$x[LabslonV$x==max(LabslonV$x)]+offsetx
    LabslonV$x[LabslonV$x==min(LabslonV$x)]=LabslonV$x[LabslonV$x==min(LabslonV$x)]-offsetx
    #rename Labs
    LatLabs=LabslatH
    LonLabs=LabslonV
  }else{
    #go with LabslatV and LabslonH
    #Get Lat/Lon
    LabslatV=project_data(Input=LabslatV,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = T,inv=T)
    LabslonH=project_data(Input=LabslonH,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = T,inv=T)
    #Add offset
    LabslonH$xadj=0.5
    LabslatV$xadj=1
    LabslatV$xadj[LabslatV$x==max(LabslatV$x)]=0
    LabslatV$x[LabslatV$x==max(LabslatV$x)]=LabslatV$x[LabslatV$x==max(LabslatV$x)]+offsetx
    LabslatV$x[LabslatV$x==min(LabslatV$x)]=LabslatV$x[LabslatV$x==min(LabslatV$x)]-offsetx
    LabslonH$y[LabslonH$y==max(LabslonH$y)]=LabslonH$y[LabslonH$y==max(LabslonH$y)]+offsety
    LabslonH$y[LabslonH$y==min(LabslonH$y)]=LabslonH$y[LabslonH$y==min(LabslonH$y)]-offsety
    #rename Labs
    LatLabs=LabslatV
    LonLabs=LabslonH
  }
  
  #round
  LatLabs$Lat=round(LatLabs$Lat,DecLat)
  LonLabs$Lon=round(LonLabs$Lon,DecLon)
}

#Add W/E and S
LatLabs$Lat=paste0(abs(LatLabs$Lat),'S')
tmp=LonLabs$Lon
indx=which(tmp%in%c(0,-180,180))
indxW=which(LonLabs$Lon<0 & (LonLabs$Lon%in%c(0,-180,180)==FALSE))
indxE=which(LonLabs$Lon>0 & (LonLabs$Lon%in%c(0,-180,180)==FALSE))
LonLabs$Lon[indxW]=paste0(abs(LonLabs$Lon[indxW]),'W')
LonLabs$Lon[indxE]=paste0(LonLabs$Lon[indxE],'E')
LonLabs$Lon[LonLabs$Lon%in%c('180','-180')]='180'

Mypar=par(xpd=TRUE)
plot(gr,lty=3,add=TRUE,lwd=lwd)
par(Mypar)
if(0.5%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==0.5],LatLabs$y[LatLabs$xadj==0.5],LatLabs$Lat[LatLabs$xadj==0.5],
       cex=fontsize,adj=c(0.5,0.5),xpd=TRUE)}
if(1%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==1],LatLabs$y[LatLabs$xadj==1],LatLabs$Lat[LatLabs$xadj==1],
       cex=fontsize,adj=c(1,0.5),xpd=TRUE)}
if(0%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==0],LatLabs$y[LatLabs$xadj==0],LatLabs$Lat[LatLabs$xadj==0],
       cex=fontsize,adj=c(0,0.5),xpd=TRUE)}

if(0.5%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==0.5],LonLabs$y[LonLabs$xadj==0.5],LonLabs$Lon[LonLabs$xadj==0.5],
       cex=fontsize,adj=c(0.5,0.5),xpd=TRUE)}
if(0%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==0],LonLabs$y[LonLabs$xadj==0],LonLabs$Lon[LonLabs$xadj==0],
       cex=fontsize,adj=c(0,0.5),xpd=TRUE)}
if(1%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==1],LonLabs$y[LonLabs$xadj==1],LonLabs$Lon[LonLabs$xadj==1],
       cex=fontsize,adj=c(1,0.5),xpd=TRUE)}
}
