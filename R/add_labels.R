#' Add labels
#'
#' Adds labels to plots. Three modes are available:
#' In \code{'auto'} mode, labels are placed at the centres of polygon parts of spatial objects
#' loaded via the \code{load_} functions. Internally used in conjunction with \code{\link{Labels}}.
#' In \code{'manual'} mode, users may click on their plot to position labels. An editable label table is generated
#' to allow fine-tuning of labels appearance, and may be saved for external use. To edit the label table,
#' double-click inside one of its cells, edit the value, then close the table.
#' In \code{'input'} mode, a label table that was generated in \code{'manual'} mode is re-used.
#'
#' @param mode either \code{'auto'}, \code{'manual'} or \code{'input'}. See Description above.
#' @param layer in \code{'auto'} mode, single or vector of characters, may only be one, some or all of: 
#' \code{c("ASDs","SSRUs","RBs","SSMUs","MAs","RefAreas","MPAs","EEZs")}.
#' @param fontsize in \code{'auto'} mode, size of the text.
#' @param fonttype in \code{'auto'} mode, type of the text (1 to 4), where 1 corresponds to plain text, 
#' 2 to bold face, 3 to italic and 4 to bold italic.
#' @param angle in \code{'auto'} mode, rotation of the text in degrees.
#' @param col in \code{'auto'} mode, color of the text.
#' @param LabelTable in \code{'input'} mode, a label table that was generated in \code{'manual'} mode.
#' @return Adds labels to plot. To save a label table generated in \code{'manual'} mode, use:
#' \code{MyLabelTable=add_labels(mode='auto')}. To re-use that label table, use: 
#' \code{add_labels(mode='input',LabelTable=MyLabelTable)}.
#' 
#' @seealso 
#' @seealso \code{\link{Labels}}, \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_EEZs}},
#' \code{\link{load_RefAreas}}, \code{\link{load_MPAs}},
#' \href{http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf}{R colors}.
#'  
#' @examples
#' \donttest{
#' 
#' #Example 1: 'auto' mode
#' #label ASDs in bold and red
#' ASDs=load_ASDs()
#' plot(ASDs)
#' add_labels(mode='auto',layer='ASDs',fontsize=1,fonttype=2,col='red')
#' #add MPAs and EEZs and their labels in large, green and vertical text
#' MPAs=load_MPAs()
#' EEZs=load_EEZs()
#' plot(MPAs,add=TRUE,border='green')
#' plot(EEZs,add=TRUE,border='green')
#' add_labels(mode='auto',layer=c('EEZs','MPAs'),fontsize=2,col='green',angle=90)
#' 
#' 
#' #Example 2: 'manual' mode (you will have to do it yourself)
#' plot(SmallBathy)
#' ASDs=load_ASDs()
#' plot(ASDs,add=T)
#' MyLabels=add_labels(mode='manual')
#' 
#' 
#' #Example 3: Re-use the label table generated in Example 2
#' plot(SmallBathy)
#' plot(ASDs,add=T)
#' add_labels(mode='input',LabelTable=MyLabels)
#' 
#' 
#' 
#' }
#' 
#' @export

add_labels=function(mode=NULL,layer=NULL,fontsize=1,fonttype=1,angle=0,col='black',LabelTable=NULL){
 if(mode=='auto'){
  for(l in layer){
   text(Labels[Labels$p==l,1:2],Labels$t[Labels$p==l],cex=fontsize,font=fonttype,srt=angle,col=col)
  }
 }
  if(mode=='manual'){
    #Initialize
    P=recordPlot()
    Lab=data.frame(
      x=numeric(),
      y=numeric(),
      text=character(),
      fontsize=numeric(),
      fonttype=numeric(),
      angle=numeric(),
      col=character()
    )
    ls=par("usr")
    Gr=raster(extent(ls),nrows=100,ncols=100)
    values(Gr)=NA
    #First label
    replayPlot(P)
    message('Click on your figure to add a label\n')
    message('Then edit the label table and close it\n')
    a=click(Gr,xy=T,n=1,show=F)
    Lab=rbind(Lab,
              data.frame(
                x=a$x,
                y=a$y,
                text='NewLabel',
                fontsize=1,
                fonttype=1,
                angle=0,
                col='black',
                stringsAsFactors=F
              )
    )
    for(ang in unique(Lab$angle)){
      text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
           Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
           font=Lab$fonttype[Lab$angle==ang],srt=ang,
           col=Lab$col[Lab$angle==ang])
    }
    Lab=suppressWarnings(edit(Lab))
    replayPlot(P)
    for(ang in unique(Lab$angle)){
      text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
           Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
           font=Lab$fonttype[Lab$angle==ang],srt=ang,
           col=Lab$col[Lab$angle==ang])
    }
    #Next labels
    x=readline('Add a new label (y/n)?')
    if(x=='y'){
      while(x!='n'){
        message('Click on your figure to add a label\n')
        message('Then edit the label table and close it\n')
        a=click(Gr,xy=T,n=1,show=F)
        Lab=rbind(Lab,
                  data.frame(
                    x=a$x,
                    y=a$y,
                    text='NewLabel',
                    fontsize=1,
                    fonttype=1,
                    angle=0,
                    col='black',
                    stringsAsFactors=F
                  )
        )
        for(ang in unique(Lab$angle)){
          text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
               Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
               font=Lab$fonttype[Lab$angle==ang],srt=ang,
               col=Lab$col[Lab$angle==ang])
        }
        Lab=suppressWarnings(edit(Lab))
        replayPlot(P)
        for(ang in unique(Lab$angle)){
          text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
               Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
               font=Lab$fonttype[Lab$angle==ang],srt=ang,
               col=Lab$col[Lab$angle==ang])
        }
        x=readline('Add a new label (y/n)?')
      }
    }
    
    x=readline('Would you like to edit your label table (y/n)?')
    if(x=='y'){
      while(x!='n'){
        Lab=suppressWarnings(edit(Lab))
        replayPlot(P)
        for(ang in unique(Lab$angle)){
          text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
               Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
               font=Lab$fonttype[Lab$angle==ang],srt=ang,
               col=Lab$col[Lab$angle==ang])
        }
        x=readline('Would you like to edit your label table (y/n)?')
      }
    }
    return(Lab)
  }
  if(mode=='input'){
    Lab=LabelTable
    for(ang in unique(Lab$angle)){
      text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
           Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
           font=Lab$fonttype[Lab$angle==ang],srt=ang,
           col=Lab$col[Lab$angle==ang])
    }
  }
}