#' Generate contour polygons from raster
#'
#' From an input raster and chosen cuts (classes), turns areas between contours into polygons.
#' An input polygon may optionally be given to constrain boundaries.
#' The accuracy is dependent on the resolution of the raster
#' (e.g., see \code{\link{load_Bathy}} to get high resolution bathymetry).
#'  
#' @param Poly optional, single polygon inside which contour polygons will be generated.
#' May be created using \code{\link{create_Polys}} or by subsetting an object obtained
#' using one of the \code{load_} functions.
#' 
#' @param Rast raster with the appropriate projection, such as
#' \code{\link[CCAMLRGIS:SmallBathy]{SmallBathy}}.
#' It is recommended to use a raster of higher resolution (see \code{\link{load_Bathy}}).
#' 
#' @param Cuts numeric, vector of desired contours. For example,
#' \code{Cuts=c(-2000,-1000,-500)}.
#' 
#' @param Cols character, vector of desired colors (see \code{\link{add_col}}).
#' 
#' @param Grp logical (TRUE/FALSE), if set to TRUE (slower), contour polygons that touch each other are
#' identified and grouped (a Grp column is added to the object). This can be used, for example, to
#' identify seamounts that are constituted of several isobaths.
#' 
#' @return Spatial object in your environment. Data within the resulting object contains
#' a polygon in each row. Columns are as follows: \code{ID} is a unique polygon identifier;
#' \code{Iso} is a contour polygon identifier; \code{Min} and \code{Max} are the range of contour values;
#' \code{c} is the color of each contour polygon; if \code{Grp} was set to TRUE, additional columns are:
#' \code{Grp} is a group identifier (e.g., a seamount constituted of several isobaths); 
#' \code{AreaKm2} is the polygon area in square kilometers; \code{Labx} and \code{Laby} can be used
#' to label groups (see GitHub example).
#' 
#' @seealso 
#' \code{\link{load_Bathy}}, \code{\link{create_Polys}}, \code{\link{get_depths}}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#46-get_iso_polys
#' 
#' Poly=create_Polys(Input=data.frame(ID=1,Lat=c(-55,-55,-61,-61),Lon=c(-30,-25,-25,-30)))
#' IsoPols=get_iso_polys(Rast=SmallBathy(),Poly=Poly,Cuts=seq(-8000,0,length.out=10),Cols=rainbow(9))
#' 
#' plot(st_geometry(Poly))
#' plot(st_geometry(IsoPols),col=IsoPols$c,add=TRUE) 
#' 
#'
#' @export

get_iso_polys=function(Rast,Poly=NULL,Cuts,Cols=c("green","yellow","red"),Grp=FALSE){
  
  if(is.null(Poly)==FALSE){
    Rast=terra::crop(Rast,Poly)
    Rast=terra::mask(Rast,Poly)
  }
  Cuts=sort(Cuts)  
  
  B=stars::st_as_stars(Rast)
  Cs=stars::st_contour(B,breaks=Cuts)
  Cs=sf::st_cast(Cs,"POLYGON",warn=FALSE)
  Cs=Cs%>%dplyr::filter(is.finite(Min)==TRUE & is.finite(Max)==TRUE)
  Cs=Cs[,-1]
  row.names(Cs)=NULL
  #Add Isobath ID
  tmp=data.frame(Min=sort(unique(Cs$Min)))
  tmp$Iso=seq(1,nrow(tmp))
  Cs=dplyr::left_join(Cs,tmp,by="Min")
  #Add colors
  tmp=add_col(var=Cs$Iso, cuts = 100, cols = Cols)
  Cs$c=tmp$varcol
  Cs$ID=seq(1,nrow(Cs))
  
  if(Grp==TRUE){
    #Add Group
    Grp=sf::st_touches(Cs,sparse = TRUE)
    Cs$Grp=NA
    Cs$Grp[1]=1
    for(i in seq(2,nrow(Cs))){
      Gr=Grp[[i]]
      if(length(Gr)==0){
        Cs$Grp[i]=Cs$Grp[i-1]+1
      }else{
        if(is.na(Cs$Grp[i])){Cs$Grp[c(i,Gr)]=Cs$Grp[i-1]+1}
      }
    }
    #Add area
    Ar=round(st_area(Cs)/1000000,2)
    Cs$AreaKm2=as.numeric(Ar)
    #Add group label location
    labs=st_coordinates(st_centroid(st_geometry(Cs)))
    Cs$Labx=labs[,1]
    Cs$Laby=labs[,2]
    #Keep label location for shallowest pol within group
    tmp=st_drop_geometry(Cs)%>%dplyr::select(Iso,Grp,AreaKm2)
    tmp2=tmp%>%dplyr::group_by(Grp)%>%dplyr::summarise(Iso2=max(Iso),AreaKm2=max(AreaKm2[Iso==max(Iso)]))
    colnames(tmp2)[2]="Iso"
    tmp2$L="Y"
    tmp=dplyr::left_join(tmp,tmp2,by = c("Iso", "Grp","AreaKm2"))
    Cs$Labx[which(is.na(tmp$L))]=NA
    Cs$Laby[which(is.na(tmp$L))]=NA
    Cs$ID=seq(1,nrow(Cs))
  }
  return(Cs)
}

