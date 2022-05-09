
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CCAMLRGIS R package

This package was developed to simplify the production of maps in the
CAMLR Convention Area. It provides two main categories of functions:
load functions and create functions. Load functions are used to import
spatial layers from the online [CCAMLR GIS](http://gis.ccamlr.org/) such
as the ASD boundaries. Create functions are used to create layers from
user data such as polygons and grids.

## Note on V4 update:

Due to the retirement of some packages that the CCAMLRGIS package use to
rely on, since CCAMLRGIS V4.0.0 the package relies on the [sf
package](https://CRAN.R-project.org/package=sf), users may need to
familiarize themselves with it. For those that were using older
versions, the main difference is in plotting commands.

Plotting a spatial object *MyObject* used to be:

``` r
plot(MyObject)
```

Since V4, it will be:

``` r
plot(st_geometry(MyObject))
```

Also, to access the data inside spatial objects, instead of
<MyObject@data>, type MyObject directly. You can revert to *sp* objects
with as_Spatial(MyObject) if preferred.

Using *sf* objects has advantages such as the ability to use [Tidyverse
methods](https://r-spatial.github.io/sf/reference/tidyverse.html).
Further, additional [plotting
methods](https://r-spatial.github.io/sf/articles/sf5.html) are
available, some of which are described in section 5.5. [Using
sf](#55-using-sf).

## Installation

You can install the CCAMLRGIS R package from CRAN with:

``` r
install.packages("CCAMLRGIS")
```

## Documentation

<center>

### A package to load and create spatial data, including layers and tools that are relevant to CCAMLR activities.

</center>

------------------------------------------------------------------------

<center>

### Table of contents

</center>

------------------------------------------------------------------------

1.  [Basemaps](#1-basemaps)
2.  [Create functions](#2-create-functions)

-   2.1. [Points](#create-points), [lines](#create-lines),
    [polygons](#create-polygons) and [grids](#create-grids)
-   2.2. [Create Stations](#22-create-stations)
-   2.3. [Create Pies](#23-create-pies)

3.  [Load functions](#3-load-functions)

-   3.1. Online use
-   3.2. Offline use

4.  Other functions

-   4.1. [get_depths](#41-get_depths)
-   4.2. [seabed_area](#42-seabed_area)
-   4.3. [assign_areas](#43-assign_areas)
-   4.4. [project_data](#44-project_data)
-   4.5. [get_C\_intersection](#45-get_c_intersection)

5.  Adding colors, legends and labels

-   5.1. [Bathymetry colors](#51-bathymetry-colors)
-   5.2. [Adding colors to data](#52-adding-colors-to-data)
-   5.3. [Adding legends](#53-adding-legends)
-   5.4. [Adding labels](#54-adding-labels)
-   5.5. [Using sf](#55-using-sf)

------------------------------------------------------------------------

## Introduction

First, install the package by typing:

``` r
install.packages("CCAMLRGIS")
```

Then, load the package by typing:

``` r
library(CCAMLRGIS)
```

In order to plot bathymetry data, you will also need to load
[terra](https://CRAN.R-project.org/package=terra):

``` r
library(terra)
```

All spatial manipulations are made using the South Pole Lambert
Azimuthal Equal Area projection (type ?CCAMLRp for more details).

``` r
#Map with axes, to illustrate projection

#Set the figure margins as c(bottom, left, top, right)
par(mai=c(1.2,0.7,0.5,0.45),xpd=TRUE)
#plot entire Coastline
plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',lwd=0.1)
#Add reference grid
add_RefGrid(bb=st_bbox(Coast[Coast$ID=='All',]),ResLat=10,ResLon=20,LabLon=-40,fontsize=0.8,lwd=0.5)
#add axes and labels
axis(1,pos=0,at=seq(-4000000,4000000,by=1000000),tcl=-0.15,labels=F,lwd=0.8,lwd.ticks=0.8,col='blue')
axis(2,pos=0,at=seq(-4000000,4000000,by=1000000),tcl=-0.15,labels=F,lwd=0.8,lwd.ticks=0.8,col='blue')
text(seq(1000000,4000000,by=1000000),0,seq(1,4,by=1),cex=0.75,col='blue',adj=c(0.5,1.75))
text(seq(-4000000,-1000000,by=1000000),0,seq(-4,-1,by=1),cex=0.75,col='blue',adj=c(0.5,1.75))
text(0,seq(1000000,4000000,by=1000000),seq(1,4,by=1),cex=0.75,col='blue',adj=c(1.75,0.5))
text(0,seq(-4000000,-1000000,by=1000000),seq(-4,-1,by=1),cex=0.75,col='blue',adj=c(1.75,0.5))
text(0,0,0,cex=0.75,col='blue',adj=c(-0.5,-0.5))
text(5200000,0,expression('x ('*10^6~'m)'),cex=0.75,col='blue')
text(0,4700000,expression('y ('*10^6~'m)'),cex=0.75,col='blue')
```

<img src="README-Fig01-1.png" width="100%" style="display: block; margin: auto;" />

<center>

#### The South Pole Lambert Azimuthal Equal Area projection converts Latitudes and Longitudes into locations on a disk with x/y axes and units of meters. The South Pole is at x=0m ; y=0m. The tip of the Peninsula, for example, is around x=-2,500,000m ; y=2,000,000m.

</center>

## 1. Basemaps

#### Bathymetry:

Prior to detailing the package’s capabilities, a set of basic commands
are shown here to display a few core mapping elements. All scripts use
the low-resolution bathymetry raster included in the package
(‘SmallBathy’). In order to obtain higher resolution bathymetry data,
use the *Load_Bathy()* function:

``` r
#Load_Bathy() example:
Bathy=load_Bathy(LocalFile = FALSE,Res=5000)
plot(Bathy, breaks=Depth_cuts,col=Depth_cols,axes=FALSE,legend=FALSE,mar=c(0,0,0,0))
```

<img src="README-Fig02-1.png" width="100%" style="display: block; margin: auto;" />

``` r

#Please refer to ?load_Bathy for more details, including how to save the bathymetry data so that you
#do not have to re-download it every time you need it.
```

#### Statistical Areas, Subareas and Divisions (ASDs):

``` r
#Load ASDs and EEZs
ASDs=load_ASDs()
EEZs=load_EEZs()
#Set the figure margins as c(bottom, left, top, right)
par(mai=c(0,0.4,0,0))
#Plot the bathymetry
plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,legend=F,axes=F,box=F,mar=c(0,0.4,0,0))
#Add reference grid
add_RefGrid(bb=st_bbox(SmallBathy),ResLat=10,ResLon=20,LabLon=0,fontsize=0.75,lwd=0.75,offset = 4)
#Add color scale
add_Cscale(height=90,fontsize=0.75,offset=-500,width=15,maxVal=-1,lwd=0.5)
#Add ASD and EEZ boundaries
plot(st_geometry(ASDs),add=T,lwd=0.75,border='red')
plot(st_geometry(EEZs),add=T,lwd=0.75,border='red')
#Add coastline (for all ASDs)
plot(st_geometry(Coast[Coast$ID=='All',]),col='grey',lwd=0.01,add=T)
#Add ASD labels
add_labels(mode='auto',layer='ASDs',fontsize=0.6,col='red')
```

<img src="README-Fig03-1.png" width="100%" style="display: block; margin: auto;" />

#### Local map (*e.g.*, Subarea 48.6):

``` r
#Load ASDs
ASDs=load_ASDs()
#Subsample ASDs to only keep Subarea 48.6
S486=ASDs[ASDs$GAR_Short_Label=='486',]
#Crop bathymetry to match the extent of S486
B486=crop(rast(SmallBathy),ext(S486))
#Plot the bathymetry
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=F,axes=F,mar=c(1.4,2,1.4,7))
#Add color scale
add_Cscale(height=80,fontsize=0.7,offset=300,width=15,lwd=0.5,maxVal=-1)
#Add coastline (for Subarea 48.6 only)
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Add reference grid
add_RefGrid(bb=st_bbox(B486),ResLat=5,ResLon=10,fontsize=0.75,lwd=0.75,offset = 100000)
#Add Subarea 48.6 boundaries
plot(st_geometry(S486),add=T,lwd=1,border='red')
#Add a -2000m contour
contour(B486,levels=-2000,add=T,lwd=0.5,labcex=0.3)
#Add single label at the centre of the polygon (see ?Labels)
text(Labels$x[Labels$t=='48.6'],Labels$y[Labels$t=='48.6'],labels='48.6',col='red',cex=1.5)
```

<img src="README-Fig04-1.png" width="100%" style="display: block; margin: auto;" />

## 2. Create functions

### 2.1. Points, lines, polygons and grids

These functions are used to transform user data into spatial layers with
the appropriate projection. User data should be provided as a dataframe
containing Latitudes and Longitudes in decimal degrees. Depending on the
function used, some other variables may be required (see help).

#### Create points:

For details, type:

``` r
?create_Points
```

``` r
#Prepare layout for 4 sub-plots
par(mfrow=c(2,2),mai=c(0,0.01,0.2,0.01))

#Example 1: Simple points with labels
MyPoints=create_Points(PointData)
plot(st_geometry(MyPoints),main='Example 1',cex.main=0.75,cex=0.5,lwd=0.5)
text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=T,cex=0.75)
box()

#Example 2: Simple points with labels, highlighting one group of points with the same name
MyPoints=create_Points(PointData)
plot(st_geometry(MyPoints),main='Example 2',cex.main=0.75,cex=0.5,lwd=0.5)
text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,-0.5),xpd=T,cex=0.75)
plot(st_geometry(MyPoints[MyPoints$name=='four',]),bg='red',pch=21,cex=1,add=T)
box()

#Example 3: Buffered points with radius proportional to catch
MyPoints=create_Points(PointData,Buffer=1*PointData$Catch)
plot(st_geometry(MyPoints),col='green',main='Example 3',cex.main=0.75,cex=0.5,lwd=0.5)
text(MyPoints$x,MyPoints$y,MyPoints$name,adj=c(0.5,0.5),xpd=T,cex=0.75)
box()

#Example 4: Buffered points with radius proportional to catch and clipped to the Coast
MyPoints=create_Points(PointData,Buffer=2*PointData$Catch,Clip=T)
plot(st_geometry(MyPoints),col='cyan',main='Example 4',cex.main=0.75,cex=0.75,lwd=0.5)
plot(st_geometry(Coast[Coast$ID=='All',]),add=T,col='grey',lwd=0.5)
box()
```

<img src="README-Fig05-1.png" width="100%" style="display: block; margin: auto;" />

#### Create lines:

For details, type:

``` r
?create_Lines
```

``` r
#If your data contains line end locations in separate columns, you may reformat it as follows:

#Original data:
MyData=data.frame(
  Line=c(1,2),
  Lat_Start=c(-60,-65),
  Lon_Start=c(-10,5),
  Lat_End=c(-61,-66),
  Lon_End=c(-2,2)
)

#Reformat data to use as input in create_Lines as:
Input=data.frame(
  Line=c(MyData$Line,MyData$Line),
  Lat=c(MyData$Lat_Start,MyData$Lat_End),
  Lon=c(MyData$Lon_Start,MyData$Lon_End)
)
```

``` r
#Prepare layout for 3 sub-plots
par(mai=c(0,0.01,0.2,0.01),mfrow=c(1,3))

#Example 1: Simple and non-densified lines
MyLines=create_Lines(LineData)
plot(st_geometry(MyLines),col=rainbow(nrow(MyLines)),main='Example 1',cex.main=0.75,lwd=2)
box()

#Example 2: Simple and densified lines (note the curvature of the purple line)
MyLines=create_Lines(LineData,Densify=T)
plot(st_geometry(MyLines),col=rainbow(nrow(MyLines)),main='Example 2',cex.main=0.75,lwd=2)
box()

#Example 3: Densified, buffered and clipped lines
MyLines=create_Lines(LineData,Densify=T,Buffer=c(10,40,50,80,100),Clip=T)
plot(st_geometry(MyLines[5:1,]),col=rainbow(nrow(MyLines)),main='Example 3',cex.main=0.75,lwd=1)
plot(Coast[Coast$ID=='All',],col='grey',add=T,lwd=0.5)
box()
```

<img src="README-Fig06-1.png" width="100%" style="display: block; margin: auto;" />

Adding a buffer with the argument *SeparateBuf* set to FALSE results in
a single polygon which may be viewed as a footprint:

``` r
#Set the figure margins as c(bottom, left, top, right)
par(mai=c(0.01,0.01,0.01,0.01))

#Buffer merged lines
MyLines=create_Lines(LineData,Buffer=10,SeparateBuf=F)
#The resulting polygon has an area of:
MyLines$Buffered_AreaKm2
#> [1] 222654.8

plot(st_geometry(MyLines),col='green',lwd=1)
box()
```

<img src="README-Fig07-1.png" width="80%" style="display: block; margin: auto;" />

#### Create polygons:

For details, type:

``` r
?create_Polys
```

``` r
#Prepare layout for 3 sub-plots
par(mfrow=c(1,3),mai=c(0,0.01,0.2,0.01))

#Example 1: Simple and non-densified polygons
MyPolys=create_Polys(PolyData,Densify=F)
plot(st_geometry(MyPolys),col='blue',main='Example 1',cex.main=0.75,lwd=0.5)
text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID,col='white',cex=0.75)
box()

#Example 2: Simple and densified polygons (note the curvature of iso-latitude lines)
MyPolys=create_Polys(PolyData)
plot(st_geometry(MyPolys),col='red',main='Example 2',cex.main=0.75,lwd=0.5)
text(MyPolys$Labx,MyPolys$Laby,MyPolys$ID,col='white',cex=0.75)
box()

#Example 3: Buffered and clipped polygons
MyPolysBefore=create_Polys(PolyData,Buffer=c(10,-15,120))
MyPolysAfter=create_Polys(PolyData,Buffer=c(10,-15,120),Clip=T)
plot(st_geometry(MyPolysBefore),col='green',main='Example 3',cex.main=0.75,lwd=0.5)
plot(st_geometry(Coast[Coast$ID=='All',]),add=T,lwd=0.5)
plot(st_geometry(MyPolysAfter),col='orange',add=T,lwd=0.5)
text(MyPolysAfter$Labx,MyPolysAfter$Laby,MyPolysAfter$ID,col='white',cex=0.75)
box()
```

<img src="README-Fig08-1.png" width="100%" style="display: block; margin: auto;" />

``` r
#Convention area
#The locations of vertices are given clockwise, starting from the northwest corner of 48.3
CA=data.frame(
  Name="CA",
  Lat=c(-50,-50,-45,-45,-55,-55,-60,-60),
  Lon=c(-50,30,30,80,80,150,150,-50)
)

#Prepare layout for 2 sub-plots
par(mfrow=c(1,2),mai=c(0,0,0.2,0))

#Example 4: Convention area contour
MyPoly=create_Polys(CA)
plot(st_geometry(MyPoly),col='blue',border='green',main='Example 4',cex.main=0.75,lwd=2)
box()

#Example 5: Convention area contour, coastline clipped
MyPoly=create_Polys(CA,Clip = TRUE)
plot(st_geometry(MyPoly),col='blue',border='green',main='Example 5',cex.main=0.75,lwd=2)
box()
```

<img src="README-Fig08b-1.png" width="100%" style="display: block; margin: auto;" />

#### Create grids:

For details, type:

``` r
?create_PolyGrids
```

``` r
#Prepare layout for 3 sub-plots
par(mfrow=c(1,3),mai=c(0,0.01,0.2,0.01))

#Example 1: Simple grid, using automatic colors
MyGrid=create_PolyGrids(GridData,dlon=2,dlat=1)
plot(st_geometry(MyGrid),col=MyGrid$Col_Catch_sum,main='Example 1',cex.main=0.75,lwd=0.1)
box()

#Example 2: Equal area grid, using automatic colors
MyGrid=create_PolyGrids(GridData,Area=10000)
plot(st_geometry(MyGrid),col=MyGrid$Col_Catch_sum,main='Example 2',cex.main=0.75,lwd=0.1)
box()

#Example 3: Equal area grid, using custom cuts and colors
MyGrid=create_PolyGrids(GridData,Area=10000,cuts=c(0,50,100,500,2000,3500),cols=c('blue','red'))
plot(st_geometry(MyGrid),col=MyGrid$Col_Catch_sum,main='Example 3',cex.main=0.75,lwd=0.1)
box()
```

<img src="README-Fig09-1.png" width="100%" style="display: block; margin: auto;" />

Customizing a grid and adding a color scale:

``` r
#Prepare layout for 2 sub-plots
par(mfrow=c(2,1),mai=c(0.2,0.05,0.1,1.3))

#Step 1: Generate your grid
MyGrid=create_PolyGrids(GridData,Area=10000)

#Step 2: Inspect your gridded data (e.g. sum of Catch) to determine whether irregular cuts are required
hist(MyGrid$Catch_sum,100,cex=0.75,main='Frequency distribution of data',
     cex.main=0.5,col='grey',axes=F)
axis(1,pos=0,tcl=-0.15,lwd=0.8,lwd.ticks=0.8,labels=F)
text(seq(0,2500,by=500),-1.5,seq(0,2500,by=500),cex=0.75,xpd=T)

#In this case (heterogeneously distributed data) irregular cuts would be preferable
#Such as:
MyCuts=c(0,50,100,500,2000,2500)
abline(v=MyCuts,col='green',lwd=0.1,lty=2) #Add classes to histogram as green dashed lines

#Step 3: Generate colors according to the desired classes (MyCuts)
Gridcol=add_col(MyGrid$Catch_sum,cuts=MyCuts,cols=c('yellow','purple'))

#Step 4: Plot result and add color scale
#Use the colors generated by add_col
plot(st_geometry(MyGrid),col=Gridcol$varcol,lwd=0.1) 
#Add color scale using cuts and cols generated by add_col
add_Cscale(title='Sum of Catch (t)',cuts=Gridcol$cuts,cols=Gridcol$cols,width=18,
     fontsize=0.6,lwd=0.5,height = 100) 
box()
```

<img src="README-Fig10-1.png" width="100%" style="display: block; margin: auto;" />

### 2.2. Create Stations

This function was designed to create random point locations inside a
polygon and within bathymetry strata constraints. A distance constraint
between stations may also be used if desired. The examples below use the
‘SmallBathy’ data for illustrative purposes; users should use a higher
resolution bathymetry dataset instead, as obtained via the
*load_Bathy()* function.

For details, type:

``` r
?create_Stations
```

First, create a polygon within which stations will be created:

``` r
#Create polygons
MyPoly=create_Polys(
        data.frame(Name="mypol",
             Latitude=c(-75,-75,-70,-70),
             Longitude=c(-170,-180,-180,-170))
        ,Densify=T)

#Set the figure margins as c(bottom, left, top, right)
par(mai=c(0,0,0,0))
plot(st_geometry(Coast[Coast$ID=='88.1',]),col='grey')
plot(st_geometry(MyPoly),col='green',add=T)
text(MyPoly$Labx,MyPoly$Laby,MyPoly$ID)
box()
```

<img src="README-Fig11-1.png" width="100%" style="display: block; margin: auto;" />

Example 1. Set numbers of stations, no distance constraint:

``` r
#optional: crop your bathymetry raster to match the extent of your polygon
BathyCroped=crop(rast(SmallBathy),ext(MyPoly))

#Create stations
MyStations=create_Stations(MyPoly,BathyCroped,Depths=c(-2000,-1500,-1000,-550),N=c(20,15,10))

#add custom colors to the bathymetry to indicate the strata of interest
MyCols=add_col(var=c(-10000,10000),cuts=c(-2000,-1500,-1000,-550),cols=c('blue','cyan'))
plot(BathyCroped,breaks=MyCols$cuts,col=MyCols$cols,legend=F,axes=F,main="Example 1")
add_Cscale(height=90,fontsize=0.75,width=16,lwd=0.5,offset=-130,cuts=MyCols$cuts,cols=MyCols$cols)
plot(st_geometry(MyPoly),add=T,border='red',lwd=2,xpd=T)
plot(st_geometry(MyStations),add=T,col='orange',cex=0.75,lwd=1.5,pch=3)
```

<img src="README-Fig12-1.png" width="100%" style="display: block; margin: auto;" />

Example 2. Set numbers of stations, with distance constraint:

``` r
#Create Stations
MyStations=create_Stations(MyPoly,BathyCroped,
                           Depths=c(-2000,-1500,-1000,-550),N=c(20,15,10),dist=10)

#add custom colors to the bathymetry to indicate the strata of interest
MyCols=add_col(var=c(-10000,10000),cuts=c(-2000,-1500,-1000,-550),cols=c('blue','cyan'))
plot(BathyCroped,breaks=MyCols$cuts,col=MyCols$cols,legend=F,axes=F,main="Example 2")
add_Cscale(height=90,fontsize=0.75,width=16,lwd=0.5,offset=-130,cuts=MyCols$cuts,cols=MyCols$cols)
plot(st_geometry(MyPoly),add=T,border='red',lwd=2,xpd=T)
plot(st_geometry(MyStations[MyStations$Stratum=='1000-550',]),pch=21,bg='yellow',add=T,cex=0.75,lwd=0.1)
plot(st_geometry(MyStations[MyStations$Stratum=='1500-1000',]),pch=21,bg='orange',add=T,cex=0.75,lwd=0.1)
plot(st_geometry(MyStations[MyStations$Stratum=='2000-1500',]),pch=21,bg='red',add=T,cex=0.75,lwd=0.1)
```

<img src="README-Fig13-1.png" width="100%" style="display: block; margin: auto;" />

Example 3. Automatic numbers of stations, with distance constraint:

``` r
#Create Stations
MyStations=create_Stations(MyPoly,BathyCroped,Depths=c(-2000,-1500,-1000,-550),Nauto=30,dist=10)

#add custom colors to the bathymetry to indicate the strata of interest
MyCols=add_col(var=c(-10000,10000),cuts=c(-2000,-1500,-1000,-550),cols=c('blue','cyan'))
plot(BathyCroped,breaks=MyCols$cuts,col=MyCols$cols,legend=F,axes=F,main="Example 3")
add_Cscale(height=90,fontsize=0.75,width=16,lwd=0.5,offset=-130,cuts=MyCols$cuts,cols=MyCols$cols)
plot(st_geometry(MyPoly),add=T,border='red',lwd=2,xpd=T)
plot(st_geometry(MyStations[MyStations$Stratum=='1000-550',]),pch=21,bg='yellow',add=T,cex=0.75,lwd=0.1)
plot(st_geometry(MyStations[MyStations$Stratum=='1500-1000',]),pch=21,bg='orange',add=T,cex=0.75,lwd=0.1)
plot(st_geometry(MyStations[MyStations$Stratum=='2000-1500',]),pch=21,bg='red',add=T,cex=0.75,lwd=0.1)
```

<img src="README-Fig14-1.png" width="100%" style="display: block; margin: auto;" />

### 2.3. Create pies

The function *create_Pies()* generates pie charts that can be overlaid
on maps. The *Input* data must be a dataframe with, at least, columns
for latitude, longitude, class and value. For each location, a pie is
created with pie pieces for each class, and the size of each pie piece
depends on the proportion of each class (the value of each class divided
by the sum of values). Optionally, the area of each pie can be
proportional to a chosen variable (if that variable is different than
the value mentioned above, the *Input* data must have a fifth column and
that variable must be unique to each location). If the *Input* data
contains locations that are too close together, the data can be gridded
by setting *GridKm* (see Examples 6-8). Once pie charts have been
created, the function *add_PieLegend()* may be used to add a legend to
the figure.

For details, type:

``` r
?create_Pies
?add_PieLegend
#The examples below use the following example datasets:
View(PieData)
View(PieData2)
```

<br>

Example 1. Pies of constant size, all classes displayed:

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(6,0,0,0))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=50
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1.6,Boxexp=c(0.5,0.45,0.12,0.45),
              PieTitle="Species")
```

<img src="README-FigP01-1.png" width="100%" style="display: block; margin: auto;" />

<br>

Example 2. Pies of constant size, selected classes displayed:

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(6,0,0,0))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=50,
                   Classes=c("TOP","TOA","ANI")
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1.6,Boxexp=c(0.6,0.6,0.12,0.55),
              PieTitle="Selected species")
```

<img src="README-FigP02-1.png" width="100%" style="display: block; margin: auto;" />

<br>

Example 3. Pies of constant size, proportions below 25% are grouped in a
‘Other’ class (*N.B.*: unlike Example 2, the ‘Other’ class may contain
classes that are displayed in the legend. Please compare Example 1 and
Example 3):

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(6,0,0,0))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=50,
                   Other=25
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1.6,Boxexp=c(0.55,0.55,0.12,0.45),
              PieTitle="Other (%) class")
```

<img src="README-FigP03-1.png" width="100%" style="display: block; margin: auto;" />

<br>

Example 4. Pies of variable size (here, their area is proportional to
‘Catch’), all classes displayed, horizontal legend:

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(6,0,0,0))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=18,
                   SizeVar="Catch"
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1.6,Boxexp=c(0.16,0.1,0.1,0.4),
              PieTitle="Species",SizeTitle="Catch (t.)")
```

<img src="README-FigP04-1.png" width="100%" style="display: block; margin: auto;" />

<br>

Example 5. Pies of variable size (here, their area is proportional to
‘Catch’), all classes displayed, vertical legend:

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(0,0,0,10))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=18,
                   SizeVar="Catch"
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=2.32,PosY=0.1,Boxexp=c(0.35,0.32,0.02,0.15),
              PieTitle="Species",SizeTitle="Catch (t.)",Horiz=FALSE,LegSp=0.6)
```

<img src="README-FigP05-1.png" width="100%" style="display: block; margin: auto;" />

<br>

Example 6. Pies of constant size, all classes displayed. Too many pies
(see next example for solution):

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(6,0,0,0))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData2,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=5
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=0.4,PosY=-1.5,Boxexp=c(0.5,0.45,0.12,0.45),
              PieTitle="Species")
```

<img src="README-FigP06-1.png" width="100%" style="display: block; margin: auto;" />

<br>

Example 7. Pies of constant size, all classes displayed. Gridded
locations (in which case numerical variables in the *Input* are summed
for each grid point):

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(6,0,0,0))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData2,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=5,
                   GridKm=250
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=0.4,PosY=-1.3,Boxexp=c(0.5,0.45,0.12,0.45),
              PieTitle="Species")
```

<img src="README-FigP07-1.png" width="100%" style="display: block; margin: auto;" />

<br>

Example 8. Pies of variable size (here, their area is proportional to
‘Catch’), all classes displayed, vertical legend, gridded locations (in
which case numerical variables in the *Input* are summed for each grid
point):

``` r
#Plot the bathymetry (See section 'Local map' where B486 was created)
plot(B486,breaks=Depth_cuts,col=Depth_cols,legend=FALSE,axes=FALSE,mar=c(0,0,0,10))
#Add coastline
plot(Coast[Coast$ID=='48.6',],col='grey',lwd=0.01,add=T)
#Create pies
MyPies=create_Pies(Input=PieData2,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=3,
                   GridKm=250,
                   SizeVar='Catch'
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col,add=TRUE)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=2.8,PosY=0.15,Boxexp=c(0.38,0.32,0.08,0.18),
              PieTitle="Species",Horiz=FALSE,SizeTitle="Catch (t.)",
              SizeTitleVadj=0.8,nSizes=2)
```

<img src="README-FigP08-1.png" width="100%" style="display: block; margin: auto;" />

<br>

## 3. Load functions

### 3.1. Online use

Download the up-to-date spatial layers from the online CCAMLR GIS and
load them to your environment.

For details, type:

``` r
?load_ASDs
?load_Bathy
```

``` r
#Load ASDs, EEZs, and Coastline
ASDs=load_ASDs()
EEZs=load_EEZs()
Coastline=load_Coastline()

#Set the figure margins as c(bottom, left, top, right)
par(mai=c(0,0,0,0))
#Plot
plot(st_geometry(ASDs),col='green',border='blue')
plot(st_geometry(EEZs),col='orange',border='purple',add=T)
plot(st_geometry(Coastline),col='grey',add=T)
add_labels(mode='auto',layer='ASDs',fontsize=0.75,col='red')
box()
```

<img src="README-Fig15-1.png" width="100%" style="display: block; margin: auto;" />

### 3.2. Offline use

Since the ‘*load\_*’ functions require an internet connection, users may
desire to save layers on their hard drive for offline use. This may be
done, at the risk of not having the most up-to-date layers, as follows:

``` r
#Load all layers
ASDs=load_ASDs()
EEZs=load_EEZs()
Coastline=load_Coastline()
SSRUs=load_SSRUs()
RBs=load_RBs()
SSMUs=load_SSMUs()
MAs=load_MAs()
MPAs=load_MPAs()

#Save as .RData file (here in the temp directory, but users might want to chose their own directory)
save(list=c('ASDs','EEZs','Coastline','SSRUs','RBs','SSMUs','MAs','MPAs'),
     file = file.path(tempdir(), "CCAMLRLayers.RData"), compress='xz')

#Later, when offline load layers:
load(file.path(tempdir(), "CCAMLRLayers.RData"))
```

The *load_Bathy()* function may also be used to download and store
bathymetry data for later use, see ?load_Bathy for details.

## 4. Other functions

### 4.1. get_depths

Given a bathymetry raster and an input dataframe of
latitudes/longitudes, this function computes the depths at these
locations. The examples below use the ‘SmallBathy’ data for illustrative
purposes; users should use a higher resolution bathymetry dataset
instead, as obtained via the *load_Bathy()* function.

For details, type:

``` r
?get_depths
```

``` r
#Generate a dataframe
MyData=data.frame(Lat=PointData$Lat,
                  Lon=PointData$Lon,
                  Catch=PointData$Catch)
#The input data looks like this:
head(MyData)
#>         Lat       Lon    Catch
#> 1 -68.63966 -175.0078 53.33002
#> 2 -67.03475 -178.0322 38.66385
#> 3 -65.44164 -170.1656 20.32608
#> 4 -68.36806  151.0247 69.81201
#> 5 -63.89171  154.4327 52.32101
#> 6 -66.35370  153.6906 78.65576

#Get depths of locations
MyDataD=get_depths(Input=MyData,Bathy=SmallBathy)
#The resulting data looks like this (where 'd' is the depth):
head(MyDataD)
#>         Lat       Lon    Catch          d
#> 1 -68.63966 -175.0078 53.33002 -3790.7695
#> 2 -67.03475 -178.0322 38.66385 -3959.3145
#> 3 -65.44164 -170.1656 20.32608 -3014.6553
#> 4 -68.36806  151.0247 69.81201  -336.2152
#> 5 -63.89171  154.4327 52.32101 -3234.9985
#> 6 -66.35370  153.6906 78.65576 -1955.7587

#Plot Catch vs Depth
plot(MyDataD$d,MyDataD$Catch,xlab='Depth',ylab='Catch',pch=21,bg='red')
```

<img src="README-Fig16-1.png" width="100%" style="display: block; margin: auto;" />

### 4.2. seabed_area

Function to calculate planimetric seabed area within polygons and depth
strata in square kilometers. Its accuracy depends on the input
bathymetry raster. The examples below use the ‘SmallBathy’ data for
illustrative purposes; users should use a higher resolution bathymetry
dataset instead, as obtained via the *load_Bathy()* function. Higher
accuracy will be obtained with raw, unprojected bathymetry data.

For details, type:

``` r
?seabed_area
```

``` r
#create some polygons
MyPolys=create_Polys(PolyData,Densify=T)
#compute the seabed areas
FishDepth=seabed_area(SmallBathy,MyPolys,PolyNames="ID",depth_classes=c(0,-200,-600,-1800,-3000,-5000))
#Result looks like this (note that the 600-1800 stratum is renamed 'Fishable_area')
head(FishDepth)
#>      ID 0|-200 -200|-600 Fishable_area -1800|-3000 -3000|-5000
#> 1   one      0  19100.01      41400.01    40500.01    92700.03
#> 2   two      0    200.00       1800.00     9300.00    93300.03
#> 3 three    700   1600.00       8100.00   229400.07   138000.04
```

### 4.3. assign_areas

Given a set of polygons and a set of point locations (given in decimal
degrees), finds in which polygon those locations fall. Finds, for
example, in which ASD the given fishing locations occurred.

For details, type:

``` r
?assign_areas
```

``` r
#Generate a dataframe with random locations
MyData=data.frame(Lat=runif(100,min=-65,max=-50),
                  Lon=runif(100,min=20,max=40))
#The input data looks like this:
head(MyData)
#>         Lat      Lon
#> 1 -53.11870 34.20721
#> 2 -55.81513 25.69306
#> 3 -61.87161 29.29898
#> 4 -64.10882 34.58778
#> 5 -55.62069 22.56286
#> 6 -52.94103 38.68591

#load ASDs and SSRUs
ASDs=load_ASDs()
SSRUs=load_SSRUs()

#Assign ASDs and SSRUs to these locations 
MyData=assign_areas(MyData,Polys=c('ASDs','SSRUs'),NamesOut=c('MyASDs','MySSRUs'))
#The output data looks like this:
head(MyData)
#>         Lat      Lon  MyASDs   MySSRUs
#> 1 -53.11870 34.20721 58.4.4a 58.4.4a D
#> 2 -55.81513 25.69306    48.6    48.6 G
#> 3 -61.87161 29.29898    48.6    48.6 F
#> 4 -64.10882 34.58778  58.4.2  58.4.2 A
#> 5 -55.62069 22.56286    48.6    48.6 G
#> 6 -52.94103 38.68591 58.4.4a 58.4.4a D

#count of locations per ASD
table(MyData$MyASDs) 
#> 
#>    48.6  58.4.2 58.4.4a 
#>      53       7      40

#count of locations per SSRU
table(MyData$MySSRUs) 
#> 
#>    48.6 F    48.6 G  58.4.2 A 58.4.4a D 
#>        17        36         7        40
```

### 4.4. project_data

A simple function to project user-supplied locations. Input must be a
dataframe, outputs may be appended to the dataframe.

For details, type:

``` r
?project_data
```

``` r
#The input data looks like this:
head(PointData)
#>         Lat       Lon  name    Catch Nfishes n
#> 1 -68.63966 -175.0078   one 53.33002     460 1
#> 2 -67.03475 -178.0322   two 38.66385     945 2
#> 3 -65.44164 -170.1656   two 20.32608     374 3
#> 4 -68.36806  151.0247   two 69.81201      87 4
#> 5 -63.89171  154.4327 three 52.32101     552 5
#> 6 -66.35370  153.6906  four 78.65576      22 6
#Generate a dataframe with random locations
MyData=project_data(Input=PointData,NamesIn=c('Lat','Lon'),
                    NamesOut=c('Projected_Y','Projected_X'),append=TRUE)
#The output data looks like this:
head(MyData)
#>         Lat       Lon  name    Catch Nfishes n Projected_Y Projected_X
#> 1 -68.63966 -175.0078   one 53.33002     460 1    -2361962  -206321.41
#> 2 -67.03475 -178.0322   two 38.66385     945 2    -2545119   -87445.72
#> 3 -65.44164 -170.1656   two 20.32608     374 3    -2680488  -464656.29
#> 4 -68.36806  151.0247   two 69.81201      87 4    -2100218  1162986.84
#> 5 -63.89171  154.4327 three 52.32101     552 5    -2606157  1246832.20
#> 6 -66.35370  153.6906  four 78.65576      22 6    -2349505  1161675.96
```

### 4.5. get_C\_intersection

Get Cartesian coordinates of lines intersection in Euclidean space. This
may have several uses, including when creating polygons with shared
boundaries. Uses the coordinates of line extremities as input.

For details, type:

``` r
?get_C_intersection
```

``` r
#Prepare layout for 4 sub-plots
par(mfrow=c(2,2),mai=c(0.8,0.8,0.2,0.05))

#Example 1 (Intersection beyond the range of segments)
get_C_intersection(Line1=c(-30,-55,-29,-50),Line2=c(-50,-60,-40,-60))
#> Lon Lat 
#> -31 -60
text(-40,-42,"Example 1",xpd=T)
box()
#Example 2 (Intersection on one of the segments)
get_C_intersection(Line1=c(-30,-65,-29,-50),Line2=c(-50,-60,-40,-60))
#>       Lon       Lat 
#> -29.66667 -60.00000
text(-40,-41,"Example 2",xpd=T)
box()
#Example 3 (Crossed segments)
get_C_intersection(Line1=c(-30,-65,-29,-50),Line2=c(-50,-60,-25,-60))
#>       Lon       Lat 
#> -29.66667 -60.00000
text(-38,-41,"Example 3",xpd=T)
box()
#Example 4 (Antimeridian crossed)
get_C_intersection(Line1=c(-179,-60,-150,-50),Line2=c(-120,-60,-130,-62))
#> Warning in get_C_intersection(Line1 = c(-179, -60, -150, -50), Line2 =
#> c(-120, : Antimeridian crossed. Find where your line crosses it first, using
#> Line=c(180,-90,180,0) or Line=c(-180,-90,-180,0).
#>        Lon        Lat 
#> -260.47619  -88.09524
text(-180,-37,"Example 4",xpd=T)
box()
```

<img src="README-Fig16b-1.png" width="100%" style="display: block; margin: auto;" />

## 5. Adding colors, legends and labels

### 5.1. Bathymetry colors

Coloring bathymetry requires a vector of depth classes and a vector of
colors. Colors are applied between depth classes (so there is one less
color than there are depth classes). Two sets of bathymetry colors are
included in the package. One simply colors the bathymetry in shades of
blue (*Depth_cols* and *Depth_cuts*), the other adds shades of green to
highlight the Fishable Depth range (600-1800m; *Depth_cols2* and
*Depth_cuts2*). The examples below use the ‘SmallBathy’ data for
illustrative purposes; users should use a higher resolution bathymetry
dataset instead, as obtained via the *load_Bathy()* function.

#### Simple set of colors:

``` r
#Set the figure margins as c(bottom, left, top, right)
par(mai=c(0,0.4,0,0))
#Plot the bathymetry
plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=FALSE,box=FALSE,legend=FALSE)
#Add color scale
add_Cscale(cuts=Depth_cuts,cols=Depth_cols,fontsize=0.75,height=80,offset=-500,width=16,maxVal=-1)
```

<img src="README-Fig17-1.png" width="100%" style="display: block; margin: auto;" />

#### Highlighting the Fishable Depth range:

``` r
#Set the figure margins as c(bottom, left, top, right)
par(mai=c(0,0.4,0,0))
#Plot the bathymetry
plot(SmallBathy,breaks=Depth_cuts2,col=Depth_cols2,axes=FALSE,box=FALSE,legend=FALSE)
#Add color scale
add_Cscale(cuts=Depth_cuts2,cols=Depth_cols2,fontsize=0.75,height=80,offset=-500,width=16,maxVal=-1)
```

<img src="README-Fig18-1.png" width="100%" style="display: block; margin: auto;" />

### 5.2. Adding colors to data

Adding colors to plots revolves around two functions:

``` r
?add_col
#and
?add_Cscale
```

*add_col()* generates colors for a variable of interest as well as a set
of color classes and colors to be used as inputs to the *add_Cscale()*
function. Colors and color classes may be generated automatically or
customized, depending on the intended appearance. Knowing the names of
colors in R would be useful here
(<http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf>).

``` r
#Adding color to points

#Prepare layout for 3 sub-plots
par(mfrow=c(3,1),mai=c(0.1,0.1,0.1,1))
#Create some points
MyPoints=create_Points(PointData)

#Example 1: Add default cols and cuts
MyCols=add_col(MyPoints$Nfishes) 
plot(st_geometry(MyPoints),pch=21,bg=MyCols$varcol,main='Example 1:',cex.main=0.75,cex=1.5,lwd=0.5)
box()
add_Cscale(title='Number of fishes',
           height=95,fontsize=0.75,width=16,lwd=1,offset=0,
           cuts=MyCols$cuts,cols=MyCols$cols)

#Example 2: Given the look of example 1, reduce the number of cuts and round their values (in add_Cscale)
MyCols=add_col(MyPoints$Nfishes,cuts=10) 
plot(st_geometry(MyPoints),pch=21,bg=MyCols$varcol,main='Example 2:',cex.main=0.75,cex=1.5,lwd=0.5)
box()
add_Cscale(title='Number of fishes',
           height=95,fontsize=0.75,width=16,lwd=1,offset=0,
           cuts=round(MyCols$cuts,1),cols=MyCols$cols)

#Example 3: same as example 2 but with custom colors
MyCols=add_col(MyPoints$Nfishes,cuts=10,cols=c('black','yellow','purple','cyan')) 
plot(st_geometry(MyPoints),pch=21,bg=MyCols$varcol,main='Example 3:',cex.main=0.75,cex=1.5,lwd=0.5)
add_Cscale(title='Number of fishes',
           height=95,fontsize=0.75,width=16,lwd=1,offset=0,
           cuts=round(MyCols$cuts,1),cols=MyCols$cols)
box()
```

<img src="README-Fig19-1.png" width="80%" style="display: block; margin: auto;" />

``` r
#Adding colors to a grid with custom cuts (see also the last example in section 2.1.)

#Step 1: Generate your grid
MyGrid=create_PolyGrids(GridData,Area=10000)

#Step 2: Inspect your gridded data (e.g. hist(MyGrid$Catch_sum,100))
#to determine whether irregular cuts are required.
#In this case (heterogeneously distributed data) irregular cuts 
#would be preferable, such as:
MyCuts=c(0,50,100,500,2000,2500)

#Step 3: Generate colors according to the desired classes (MyCuts)
Gridcol=add_col(MyGrid$Catch_sum,cuts=MyCuts,cols=c('blue','white','red'))

#Step 4: Plot result and add color scale
par(mai=c(0,0,0,1.5)) #set plot margins as c(bottom, left, top, right)
#Use the colors generated by add_col
plot(st_geometry(MyGrid),col=Gridcol$varcol,lwd=0.1) 
#Add color scale using cuts and cols generated by add_col
add_Cscale(title='Sum of Catch (t)',cuts=Gridcol$cuts,cols=Gridcol$cols,width=22,
     fontsize=0.75,lwd=1) 
```

<img src="README-Fig20-1.png" width="100%" style="display: block; margin: auto;" />

### 5.3. Adding legends

To add a legend, use the base *legend()* function:

``` r
?legend
```

To position the legend, the *add_Cscale()* function can generate legend
coordinates which correspond to the top-left corner of the legend box.
These may be adjusted using the ‘pos’, ‘height’ and ‘offset’ arguments
within *add_Cscale()*, *e.g.*:

``` r
Legend_Coordinates=add_Cscale(pos='2/3',offset=1000,height=40,mode="Legend")
```

``` r
#Adding a color scale and a legend

#Create some point data
MyPoints=create_Points(PointData)

#Crop the bathymetry to match the extent of MyPoints (extended extent)
BathyCr=crop(rast(SmallBathy),extend(ext(MyPoints),100000))
#Plot the bathymetry
plot(BathyCr,breaks=Depth_cuts,col=Depth_cols,legend=F,axes=F,mar=c(0,0,0,7))
#Add a color scale
add_Cscale(pos='3/8',height=50,maxVal=-1,minVal=-4000,fontsize=0.75,lwd=1,width=16)

#Plot points with different symbols and colors (see ?points)
Psymbols=c(21,22,23,24)
Pcolors=c('red','green','blue','yellow')
plot(st_geometry(MyPoints[MyPoints$name=='one',]),pch=Psymbols[1],bg=Pcolors[1],add=T)
plot(st_geometry(MyPoints[MyPoints$name=='two',]),pch=Psymbols[2],bg=Pcolors[2],add=T)
plot(st_geometry(MyPoints[MyPoints$name=='three',]),pch=Psymbols[3],bg=Pcolors[3],add=T)
plot(st_geometry(MyPoints[MyPoints$name=='four',]),pch=Psymbols[4],bg=Pcolors[4],add=T)

#Add legend with position determined by add_Cscale
Loc=add_Cscale(pos='7/8',height=40,mode='Legend')
legend(Loc,legend=c('one','two','three','four'),
       title='Vessel',pch=Psymbols,pt.bg=Pcolors,xpd=T,
       box.lwd=1,cex=0.75,pt.cex=1,y.intersp=1.5)
```

<img src="README-Fig21-1.png" width="100%" style="display: block; margin: auto;" />

### 5.4. Adding labels

To add labels, use the *add_labels()* function:

``` r
?add_labels
```

Three modes are available within the *add_labels()* function:

-   In ‘auto’ mode, labels are placed at the centres of polygon parts of
    spatial objects loaded via the *load\_* functions.
-   In ‘manual’ mode, users may click on their plot to position labels.
    An editable label table is generated to allow fine-tuning of labels
    appearance, and may be saved for later use. To edit the label table,
    double-click inside one of its cells, edit the value, then close the
    table.
-   In ‘input’ mode, a label table that was generated in ‘manual’ mode
    is re-used.

``` r
#Example 1: 'auto' mode
#label ASDs in bold and red
ASDs=load_ASDs()
#set plot margins as c(bottom, left, top, right)
par(mai=c(0,0,0,0))
plot(st_geometry(ASDs))
add_labels(mode='auto',layer='ASDs',fontsize=0.75,fonttype=2,col='red')
#add MPAs and EEZs and their labels in large, green and vertical text
MPAs=load_MPAs()
EEZs=load_EEZs()
plot(st_geometry(MPAs),add=TRUE,border='green')
plot(st_geometry(EEZs),add=TRUE,border='green')
add_labels(mode='auto',layer=c('EEZs','MPAs'),fontsize=1,col='green',angle=90)
```

<img src="README-Fig22-1.png" width="100%" style="display: block; margin: auto;" />

``` r
#Example 2: 'auto' and 'input' modes
#This example is not executed here because it needs user interaction.
#Please copy and paste it in the Console to see how it works.

#Prepare a basemap
plot(SmallBathy)
ASDs=load_ASDs()
plot(st_geometry(ASDs),add=T)

#Build your labels
MyLabels=add_labels(mode='manual') 

#Re-use the label table generated (if desired)
plot(SmallBathy)
plot(st_geometry(ASDs),add=T)
add_labels(mode='input',LabelTable=MyLabels)
```

### 5.5. Using sf

Depending on the function used, the CCAMLRGIS package computes data
summaries and includes them in the resulting spatial object. For
example, *create_Polys* takes any numerical values included in the
*Input* data frame and computes, for each polygon, the minimum, maximum,
mean, median, sum, count and standard deviation of values associated
with each polygon. The *sf* package has some useful plotting methods,
some of which are shown below.

``` r
#First, let's create some example polygons
MyPolys=create_Polys(PolyData)

#MyPolys is an sf object; it is a data frame that includes a column named 'geometry':
kableExtra::kable(MyPolys,row.names = F)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
ID
</th>
<th style="text-align:right;">
Catch_min
</th>
<th style="text-align:right;">
Nfishes_min
</th>
<th style="text-align:right;">
n_min
</th>
<th style="text-align:right;">
Catch_max
</th>
<th style="text-align:right;">
Nfishes_max
</th>
<th style="text-align:right;">
n_max
</th>
<th style="text-align:right;">
Catch_mean
</th>
<th style="text-align:right;">
Nfishes_mean
</th>
<th style="text-align:right;">
n_mean
</th>
<th style="text-align:right;">
Catch_sum
</th>
<th style="text-align:right;">
Nfishes_sum
</th>
<th style="text-align:right;">
n_sum
</th>
<th style="text-align:right;">
Catch_count
</th>
<th style="text-align:right;">
Nfishes_count
</th>
<th style="text-align:right;">
n_count
</th>
<th style="text-align:right;">
Catch_sd
</th>
<th style="text-align:right;">
Nfishes_sd
</th>
<th style="text-align:right;">
n_sd
</th>
<th style="text-align:right;">
Catch_median
</th>
<th style="text-align:right;">
Nfishes_median
</th>
<th style="text-align:right;">
n_median
</th>
<th style="text-align:left;">
geometry
</th>
<th style="text-align:right;">
AreaKm2
</th>
<th style="text-align:right;">
Labx
</th>
<th style="text-align:right;">
Laby
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
one
</td>
<td style="text-align:right;">
52.61262
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
71.65909
</td>
<td style="text-align:right;">
329
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
64.17380
</td>
<td style="text-align:right;">
172.5000
</td>
<td style="text-align:right;">
2.5
</td>
<td style="text-align:right;">
256.6952
</td>
<td style="text-align:right;">
690
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
9.084736
</td>
<td style="text-align:right;">
153.3917
</td>
<td style="text-align:right;">
1.290994
</td>
<td style="text-align:right;">
66.21175
</td>
<td style="text-align:right;">
175.0
</td>
<td style="text-align:right;">
2.5
</td>
<td style="text-align:left;">
POLYGON ((-290035.9 -164487…
</td>
<td style="text-align:right;">
187281.3
</td>
<td style="text-align:right;">
-170519.8
</td>
<td style="text-align:right;">
-1949051
</td>
</tr>
<tr>
<td style="text-align:left;">
two
</td>
<td style="text-align:right;">
23.12032
</td>
<td style="text-align:right;">
116
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:right;">
73.49383
</td>
<td style="text-align:right;">
954
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
51.94951
</td>
<td style="text-align:right;">
505.0000
</td>
<td style="text-align:right;">
6.5
</td>
<td style="text-align:right;">
207.7980
</td>
<td style="text-align:right;">
2020
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
22.264999
</td>
<td style="text-align:right;">
428.9188
</td>
<td style="text-align:right;">
1.290994
</td>
<td style="text-align:right;">
55.59195
</td>
<td style="text-align:right;">
475.0
</td>
<td style="text-align:right;">
6.5
</td>
<td style="text-align:left;">
POLYGON ((-423880.7 -240394…
</td>
<td style="text-align:right;">
95294.2
</td>
<td style="text-align:right;">
0.0
</td>
<td style="text-align:right;">
-2483470
</td>
</tr>
<tr>
<td style="text-align:left;">
three
</td>
<td style="text-align:right;">
10.23393
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
95.57774
</td>
<td style="text-align:right;">
988
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
52.50313
</td>
<td style="text-align:right;">
412.3333
</td>
<td style="text-align:right;">
11.5
</td>
<td style="text-align:right;">
315.0188
</td>
<td style="text-align:right;">
2474
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
32.152675
</td>
<td style="text-align:right;">
382.8685
</td>
<td style="text-align:right;">
1.870829
</td>
<td style="text-align:right;">
54.15367
</td>
<td style="text-align:right;">
341.5
</td>
<td style="text-align:right;">
11.5
</td>
<td style="text-align:left;">
POLYGON ((480755.1 -2726497…
</td>
<td style="text-align:right;">
361556.2
</td>
<td style="text-align:right;">
786933.1
</td>
<td style="text-align:right;">
-2846388
</td>
</tr>
</tbody>
</table>

The ‘geometry’ column contains the locations of each point of a given
polygon (each row), and can be plotted using
*plot(st_geometry(MyPolys))*, as shown previously in this document.
Alternatively, one can use *plot(MyPolys)* directly:

``` r
plot(MyPolys)
#> Warning: plotting the first 9 out of 25 attributes; use max.plot = 25 to plot
#> all
```

<img src="README-Fig23-1.png" width="100%" style="display: block; margin: auto;" />

This results in a warning *Warning: plotting the first 9 out of 25
attributes…* and a 9-panel plot as shown above, with each panel
corresponding to each column present in *MyPolys* and automatic colors
generated according to the values in each column. In order to plot only
one variable, it must be named in the plotting command:

``` r
plot(MyPolys["Catch_mean"])
```

<img src="README-Fig24-1.png" width="100%" style="display: block; margin: auto;" />

There are several available options, for example:

``` r
Gr=st_graticule(MyPolys,lon=seq(-180,180,by=5),lat=seq(-80,0,by=2.5))
plot(MyPolys["Catch_mean"],
     graticule=Gr,axes=T,key.pos=1,key.width=0.2,key.length=0.8,breaks=seq(50,65,by=2.5))
```

<img src="README-Fig25-1.png" width="100%" style="display: block; margin: auto;" />

Where:

-   *key.pos* controls the color legend position as 1=below, 2=left,
    3=above and 4=right,

-   *key.width* and *key.length* control the size of the color legend,

-   *breaks* controls the classes,

-   The function *st_graticule* generates a Lat/Lon grid.

Additionally, *sf* objects can be plotted using *ggplot2*. For example:

``` r
library(ggplot2)
ggplot() + 
  geom_sf(data = MyPolys, aes(fill = Catch_mean))
```

<img src="README-Fig26-1.png" width="100%" style="display: block; margin: auto;" />

Using *ggplot2* and *gridExtra*, multi-panel plots can be drawn:

``` r
library(gridExtra)
map1 <- ggplot() +
  geom_sf(data = MyPolys, aes(fill = Catch_mean)) + 
  labs(title="Mean catch")

map2 <- ggplot() +
  geom_sf(data = MyPolys, aes(fill = Catch_sd)) + 
  labs(title="S.D. of catch")

map3 <- ggplot() +
  geom_sf(data = MyPolys, aes(fill = AreaKm2)) + 
  labs(title="Polygon area")

grid.arrange(map1, map2, map3, ncol=2)
```

<img src="README-Fig27-1.png" width="100%" style="display: block; margin: auto;" />
