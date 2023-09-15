#' Add a Reference grid
#'
#' Add a Latitude/Longitude reference grid to maps.
#'
#' @param bb bounding box of the first plotted object. for example, \code{bb=st_bbox(SmallBathy())} or \code{bb=st_bbox(MyPolys)}.
#' @param ResLat numeric, latitude resolution in decimal degrees.
#' @param ResLon numeric, longitude resolution in decimal degrees.
#' @param LabLon numeric, longitude at which Latitude labels should appear. if set, the resulting Reference grid will be circumpolar.
#' @param LatR numeric, range of latitudes of circumpolar grid.
#' @param lwd numeric, line thickness of the Reference grid.
#' @param lcol character, line color of the Reference grid.
#' @param fontsize numeric, font size of the Reference grid's labels.
#' @param fontcol character, font color of the Reference grid's labels.
#' @param offset numeric, offset of the Reference grid's labels (distance to plot border).
#' @seealso 
#' \code{\link{load_Bathy}}, \code{\link{SmallBathy}}.
#' 
#' @examples
#' library(terra)
#' 
#' #Example 1: Circumpolar grid with Latitude labels at Longitude 0
#' 
#' plot(SmallBathy(),breaks=Depth_cuts, col=Depth_cols, legend=FALSE,axes=FALSE,box=FALSE)
#' add_RefGrid(bb=st_bbox(SmallBathy()),ResLat=10,ResLon=20,LabLon = 0)
#' 
#' #Example 2: Local grid around created polygons
#' 
#' MyPolys=create_Polys(PolyData,Densify=TRUE)
#' BathyC=crop(SmallBathy(),ext(MyPolys))#crop the bathymetry to match the extent of MyPolys
#' Mypar=par(mai=c(0.5,0.5,0.5,0.5)) #Figure margins as c(bottom, left, top, right)
#' par(Mypar)
#' plot(BathyC,breaks=Depth_cuts, col=Depth_cols, legend=FALSE,axes=FALSE,box=FALSE)
#' add_RefGrid(bb=st_bbox(BathyC),ResLat=2,ResLon=6)
#' plot(st_geometry(MyPolys),add=TRUE,col='orange',border='brown',lwd=2)
#' 
#' @export

add_RefGrid=function(bb,ResLat=1,ResLon=2,LabLon=NA,LatR=c(-80,-45),lwd=1,lcol="black",fontsize=1,fontcol="black",offset=NA){

#Get bbox
xmin=as.numeric(bb['xmin'])
xmax=as.numeric(bb['xmax'])
ymin=as.numeric(bb['ymin'])
ymax=as.numeric(bb['ymax'])
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

#Create Lat/Lon lines
Lats=seq(LatR[1],LatR[2],by=ResLat)
if(is.na(LabLon)==FALSE){
 Lons=sort(unique(c(seq(-180,180,by=ResLon),LabLon)))
}else{
 Lons=seq(-180,180,by=ResLon)
}
LLats=list()
for(i in seq(1,length(Lats))){
  LLats[[i]]=st_linestring(cbind(seq(-180,180,by=0.1),Lats[i]))
}
LLats=st_sfc(LLats, crs = 4326)

LLons=list()
for(i in seq(1,length(Lons))){
  LLons[[i]]=st_linestring(cbind(Lons[i],range(Lats)))
}
LLons=st_sfc(LLons, crs = 4326)

gr=c(LLats,LLons)
gr=st_transform(gr,6932)

#Create Lat/Lon points
Ps=expand.grid(Lon=Lons,Lat=Lats)
grP=st_as_sf(x=Ps,coords=c(1,2),crs=4326,remove=FALSE)
grP=st_transform(grP,6932)

#Create box
LocsP=st_sfc(st_polygon(list(Locs)), crs = 6932)


#Get labels
#Circumpolar
if(is.na(LabLon)==FALSE){
  Labsxy=st_coordinates(grP)
  Labs=st_drop_geometry(grP)
  Labs$x=Labsxy[,1]
  Labs$y=Labsxy[,2]
  LatLabs=Labs[Labs$Lon==LabLon,]
  LonLabs=Labs[Labs$Lat==max(Labs$Lat),]
  #Offset Longitude labels
  Lps=st_as_sf(x=data.frame(Lon=Lons,Lat=max(Lats)+2+offsetx),coords=c(1,2),crs=4326)
  Lps=st_transform(Lps,6932)
  Lps=st_coordinates(Lps)
  LonLabs$x=Lps[,1]
  LonLabs$y=Lps[,2]
  #Adjust
  LonLabs$xadj=0.5
  LatLabs$xadj=0.5
  #Remove one of the antimeridians
  LonLabs=LonLabs[-which(LonLabs$Lon==-180),]
}else{
  grlat=st_transform(LLats,6932)
  grlon=st_transform(LLons,6932)
  
  grlat=sf::st_intersection(LocsP,grlat)
  grlon=sf::st_intersection(LocsP,grlon)
  
  gr=c(grlat,grlon)
  
  grPlat=sf::st_intersection(st_cast(LocsP,"LINESTRING"),grlat)
  grPlon=sf::st_intersection(st_cast(LocsP,"LINESTRING"),grlon)
  grPlat=st_cast(grPlat,'MULTIPOINT')
  grPlon=st_cast(grPlon,'MULTIPOINT')
  
  
  tmp=st_coordinates(grPlat)
  Labslat=data.frame(x=tmp[,1],y=tmp[,2])
  
  tmp=st_coordinates(grPlon)
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
    LabslatH=project_data(Input=LabslatH,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = TRUE,inv=TRUE)
    LabslonV=project_data(Input=LabslonV,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = TRUE,inv=TRUE)
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
    LabslatV=project_data(Input=LabslatV,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = TRUE,inv=TRUE)
    LabslonH=project_data(Input=LabslonH,NamesIn = c('y','x'),NamesOut = c('Lat','Lon'),append = TRUE,inv=TRUE)
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
graphics::plot(gr,lty=3,add=TRUE,lwd=lwd,col=lcol)
par(Mypar)
if(0.5%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==0.5],LatLabs$y[LatLabs$xadj==0.5],LatLabs$Lat[LatLabs$xadj==0.5],
       cex=fontsize,adj=c(0.5,0.5),xpd=TRUE,col=fontcol)}
if(1%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==1],LatLabs$y[LatLabs$xadj==1],LatLabs$Lat[LatLabs$xadj==1],
       cex=fontsize,adj=c(1,0.5),xpd=TRUE,col=fontcol)}
if(0%in%LatLabs$xadj){
  text(LatLabs$x[LatLabs$xadj==0],LatLabs$y[LatLabs$xadj==0],LatLabs$Lat[LatLabs$xadj==0],
       cex=fontsize,adj=c(0,0.5),xpd=TRUE,col=fontcol)}

if(0.5%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==0.5],LonLabs$y[LonLabs$xadj==0.5],LonLabs$Lon[LonLabs$xadj==0.5],
       cex=fontsize,adj=c(0.5,0.5),xpd=TRUE,col=fontcol)}
if(0%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==0],LonLabs$y[LonLabs$xadj==0],LonLabs$Lon[LonLabs$xadj==0],
       cex=fontsize,adj=c(0,0.5),xpd=TRUE,col=fontcol)}
if(1%in%LonLabs$xadj){
  text(LonLabs$x[LonLabs$xadj==1],LonLabs$y[LonLabs$xadj==1],LonLabs$Lon[LonLabs$xadj==1],
       cex=fontsize,adj=c(1,0.5),xpd=TRUE,col=fontcol)}
}
