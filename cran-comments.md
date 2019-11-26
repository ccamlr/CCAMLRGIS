## Test environments

* win-builder (devel and release)
* R-hub

## R CMD check results

There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* installed size is 32.8Mb
  sub-directories of 1Mb or more:
  data  32.0Mb
  
This relates to 'SmallBathy' which is a bathymetry raster that is needed in the Package.
It has been sub-sampled to a minimum acceptable size.