#' Sum planimetric seabed area
#'
#' Sum planimetric seabed area
#' @param bathymetry is the bathymetry raster data upon which the planimetric seabed area calculation
#' is based
#' @export
sum_area <- function(bathymetry){
  plan_area_cells <- raster::freq(bathymetry, useNA="no")
  # multiply the total number of cells by cell res and convert to km2
  sum_area <- (sum(plan_area_cells[,2])*raster::xres(bathymetry)*raster::yres(bathymetry))/1e6
  sum_area
}


#' Calculate planimetric seabed area
#'
#' Calculate planimetric seabed area within the single depth class and/or multiple depth classes
#' @param bathymetry is data in a raster file format upon which the calculation
#' is based, it is assumed that all bathymetry values above zero have been removed. 
#' @param Polys is the polygon(s) region of interest in the SpatialPolygonsDataFrame 
#' @param fishable_area is TRUE if the planimetric seabed area in the fishable depth range (i.e. 800-1600m) will be calculated if FALSE then the total seabed area will be calculated
#' @param depth_classes is a character vector that includes the minimum and maximum depth within each depth class e.g. c("0-600","600-1800","1800-max")
#' @import raster
#' @export
seabed_area <- function(bathymetry, Polys, fishable_area, depth_classes=NA){
 # check that all spatial data are in the same projection
  ##* proj4string is in both raster and sp, use :: to specify which
  if(sp::proj4string(bathymetry)!=sp::proj4string(Polys)) stop("projection of bathymetry data does not match that of the Polys")
  
  area_names <- Polys@data[,1]
  
  if(fishable_area==TRUE & any(is.na(depth_classes))==TRUE){
    plan_area <- data.frame(matrix(nrow=length(area_names),ncol=2))
    names(plan_area)<-c("Polys","Fishable_area")
  }else{
    plan_area=data.frame(matrix(nrow=length(area_names),ncol=length(depth_classes)+2))
    names(plan_area)=c("Polys","Total_area",depth_classes)
    # prepare depth reclass matrix
    depth_class_mat<-as.matrix(do.call('rbind', strsplit(as.character(depth_classes),'-',fixed=TRUE)))
    depth_class_mat[dim(depth_class_mat)[1],dim(depth_class_mat)[2]]<- minValue(bathymetry)-1
    class(depth_class_mat)<- "numeric"
    # if depth classes are specified in positive values then change to negative
    depth_class_mat[depth_class_mat>0]<- depth_class_mat[depth_class_mat>0]*-1
    # reorder matrix with lower values in first col
    depth_class_mat[,c(1,2)]<-depth_class_mat[,c(2,1)]
    depth_class_mat<-cbind(depth_class_mat,seq(from=1,length(depth_classes),by=1))
  }
  
  for (name in area_names) {
    # index Research block
    Poly <- Polys[area_names%in%name,]
    Bathy <- raster::crop(bathymetry, raster::extent(Poly))
    Total_area <- raster::mask(Bathy,Poly)
    
    if(fishable_area==TRUE){
      if(minValue(bathymetry) < -1800 | maxValue(bathymetry) > -600){
        Poly_mask <- Total_area > -1800 & Total_area < -600
        Fishable_area <- raster::mask(Total_area, Poly_mask, maskvalue=0)}
      else{
        Fishable_area <- Total_area   
      }
      # estimate total planimetric area
      plan_area[area_names%in%name,1]<- as.character(name)
      plan_area[area_names%in%name,2]<- sum_area(Fishable_area)
      
    }else{
      
      Depth_strata_reclass=reclassify(Total_area,depth_class_mat)
      
      new_df <- matrix(nrow=length(depth_classes),ncol=2)
      new_df[,1] <- depth_class_mat[,3]
      class_freq=raster::freq(Depth_strata_reclass,useNA="no")
      new_df[new_df[,1]%in%class_freq[,1],]= class_freq
      new_df[!new_df[,1]%in%class_freq[,1],2]= 0
      
      # summarise planimetric area by depth interval
      sum_area_depth_class=(new_df[,2]*raster::xres(Bathy)*raster::yres(Bathy))/1e6
      sum_area_depth_class=round(sum_area_depth_class,2)
      
      plan_area[area_names%in%name,1]<- name
      plan_area[area_names%in%name,2]<- sum(sum_area_depth_class)
      plan_area[area_names%in%name,3:ncol(plan_area)]<- sum_area_depth_class
    }
  }
  plan_area
}
