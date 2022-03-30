#' Get Cartesian coordinates of lines intersection in Euclidean space
#'
#' Given two lines defined by the Latitudes/Longitudes of their extremities, finds the location of their 
#' intersection, in Euclidean space, using 
#' \href{https://en.wikipedia.org/wiki/Line-line_intersection}{this approach}.
#'  
#' @param Line1 Vector of 4 coordinates, given in decimal degrees as: 
#' 
#' \code{c(Longitude_start,Latitude_start,Longitude_end,Latitude_end)}.
#' 
#' @param Line2 Same as \code{Line1}.
#' 
#' @param Plot Logical (TRUE or FALSE), plot a schematic of calculations.
#' 
#' @examples
#' \donttest{
#' 
#' 
#'#Example 1 (Intersection beyond the range of segments)
#'get_cart_intersection(Line1=c(-30,-55,-29,-50),Line2=c(-50,-60,-40,-60))
#'
#'#Example 2 (Intersection on one of the segments)
#'get_cart_intersection(Line1=c(-30,-65,-29,-50),Line2=c(-50,-60,-40,-60))
#'
#'#Example 3 (Crossed segments)
#'get_cart_intersection(Line1=c(-30,-65,-29,-50),Line2=c(-50,-60,-25,-60))
#'
#'#Example 4 (Antimeridian crossed)
#'get_cart_intersection(Line1=c(-179,-60,-150,-50),Line2=c(-120,-60,-130,-62))
#'
#'#Example 5 (Parallel lines)
#'get_cart_intersection(Line1=c(0,-60,10,-60),Line2=c(-10,-60,10,-60))
#'
#'
#'}
#'
#' @export

get_C_intersection=function(Line1,Line2,Plot=TRUE){
  
  #Line 1
  x1=Line1[1]
  y1=Line1[2]
  x2=Line1[3]
  y2=Line1[4]
  
  #Line 2
  x3=Line2[1]
  y3=Line2[2]
  x4=Line2[3]
  y4=Line2[4]
  
  #Compute intersection:
  D=(x1-x2)*(y3-y4)-(y1-y2)*(x3-x4)
  if(D==0){
    if(Plot==T){plot(1,1);text(1,1,"Parallel lines",col="red")}
    stop("Parallel lines.")
  }
  Px=((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/D
  Py=((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/D
  
  #Warn user if the longitude of the intersection crosses the antimeridian.
  if(abs(Px)>180){warning("Antimeridian crossed. Find where your line crosses it first, using Line=c(180,-90,180,0) or Line=c(-180,-90,-180,0).")}
  
  if(Plot==TRUE){
    XL=range(c(x1,x2,x3,x4,Px))
    XL=c(XL[1]-0.1*abs(mean(XL)),XL[2]+0.1*abs(mean(XL)))
    YL=range(c(y1,y2,y3,y4,Py))
    YL=c(YL[1]-0.1*abs(mean(YL)),YL[2]+0.1*abs(mean(YL)))
    plot(c(x1,x2,x3,x4),c(y1,y2,y3,y4),xlim=XL,ylim=YL,pch=21,bg=c("green","green","blue","blue"),xlab="Longitude",ylab="Latitude")
    par(new=T)
    plot(Px,Py,xlim=XL,ylim=YL,pch=4,col="red",xlab="",ylab="",lwd=2)
    lines(c(x1,x2),c(y1,y2),col="green",lwd=2)
    lines(c(x3,x4),c(y3,y4),col="blue",lwd=2)
    lines(c(x1,x2,Px),c(y1,y2,Py),col="green",lty=2)
    lines(c(x3,x4,Px),c(y3,y4,Py),col="blue",lty=2)
    if(abs(Px)>180){abline(v=c(-180,180),col="red",lwd=2);text(Px,Py,"Antimeridian crossed",col="red",xpd=T)}
    legend("topleft",c("Line 1","Line 2","Intersection"),col=c("green","blue","red"),lwd=c(2,2,NA),pch=c(21,21,4),pt.bg=c("green","blue","red"))
  }
  return(c(Lon=Px,Lat=Py))
}
