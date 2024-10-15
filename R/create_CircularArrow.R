#' Create Circular Arrow
#' 
#' Create one or multiple arrows on an elliptical path, or a custom path (using \code{Input}).
#' This function uses \code{\link{create_Arrow}} and \code{\link{create_Ellipse}}.
#' Defaults are set for a simplified Weddell Sea gyre.
#' 
#' @param Latc numeric, latitude of the ellipse centre in decimal degrees, or Y projected 
#' coordinate if \code{yx} is set to \code{TRUE}. 
#' 
#' @param Lonc numeric, longitude of the ellipse centre in decimal degrees, or X projected 
#' coordinate if \code{yx} is set to \code{TRUE}. 
#' 
#' @param Lmaj numeric, length of major axis.
#' 
#' @param Lmin numeric, length of minor axis.
#' 
#' @param Ang numeric, angle of rotation (0-360).
#' 
#' @param Npe integer, number of points on the ellipse.
#' 
#' @param dir character, direction along the ellipse, either \code{"cw"} (clockwise)
#'  or \code{"ccw"} (counterclockwise). 
#' 
#' @param Narr integer, number of arrows.
#' 
#' @param Spc integer, spacing between arrows, or length of single arrow.
#' 
#' @param Stp numeric, starting point of an arrow on the ellipse (0 to 1).
#' 
#' @param yx Logical, if set to \code{TRUE} the input coordinates are projected.
#' Give Y as \code{Latc}, X as \code{Lonc}.
#' 
#' @param Npa integer, number of points to build the path of the arrow.
#' 
#' @param Pwidth numeric, width of the arrow's path.
#' 
#' @param Hlength numeric, length of the arrow's head.
#' 
#' @param Hwidth numeric, width of the arrow's head.
#' 
#' @param dlength numeric, length of dashes for dashed arrows.
#' 
#' @param Atype character, arrow type either "normal" or "dashed". A normal arrow is a single polygon,
#' with a single color (set by \code{Acol}) and transparency (set by \code{Atrans}). A dashed arrow
#' is a series of polygons which can be colored separately by setting two or more values as
#' \code{Acol=c("color start","color end")} and two or more transparency values as
#' \code{Atrans=c("transparency start","transparency end")}. The length of dashes is controlled
#' by \code{dlength}.
#' 
#' @param Acol Color of the arrow, see \code{Atype} above.
#' 
#' @param Atrans Numeric, transparency of the arrow, see \code{Atype} above.
#' 
#' @param yx Logical, if set to \code{TRUE} the input coordinates are projected.
#' Give Y in the first column, X in the second.
#' 
#' @param Input Either \code{NULL}, or a projected spatial object to control the arrow's
#'  path (see examples). 
#' 
#' @return Spatial object in your environment.
#' 
#' @seealso 
#' \code{\link{create_Ellipse}}, \code{\link{create_Arrow}}, \code{\link{create_Polys}},
#' \code{\link{add_Legend}}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#27-create-circular-arrow
#' 
#' #Example 1
#' Arr=create_CircularArrow()
#' 
#' terra::plot(SmallBathy(),xlim=c(-3e6,0),ylim=c(0,3e6),breaks=Depth_cuts,
#'             col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE,main="Example 1")
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',add=TRUE)
#' plot(st_geometry(Arr),col=Arr$col,border=NA,add=TRUE)
#' 
#' 
#' #Example 2
#' Arr=create_CircularArrow(Narr=2,Spc=5)
#' 
#' terra::plot(SmallBathy(),xlim=c(-3e6,0),ylim=c(0,3e6),breaks=Depth_cuts,
#'             col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE,main="Example 2")
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',add=TRUE)
#' plot(st_geometry(Arr),col=Arr$col,border=NA,add=TRUE)
#' 
#' 
#' #Example 3
#' Arr=create_CircularArrow(Narr=10,Spc=-4,Hwidth=15,Hlength=20)
#' 
#' terra::plot(SmallBathy(),xlim=c(-3e6,0),ylim=c(0,3e6),breaks=Depth_cuts,
#'             col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE,main="Example 3")
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',add=TRUE)
#' plot(st_geometry(Arr),col=Arr$col,border=NA,add=TRUE)
#' 
#' 
#' #Example 4
#' Arr=create_CircularArrow(Narr=8,Spc=-2,Npa=200,Acol=c("red","orange","green"),
#'                          Atrans = c(0,0.9,0),Atype = "dashed")
#' 
#' terra::plot(SmallBathy(),xlim=c(-3e6,0),ylim=c(0,3e6),breaks=Depth_cuts,
#'             col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE,main="Example 4")
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',add=TRUE)
#' plot(st_geometry(Arr),col=Arr$col,border=NA,add=TRUE)
#' 
#' 
#' #Example 5 Path around two ellipses
#' El1=create_Ellipse(Latc=-61,Lonc=-50,Lmaj=500,Lmin=250,Ang=120)
#' El2=create_Ellipse(Latc=-68,Lonc=-57,Lmaj=400,Lmin=200,Ang=35)
#' #Merge ellipses and take convex hull
#' El=st_union(st_geometry(El1),st_geometry(El2))
#' El=st_convex_hull(El)
#' El=st_segmentize(El,dfMaxLength = 10000)
#' #Go counterclockwise if desired:
#' #El=st_coordinates(El)
#' #El=st_polygon(list(El[nrow(El):1,])) 
#' 
#' Arr=create_CircularArrow(Narr=10,Spc=3,Npa=200,Acol=c("green","darkgreen"),
#'                          Atype = "dashed",Input=El)
#' 
#' terra::plot(SmallBathy(),xlim=c(-3e6,0),ylim=c(0,3e6),breaks=Depth_cuts,
#'             col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE,main="Example 5")
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',add=TRUE)
#' plot(st_geometry(Arr),col=Arr$col,border=NA,add=TRUE)
#' 
#' 
#' 
#' 
#' @export

create_CircularArrow=function(Latc=-67,Lonc=-30,Lmaj=800,Lmin=500,Ang=140,Npe=100,dir="cw",
                              Narr=1,Spc=0,Stp=0,Npa=50,Pwidth=5,Hlength=15,Hwidth=10,
                              dlength=0,Atype="normal",Acol="green",Atrans=0,yx=FALSE,Input=NULL){
  if(is.null(Input)){
    El=create_Ellipse(Latc=Latc,Lonc=Lonc,Lmaj=Lmaj,Lmin=Lmin,Ang=Ang,Np=Npe,dir=dir,yx=yx)
  }else{
    El=Input
  }
  Elp=st_coordinates(El)
  Elp=data.frame(Y=Elp[,2],X=Elp[,1])
  Elp=dplyr::distinct(Elp)
  
  #set starting point
  ip=round(nrow(Elp)*Stp+1)
  ip=min(max(1,ip),nrow(Elp))
  if(ip!=1 & ip!=nrow(Elp)){
    Elp=Elp[c(ip:nrow(Elp),1:(ip-1)),]
  }
  Elp=rbind(Elp,Elp[1,])
  
  #Build arrows
  Elp$a=1
  if(Narr>1){
    Elp$a=cut(seq(1,nrow(Elp)),Narr,labels = FALSE)
  }
  Arr=NULL
  Arri=NULL
  for(i in seq(1,Narr)){
    Pts=Elp[Elp$a==i,]
    if(Spc>=0){
      if(i>1){
        Pts=rbind(Elp[max(which(Elp$a==(i-1))),],Pts)
      }
      Arri=create_Arrow(Input=Pts[1:(nrow(Pts)-Spc),],yx=TRUE,
                        Np=Npa,Pwidth=Pwidth,Hlength=Hlength,Hwidth=Hwidth,dlength=dlength,Atype=Atype,Acol=Acol,Atrans=Atrans)
      Arri$a=i
      Arri$n=1
    }else{
      if(Narr==1){
        Arri=create_Arrow(Input=rbind(Pts,Pts[1:(-Spc),]),yx=TRUE,
                          Np=Npa,Pwidth=Pwidth,Hlength=Hlength,Hwidth=Hwidth,dlength=dlength,Atype=Atype,Acol=Acol,Atrans=Atrans)
        Arri$a=i
        Arri$n=1
      }else{
        if(i==1){
          adp=tail(which(Elp$a==max(Elp$a)),-Spc)
          Pts=rbind(Elp[adp,],Pts)
          Arri=create_Arrow(Input=Pts,yx=TRUE,
                            Np=Npa,Pwidth=Pwidth,Hlength=Hlength,Hwidth=Hwidth,dlength=dlength,Atype=Atype,Acol=Acol,Atrans=Atrans)
          Arri$a=i
          Arri$n=seq(1,nrow(Arri))
        }else{
          adp=tail(which(Elp$a==(i-1)),-Spc)
          Pts=rbind(Elp[adp,],Pts)
          Arri=create_Arrow(Input=Pts,yx=TRUE,
                            Np=Npa,Pwidth=Pwidth,Hlength=Hlength,Hwidth=Hwidth,dlength=dlength,Atype=Atype,Acol=Acol,Atrans=Atrans)
          Arri$a=i
          Arri$n=seq(1,nrow(Arri))
        }
      }
    }
    Arr=rbind(Arr,Arri)
    #Reorder to get heads on top when possible
    if(max(Arr$n)>3){
      Thr=floor(max(Arr$n)/3)
      Arr=Arr[c(which(Arr$n<=Thr),which(Arr$n>Thr)),]
    }
    
  }
  return(Arr)
}
