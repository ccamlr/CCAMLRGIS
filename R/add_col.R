#' Add colors
#'
#' Given an input variable, generates either a continuous color gradient or color classes.
#' To be used in conjunction with \code{\link{add_Cscale}}.
#'  
#' @param var numeric vector of the variable to be colorized. Either all values (in which case all
#' values will be assigned to a color) or only two values (in which case these are considered to be
#' the range of values).
#' @param cuts numeric, controls color classes. Either one value (in which case \code{n=cuts} equally
#' spaced color classes are generated) or a vector (in which case irregular color classes are
#' generated e.g.: \code{c(-10,0,100,2000)}).
#' @param cols character vector of colors (see R standard color names \href{http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf}{here}).
#' \code{cols} are interpolated along \code{cuts}. Color codes as those generated,
#' for example, by \code{\link[grDevices]{rgb}} may also be used.
#' @return list containing the colors for the variable \code{var} (given as \code{$varcol} in the output) as
#' well as the single \code{cols} and \code{cuts}, to be used as inputs in \code{\link{add_Cscale}}.
#'
#' @seealso 
#' \code{\link{add_Cscale}}, \code{\link{create_PolyGrids}}, \href{http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf}{R colors}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#52-adding-colors-to-data
#' 
#' MyPoints=create_Points(PointData)
#' MyCols=add_col(MyPoints$Nfishes)
#' plot(st_geometry(MyPoints),pch=21,bg=MyCols$varcol,cex=2)
#' 
#' 
#' @export

add_col=function(var,cuts=100,cols=c('green','yellow','red')){
  pal=colorRampPalette(cols)
   if(length(cuts)==1){
    cutsTo=seq(min(var,na.rm=TRUE),max(var,na.rm=TRUE),length.out=cuts)
  }else{
    cutsTo=cuts
  } 
  colsTo=pal(length(cutsTo)-1)
  if(length(unique(quantile(var,na.rm=TRUE)))==1){varcol=rep(colsTo[1],length(var))}else{
    varcol=colsTo[cut(var,cutsTo,include.lowest=TRUE,right=FALSE)]}
  return(list('cuts'=cutsTo,'cols'=colsTo,'varcol'=varcol))
}
