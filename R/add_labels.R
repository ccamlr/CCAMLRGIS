#' Add labels
#'
#' Adds labels to plots of the layers obtained via 'load_' functions. Positions correspond to the centroids
#' of polygon parts. Internally used in conjunction with \code{\link{Labels}}.
#' To manually generate your own labels, see \code{\link[rgeos]{polygonsLabel}}.
#'   
#' @param layer single or vector of characters, may only be one, some or all of: 
#' \code{c("ASDs","SSRUs","RBs","SSMUs","MAs","RefAreas","MPAs","EEZs")}.
#' @param fontsize size of the text.
#' @param fonttype type of the text (1 to 4), where 1 corresponds to plain text, 
#' 2 to bold face, 3 to italic and 4 to bold italic.
#' @param angle rotation of the text in degrees.
#' @param col color of the text.
#' @return Adds labels to plot.
#' 
#' @seealso 
#' @seealso \code{\link{Labels}}, \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_EEZs}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}}, \code{\link[rgeos]{polygonsLabel}}.
#'  
#' @examples
#' \dontrun{
#' 
#' 
#' #label ASDs in bold and red
#' 
#' ASDs=load_ASDs()
#' plot(ASDs)
#' add_labels('ASDs',fontsize=1,fonttype=2,col='red')
#' 
#' #add MPAs and EEZs and their labels in large, green and vertical text
#' MPAs=load_MPAs()
#' EEZs=load_EEZs()
#' plot(MPAs,add=TRUE,border='green')
#' plot(EEZs,add=TRUE,border='green')
#' add_labels(c('EEZs','MPAs'),fontsize=2,col='green',angle=90)
#' 
#' 
#' }
#' 
#' @export

add_labels=function(layer=NULL,fontsize=1,fonttype=1,angle=0,col='black'){
 for(l in layer){
   text(Labels[Labels$p==l,1:2],Labels$t[Labels$p==l],cex=fontsize,font=fonttype,srt=angle,col=col)
 }
}