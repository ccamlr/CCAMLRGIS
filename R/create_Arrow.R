#' Create Arrow
#' 
#' Create an arrow which can be curved and/or segmented.
#' 
#' @param Input input dataframe with at least two columns (Latitudes then Longitudes) and an
#' optional third column for weights. First row is the location of the start of the arrow,
#' Last row is the location of the end of the arrow (where the arrow will point to). Optional
#' intermediate rows are the locations of points towards which the arrow's path will bend. 
#' Weights (third column) can be added to the intermediate points to make the arrow's path
#' bend more towards them. Projected coordinates may be used (Y then X) instead of Latitudes
#' and Longitudes by setting \code{yx} to \code{TRUE}. Coordinates may be extracted from a
#' spatial object and used as input (see Example 9 below).
#' 
#' @param Np integer, number of additional points generated to create a curved path. If the 
#' arrow's path appears too segmented, increase \code{Np}.
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
#' @return Spatial object in your environment with colors included in the dataframe (see examples).
#' 
#' @seealso 
#' \code{\link{create_CircularArrow}}, \code{\link{create_Ellipse}},\code{\link{add_Legend}},
#' \code{\link{create_Points}}, \code{\link{create_Lines}}, \code{\link{create_Polys}},
#' \code{\link{create_PolyGrids}}, \code{\link{create_Stations}}, \code{\link{create_Pies}}.
#' 
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#24-create-arrow
#' 
#' #Example 1: straight green arrow
#' myInput=data.frame(lat=c(-61,-52),
#'                    lon=c(-60,-40))
#' Arrow=create_Arrow(Input=myInput)
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 1")
#' 
#' 
#' #Example 2: blue arrow with one bend
#' myInput=data.frame(lat=c(-61,-65,-52),
#'                    lon=c(-60,-45,-40))
#' Arrow=create_Arrow(Input=myInput,Acol="lightblue")
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 2")
#' 
#' #Example 3: blue arrow with two bends
#' myInput=data.frame(lat=c(-61,-60,-65,-52),
#'                    lon=c(-60,-50,-45,-40))
#' Arrow=create_Arrow(Input=myInput,Acol="lightblue")
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 3")
#' 
#' #Example 4: blue arrow with two bends, with more weight on the second bend
#' #and a big head
#' myInput=data.frame(lat=c(-61,-60,-65,-52),
#'                    lon=c(-60,-50,-45,-40),
#'                    w=c(1,1,2,1))
#' Arrow=create_Arrow(Input=myInput,Acol="lightblue",Hlength=20,Hwidth=20)
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 4")
#' 
#' #Example 5: Dashed arrow, small dashes
#' myInput=data.frame(lat=c(-61,-60,-65,-52),
#'                    lon=c(-60,-50,-45,-40),
#'                    w=c(1,1,2,1))
#' Arrow=create_Arrow(Input=myInput,Acol="blue",Atype = "dashed",dlength = 1)
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 5",border=NA)
#' 
#' #Example 6: Dashed arrow, big dashes
#' myInput=data.frame(lat=c(-61,-60,-65,-52),
#'                    lon=c(-60,-50,-45,-40),
#'                    w=c(1,1,2,1))
#' Arrow=create_Arrow(Input=myInput,Acol="blue",Atype = "dashed",dlength = 2)
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 6",border=NA)
#' 
#' #Example 7: Dashed arrow, no dashes, 3 colors and transparency gradient
#' myInput=data.frame(lat=c(-61,-60,-65,-52),
#'                    lon=c(-60,-50,-45,-40),
#'                    w=c(1,1,2,1))
#' Arrow=create_Arrow(Input=myInput,Acol=c("red","green","blue"),
#' Atrans = c(0,0.9,0),Atype = "dashed",dlength = 0)
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 7",border=NA)
#' 
#' #Example 8: Same as example 7 but with more points, so smoother
#' myInput=data.frame(lat=c(-61,-60,-65,-52),
#'                    lon=c(-60,-50,-45,-40),
#'                    w=c(1,1,2,1))
#' Arrow=create_Arrow(Input=myInput,Np=200,Acol=c("red","green","blue"),
#'                    Atrans = c(0,0.9,0),Atype = "dashed",dlength = 0)
#' plot(st_geometry(Arrow),col=Arrow$col,main="Example 8",border=NA)
#' 
#' #Example 9 Path along isobath
#' Iso=st_as_sf(terra::as.contour(SmallBathy(),levels=-1000)) #Take isobath
#' Iso=suppressWarnings(st_cast(Iso,"LINESTRING")) #convert to individual lines
#' Iso$L=st_length(Iso) #Get line length
#' Iso=Iso[Iso$L==max(Iso$L),] #Keep longest line (circumpolar)
#' Iso=st_coordinates(Iso) #Extract coordinates
#' Iso=Iso[Iso[,1]>-2.1e6 & Iso[,1]<(-0.1e6) & Iso[,2]>0,] #crop line
#' Inp=data.frame(Y=Iso[,2],X=Iso[,1])
#' Inp=Inp[seq(nrow(Inp),1),] #Go westward
#' Third=nrow(Inp)/3 #Cut in thirds
#' Arr1=create_Arrow(Input=Inp[1:Third,],yx=TRUE)
#' Arr2=create_Arrow(Input=Inp[(Third+2):(2*Third),],yx=TRUE)
#' Arr3=create_Arrow(Input=Inp[(2*Third+2):nrow(Inp),],yx=TRUE)
#' 
#' terra::plot(SmallBathy(),xlim=c(-2.5e6,0.5e6),ylim=c(0.25e6,2.75e6),breaks=Depth_cuts,
#'             col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE,main="Example 9")
#' plot(st_geometry(Arr1),col="darkred",add=TRUE)
#' plot(st_geometry(Arr2),col="darkred",add=TRUE)
#' plot(st_geometry(Arr3),col="darkred",add=TRUE)
#' plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',add=TRUE)
#' 
#' @export

create_Arrow=function(Input,Np=50,Pwidth=5,Hlength=15,Hwidth=10,dlength=0,Atype="normal",Acol="green",Atrans=0,yx=FALSE){
  
  if(Atype=="normal" & length(Acol)>1){
    stop("A 'normal' arrow can only have one color.")
  }
  
  if(length(Acol)>1 & length(Atrans)==1){
    Atrans=rep(Atrans,length(Acol))
  }
  
  if(length(Acol)!=length(Atrans)){
    stop("length(Atrans) should equal length(Acol).")
  }
  
  Pwidth=Pwidth*10000
  Hlength=Hlength*10000
  Hwidth=Hwidth*10000
  Hwidth=max(c(Pwidth,Hwidth))
  
  Input=as.data.frame(Input)
  if(ncol(Input)==2){
    Input$w=1
  }
  Input[,3]=round(Input[,3])
  
  if(any(is.na(Input[,3]))==TRUE){
    stop("Missing weight(s) in the Input.")
  }
  
  Ps=data.frame(Lat=Input[,1],Lon=Input[,2],w=Input[,3])
  
  if(nrow(Input)>2 & length(unique(Input[,3]))>1){
    Ps=Ps[rep(seq(1,nrow(Ps)),Ps$w),] 
  }
  
  #Get curve
  if(yx==FALSE){
  Ps=project_data(Ps,NamesIn=c("Lat","Lon"),append = FALSE)
  }
  Bs=bezier::bezier(t=seq(0,1,length=Np),p=Ps)
  
  #Build linestring
  LS=sf::st_linestring(x = Bs[,2:1])
  LS=sf::st_sfc(LS, crs = 6932)
  #Find head point inside the line (Head center start): pt1
  pt1=lwgeom::st_linesubstring(LS,from=0,to=1-(Hlength/as.numeric(sf::st_length(LS))))
  pt1=sf::st_coordinates(pt1)
  pt1=pt1[nrow(pt1),c(1,2)]
  #Limit points of the line to just beyond pt1
  ofs=abs(Hlength*(1-(Pwidth/Hwidth))) #distance the line can get into the head without going too far
  ofs=ofs-0.1*ofs
  pt2=lwgeom::st_linesubstring(LS,from=0,to=1-((Hlength-ofs)/as.numeric(sf::st_length(LS))))
  pt2=sf::st_coordinates(pt2)
  
  #Build head
  Input=data.frame(x=c(pt1[1],Bs[nrow(Bs),2]),
                   y=c(pt1[2],Bs[nrow(Bs),1]))
  Hea=GetPerp(Input, d=Hwidth)
  Hea=Hea[1:2,]
  x=c(Hea$x,Bs[nrow(Bs),2])
  y=c(Hea$y,Bs[nrow(Bs),1])
  ci=grDevices::chull(x,y)
  x=x[ci]
  y=y[ci]
  x=c(x,x[1])
  y=c(y,y[1])
  Hea=sf::st_polygon(list(cbind(x,y)))
  
  #Get perpendiculars
  Input=data.frame(x=pt2[,1],
                   y=pt2[,2])
  Perps=GetPerp(Input, d=Pwidth)
  
  #Loop over perps to build squares
  Seqs=seq(1, nrow(Perps),by=2)
  Seqs=Seqs[-length(Seqs)]
  if(dlength>0){
    dlength=round(dlength)
    itmp=rep(c(1,0),each=dlength,length.out=length(Seqs))
    Seqs=Seqs[itmp==1]
  }
  
  Pl=list()
  np=1
  for(i in Seqs){
    x=Perps$x[i:(i+3)]
    y=Perps$y[i:(i+3)]
    ci=grDevices::chull(x,y)
    x=x[ci]
    y=y[ci]
    x=c(x,x[1])
    y=c(y,y[1])
    Pl[[np]]=sf::st_polygon(list(cbind(x,y)))
    np=np+1
  }
  
  pPl=sf::st_sfc(Pl, crs = 6932)
  pHea=sf::st_sfc(Hea, crs = 6932)
  
  #Build color ramp
  Cols=NULL
  for(i in seq(1,length(Acol))){
    Col=grDevices::col2rgb(Acol[i],alpha = TRUE)
    Col=as.vector(Col)/255
    Col[4]=Col[4]-Atrans[i]
    Col=grDevices::rgb(red=Col[1], green=Col[2], blue=Col[3], alpha=Col[4])
    Cols=c(Cols,Col)
  }
  pal=grDevices::colorRampPalette(Cols, alpha=TRUE)
  
  if(Atype=="normal"){
    Ar=sf::st_union(pHea,pPl)
    Ar=sf::st_union(Ar)
    Ardata=data.frame(col=pal(1))
  }
  
  if(Atype=="dashed"){
    pPl=pPl[sf::st_contains_properly(Hea,pPl,sparse=FALSE)==FALSE,]
    Ar=c(pPl,pHea) 
    Ardata=data.frame(col=pal(length(Ar)))
  }
  
  Ar=sf::st_set_geometry(Ardata,Ar)
  return(Ar)
}
