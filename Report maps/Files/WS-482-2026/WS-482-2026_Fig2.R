#Script to reproduce Fig 2 of WS-48.2-2026
library(CCAMLRGIS)
library(terra)
library(png)

#Get Bathymetry and isobath (generated from WS482Bathy.R)
Bathy=rast("Report maps/ExternalFiles/Bathy482.tif")
Iso400=st_read("Report maps/Files/WS-482-2026/Iso400.gpkg",quiet=T)

#Get coastline
coast=load_Coastline()
#Get Areas
ASDs=load_ASDs()
MPAs=load_MPAs()
MPAs=MPAs[MPAs$GAR_Short_Label=="SOSS",]

#KFCA (From Figure 8 of WS-48.2-2026/05)
KFCA=st_read("Report maps/ExternalFiles/KFCA_WS_482.gpkg",quiet=T)
KFCA=KFCA[KFCA$ASD=="48.2",]

#Additional areas
Add_Areas=read.csv("Report maps/Files/WS-482-2026/Additional_Areas_WS482.csv")
AreasP=create_Polys(Add_Areas)

#Get inset map
inset=readPNG("Report maps/Files/WS-482-2026/Inset_482.png",native = T)

#Rotate objects
Lonzero=-40 #This longitude will point up
R_bathy=Rotate_obj(Bathy,Lonzero)
R_asds=Rotate_obj(ASDs,Lonzero)
R_coast=Rotate_obj(coast,Lonzero)
R_mpas=Rotate_obj(MPAs,Lonzero)
Iso400=Rotate_obj(Iso400,Lonzero)
R_KFCA=Rotate_obj(KFCA,Lonzero)
R_AreasP=Rotate_obj(AreasP,Lonzero)

  
#Select ASD of interest to build bounding box
R_asdsb=R_asds[R_asds$GAR_Long_Label=="48.2",]
#Create a bounding box for the region
bb=st_bbox(st_buffer(R_asdsb,20000)) #Get bounding box (x/y limits) + buffer
bx=st_as_sfc(bb) #Build spatial box to plot

#Use bounding box to crop elements
R_asds=suppressWarnings(st_intersection(R_asds,bx))
R_coast=suppressWarnings(st_intersection(R_coast,bx))
Iso400=suppressWarnings(st_intersection(Iso400,bx))
R_bathy=crop(R_bathy,ext(bb))

#CEMP sites
CEMP=data.frame(Lat=c(-60.717,-60.7286),
                Lon=c(-45.6,-44.5181),
                text=c("Signy Island \n (SIO - UK)","Laurie Island \n (LAO - ARG)"))
CEMP=create_Points(CEMP)
CEMP=Rotate_obj(CEMP,Lonzero)

#Subarea Labels
Labs=data.frame(
  Lat=c(-60.8,-60,-56.73,-61.5,-64.3),
  Lon=c(-50.9,-39,-48,-29,-40),
  text=c(48.1,48.2,48.3,48.4,48.5)
)
Labs_p=create_Points(Labs,NamesIn =  c("Lat","Lon"))
R_labsp=Rotate_obj(Labs_p,Lonzero) #Rotate labels
R_labsp$x=st_coordinates(R_labsp)[,1]
R_labsp$y=st_coordinates(R_labsp)[,2]
R_labsp=st_drop_geometry(R_labsp)

#Load Legend Items
source("Report maps/Files/WS-482-2026/LegendItemsWS482.R")



#Plot
png(filename='Report maps/Files/WS-482-2026/WS-482-2026_Fig2.png',width=2400,height=1500,res=300)
par(mar=c(1,2,1,2),lend=0)
plot(R_bathy,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=NA,maxcell=5e6)
plot(Iso400,lwd=1,add=T,xpd=T,border="grey50")#Isobath
plot(st_geometry(R_asds),border="grey",lwd=3.5,add=T)
plot(st_geometry(R_mpas),border="red",col=rgb(1,0.5,0,0.25),lwd=4,add=T)
plot(st_geometry(R_coast),col="grey",add=T,lwd=0.5)

plot(st_geometry(R_AreasP[R_AreasP$ID=="D1MPA-GPZ-SOI",]),border="green",col=rgb(0,1,0.5,0.25),lwd=2,add=T)
plot(st_geometry(R_KFCA),col=rgb(0,0,1,0.2),add=T,lwd=0.2)
plot(st_geometry(R_AreasP[R_AreasP$ID=="Area D",]),border="pink",add=T,lwd=8)
plot(st_geometry(R_AreasP[R_AreasP$ID=="Area C",]),border="orange",add=T,lwd=6)
plot(st_geometry(R_AreasP[R_AreasP$ID=="Area B",]),border="yellow",add=T,lwd=4)
plot(st_geometry(R_AreasP[R_AreasP$ID=="Area A",]),add=T,lwd=2)

add_RefGrid(bb=bb,ResLat = 2.5,ResLon = 5,lwd=1,fontsize = 0.75)
plot(bx,lwd=2,add=T,xpd=T)

#Add inset map
Loc=c(400000,2810000) #XY location of inset
rasterImage(inset,xleft=Loc[1],
            ybottom=Loc[2],
            xright=Loc[1]+250000,
            ytop=Loc[2]+250000,
            xpd=T)

#CEMP sites
plot(st_geometry(CEMP),pch=21,bg='darkgreen',add=T,cex=0.75,col='cyan',lwd=0.5)

#Legend
LegOpt=list( 
  Pos = "topright",
  Boxbd="white",
  BoxW= 60,
  BoxH= 120,
  Boxexp = c(5,0,-2,-2),
  PosX=-30,
  PosY=-18
)
add_Legend(bb,LegOpt,
           Items=list(L_ASDs,L_MPA,L_D1MPA,L_KFCA,L_CEMP,L_A,L_B,L_C,L_D
           ))

text(R_labsp$x,R_labsp$y,R_labsp$text,cex=1.2,font=2)

dev.off()


#Compute marine areas
#Put all polygons together
tmp=ASDs[ASDs$GAR_Long_Label=="48.2",]
tmp=tmp[,"GAR_Name"]
colnames(tmp)[1]="Polygon"
Polys=tmp

tmp=MPAs[MPAs$GAR_Short_Label=="SOSS",]
tmp=tmp[,"GAR_Short_Label"]
colnames(tmp)[1]="Polygon"
Polys=rbind(Polys,tmp)

tmp=AreasP
tmp=tmp[,"ID"]
colnames(tmp)[1]="Polygon"
Polys=rbind(Polys,tmp)
#Clip to the coastline
Polys=suppressWarnings(st_difference(Polys,st_union(coast[coast$surface=="Land",])))
Ar=as.numeric(round(st_area(Polys)/1e6))

Areas=data.frame(
  Polygon=Polys$Polygon,
  Marine_Area_km2=Ar
)
#Export
write.csv(Areas,"Report maps/Files/WS-482-2026/WS-482-2026_Polygon_Areas.csv",row.names = F)
