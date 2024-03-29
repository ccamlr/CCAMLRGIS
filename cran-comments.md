
## Test environments

* win-builder (devel and release, 64 and 32bit)
* Rhub


## R CMD check results

* There were no ERRORS, WARNINGS, or NOTES except for:

2 Notes on Windows Server 2022, R-devel, 64 bit: 

- Found the following files/directories: ''NULL''
- checking for detritus in the temp directory: 'lastMiKTeXException'

1 Note on Fedora Linux, R-devel, clang, gfortran; and on Ubuntu Linux 20.04.1 LTS, R-release, GCC:

- Skipping checking HTML validation: no command 'tidy' found

## Notes about CRAN edits

### V4.0.7

Updated SmallBathy() and coastline accessed by load_Coastline().

### Previous versions

* Added Rotate_obj() function.
* Added create_Arrow() function. Fixed bug in seabed_area(). SmallBathy is now a function, not an object.
* Improved add_Cscale() and updated SmallBathy.
* Improved create_Pies().
* Improved DensifyData().
* Added get_iso_polys() function.
* Moved all operations from sp/raster to sf/terra. Added get_C_intersection() function.
* Now the vignette links to the GitHub README to avoid CRAN Checks issues.
* Added create_Pies() and add_PieLegend() functions.
* Added load_Bathy() function.
* Shortened Vignette to pass CRAN tests.
* Added area and centroid for each cell created using create_PolyGrids().
* Moved to using EPSG codes in spatial operations.
* Added NamesIn parameter in create_x functions.
* Changed handling of packages dependencies.
* Changed crs argument to accommodate rgdal and sp updates.
* Modified create_PolyGrids() function to avoid locations falling on edges between cells.
* Added p4s argument in load functions to force the Lambert azimuthal equal-area projection when loading via GEOJSON.
* replaced T by TRUE and F by FALSE.
* on.exit() was used in the get_depths function (option call is needed to produce acurate contours).
* cat() was replaced by either warning() or message() when needed.
* replaced dontrun{} by donttest{} (necessary because some example are slow, because they use a call to load a GEOJSON file from an online source - and this seems slow during checks()).
* modified par() calls as requested.
* directed save() calls to temp directory.
* added more details in description file.

