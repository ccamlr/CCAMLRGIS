## Test environments

* win-builder (devel and release, 64 and 32bit)
* Rhub


## R CMD check results

* There were no ERRORS, WARNINGS OR NOTES on Windows OS. 
* 1 NOTE on other platforms: package was archived (I don't know why it was)

## Notes about CRAN edits

* Added create_Pies() and add_PieLegend() functions
* Added load_Bathy() function
* Shortened Vignette to pass CRAN tests
* Added area and centroid for each cell created using create_PolyGrids
* Moved to using EPSG codes in spatial operations
* Added NamesIn parameter in create_x functions
* Changed handling of packages dependencies
* Changed crs argument to accommodate rgdal and sp updates
* Modified create_PolyGrids function to avoid locations falling on edges between cells.
* Added p4s argument in load functions to force the Lambert azimuthal equal-area projection when loading via GEOJSON.
* replaced T by TRUE and F by FALSE.
* on.exit() was used in the get_depths function (option call is needed to produce acurate contours).
* cat() was replaced by either warning() or message() when needed.
* replaced dontrun{} by donttest{} (necessary because some example are slow, because they use a call to load a GEOJSON file from an online source - and this seems slow during checks()).
* modified par() calls as requested.
* directed save() calls to temp directory.
* added more details in description file.

