# CCAMLRGIS 3.0.1

Added p4s argument in load functions to force the Lambert azimuthal equal-area projection when loading via GEOJSON. 

# CCAMLRGIS 3.0.0

Recoded the entire package
Added several new functions:
  add_col	Add colors
  add_Cscale	Add a color scale
  add_labels	Add labels
  add_RefGrid	Add a Reference grid
  assign_areas	Assign Areas
  create_Stations	Create Stations
  get_depths	Get depths of locations from bathymetry raster
Added bathymetry data


# CCAMLRGIS 2.2.3.9000

small patches to existing load functions after the issue with rdgal readOGR fcn was resolved

this version will only run on R versions >= 3.4.0 


# CCAMLRGIS 2.2.0.9000

Seabed area estimation function and example bathymetry data added 

Functionalities to be added in the near-medium term:

extract_area functions to assign management area codes to georeferenced point data 


# CCAMLRGIS 2.1.0.9000

create_Lines and create_Points functions have been added

Vignette updated with new functions

Automated testing from travis and appveyor



