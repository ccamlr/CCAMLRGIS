#' Assign point locations to polygons
#'
#' Given a set of polygons and a set of point locations (given in decimal degrees),
#' finds in which polygon those locations fall.
#' Finds, for example, in which ASD the given fishing locations occurred.
#' 
#' @param Input dataframe containing - at the minimum - Latitudes and Longitudes to be assigned to polygons.
#' 
#' \strong{If \code{NamesIn} is not provided, the columns in the \code{Input} must be in the following order:
#' Latitude, Longitude, Variable 1, Variable 2, ... Variable x.}.
#' 
#' @param NamesIn character vector of length 2 specifying the column names of Latitude and Longitude fields in
#' the \code{Input}. \strong{Latitudes name must be given first, e.g.:
#' 
#' \code{NamesIn=c('MyLatitudes','MyLongitudes')}}.
#' 
#' @param Polys character vector of spatial objects names (e.g., \code{Polys=c('ASDs','RBs')}).
#' 
#' \strong{Must be matching the names of the pre-loaded spatial objects (loaded via e.g., \code{ASDs=load_ASDs()})}
#' 
#' @param AreaNameFormat dependent on the polygons loaded. For the Secretariat's spatial objects loaded via 'load_' functions,
#' we have the following:
#' 
#' \code{'GAR_Name'} e.g., \code{'Subarea 88.2'}
#' 
#' \code{'GAR_Short_Label'} e.g., \code{'882'}
#' 
#' \code{'GAR_Long_Label'} (default) e.g., \code{'88.2'}
#' 
#' Several values may be entered if desired (if several \code{Polys} are used), e.g.:
#' 
#' \code{c('GAR_Short_Label','GAR_Name')}, in which case \code{AreaNameFormat} must be given in the same order as \code{Polys}.
#' 
#' @param Buffer distance in nautical miles to be added around the \code{Polys} of interest.
#' Can be specified for each of the spatial objects named in \code{Polys} (e.g., \code{Buffer=c(2,5)}). Useful to determine whether locations are within
#' \code{Buffer} nautical miles of a polygon.
#' @param NamesOut names of the resulting area columns in the output dataframe,
#' with order matching that of \code{Polys} (e.g., \code{NamesOut=c('Recapture_ASD','Recapture_RB')}).
#' If not provided will be set as equal to \code{Polys}.
#' @return dataframe with the same structure as the \code{Input}, with additional columns corresponding
#' to the \code{Polys} used and named after \code{NamesOut}.
#'
#' @seealso 
#' \code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
#' \code{\link{load_SSMUs}}, \code{\link{load_MAs}},
#' \code{\link{load_MPAs}}, \code{\link{load_EEZs}}.
#' 
#' @examples
#' \donttest{
#' 
#'
#' #Generate a dataframe
#' MyData=data.frame(Lat=runif(100,min=-65,max=-50),
#'                   Lon=runif(100,min=20,max=40))
#' 
#' #Assign ASDs and SSRUs to these locations (first load ASDs and SSRUs)
#' ASDs=load_ASDs()
#' SSRUs=load_SSRUs()
#' 
#' MyData=assign_areas(Input=MyData,Polys=c('ASDs','SSRUs'),NamesOut=c('MyASDs','MySSRUs'))
#' 
#' #View(MyData)
#' table(MyData$MyASDs) #count of locations per ASD
#' table(MyData$MySSRUs) #count of locations per SSRU
#' 
#' }
#' 
#' @export

assign_areas=function(Input,Polys,AreaNameFormat='GAR_Long_Label',Buffer=0,NamesOut=NULL,NamesIn=NULL){
  #Ensure Input is a data.frame
  Input=as.data.frame(Input)
  #Check NamesIn
  if(is.null(NamesIn)==F){
    if(length(NamesIn)!=2){stop("'NamesIn' should be a character vector of length 2")}
    if(any(NamesIn%in%colnames(Input)==F)){stop("'NamesIn' do not match column names in 'Input'")}
  }
  #Set NamesOut if not provided
  if(is.null(NamesOut)==TRUE){NamesOut=Polys}
  if(any(NamesOut%in%colnames(Input)==T)){stop("'NamesOut' matches column names in 'Input', please use different names")}
  #Repeat Buffer if needed
  if(length(Buffer)==1 & length(Polys)>1){Buffer=rep(Buffer,length(Polys))}
  #Repeat AreaNameFormat if needed
  if(length(AreaNameFormat)==1 & length(Polys)>1){AreaNameFormat=rep(AreaNameFormat,length(Polys))}
  #Get locations
  if(is.null(NamesIn)==T){
  Locs=Input[,c(2,1)]
  }else{
  Locs=Input[,NamesIn[c(2,1)]]  
  }
  #Count missing locations to warn user
  Missing=which(is.na(Locs[,1])==TRUE | is.na(Locs[,2])==TRUE)
  if(length(Missing)>1){
    warning(paste0(length(Missing),' records are missing location and will not be assigned to any area\n'))
  }
  if(length(Missing)==1){
    warning('One record is missing location and will not be assigned to any area\n')
  }
  #Count impossible locations to warn user and replace with NAs
  Impossible=which(Locs[,1]>180 | Locs[,1]<(-180) | Locs[,2]>90 | Locs[,2]<(-90))
  if(length(Impossible)>1){
    warning(paste0(length(Impossible),' records are not on Earth and will not be assigned to any area\n'))
    Locs[Impossible,]=NA
  }
  if(length(Impossible)==1){
    warning('One record is not on Earth and will not be assigned to any area\n')
    Locs[Impossible,]=NA
  }
  #Create a code to match back to the dataframe at the end
  Locs$Code=paste0(Locs[,1],'|',Locs[,2])
  #Get uniques
  Locu=unique(Locs)
  #Remove missing locations
  Locu=Locu[is.na(Locu[,1])==FALSE & is.na(Locu[,2])==FALSE,]
  #Turn uniques into Spatial data
  SPls=SpatialPoints(cbind(Locu[,1],Locu[,2]),proj4string = CRS("+init=epsg:4326"))
  #Project to match Polys projection
  SPls=spTransform(SPls,CRS("+init=epsg:6932"))
  #Initialize a dataframe which will collate assigned Polys
  Assigned_Areas=data.frame(matrix(NA,nrow=dim(Locu)[1],ncol=length(Polys),dimnames=list(NULL,NamesOut)))
  #loop over Polys to assign them to locations
  for(i in seq(1,length(Polys))){
    #Get each Area sequentially
    tmpArea=get(Polys[i])
    #Add buffer to Area if desired
    if(Buffer[i]>0){
        tmpArea=gBuffer(tmpArea,width=Buffer[i]*1852,byid=TRUE)
    }
    #Match points to polygons
    match=over(SPls,tmpArea)
    #Store results (an Area name per unique location)
    Assigned_Areas[,NamesOut[i]]=as.character(match[,AreaNameFormat[i]])
  }
  #Add new, empty columns to input dataframe to store results
  Input=cbind(Input,data.frame(matrix(NA,nrow=dim(Input)[1],ncol=length(Polys),dimnames=list(NULL,NamesOut))))
  #Create a temporary code to match unique locations back to input dataframe
  if(is.null(NamesIn)==T){
  tmp=paste0(Input[,2],'|',Input[,1])
  }else{
  tmp=paste0(Input[,NamesIn[2]],'|',Input[,NamesIn[1]])  
  }
  #Match assigned areas to input dataframe
  match=match(tmp,Locu$Code)
  for(i in seq(1,length(Polys))){
    Input[,NamesOut[i]]=Assigned_Areas[match,NamesOut[i]]
  }
  return(Input)
}