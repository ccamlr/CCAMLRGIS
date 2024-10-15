#' Add Legend
#' 
#' Add a legend to you map. Give the bounding box of your plot and lists of parameters as inputs.
#' 
#' @param bb bounding box of your plot area. for example, 
#' \code{bb=st_bbox(SmallBathy())} or \code{bb=st_bbox(MyPolys)}.
#' 
#' @param LegOpt list of general legend options. for example:
#' 
#' \code{LegOpt=list(Title="Speed",Subtitle="(km/h)")}. 
#' 
#'  
#' @param Items list, or list of lists containing options for each item to be displayed in the legend. for example:
#'  
#'  \code{item1=list(Text="one",Shape="rectangle")}
#'  
#'  \code{item2=list(Text="two",Shape="circle")}
#'  
#'  \code{Items=list(item1,item2)}
#'  
#'
#' @return Legend added to current plot.
#'
#' 
#' @section LegOpt options:
#' 
#' \itemize{
#'   \item Title: character, title of the legend, set to NULL for no title.
#'   \item Subtitle: character, subtitle of the legend, set to NULL for no subtitle.
#'   \item Pos: character, general position of the legend. One of "bottomright" (default),
#'    "bottom", "bottomleft", "left", "topleft", "top", "topright", "right" or "center".
#'   \item BoxW: numeric, legend box width (see figure below).
#'   \item BoxH: numeric, legend box height (see figure below).
#'   \item PosX: numeric, horizontal adjustment of legend (see figure below).
#'   \item PosY: numeric, vertical adjustment of legend (see figure below). 
#'   \item Boxexp: numeric, vector of length 4 controlling the expansion of the legend box, 
#'    given as c(xmin,xmax,ymin,ymax), see figure below.
#'   \item Boxbd: character, color of the background of the legend box. set to NA for no background.
#'   \item Boxcol: character, color of the border of the legend box. Set to NA for no box.
#'   \item Boxlwd: numeric, line thickness of the legend box. Set Boxcol to NA for no box.
#'   \item Titlefontsize: numeric, size of the legend title.
#'   \item Subtitlefontsize: numeric, size of the legend subtitle.
#'   \item TitleAdj: numeric vector of length 2, as c(x,y) to adjust title location (see figure below).
#'   \item SubtitleAdj: numeric vector of length 2, as c(x,y) to adjust subtitle location.
#' }
#'
#' @section Items options that are common to all items:
#' 
#' \itemize{
#'   \item Text: character, text of the item.
#'   \item Shape: character, shape description, one of "rectangle", "circle", "ellipse", "line", 
#'   "arrow" or "none". Using "none" will leave a blank space that can be filled by a user-defined shape.
#'   \item ShpFill: character, fill color of shape, set to NA for no fill.
#'   \item ShpBord: character, border color of shape, set to NA for no border.
#'   \item ShpHash: logical (TRUE/FALSE) to add hashed lines to the shape (see \link{create_Hashes}).
#'   \item Shplwd: numeric, line thickness of the shape's border, set ShpBord to NA for no border.
#'   \item fontsize: numeric, size of the text.
#'   \item STSpace: numeric, space between the Shape and its Text (see figure below).
#'   \item ShiftX: numeric, shift Shape and Text left or right (see figure below).
#'   \item ShiftY: numeric, shift Shape and Text up or down (see figure below).
#'   \item Hashcol: character, color of hashes (if ShpHash is TRUE), see \link{create_Hashes} for details.
#'   \item Hashangle: numeric, angle of hashes (if ShpHash is TRUE), see \link{create_Hashes} for details.
#'   \item Hashspacing: numeric, spacing between hashes (if ShpHash is TRUE), see \link{create_Hashes} for details.
#'   \item Hashwidth: numeric, width of hashes (if ShpHash is TRUE), see see \link{create_Hashes} for details.
#' }
#' 
#' @section Items options that are specific to the item's Shape:
#' 
#' \itemize{
#'   \item RectW: numeric, width of rectangle shape.
#'   \item RectH: numeric, height of rectangle shape.
#'   \item CircD: numeric, diameter of circle shape.
#'   \item EllW: numeric, width of ellipse shape.
#'   \item EllH: numeric, height of ellipse shape.
#'   \item EllA: numeric, angle of ellipse shape.
#'   \item LineTyp: numeric, type of line shape (0=blank, 1=solid, 2=dashed, 3=dotted, 4=dotdash, 5=longdash, 6=twodash).
#'   \item LineL: numeric, length of the line shape.
#'   \item ArrL: numeric, length of the arrow shape.
#'   \item ArrPwidth: numeric, width of arrow's path. see \link{create_Arrow} for details.
#'   \item ArrHlength: numeric, length of arrow's head. see \link{create_Arrow} for details.
#'   \item ArrHwidth: numeric, width of arrow's head. see \link{create_Arrow} for details.
#'   \item Arrdlength: numeric, length of dashes for dashed arrows. see \link{create_Arrow} for details.
#'   \item Arrtype: character, arrow type either "normal" or "dashed". see \link{create_Arrow} for details. 
#'   \item Arrcol: character, color of the arrow. see \link{create_Arrow} for details.
#'   \item Arrtrans: numeric, transparency of the arrow. see \link{create_Arrow} for details.
#' }
#' 
#' 
#' The figure below shows some of the options used to customize the legend box and its items. 
#' Blue arrows represent location options and black arrows represent sizing options:
#' 
#' \if{html}{\figure{Addlegenddetails.png}{options: width=800}}
#' \if{latex}{\figure{Addlegenddetails.pdf}{options: width=6in}}
#' 
#' 
#' @seealso 
#' \code{\link{create_Hashes}}, \code{\link{create_Arrow}}, \code{\link{create_Ellipse}},
#' \code{\link{add_labels}}, \code{\link{add_Cscale}}, \code{\link{add_PieLegend}}.
#'  
#'  
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#53-adding-legends
#' 
#' # Set general options:
#' 
#' LegOpt=list( 
#' Title= "Title",
#' Subtitle="(Subtitle)",
#' Pos = "bottomright",
#' BoxW= 80,
#' BoxH= 170,
#' Boxexp = c(5,-2,-4,-4),
#' Titlefontsize = 2
#' )
#' 
#'
#' #Create separate items, each with their own options:
#' 
#' 
#' Rectangle1=list(
#'   Text="Rectangle 1", 
#'   Shape="rectangle",
#'   ShpFill="cyan",
#'   ShpBord="blue",
#'   Shplwd=2,
#'   fontsize=1.2,
#'   STSpace=3,
#'   RectW=10,
#'   RectH=7
#' )
#' 
#' Rectangle2=list(
#'   Text="Rectangle 2", 
#'   Shape="rectangle",
#'   ShpFill="red",
#'   ShpBord="orange",
#'   ShpHash=TRUE,
#'   Shplwd=2,
#'   fontsize=1.2,
#'   STSpace=3,
#'   RectW=10,
#'   RectH=7,
#'   Hashcol="white",
#'   Hashangle=45,
#'   Hashspacing=1,
#'   Hashwidth=1
#' )
#' 
#' Circle1=list(
#'   Text="Circle 1", 
#'   Shape="circle",
#'   ShpFill="grey",
#'   ShpBord="yellow",
#'   Shplwd=2,
#'   fontsize=1.2,
#'   STSpace=3,
#'   CircD=10
#' )
#' 
#' Circle2=list(
#'   Text="Circle 2", 
#'   Shape="circle",
#'   ShpFill="white",
#'   ShpBord="red",
#'   ShpHash=TRUE,
#'   Shplwd=2,
#'   fontsize=1.2,
#'   STSpace=3,
#'   CircD=10,
#'   Hashcol="black",
#'   Hashangle=0,
#'   Hashspacing=2,
#'   Hashwidth=2
#' )
#' 
#' Ellipse1=list(
#'   Text="Ellipse 1", 
#'   Shape="ellipse",
#'   ShpFill="white",
#'   ShpBord="darkblue",
#'   Shplwd=2,
#'   fontsize=1.2,
#'   STSpace=3,
#'   EllW=10,
#'   EllH=6,
#'   EllA=35
#' )
#' 
#' Ellipse2=list(
#'   Text="Ellipse 2", 
#'   Shape="ellipse",
#'   ShpFill="red",
#'   ShpBord="green",
#'   ShpHash=TRUE,
#'   Shplwd=2,
#'   fontsize=1.2,
#'   STSpace=3,
#'   EllW=10,
#'   EllH=7,
#'   EllA=0,
#'   Hashcol="black",
#'   Hashangle=-45,
#'   Hashspacing=1.5,
#'   Hashwidth=1.5
#' )
#' 
#' Line1=list(
#'   Text="Line 1", 
#'   Shape="line",
#'   ShpFill="black",
#'   Shplwd=5,
#'   fontsize=1.2,
#'   STSpace=3,
#'   LineL=10
#' )
#' 
#' Line2=list(
#'   Text="Line 2", 
#'   Shape="line",
#'   Shplwd=5,
#'   ShpFill="green",
#'   Shplwd=5,
#'   fontsize=1.2,
#'   STSpace=3,
#'   LineTyp=6, 
#'   LineL=10
#' )
#' 
#' Arrow1=list(
#'   Text="Arrow 1", 
#'   Shape="arrow",
#'   ShpBord="green",
#'   Shplwd=1,
#'   ArrL=10,
#'   ArrPwidth=5,
#'   ArrHlength=15, 
#'   ArrHwidth=10, 
#'   Arrcol="orange",
#'   fontsize=1.2,
#'   STSpace=3
#' )
#' 
#' Arrow2=list(
#'   Text="Arrow 2", 
#'   Shape="arrow",
#'   ShpBord=NA,
#'   ArrL=10,
#'   ArrPwidth=5,
#'   ArrHlength=15, 
#'   ArrHwidth=10, 
#'   Arrdlength=0, 
#'   Arrtype="dashed",
#'   Arrcol=c("red","green","blue"),
#'   fontsize=1.2,
#'   STSpace=3
#' )
#' 
#' Arrow3=list(
#'   Text="Arrow 3", 
#'   Shape="arrow",
#'   ShpBord=NA,
#'   ArrL=10,
#'   ArrPwidth=5,
#'   ArrHlength=15, 
#'   ArrHwidth=10, 
#'   Arrdlength=5, 
#'   Arrtype="dashed",
#'   Arrcol="darkgreen",
#'   fontsize=1.2,
#'   STSpace=3
#' )
#' 
#' Arrow4=list(
#'   Text="Arrow 4", 
#'   Shape="arrow",
#'   ShpBord="black",
#'   Shplwd=0.1,
#'   ArrL=10,
#'   ArrPwidth=5,
#'   ArrHlength=15, 
#'   ArrHwidth=10, 
#'   Arrcol="pink",
#'   ShpHash=TRUE,
#'   Hashcol="blue",
#'   Hashangle=-45,
#'   Hashspacing=1,
#'   Hashwidth=1,
#'   fontsize=1.2,
#'   STSpace=3
#' )
#' 
#' None=list(
#'   Text="None", 
#'   Shape="none",
#'   fontsize=1.2,
#'   STSpace=3,
#'   ShiftX=10
#' )
#' 
#' 
#' #Combine all items into a single list:
#' 
#' Items=list(Rectangle1,Rectangle2,Circle1,Circle2,
#' Ellipse1,Ellipse2,Line1,Line2,Arrow1,Arrow2,Arrow3,Arrow4,None)
#' 
#' #manually build a bounding box (same as st_bbox(load_ASDs())):
#' 
#' bb=st_bbox(c(xmin=-3348556,xmax=4815055,ymax=4371127,ymin=-3329339),
#'            crs = st_crs(6932))
#' bx=st_as_sfc(bb) #Convert to polygon to plot it
#' 
#' #Plot and add legend
#' 
#' plot(bx,col="grey")
#' add_Legend(bb,LegOpt,Items)
#' 
#' @export

add_Legend=function(bb,LegOpt,Items){
  
  if(inherits(bb,"bbox")==FALSE){stop("bb is not an sf bounding box, use st_bbox() to create bb.")}
  dx=as.numeric(bb['xmax']-bb['xmin']) #x scaler
  dy=as.numeric(bb['ymax']-bb['ymin']) #y scaler
  d=min(c(round(dx/200),round(dy/200)))
  
  #Set defaults
  if(is.null(LegOpt$Pos)){LegOpt$Pos="bottomright"}
  if(is.null(LegOpt$BoxW)){LegOpt$BoxW=50}
  if(is.null(LegOpt$BoxH)){LegOpt$BoxH=50}
  if(is.null(LegOpt$PosX)){LegOpt$PosX=0}
  if(is.null(LegOpt$PosY)){LegOpt$PosY=0}
  if(is.null(LegOpt$Boxexp)){LegOpt$Boxexp=c(0,0,0,0)}
  if(is.null(LegOpt$Boxbd)){LegOpt$Boxbd="white"}
  if(is.null(LegOpt$Boxlwd)){LegOpt$Boxlwd=1}
  if(is.null(LegOpt$Boxcol)){LegOpt$Boxcol="black"}
  if(is.null(LegOpt$Titlefontsize)){LegOpt$Titlefontsize=1}
  if(is.null(LegOpt$Subtitlefontsize)){LegOpt$Subtitlefontsize=1}
  if(is.null(LegOpt$TitleAdj)){LegOpt$TitleAdj=c(0,0)}
  if(is.null(LegOpt$SubtitleAdj)){LegOpt$SubtitleAdj=c(0,0)}
  
  #Get bottom-right corner of legend box
  Pos=LegOpt$Pos
  if(!Pos%in%c("bottomright","bottom","bottomleft","left","topleft","top","topright","right","center")){stop("Argument 'Pos' mis-specified in add_Legend()")}
  if(Pos=="bottomright"){
    #Get bottom-right of bounding box
    xbb=as.numeric(bb['xmax'])
    ybb=as.numeric(bb['ymin'])
    #Get bottom-right of legend box
    xbr=xbb
    ybr=ybb
    #Get other points
    #bottom-left
    xbl=xbr-LegOpt$Boxexp[2]*d-LegOpt$BoxW*d-LegOpt$Boxexp[1]*d
    ybl=ybr
    #top-left
    xtl=xbl
    ytl=ybr+LegOpt$Boxexp[3]*d+LegOpt$BoxH*d+LegOpt$Boxexp[4]*d
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="bottom"){
    #Get bottom-centre of bounding box
    xbb=as.numeric(mean(c(bb['xmax'],bb['xmin'])))
    ybb=as.numeric(bb['ymin'])
    #Get bottom-right of legend box
    xbr=xbb+LegOpt$Boxexp[2]*d+LegOpt$BoxW*d/2
    ybr=ybb
    #Get other points
    #bottom-left
    xbl=xbb-LegOpt$BoxW*d/2-LegOpt$Boxexp[1]*d
    ybl=ybb
    #top-left
    xtl=xbl
    ytl=ybr+LegOpt$Boxexp[3]*d+LegOpt$BoxH*d+LegOpt$Boxexp[4]*d
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="bottomleft"){
    #Get bottom-left of bounding box
    xbb=as.numeric(bb['xmin'])
    ybb=as.numeric(bb['ymin'])
    #Get bottom-right of legend box
    xbr=xbb+LegOpt$Boxexp[1]*d+LegOpt$Boxexp[2]*d+LegOpt$BoxW*d
    ybr=ybb
    #Get other points
    #bottom-left
    xbl=xbb
    ybl=ybb
    #top-left
    xtl=xbl
    ytl=ybr+LegOpt$Boxexp[3]*d+LegOpt$BoxH*d+LegOpt$Boxexp[4]*d
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="left"){
    #Get center-left of bounding box
    xbb=as.numeric(bb['xmin'])
    ybb=as.numeric(mean(c(bb['ymax'],bb['ymin'])))
    #Get bottom-right of legend box
    xbr=xbb+LegOpt$Boxexp[1]*d+LegOpt$Boxexp[2]*d+LegOpt$BoxW*d
    ybr=ybb-LegOpt$Boxexp[3]*d-LegOpt$BoxH*d/2
    #Get other points
    #bottom-left
    xbl=xbb
    ybl=ybr
    #top-left
    xtl=xbl
    ytl=ybr+LegOpt$Boxexp[3]*d+LegOpt$BoxH*d+LegOpt$Boxexp[4]*d
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="topleft"){
    #Get top-left of bounding box
    xbb=as.numeric(bb['xmin'])
    ybb=as.numeric(bb['ymax'])
    #Get bottom-right of legend box
    xbr=xbb+LegOpt$Boxexp[1]*d+LegOpt$Boxexp[2]*d+LegOpt$BoxW*d
    ybr=ybb-LegOpt$Boxexp[4]*d-LegOpt$Boxexp[3]*d-LegOpt$BoxH*d
    #Get other points
    #bottom-left
    xbl=xbb
    ybl=ybr
    #top-left
    xtl=xbb
    ytl=ybb
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="top"){
    #Get center-top of bounding box
    xbb=as.numeric(mean(c(bb['xmax'],bb['xmin'])))
    ybb=as.numeric(bb['ymax'])
    #Get bottom-right of legend box
    xbr=xbb+LegOpt$Boxexp[2]*d+LegOpt$BoxW*d/2
    ybr=ybb-LegOpt$Boxexp[4]*d-LegOpt$Boxexp[3]*d-LegOpt$BoxH*d
    #Get other points
    #bottom-left
    xbl=xbb-LegOpt$Boxexp[1]*d-LegOpt$BoxW*d/2
    ybl=ybr
    #top-left
    xtl=xbl
    ytl=ybb
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="topright"){
    #Get top-right of bounding box
    xbb=as.numeric(bb['xmax'])
    ybb=as.numeric(bb['ymax'])
    #Get bottom-right of legend box
    xbr=xbb
    ybr=ybb-LegOpt$Boxexp[4]*d-LegOpt$Boxexp[3]*d-LegOpt$BoxH*d
    #Get other points
    #bottom-left
    xbl=xbb-LegOpt$Boxexp[1]*d-LegOpt$BoxW*d-LegOpt$Boxexp[2]*d
    ybl=ybr
    #top-left
    xtl=xbl
    ytl=ybb
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="right"){
    #Get center-right of bounding box
    xbb=as.numeric(bb['xmax'])
    ybb=as.numeric(mean(c(bb['ymax'],bb['ymin'])))
    #Get bottom-right of legend box
    xbr=xbb
    ybr=ybb-LegOpt$Boxexp[3]*d-LegOpt$BoxH*d/2
    #Get other points
    #bottom-left
    xbl=xbb-LegOpt$Boxexp[1]*d-LegOpt$BoxW*d-LegOpt$Boxexp[2]*d
    ybl=ybr
    #top-left
    xtl=xbl
    ytl=ybb+LegOpt$Boxexp[4]*d+LegOpt$BoxH*d/2
    #top-right
    xtr=xbr
    ytr=ytl
  }
  if(Pos=="center"){
    #Get centerof bounding box
    xbb=as.numeric(mean(c(bb['xmax'],bb['xmin'])))
    ybb=as.numeric(mean(c(bb['ymax'],bb['ymin'])))
    #Get bottom-right of legend box
    xbr=xbb+LegOpt$Boxexp[2]*d+LegOpt$BoxW*d/2
    ybr=ybb-LegOpt$Boxexp[3]*d-LegOpt$BoxH*d/2
    #Get other points
    #bottom-left
    xbl=xbr-LegOpt$Boxexp[1]*d-LegOpt$BoxW*d-LegOpt$Boxexp[2]*d
    ybl=ybr
    #top-left
    xtl=xbl
    ytl=ybl+LegOpt$Boxexp[4]*d+LegOpt$BoxH*d+LegOpt$Boxexp[3]*d
    #top-right
    xtr=xbr
    ytr=ytl
  }
  
  #build box, clockwise from bottom-right
  Xs=c(xbr,xbl,xtl,xtr,xbr)+LegOpt$PosX*d
  Ys=c(ybr,ybl,ytl,ytr,ybr)+LegOpt$PosY*d
  Lbox=st_polygon(list(cbind(Xs,Ys)))
  #Plot it
  plot(Lbox,add=TRUE,col=LegOpt$Boxbd,lwd=LegOpt$Boxlwd,border=LegOpt$Boxcol,xpd=TRUE)
  
  #Get number of rows (1 per title, subtitle and item)
  Nr=0
  if(is.null(LegOpt$Title)==FALSE){Nr=Nr+1}
  if(is.null(LegOpt$Subtitle)==FALSE){Nr=Nr+1}
  Nr=Nr+length(Items)
  #Get Ys of rows
  Ys=seq(ytl-LegOpt$Boxexp[4]*d,ybl+LegOpt$Boxexp[3]*d,length.out=Nr+2)
  Ys=Ys[2:(Nr+1)]+LegOpt$PosY*d
  X=xbl+LegOpt$Boxexp[1]*d+LegOpt$PosX*d
  
  #Add title if needed and remove that Y
  if(is.null(LegOpt$Title)==FALSE){
    text(X+LegOpt$TitleAdj[1]*d,Ys[1]+LegOpt$TitleAdj[2]*d,LegOpt$Title,cex=LegOpt$Titlefontsize,adj=c(0,0.5),xpd=TRUE)
    Ys=Ys[-1]
  }
  #Add subtitle if needed and remove that Y
  if(is.null(LegOpt$Subtitle)==FALSE){
    text(X+LegOpt$SubtitleAdj[1]*d,Ys[1]+LegOpt$SubtitleAdj[2]*d,LegOpt$Subtitle,cex=LegOpt$Subtitlefontsize,adj=c(0,0.5),xpd=TRUE)
    Ys=Ys[-1]
  }
  
  #Loop over items and add them
  for(i in seq(1,length(Items))){
    item=Items[[i]]
    if(!item$Shape%in%c("rectangle","circle","ellipse","line","arrow","none")){stop(paste0("Argument 'Shape' mis-specified in add_Legend() for item ",i))}
    
    #Set defaults
    if(is.null(item$ShpFill)){item$ShpFill="white"}
    if(is.null(item$ShpBord)){item$ShpBord="black"}
    if(is.null(item$ShpHash)){item$ShpHash=FALSE}
    if(is.null(item$Shplwd)){item$Shplwd=1}
    if(is.null(item$fontsize)){item$fontsize=1}
    if(is.null(item$STSpace)){item$STSpace=0}
    if(is.null(item$ShiftX)){item$ShiftX=0}
    if(is.null(item$ShiftY)){item$ShiftY=0}
    if(is.null(item$Hashcol)){item$Hashcol="black"}
    if(is.null(item$Hashangle)){item$Hashangle=45}
    if(is.null(item$Hashspacing)){item$Hashspacing=1}
    if(is.null(item$Hashwidth)){item$Hashwidth=1}
    if(is.null(item$RectW)){item$RectW=10}
    if(is.null(item$RectH)){item$RectH=7}
    if(is.null(item$CircD)){item$CircD=10}
    if(is.null(item$EllW)){item$EllW=10}
    if(is.null(item$EllH)){item$EllH=7}
    if(is.null(item$EllA)){item$EllA=0}
    if(is.null(item$LineTyp)){item$LineTyp=1}
    if(is.null(item$LineL)){item$LineL=10}
    if(is.null(item$ArrL)){item$ArrL=10}
    if(is.null(item$ArrPwidth)){item$ArrPwidth=5}
    if(is.null(item$ArrHlength)){item$ArrHlength=15}
    if(is.null(item$ArrHwidth)){item$ArrHwidth=10}
    if(is.null(item$Arrdlength)){item$Arrdlength=0}
    if(is.null(item$Arrtype)){item$Arrtype="normal"}
    if(is.null(item$Arrcol)){item$Arrcol="white"}
    if(is.null(item$Arrtrans)){item$Arrtrans=0}

    Y=Ys[i]+item$ShiftY*d
    
    #Rectangle
    if(item$Shape=="rectangle"){
      #Build shape
      Xsh=c(X,X+item$RectW*d,X+item$RectW*d,X,X)+item$ShiftX*d
      Ysh=c(Y+item$RectH*d/2,Y+item$RectH*d/2,Y-item$RectH*d/2,Y-item$RectH*d/2,Y+item$RectH*d/2)
      sh=st_polygon(list(cbind(Xsh,Ysh)))
      plot(sh,add=TRUE,lwd=item$Shplwd,col=item$ShpFill,border=item$ShpBord,xpd=TRUE)
      #Hashed?
      if(item$ShpHash==TRUE){
        Hh=create_Hashes(pol=sh,angle=item$Hashangle,spacing=item$Hashspacing,width=item$Hashwidth)
        plot(Hh,add=TRUE,col=item$Hashcol,xpd=TRUE,border=NA)
        plot(sh,add=TRUE,lwd=item$Shplwd,border=item$ShpBord,xpd=TRUE)
      }
      #Add text
      text(X+item$RectW*d+item$STSpace*d+item$ShiftX*d,Y,item$Text,cex=item$fontsize,adj=c(0,0.5),xpd=TRUE)
    }
    
    #Circle
    if(item$Shape=="circle"){
      #Build shape
      R=item$CircD*d/2
      #Get center
      Cx=X+R+item$ShiftX*d
      Cy=Y
      #Get angles
      ang=2*pi*seq(0,1,length.out=30)
      #Get points
      Xsh=Cx+R*sin(ang)
      Ysh=Cy+R*cos(ang)
      sh=st_polygon(list(cbind(Xsh,Ysh)))
      plot(sh,add=TRUE,lwd=item$Shplwd,col=item$ShpFill,border=item$ShpBord,xpd=TRUE)
      #Hashed?
      if(item$ShpHash==TRUE){
        Hh=create_Hashes(pol=sh,angle=item$Hashangle,spacing=item$Hashspacing,width=item$Hashwidth)
        plot(Hh,add=TRUE,col=item$Hashcol,xpd=TRUE,border=NA)
        plot(sh,add=TRUE,lwd=item$Shplwd,border=item$ShpBord,xpd=TRUE)
      }
      #Add text
      text(X+item$CircD*d+item$STSpace*d+item$ShiftX*d,Y,item$Text,cex=item$fontsize,adj=c(0,0.5),xpd=TRUE)
    }
    
    #Circle
    if(item$Shape=="ellipse"){
      #Get radius
      R=item$EllW*d/2
      #Get center
      Cx=X+R+item$ShiftX*d
      Cy=Y
      #build shape
      sh=create_Ellipse(Latc=Cy,Lonc=Cx,Lmaj=item$EllW*20,Lmin=item$EllH*20,Ang=item$EllA,yx=TRUE)
      #plot shape
      plot(st_geometry(sh),add=TRUE,lwd=item$Shplwd,col=item$ShpFill,border=item$ShpBord,xpd=TRUE)
      #Hashed?
      if(item$ShpHash==TRUE){
        Hh=create_Hashes(pol=sh,angle=item$Hashangle,spacing=item$Hashspacing,width=item$Hashwidth)
        plot(Hh,add=TRUE,col=item$Hashcol,xpd=TRUE,border=NA)
        plot(st_geometry(sh),add=TRUE,lwd=item$Shplwd,border=item$ShpBord,xpd=TRUE)
      }
      #Add text
      text(X+item$EllW*d+item$STSpace*d+item$ShiftX*d,Y,item$Text,cex=item$fontsize,adj=c(0,0.5),xpd=TRUE)
    }
    
    #Line
    if(item$Shape=="line"){
      #Build shape
      Xsh=c(X,X+item$LineL*d)+item$ShiftX*d
      Ysh=c(Y,Y)
      segments(x0=Xsh[1],y0=Ysh[1],x1=Xsh[2],y1=Ysh[2],
               lwd=item$Shplwd,col=item$ShpFill,lty=item$LineTyp,lend=1,xpd=TRUE)
      #Add text
      text(X+item$LineL*d+item$STSpace*d+item$ShiftX*d,Y,item$Text,cex=item$fontsize,adj=c(0,0.5),xpd=TRUE)
    }
    
    #Arrow
    if(item$Shape=="arrow"){
      #Build shape
      Xsh=c(X,X+item$ArrL*d)+item$ShiftX*d
      Ysh=c(Y,Y)
      Input=data.frame(Y=Ysh,X=Xsh)
      Input=project_data(Input,NamesIn = c("Y","X"),inv=TRUE,append=FALSE)
      sh=create_Arrow(Input,Pwidth = item$ArrPwidth,
                      Hlength = item$ArrHlength,
                      Hwidth = item$ArrHwidth,
                      dlength = item$Arrdlength,
                      Atype = item$Arrtype,
                      Acol = item$Arrcol,
                      Atrans = item$Arrtrans)
      plot(st_geometry(sh),col=sh$col,lwd=item$Shplwd,border=item$ShpBord,xpd=TRUE,add=TRUE)
      #Hashed?
      if(item$ShpHash==TRUE){
        Hh=create_Hashes(pol=sh,angle=item$Hashangle,spacing=item$Hashspacing,width=item$Hashwidth)
        plot(Hh,add=TRUE,col=item$Hashcol,xpd=TRUE,border=NA)
        plot(st_geometry(sh),add=TRUE,lwd=item$Shplwd,border=item$ShpBord,xpd=TRUE)
      }
      #Add text
      text(X+item$ArrL*d+item$STSpace*d+item$ShiftX*d,Y,item$Text,cex=item$fontsize,adj=c(0,0.5),xpd=TRUE)
    }
    
    #None
    if(item$Shape=="none"){
      text(X+item$STSpace*d+item$ShiftX*d,Y,item$Text,cex=item$fontsize,adj=c(0,0.5),xpd=TRUE)
    }
  }
  
  
  
  
}
