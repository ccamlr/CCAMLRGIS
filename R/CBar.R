CBar=function(pos='1/1',title='Depth (m)',width=18,height=70,
              Bcuts=Depth_cuts,Bcols=Depth_cols,
              minVal=NA,maxVal=NA,fonsize=1,offset=100){
  offset=offset*1000
  #Get plot boundaries
  ls=par("usr")
  xmin=ls[1]
  xmax=ls[2]
  ymin=ls[3]
  ymax=ls[4]
  xdist=xmax-xmin
  ydist=ymax-ymin
  
  #constrain colors and breaks
  cuts=Bcuts
  if(is.na(minVal)==F){
    indx=which(cuts>=minVal)
    if(min(indx)>1){indx=c(min(indx)-1,indx)}
    cuts=cuts[indx]
  }
  if(is.na(maxVal)==F){
    indx=which(cuts<=maxVal)
    if(max(indx)<length(cuts)){indx=c(indx,max(indx+1))}
    cuts=cuts[indx]
  }
  cutsTo=Bcuts
  colsTo=Bcols
  
  if(any(is.na(c(minVal,maxVal))==F)){
    indx=match(cuts,cutsTo)
    cutsTo=cutsTo[indx]
    colsTo=colsTo[seq(min(indx),max(indx)-1)]
  }
  
  if(all(cutsTo<0)){
    cutsTo=-cutsTo
  }
  


  #Midpoint
  n=as.numeric(strsplit(pos,'/')[[1]])
  N=n[2]
  n=n[1]
  ymid=seq(ymax,ymin,length.out=2*N+1)[seq(2,n+N,by=2)[n]]

  #Overall box
  bxmin=xmax+0.005*xdist+offset
  bxmax=xmax+(width/100)*xdist+offset
  bymin=ymid-(height/200)*ydist
  bymax=ymid+(height/200)*ydist
  rect(xleft=bxmin,
       ybottom=bymin,
       xright=bxmax,
       ytop=bymax,xpd=T,lwd=1.5,col='white')
  #Col box
  cxmin=bxmin+0.01*xdist
  cxmax=bxmin+0.05*xdist
  cymin=bymin+0.02*ydist
  cymax=bymax-0.05*ydist
  Ys=seq(cymin,cymax,length.out=length(colsTo)+1)
  rect(xleft=cxmin,
       ybottom=Ys[1:(length(Ys)-1)],
       xright=cxmax,
       ytop=Ys[2:length(Ys)],xpd=T,lwd=0,col=colsTo)
  rect(xleft=cxmin,
       ybottom=cymin,
       xright=cxmax,
       ytop=cymax,xpd=T,lwd=1.5)
  #Ticks
  segments(x0=cxmax,
           y0=Ys,
           x1=cxmax+0.01*xdist,
           y1=Ys,lwd=1,xpd=T,lend=1)
  text(cxmax+0.02*xdist,Ys,
       cutsTo,adj=c(0,0.5),xpd=T,cex=fonsize)
  #Title
  text(cxmin,cymax+0.03*ydist,title,
       cex=1.2*fonsize,adj=c(0,0.5),xpd=T)
}