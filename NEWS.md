# CCAMLRGIS 3.0.3

Modified the way locations that are falling on a grid cell edge are dealt with (what was done in Version 3.0.2 did not always work). This sometimes occurs when building equal-area grids using create_PolyGrids. Now, those locations that are falling between cells are isolated and their Latitude and Longitude are randomly shifted by -0.0001 or +0.0001. This is done within a while loop, and, while there are locations that do not fall inside a cell, their locations are randomly shifted by a value increasing by 0.0001 increments (e.g., at the third unsuccessful iteration, Latitudes and Longitudes are randomly shifted by -0.0003 or +0.0003).

# CCAMLRGIS 3.0.2

Simplified Depth_cols and Depth_cuts. Added Depth_cols2 and Depth_cuts2 in which the Fishable Depth is highlighted in shades of green.

In create_PolyGrids, when using equal area, added a condition to shift latitudes by -0.0001 degree for those latitudes that are too close to an integer value. Without this fix, those latitudes were not assigned to a grid cell as they were falling on an edge between cells.

In create_PolyGrids, added the possibility to only input Lat/Lon without data, in which case the count of locations is gridded.

In add_RefGrid, added the possibility to place LabLon wherever desired (ie not constrained to the grid produced by ResLat and ResLon).


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



