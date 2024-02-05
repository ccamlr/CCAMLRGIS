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
#' @param mode character, either \code{'auto'}, \code{'manual'} or \code{'input'}. See Description above.
#' @param layer character, in \code{'auto'} mode, single or vector of characters, may only be one, some or all of: 
#' \code{c("ASDs","SSRUs","RBs","SSMUs","MAs","MPAs","EEZs")}.
#' @param fontsize numeric, in \code{'auto'} mode, size of the text.
#' @param fonttype numeric, in \code{'auto'} mode, type of the text (1 to 4), where 1 corresponds to plain text, 
#' 2 to bold face, 3 to italic and 4 to bold italic.
#' @param angle numeric, in \code{'auto'} mode, rotation of the text in degrees.
#' @param col character, in \code{'auto'} mode, color of the text.
#' @param LabelTable in \code{'input'} mode, name of the label table that was generated in \code{'manual'} mode.
#' @return Adds labels to plot. To save a label table generated in \code{'manual'} mode, use:
#' \code{MyLabelTable=add_labels(mode='auto')}. 
#' To re-use that label table, use: 
#' \code{add_labels(mode='input',LabelTable=MyLabelTable)}.
#' 
#' @seealso \code{\link{Labels}}, \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_EEZs}},
#' \code{\link{load_MPAs}},
#' \href{http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf}{R colors}.
#'  
#' @examples
#' \donttest{
#' 
#' #Example 1: 'auto' mode
#' #label ASDs in bold and red
#' ASDs=load_ASDs()
#' plot(st_geometry(ASDs))
#' add_labels(mode='auto',layer='ASDs',fontsize=1,fonttype=2,col='red')
#' #add EEZs and their labels in large, green and vertical text
#' EEZs=load_EEZs()
#' plot(st_geometry(EEZs),add=TRUE,border='green')
#' add_labels(mode='auto',layer='EEZs',fontsize=2,col='green',angle=90)
#' 
#' 
#' #Example 2: 'manual' mode (you will have to do it yourself)
#' #Examples 2 and 3 below are commented (remove the # to test)
#' #library(terra)
#' #plot(SmallBathy())
#' #ASDs=load_ASDs()
#' #plot(st_geometry(ASDs),add=TRUE)
#' #MyLabels=add_labels(mode='manual')
#' 
#' 
#' #Example 3: Re-use the label table generated in Example 2
#' #plot(SmallBathy())
#' #plot(st_geometry(ASDs),add=TRUE)
#' #add_labels(mode='input',LabelTable=MyLabels)
#' 
#' 
#' 
#' }
#' 
#' @export

add_labels=function(mode=NULL,layer=NULL,fontsize=1,fonttype=1,angle=0,col='black',LabelTable=NULL){
 if(mode=='auto'){
  for(l in layer){
   text(Labels[Labels$p==l,1:2],Labels$t[Labels$p==l],cex=fontsize,font=fonttype,srt=angle,col=col,xpd=TRUE)
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
    Gr=terra::rast(terra::ext(ls),nrows=100,ncols=100,vals=NA)
    #First label
    replayPlot(P)
    message('Click on your figure to add a label\n')
    message('Then edit the label table and close it\n')
    a=terra::click(Gr,xy=TRUE,n=1,show=FALSE,type="n")
    Lab=rbind(Lab,
              data.frame(
                x=a$x,
                y=a$y,
                text='NewLabel',
                fontsize=1,
                fonttype=1,
                angle=0,
                col='black',
                stringsAsFactors=FALSE
              )
    )
    Lab=project_data(Input=Lab,NamesIn=c('y','x'),NamesOut=c('Latitude','Longitude'),append=TRUE,inv=TRUE)
    
    for(ang in unique(Lab$angle)){
      text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
           Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
           font=Lab$fonttype[Lab$angle==ang],srt=ang,
           col=Lab$col[Lab$angle==ang],xpd=TRUE)
    }
    Lab=suppressWarnings(edit(Lab))
    replayPlot(P)
    for(ang in unique(Lab$angle)){
      text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
           Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
           font=Lab$fonttype[Lab$angle==ang],srt=ang,
           col=Lab$col[Lab$angle==ang],xpd=TRUE)
    }
    #Next labels
    xx=menu(c('Add a new label','Edit the label table'),title = 'What would you like to do?')
    
    while(xx!=3){
 
            if(xx==1){
        message('Click on your figure to add a label\n')
        message('Then edit the label table and close it\n')
        a=terra::click(Gr,xy=TRUE,n=1,show=FALSE,type="n")
        Lab=rbind(Lab,
                       project_data(Input=data.frame(
                       x=a$x,
                       y=a$y,
                       text='NewLabel',
                       fontsize=1,
                       fonttype=1,
                       angle=0,
                       col='black',
                       stringsAsFactors=FALSE
                     ),NamesIn=c('y','x'),NamesOut=c('Latitude','Longitude'),append=TRUE,inv=TRUE)
        )
        
        
        for(ang in unique(Lab$angle)){
          text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
               Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
               font=Lab$fonttype[Lab$angle==ang],srt=ang,
               col=Lab$col[Lab$angle==ang],xpd=TRUE)
        }
        Lab=suppressWarnings(edit(Lab))
        replayPlot(P)
        for(ang in unique(Lab$angle)){
          text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
               Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
               font=Lab$fonttype[Lab$angle==ang],srt=ang,
               col=Lab$col[Lab$angle==ang],xpd=TRUE)
        }
      
    }
    
      if(xx==2){
        message('Edit the label table and close it\n')
        Lab=suppressWarnings(edit(Lab))
        replayPlot(P)
        for(ang in unique(Lab$angle)){
          text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
               Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
               font=Lab$fonttype[Lab$angle==ang],srt=ang,
               col=Lab$col[Lab$angle==ang],xpd=TRUE)
        }
      }
      xx=menu(c('Add a new label','Edit the label table','Exit'),title = 'What would you like to do?')
      
      
    }  
    return(Lab)
  }
  if(mode=='input'){
    Lab=LabelTable
    for(ang in unique(Lab$angle)){
      text(Lab$x[Lab$angle==ang],Lab$y[Lab$angle==ang],
           Lab$text[Lab$angle==ang],cex=Lab$fontsize[Lab$angle==ang],
           font=Lab$fonttype[Lab$angle==ang],srt=ang,
           col=Lab$col[Lab$angle==ang],xpd=TRUE)
    }
  }
}
