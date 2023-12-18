#Generate simulated data for Advanced_Grids

library(CCAMLRGIS)
library(dplyr)
ASDs=load_ASDs() #Load Subareas
ASDs=ASDs[ASDs$GAR_Short_Label%in%c("481","482","483"),] #keep only 48.1-48.3

#First, generate locations (Lat/Lon) as normally distributed around 3 centers, one in each
#of Subareas 48.1-48.3

#In 48.1
Locations=data.frame(
  Lat=rnorm(n=100,mean=-62.5,sd=2),
  Lon=rnorm(n=100,mean=-60,sd=2)
)

#In 48.2
Locations=rbind(Locations,data.frame(
  Lat=rnorm(n=100,mean=-61,sd=2),
  Lon=rnorm(n=100,mean=-47,sd=2)
))

#In 48.3
Locations=rbind(Locations,data.frame(
  Lat=rnorm(n=100,mean=-54,sd=2),
  Lon=rnorm(n=100,mean=-36,sd=2)
))

#Keep only locations that fall inside ASDs
Locations=assign_areas(Locations,"ASDs")
Locations=Locations[is.na(Locations$ASDs)==F,]

#Check locations on map
Ps=create_Points(Locations) #Turn locations into projected points
plot(st_geometry(ASDs))
plot(st_geometry(Ps),add=T)

#Now grid locations to assign a cell to each location (so that after, some cells are excluded from the Observations)
Gr=create_PolyGrids(Locations,Area=5000)
plot(st_geometry(Gr),add=T)

Locations=assign_areas(Locations,"Gr",AreaNameFormat = "ID")
NperID=Locations%>%group_by(Gr)%>%summarise(n=n()) #Count of records per cell
ObsID=NperID$Gr[NperID$n>1] #Cells with more than one record, and for which there will be observations

#Build Effort data - 4 seasons, 200 records per season.
Isample=sample(seq(1,nrow(Locations)),size=800,replace = T) #Random samples of rows in Locations
Effort=data.frame(
  Latitude=Locations$Lat[Isample],
  Longitude=Locations$Lon[Isample],
  Season=rep(seq(2019,2022),each=200),
  Catch=runif(n=800,min=50,max=150)
)

#Build Observations data, same as above but after excluding cells with only 1 record
E_cells=Locations$Gr[Isample] #Cells that are in the Effort data
Observations=Effort[which(E_cells%in%ObsID),1:3]
Observations$Value=rnorm(n=nrow(Observations),mean=100,sd=10)


#Export data
write.csv(Effort,"Advanced_Grids/Effort.csv",row.names = F)
write.csv(Observations,"Advanced_Grids/Observations.csv",row.names = F)
