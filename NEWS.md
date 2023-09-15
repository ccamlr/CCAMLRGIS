# CCAMLRGIS 4.0.5

Added create_Arrow() function.
Fixed bug in seabed_area caused by change in terra::expanse.
Changed SmallBathy, now requires parentheses eg: plot(SmallBathy()).
Fixed some dependencies issues.

# CCAMLRGIS 4.0.4

Improved create_Pies() when gridding is required. Added finer controls of color legend in add_Cscale().
Updated SmallBathy to GEBCO 2022.


# CCAMLRGIS 4.0.3

New implementation of line densification. Now all lines than span more than 0.1 degree longitude are densified (before, only isolatitude lines were densified).

# CCAMLRGIS 4.0.2

Added get_iso_polys function.

# CCAMLRGIS 4.0.1

Re-built manual as per CRAN instructions (switch to HTML5): Removed bold emphasis on text.

# CCAMLRGIS 4.0.0

Due to the incoming retirement of packages rgdal and rgeos, the CCAMLRGIS package has been recoded to use the packages sf and terra. The main difference to users is that in order to plot objects, one must replace:

plot(MyObject)

with:

plot(st_geometry(MyObject))

Also, to access the data inside objects, instead of MyObject@data, type MyObject directly.

Convert sf objects to sp objects using as_Spatial() if preferred.

Simplified create_X() functions to only use dataframe input.

Added get_C_intersection() function.

Removed distance to isobath calculations in get_depths().

# CCAMLRGIS 3.2.0

Added the create_Pies and add_PieLegend functions.

# CCAMLRGIS 3.1.0

Added the load_Bathy function.

# CCAMLRGIS 3.0.7

Added the area and centroid location for each cell in the outputs of create_PolyGrids. 

# CCAMLRGIS 3.0.6

Moved to spatial operations using EPSG codes. Now using EPSG:6932 to project to Lambert azimuthal equal-area projection. This was included in all internal projections as well as load_ functions.

Added project_data function.

Added Latitudes/Longitudes to label table when using the add_labels function in 'manual' mode. This may be used to find Latitudes/Longitudes by clicking on a map.

Updated SmallBathy to GEBCO 2020.

assign_areas doesn't re-order columns of the input dataframe any more (when using NamesIn parameter).

# CCAMLRGIS 3.0.5

Changed how other packages and functions are loaded when CCAMLRGIS is loaded. Now, only sp is loaded (unavoidable) which removes some past package conflicts (e.g., masking of dplyr functions when raster was loaded).

Added 'NamesIn' parameter to assign_areas, get_depths and create_x functions. See help on these functions for details.

Added a warning in assign_areas when 'Input' locations are impossible (Latitudes not within -90 to 90 and Longitudes not within -180 to 180).


# CCAMLRGIS 3.0.4

Changed crs arguments to accommodate rgdal and sp updates.

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



