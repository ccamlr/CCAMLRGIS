## Test environments

* win-builder (devel and release)
* R-hub

## R CMD check results

* For windows: There were no ERRORs or WARNINGs. 

There was 1 NOTE:

installed size is 32.8Mb
sub-directories of 1Mb or more:
data  32.0Mb
  
This relates to 'SmallBathy' which is a bathymetry raster that is needed in the Package.
It has been sub-sampled to a minimum acceptable size.

* For Linux: There is an issue with rgdal which is out of my control, error message is:

checking GDAL version >= 1.11.4... no
configure: error: upgrade GDAL to 1.11.4 or later
ERROR: configuration failed for package ‘rgdal’
