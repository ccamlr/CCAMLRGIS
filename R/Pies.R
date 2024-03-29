#' Create Pies
#'
#' Generates pie charts that can be overlaid on maps. The \code{Input} data must be a dataframe with, at least,
#' columns for latitude, longitude, class and value. For each location, a pie is created with pieces for each class,
#' and the size of each piece depends on the proportion of each class (the value of each class divided by the sum of values).
#' Optionally, the area of each pie can be proportional to a chosen variable (if that variable is different than the 
#' value mentioned above, the \code{Input} data must have a fifth column and that variable must be unique to each location).
#' If the \code{Input} data contains locations that are too close together, the data can be gridded by setting \code{GridKm}.
#' Once pie charts have been created, the function \link{add_PieLegend} may be used to add a legend to the figure.
#'
#' @param Input input dataframe.
#' 
#' @param NamesIn character vector of length 4 specifying the column names of Latitude, Longitude,
#' Class and value fields in the \code{Input}.
#' 
#' Names must be given in that order, e.g.:
#' 
#' \code{NamesIn=c('Latitude','Longitude','Class','Value')}.
#' 
#' @param Classes character, optional vector of classes to be displayed. If this excludes classes that are in the \code{Input},
#' those excluded classes will be pooled in a 'Other' class.
#' 
#' @param cols character, vector of two or more color names to colorize pie pieces.
#' 
#' @param Size numeric, value controlling the size of pies.
#' 
#' @param SizeVar numeric, optional, name of the field in the \code{Input} that should be used to scale the area of pies.
#' Must be unique to locations in the input.
#' 
#' @param GridKm numeric, optional, cell size of the grid in kilometers. If provided, locations are pooled by grid
#' cell and values are summed for each class.
#'  
#' @param Other numeric, optional, percentage threshold below which classes are pooled in a 'Other' class.
#' 
#' @param Othercol character, optional, color of the pie piece for the 'Other' class.
#' 
#' @return Spatial object in your environment, ready to be plotted.
#'
#' @seealso 
#' \code{\link{add_PieLegend}}, \code{\link{PieData}}, \code{\link{PieData2}}.
#' 
#' @examples
#'  
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#23-create-pies
#'   
#' #Pies of constant size, all classes displayed:
#' #Create pies
#' MyPies=create_Pies(Input=PieData,NamesIn=c("Lat","Lon","Sp","N"),Size=50)
#' #Plot Pies
#' plot(st_geometry(MyPies),col=MyPies$col)
#' #Add Pies legend
#' add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1,Boxexp=c(0.5,0.45,0.12,0.45),
#'              PieTitle="Species")
#'
#' 
#' 
#' @export

create_Pies=function(Input,NamesIn=NULL,Classes=NULL,cols=c("green","red"),Size=50,SizeVar=NULL,GridKm=NULL,Other=0,Othercol="grey"){
  Input = as.data.frame(Input)
  
  if (is.null(NamesIn) == FALSE) {
    if (length(NamesIn) != 4) {
      stop("'NamesIn' should be a character vector of length 4")
    }
    if (any(NamesIn %in% colnames(Input) == FALSE)) {
      stop("'NamesIn' do not match column names in 'Input'")
    }
  }else{
    stop("'NamesIn' not specified")
  }
  
  if(is.null(SizeVar)==FALSE){
    if(SizeVar%in%colnames(Input)==FALSE){
      stop("'SizeVar' does not match any column name in 'Input'")
    }else{
      NamesIn=unique(c(NamesIn,SizeVar))
    }
  }
  
  D=Input[,NamesIn]
  if(length(NamesIn)==4){
    colnames(D)=c("Lat","Lon","Cl","N")
  }else{
    colnames(D)=c("Lat","Lon","Cl","N","SizeVar")  
    Chck=dplyr::summarise(group_by(D,Lat,Lon),
                          n=length(unique(SizeVar)),
                          Svar=unique(SizeVar)[1],.groups = 'drop')
    if(max(Chck$n)!=1){
      stop("Some location(s) have more than one 'SizeVar'")
    }
  }
  
  if(is.null(Classes)==TRUE){
    Classes=sort(unique(D$Cl))
  }else{
    ClassesInData=sort(unique(D$Cl))
    if(all(ClassesInData%in%Classes)==FALSE){ #Chosen classes are excluding 1 or more classes that are in the data
      ExclCl=ClassesInData[!ClassesInData%in%Classes] #Classes to exclude
      D$Cl[D$Cl%in%ExclCl]="Other"
    }
  }
  
  if(is.null(GridKm)==FALSE){
    Gr=GridKm*1000
    Locs=project_data(D,NamesIn = c("Lat","Lon"),append = TRUE)
    #X
    Cl=seq(Gr*floor((min(Locs$X)-Gr)/Gr),Gr*ceiling((max(Locs$X)+Gr)/Gr),by=Gr)
    Locs$Xc=Cl[cut(Locs$X,Cl,include.lowest=TRUE,right=FALSE)]+Gr/2
    #Y
    Cl=seq(Gr*floor((min(Locs$Y)-Gr)/Gr),Gr*ceiling((max(Locs$Y)+Gr)/Gr),by=Gr)
    Locs$Yc=Cl[cut(Locs$Y,Cl,include.lowest=TRUE,right=FALSE)]+Gr/2
    Locs=project_data(Locs,NamesIn = c("Yc","Xc"),inv=TRUE)
    D$Lat=Locs$Latitude
    D$Lon=Locs$Longitude
    
    
    if(ncol(D)==4){
      D=dplyr::summarise(group_by(D,Lat,Lon,Cl),N=sum(N,na.rm=TRUE),.groups = 'drop')
      D=as.data.frame(D)
    }
    if(ncol(D)==5){
      #Append gridded Lat/Lon to Chck (contains SizeVar per unique locations)
      Locs=Locs%>%dplyr::select(Lat,Lon,Latitude,Longitude)%>%distinct()
      Chck=dplyr::left_join(Chck,Locs,by = c("Lat", "Lon"))
      #Summarize per location
      D=dplyr::summarise(group_by(D,Lat,Lon,Cl),N=sum(N,na.rm=TRUE),.groups = 'drop')
      Svar=dplyr::summarise(group_by(Chck,Lat=Latitude,Lon=Longitude),SizeVar=sum(Svar,na.rm = TRUE),.groups = 'drop')
      D=dplyr::left_join(D,Svar,by = c("Lat", "Lon"))
      D=as.data.frame(D)
    }
  }
  
  #Compute sum(N) and append to D
  C=dplyr::summarise(group_by(D,Lat,Lon),Tot=sum(N,na.rm=TRUE),.groups = 'drop')
  C$ID=seq(1,nrow(C))
  D=dplyr::left_join(D,C, by = c("Lat", "Lon"))
  if(is.null(SizeVar)==FALSE){
    if(SizeVar==NamesIn[4]){
      D$SizeVar=D$Tot
    }
  }
  
  #Compute proportions
  D$p=D$N/D$Tot
  if(Other>0){
    D$Cl[100*D$p<Other]="Other"
  }
  
  #Re-group if some Cl have become 'Other'
  if(is.null(SizeVar)==FALSE){
    D=dplyr::summarise(group_by(D,ID,Lat,Lon,Cl),
                       N=sum(N,na.rm=TRUE),SizeVar=unique(SizeVar),
                       Tot=unique(Tot),p=sum(p,na.rm=TRUE),.groups = 'drop')
  }else{
    D=dplyr::summarise(group_by(D,ID,Lat,Lon,Cl),
                       N=sum(N,na.rm=TRUE),
                       Tot=unique(Tot),p=sum(p,na.rm=TRUE),.groups = 'drop')
    
  }
  D=as.data.frame(D)
  
  pal=colorRampPalette(cols)
  cols=pal(length(Classes))
  
  if("Other"%in%D$Cl & "Other"%in%Classes==F){
    Classes=c(Classes,"Other")
    cols=c(cols,colorRampPalette(Othercol)(1))
  }
  
  D$col=cols[match(D$Cl,Classes)]
  D=project_data(D,NamesIn = c("Lat","Lon")) #Project locations
  
  D$Area=Size*1e10
  if(is.null(SizeVar)==FALSE){
    D$Area=D$Area*D$SizeVar/mean(unique(D$SizeVar))
  }
  
  D$R=sqrt(D$Area/pi)
  D$PolID=seq(1,nrow(D))
  D$LegT=NA
  D$Leg=NA
  D$LegT[1]="Classes"
  D$Leg[1]=paste0(Classes,collapse = ";")
  D$LegT[2]="cols"
  D$Leg[2]=paste0(cols,collapse = ";")
  
  Pl=list()
  #Loop over pies
  for(i in unique(D$ID)){
    dat=D[D$ID==i,]
    #Order according to classes
    dat=dat[order(match(dat$Cl,Classes)),]
    #Get center
    Cx=dat$X[1]
    Cy=dat$Y[1]
    #Convert values to angles
    dat$ang=2*pi*dat$p
    #Get starts and ends
    As=c(0,cumsum(dat$ang)) #angles
    Starts=As[seq(1,length(As)-1)]
    Ends=As[seq(2,length(As))]
    R=dat$R[1]
    for(j in seq(1,dim(dat)[1])){
      PolID=dat$PolID[j]
      A=c(Starts[j],Ends[j]) #angles
      if(diff(A)>0.1){A=sort(unique(c(A,seq(A[1],A[2],by=0.1))))} #Densify
      X=c(Cx,Cx+R*sin(A),Cx)
      Y=c(Cy,Cy+R*cos(A),Cy)
      if(dat$p[j]==1){
        A=c(A,0)
        X=Cx+R*sin(A)
        Y=Cy+R*cos(A)
      }
      Pl[[PolID]]=st_polygon(list(cbind(X,Y)))
    }
  }
  Pols=st_sfc(Pl, crs = 6932)
  Pols=st_set_geometry(D,Pols)
  #Re-order polys if needed
  if(length(unique(Pols$R))>1){
    Pols=Pols[order(Pols$R,decreasing = TRUE),]
  }
  return(Pols)
}


#' Add a legend to Pies
#'
#' Adds a legend to pies created using \link{create_Pies}.
#'
#' @param Pies Spatial object created using \link{create_Pies}.
#' 
#' @param bb Spatial object, sf bounding box created with \code{st_bbox()}. If provided,
#' the legend will be centered in that bb. Otherwise it is centered on the \code{min(Latitudes)}
#' and \code{median(Longitudes)} of coordinates found in the input \code{Pies}.
#' 
#' @param PosX numeric, horizontal adjustment of legend.
#' 
#' @param PosY numeric, vertical adjustment of legend.
#' 
#' @param Size numeric, controls the size of pies.
#' 
#' @param lwd numeric, line thickness of pies.
#' 
#' @param Boxexp numeric, vector of length 4 controls the expansion of the legend box, given
#' as \code{c(xmin,xmax,ymin,ymax)}.
#' 
#' @param Boxbd character, color of the background of the legend box.
#' 
#' @param Boxlwd numeric, line thickness of the legend box. Set to zero if no box is desired.
#'  
#' @param Labexp numeric, controls the distance of the pie labels to the center of the pie.
#' 
#' @param fontsize numeric, size of the legend font.
#' 
#' @param LegSp numeric, spacing between the pie and the size chart (only used if \code{SizeVar}
#'  was specified in \link{create_Pies}).
#' 
#' @param Horiz logical. Set to FALSE for vertical layout (only used if \code{SizeVar}
#'  was specified in \link{create_Pies}).
#' 
#' @param PieTitle character, title of the pie chart.
#' 
#' @param SizeTitle character, title of the size chart (only used if \code{SizeVar}
#'  was specified in \link{create_Pies}).
#' 
#' @param PieTitleVadj numeric, vertical adjustment of the title of the pie chart.
#' 
#' @param SizeTitleVadj numeric, vertical adjustment of the title of the size chart (only used if \code{SizeVar}
#'  was specified in \link{create_Pies}).
#' 
#' @param nSizes integer, number of size classes to display in the size chart. Minimum and maximum sizes are
#' displayed by default. (only used if \code{SizeVar} was specified in \link{create_Pies}).
#' 
#' @param SizeClasses numeric, vector (e.g. c(1,10,100)) of size classes to display in the size chart
#' (only used if \code{SizeVar} was specified in \link{create_Pies}). If set, overrides \code{nSizes}.
#' 
#' @return Adds a legend to a pre-existing pie plot.
#'
#' @seealso 
#' \code{\link{create_Pies}}, \code{\link{PieData}}, \code{\link{PieData2}}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#23-create-pies
#' 
#' #Pies of constant size, all classes displayed:
#' #Create pies
#' MyPies=create_Pies(Input=PieData,
#'                    NamesIn=c("Lat","Lon","Sp","N"),
#'                    Size=50
#'                    )
#' #Plot Pies
#' plot(st_geometry(MyPies),col=MyPies$col)
#' #Add Pies legend
#' add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1,Boxexp=c(0.5,0.45,0.12,0.45),
#'              PieTitle="Species")
#'
#'
#' 
#' @export

add_PieLegend=function(Pies=NULL,bb=NULL,PosX=0,PosY=0,Size=25,lwd=1,Boxexp=c(0.2,0.2,0.12,0.3), #xmin,xmax,ymin,ymax
                       Boxbd='white',Boxlwd=1,Labexp=0.3,fontsize=1,LegSp=0.5,Horiz=TRUE,
                       PieTitle="Pie chart",SizeTitle="Size chart",
                       PieTitleVadj=0.5,SizeTitleVadj=0.3,nSizes=3,SizeClasses=NULL){
  
  if(class(Pies)[1]!="sf"){
    stop("'Pies' must be generated using create_Pies()")
  }
  if("LegT"%in%colnames(Pies)==FALSE){
    stop("'Pies' must be generated using create_Pies()")
  }
  if(is.null(PosX)==TRUE){
    stop("Argument 'PosX' is missing")
  }
  if(is.null(PosY)==TRUE){
    stop("Argument 'PosY' is missing")
  }
  if(is.null(SizeClasses) & is.null(nSizes)){
    stop("'SizeClasses' and 'nSizes' cannot be both NULL")
  }
  if(is.null(SizeClasses)==FALSE & is.null(nSizes)==FALSE){
    nSizes=NULL
  }
  
  Pdata=st_drop_geometry(Pies)
  Classes=Pdata$Leg[which(Pdata$LegT=="Classes")]
  cols=Pdata$Leg[which(Pdata$LegT=="cols")]
  Classes=strsplit(Classes,";")[[1]]
  cols=strsplit(cols,";")[[1]]
  dat=data.frame(Cl=Classes,col=cols)
  
  if(is.null(bb)){
  Lat=min(Pdata$Lat)
  Lon=median(Pdata$Lon)
  }else{
    if(inherits(bb,"bbox")==FALSE){stop("bb is not an sf bounding box, use st_bbox() to create bb.")}
  Lat=mean(bb[c('ymin','ymax')])
  Lon=mean(bb[c('xmin','xmax')])
  Lat=project_data(data.frame(La=Lat,Lo=Lon),NamesIn=c("La","Lo"),inv=TRUE,append=FALSE)
  Lon=Lat$Longitude
  Lat=Lat$Latitude
  }
  
  if(length(unique(Pdata$R))==1){ #No SizeVar
    dat$Lat=Lat
    dat$Lon=Lon
    dat=project_data(dat,NamesIn = c("Lat","Lon")) #Project locations
    dat$X=dat$X+PosX*1e6
    dat$Y=dat$Y+PosY*1e6
    dat$p=1/nrow(dat)
    dat$PolID=seq(1,nrow(dat))
    dat$LabA=NA
    dat$Labx=NA
    dat$Laby=NA
    
    #Build pie
    Area=Size*1e10
    R=sqrt(Area/pi)
    
    Pl=list()
    #Get center
    Cx=dat$X[1]
    Cy=dat$Y[1]
    #Convert values to angles
    dat$ang=2*pi*dat$p
    #Get starts and ends
    As=c(0,cumsum(dat$ang)) #angles
    Starts=As[seq(1,length(As)-1)]
    Ends=As[seq(2,length(As))]
    for(j in seq(1,dim(dat)[1])){
      PolID=dat$PolID[j]
      A=c(Starts[j],Ends[j]) #angles
      dat$LabA[j]=mean(A)
      dat$Labx[j]=Cx+(R+R*Labexp)*sin(dat$LabA[j])
      dat$Laby[j]=Cy+(R+R*Labexp)*cos(dat$LabA[j])
      if(diff(A)>0.1){A=sort(unique(c(A,seq(A[1],A[2],by=0.1))))} #Densify
      X=c(Cx,Cx+R*sin(A),Cx)
      Y=c(Cy,Cy+R*cos(A),Cy)
      Pl[[PolID]]=st_polygon(list(cbind(X,Y)))
    }
    Pols=st_sfc(Pl, crs = 6932)
    Pols=st_set_geometry(dat,Pols)
    
    PieTitlex=Cx
    PieTitley=Cy+(R+R*PieTitleVadj)
    
    dat$Ladjx=0
    dat$Ladjx[dat$LabA==0]=0.5
    dat$Ladjx[dat$LabA==pi]=0.5
    dat$Ladjx[dat$LabA>pi & dat$LabA<2*pi]=1
    
    if(is.null(Boxexp)==FALSE){
      bb=st_bbox(Pols)
      Xmin=bb['xmin']
      Ymin=bb['ymin']
      Xmax=bb['xmax']
      Ymax=bb['ymax']
      
      dX=abs(Xmax-Xmin)
      dY=abs(Ymax-Ymin)
      
      Xmin=min(c(Xmin,dat$Labx))
      Ymin=min(c(Ymin,dat$Laby))
      Xmax=max(c(Xmax,dat$Labx))
      Ymax=max(c(Ymax,dat$Laby))
      
      Xmin=Xmin-Boxexp[1]*dX
      Xmax=Xmax+Boxexp[2]*dX
      Ymin=Ymin-Boxexp[3]*dY
      Ymax=Ymax+Boxexp[4]*dY
      
      X=c(Xmin,Xmin,Xmax,Xmax,Xmin)
      Y=c(Ymin,Ymax,Ymax,Ymin,Ymin)
      
      if(Boxlwd>0){
        Bpol=st_sfc(st_polygon(list(cbind(X,Y))), crs = 6932)
        plot(st_geometry(Bpol),col=Boxbd,lwd=Boxlwd,add=TRUE,xpd=TRUE)
      }
    }
    for(i in seq(1,nrow(dat))){
      text(dat$Labx[i],dat$Laby[i],dat$Cl[i],adj=c(dat$Ladjx[i],0.5),xpd=TRUE,cex=fontsize)
    }
    plot(st_geometry(Pols),col=Pols$col,add=TRUE,xpd=TRUE,lwd=lwd) 
    text(PieTitlex,PieTitley,PieTitle,adj=c(0.5,0),cex=fontsize*1.2,xpd=TRUE)
    
  }else{ #With SizeVar
    #Get centers
    Cen=project_data(data.frame(Lat=Lat,Lon=Lon),NamesIn = c("Lat","Lon"))
    if(Horiz==TRUE){
      dX=LegSp*1000000
      PieX=Cen$X-dX+PosX*1e6
      SvarX=Cen$X+dX+PosX*1e6
      PieY=Cen$Y+PosY*1e6
      SvarY=Cen$Y+PosY*1e6
    }else{
      dY=LegSp*1000000
      PieX=Cen$X+PosX*1e6
      SvarX=Cen$X+PosX*1e6
      PieY=Cen$Y+dY+PosY*1e6
      SvarY=Cen$Y-dY+PosY*1e6
    }
    #Do pie
    dat$p=1/nrow(dat)
    dat$PolID=seq(1,nrow(dat))
    dat$LabA=NA
    dat$Labx=NA
    dat$Laby=NA
    
    #Build pie
    Area=Size*1e10
    R=sqrt(Area/pi)
    
    Pl=list()
    #Get center
    Cx=PieX
    Cy=PieY
    #Convert values to angles
    dat$ang=2*pi*dat$p
    #Get starts and ends
    As=c(0,cumsum(dat$ang)) #angles
    Starts=As[seq(1,length(As)-1)]
    Ends=As[seq(2,length(As))]
    for(j in seq(1,dim(dat)[1])){
      PolID=dat$PolID[j]
      A=c(Starts[j],Ends[j]) #angles
      dat$LabA[j]=mean(A)
      dat$Labx[j]=Cx+(R+R*Labexp)*sin(dat$LabA[j])
      dat$Laby[j]=Cy+(R+R*Labexp)*cos(dat$LabA[j])
      if(diff(A)>0.1){A=sort(unique(c(A,seq(A[1],A[2],by=0.1))))} #Densify
      X=c(Cx,Cx+R*sin(A),Cx)
      Y=c(Cy,Cy+R*cos(A),Cy)
      Pl[[PolID]]=st_polygon(list(cbind(X,Y)))
    }
    Pols=st_sfc(Pl, crs = 6932)
    Pols=st_set_geometry(dat,Pols)
    
    PieTitlex=Cx
    PieTitley=Cy+(R+R*PieTitleVadj)
    
    dat$Ladjx=0
    dat$Ladjx[dat$LabA==0]=0.5
    dat$Ladjx[dat$LabA==pi]=0.5
    dat$Ladjx[dat$LabA>pi & dat$LabA<2*pi]=1
    
    #Do Svar
    if(is.null(nSizes)==FALSE){
      if(nSizes==1){nSizes=2}
      Svars=seq(min(Pdata$SizeVar),max(Pdata$SizeVar),length.out=nSizes)
    }
    if(is.null(SizeClasses)==FALSE){
      Svars=SizeClasses
    }
    
    Svars=sort(Svars,decreasing = TRUE)
    Ssize=Pdata$Area[1]/(1e10*Pdata$SizeVar[1]/mean(unique(Pdata$SizeVar))) #Get back to Size
    Rs=sqrt((Ssize* 1e10* Svars / mean(unique(Pdata$SizeVar)) )/pi)
    
    Sdat=data.frame(ID=seq(1,length(Svars)),vals=Svars,R=Rs,X=SvarX,Y=SvarY,Xs=NA,Xe=NA,Ys=NA,Ye=NA,row.names=NULL)
    
    Pl=list()
    for(j in seq(1,dim(Sdat)[1])){
      PolID=Sdat$ID[j]
      A=c(seq(0,2*pi,length.out=50),0) #angles
      X=SvarX+Sdat$R[j]*sin(A)
      Y=SvarY+Sdat$R[j]*cos(A)
      Pl[[PolID]]=st_polygon(list(cbind(X,Y)))
      Sdat$Xs[j]=X[1]
      Sdat$Ys[j]=Y[1]
      Sdat$Xe[j]=SvarX+Sdat$R[1]+(Sdat$R[1]-Sdat$R[2])/10
      Sdat$Ye[j]=Y[1]
    }
    Polsvar=st_sfc(Pl, crs = 6932)
    Polsvar=st_set_geometry(Sdat,Polsvar)
    
    SizeTitlex=SvarX
    SizeTitley=SvarY+(Sdat$R[1]+Sdat$R[1]*SizeTitleVadj)
    
    #Do box
    if(is.null(Boxexp)==FALSE){
      bb=st_bbox(Polsvar)
      Xmin=bb['xmin']
      Ymin=bb['ymin']
      Xmax=bb['xmax']
      Ymax=bb['ymax']
      
      Xmin=min(c(Xmin,dat$Labx))
      Ymin=min(c(Ymin,dat$Laby))
      Xmax=max(c(Xmax,dat$Labx,Sdat$Xe))
      Ymax=max(c(Ymax,dat$Laby))
      
      dX=abs(Xmax-Xmin)
      dY=abs(Ymax-Ymin)
      
      Xmin=Xmin-Boxexp[1]*dX
      Xmax=Xmax+Boxexp[2]*dX
      Ymin=Ymin-Boxexp[3]*dY
      Ymax=Ymax+Boxexp[4]*dY
      
      X=c(Xmin,Xmin,Xmax,Xmax,Xmin)
      Y=c(Ymin,Ymax,Ymax,Ymin,Ymin)
      
      if(Boxlwd>0){
        Bpol=st_sfc(st_polygon(list(cbind(X,Y))), crs = 6932)
        plot(st_geometry(Bpol),col=Boxbd,lwd=Boxlwd,add=TRUE,xpd=TRUE)
      }
    }
    #Plot Pols
    plot(st_geometry(Pols),col=Pols$col,add=TRUE,xpd=TRUE,lwd=lwd) 
    plot(st_geometry(Polsvar),add=TRUE,xpd=TRUE,col='white',lwd=lwd)
    
    #Add Pie labels
    for(i in seq(1,nrow(dat))){
      text(dat$Labx[i],dat$Laby[i],dat$Cl[i],adj=c(dat$Ladjx[i],0.5),xpd=TRUE,cex=fontsize)
    }
    #add Svar labels
    segments(x0=Polsvar$Xs,y0=Polsvar$Ys,x1=Polsvar$Xe,y1=Polsvar$Ye,xpd=TRUE,lwd=lwd)
    text(Polsvar$Xe,Polsvar$Ye,Polsvar$vals,adj=c(-0.1,0.5),xpd=TRUE,cex=fontsize)
    
    text(PieTitlex,PieTitley,PieTitle,adj=c(0.5,0),xpd=TRUE,cex=fontsize*1.2)
    text(SizeTitlex,SizeTitley,SizeTitle,adj=c(0.5,0),xpd=TRUE,cex=fontsize*1.2)
    
  }
}
