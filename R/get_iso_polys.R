#' Generate Polygons from Isobaths
#'
#' From an input bathymetry and chosen depths, turns areas between isobaths into polygons.
#' An input polygon may optionally be given to constrain boundaries.
#' The accuracy is dependent on the resolution of the bathymetry raster
#' (see \code{\link{load_Bathy}} to get high resolution data).
#'  
#' @param Poly optional, single polygon inside which isobaths will be computed.
#' May be created using \code{\link{create_Polys}} or by subsetting an object obtained
#' using one of the \code{load_} functions (see examples).
#' 
#' @param Bathy bathymetry raster with the appropriate projection, such as
#' \code{\link[CCAMLRGIS:SmallBathy]{SmallBathy}}.
#' It is highly recommended to use a raster of higher resolution (see \code{\link{load_Bathy}}).
#' 
#' @param Depths numeric, vector of desired isobaths. For example,
#' \code{Depths=c(-2000,-1000,-500)}.
#' 
#' @return Spatial object in your environment. Data within the resulting object contains
#' a polygon in each row. Columns are as follows: \code{ID} is a unique polygon identifier;
#' \code{Iso} is an isobath identifier; \code{Min} and \code{Max} is the depth range of isobaths;
#' \code{Grp} is a group identifier (e.g., a seamount constituted of several isobaths); 
#' \code{AreaKm2} is the polygon area in square kilometers; \code{Labx} and \code{Laby} can be used
#' to label groups (see examples).
#' 
#' @seealso 
#' \code{\link{load_Bathy}}, \code{\link{create_Polys}}, \code{\link{get_depths}}.
#' 
#' @examples
#' 
#' # For more examples, see:
#' # https://github.com/ccamlr/CCAMLRGIS#46-get_iso_polys
#' 
#' 
#' Poly=create_Polys(Input=data.frame(ID=1,Lat=c(-55,-55,-61,-61),Lon=c(-30,-25,-25,-30)))
#' IsoPols=get_iso_polys(Bathy=SmallBathy,Poly=Poly,Depths=seq(-8000,0,length.out=10))
#' 
#' plot(st_geometry(Poly))
#' for(i in unique(IsoPols$Iso)){
#'   plot(st_geometry(IsoPols[IsoPols$Iso==i,]),col=rainbow(9)[i],add=TRUE)
#' }
#' 
#'
#' @export

get_iso_polys=function(Bathy,Poly=NULL,Depths){
  
  if(is.null(Poly)==FALSE){
    Bathy=terra::crop(Bathy,Poly)
    Bathy=terra::mask(Bathy,Poly)
  }
  Depths=sort(Depths)  
  
  B=stars::st_as_stars(Bathy)
  Cs=stars::st_contour(B,breaks=Depths)
  Cs=sf::st_cast(Cs,"POLYGON",warn=FALSE)
  Cs=Cs%>%dplyr::filter(is.finite(Min)==TRUE & is.finite(Max)==TRUE)
  Cs=Cs[,-1]
  row.names(Cs)=NULL
  Grp=sf::st_touches(Cs,sparse = TRUE)
  #Add Isobath ID
  tmp=data.frame(Min=sort(unique(Cs$Min)))
  tmp$Iso=seq(1,nrow(tmp))
  Cs=dplyr::left_join(Cs,tmp,by="Min")
  #Add Group
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
  Cs=Cs[,c(9,3,1,2,5,6,7,8,4)]
  return(Cs)
}
