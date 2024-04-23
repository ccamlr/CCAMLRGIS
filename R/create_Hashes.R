#' Create Hashes
#' 
#' Create hashed lines to fill a polygon.
#' 
#' @param pol single polygon inside which hashed lines will be created.
#' May be created using \code{\link{create_Polys}} or by subsetting an 
#' object obtained using one of the \code{load_} functions.
#' 
#' @param angle numeric, angle of the hashed lines in degrees (0-360), 
#' noting that the function might struggle with angles 0, 180, -180 or 360.
#' 
#' @param spacing numeric, spacing between hashed lines.
#' 
#' @param width numeric, width of hashed lines.
#' 
#' @return Spatial object in your environment, to be added to your plot.
#' 
#' @seealso 
#' \code{\link{create_Polys}}, \code{\link{add_Legend}}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#25-create-hashes
#' 
#' #Create some polygons
#' MyPolys=create_Polys(Input=PolyData)
#' #Create hashes for each polygon
#' H1=create_Hashes(pol=MyPolys[1,],angle=45,spacing=1,width=1)
#' H2=create_Hashes(pol=MyPolys[2,],angle=90,spacing=2,width=2)
#' H3=create_Hashes(pol=MyPolys[3,],angle=0,spacing=3,width=3)
#' 
#' plot(st_geometry(MyPolys),col='cyan')
#' plot(st_geometry(H1),col='red',add=TRUE)
#' plot(st_geometry(H2),col='green',add=TRUE)
#' plot(st_geometry(H3),col='blue',add=TRUE)
#' 
#' @export

create_Hashes=function(pol,angle=45,spacing=1,width=1){
  if(angle==0){angle=0.00000001}
  if(angle==180){angle=180.00000001}
  if(angle==-180){angle=-180.00000001}
  if(angle==360){angle=359.999999999}
  bb=st_bbox(pol)
  bx=st_as_sfc(bb)
  #Get centre
  xc=mean(c(bb['xmin'],bb['xmax']))
  yc=mean(c(bb['ymin'],bb['ymax']))
  #Build first segment
  d=max(c(bb['xmax']-bb['xmin'],bb['ymax']-bb['ymin'])) #distance
  x1=xc+d*cos(angle*pi/180)
  y1=yc+d*sin(angle*pi/180)
  x2=xc+d*cos((angle+180)*pi/180)
  y2=yc+d*sin((angle+180)*pi/180)
  Hs=data.frame(x=c(x1,x2),y=c(y1,y2))
  Lls=list(as.matrix(Hs))
  #first getperp
  tmp=GetPerp(Hs, d=50000*spacing)
  #Get segments A(1-3) and B(2-4)
  A=cbind(x=tmp$x[c(1,3)],y=tmp$y[c(1,3)])
  Al=st_linestring(A)
  Lls=c(Lls,list(A))
  B=cbind(x=tmp$x[c(2,4)],y=tmp$y[c(2,4)])
  Bl=st_linestring(B)
  Lls=c(Lls,list(B))
  while(st_intersects(Al,bx,sparse = F)){
    tmp=GetPerp(as.data.frame(A), d=50000*spacing)
    A=cbind(x=tmp$x[c(1,3)],y=tmp$y[c(1,3)])
    Al=st_linestring(A)
    Lls=c(Lls,list(A))
  }
  while(st_intersects(Bl,bx,sparse = F)){
    tmp=GetPerp(as.data.frame(B), d=50000*spacing)
    B=cbind(x=tmp$x[c(2,4)],y=tmp$y[c(2,4)])
    Bl=st_linestring(B)
    Lls=c(Lls,list(B))
  }
  lls=st_multilinestring(Lls)
  lls=st_sfc(lls, crs = st_crs(pol))
  lls=st_buffer(lls,dist=10000*width)
  lls=suppressWarnings( st_intersection(pol,lls) )
  lls=st_geometry(lls)
}
