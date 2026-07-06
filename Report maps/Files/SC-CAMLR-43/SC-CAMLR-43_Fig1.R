#Script to plot the krill fishery management units as built by Krill_Fishery_Management_Units_V2_0.R

#Load the CCAMLRGIS library
library(CCAMLRGIS)


#Load the units
P=st_read("Report maps/Files/SC-CAMLR-43/Candidate_KFMUs.gpkg",quiet = T)

#Load the coastline
coast=load_Coastline()

#Rotate objects
Lonzero=-60 #This longitude will point up
R_P=Rotate_obj(P,Lonzero)
R_coast=Rotate_obj(coast,Lonzero)

#Get labels
R_labs=suppressWarnings( st_centroid(R_P) )
R_labs$x=st_coordinates(R_labs)[,1]
R_labs$y=st_coordinates(R_labs)[,2]


#Create a bounding box for the region
bb=st_bbox(st_buffer(R_P,20000)) #Get bounding box (x/y limits) + buffer
bx=st_as_sfc(bb) #Build spatial box to plot

#Use spatial box to crop coastline
R_coast=suppressWarnings(st_intersection(R_coast,bx))

# adjust labels
R_labs$y[R_labs$id=="DP2"]=3100000
R_labs$y[R_labs$id=="DP1"]=2730000
R_labs$y[R_labs$id=="EI"]=3230000

#Plot
png(filename="Report maps/Files/SC-CAMLR-43/SC-CAMLR-43_Fig1.png",
width=2700,height=3000,res=600)
par(mai=rep(0,4))
plot(bx,lwd=0.1,xpd=T)
plot(st_geometry(R_coast[R_coast$surface=="Ice",]),col="white",lwd=0.5,add=T)
plot(st_geometry(R_P),border="black",lwd=1.5,add=T)
plot(st_geometry(R_coast[R_coast$surface=="Land",]),col="grey",add=T)
add_RefGrid(bb=bb,ResLat = 2.5,ResLon = 5,lwd=0.5,fontsize = 0.75)
plot(bx,lwd=1,add=T,xpd=T)

text(R_labs$x,R_labs$y,R_labs$id)

dev.off()


#Export areas
Areas=data.frame(
  Polygon=P$id,
  Marine_Area_km2=P$areakm2
)
write.csv(Areas,"Report maps/Files/SC-CAMLR-43/SC-CAMLR-43_Polygon_Areas.csv",row.names = F)


