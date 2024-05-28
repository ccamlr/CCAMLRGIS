
## Test environments

win-builder (devel and release, 64 and 32bit).
devtools::check_win_devel() OK - see: https://win-builder.r-project.org/hwj3PeEOv56P/00check.log

OK on Rhubv2 for platfroms as follows:

* 1 [VM] linux          R-* (any version)                     ubuntu-latest on GitHub
* 2 [VM] macos          R-* (any version)                     macos-13 on GitHub
* 3 [VM] macos-arm64    R-* (any version)                     macos-latest on GitHub
* 4 [VM] windows        R-* (any version)                     windows-latest on GitHub
* 5 [CT] atlas          R-devel (2024-05-26 r86629)           Fedora Linux 38 (Container Image)
* 6 [CT] c23            R-devel (2024-05-25 r86622)           Ubuntu 22.04.4 LTS
* 8 [CT] clang16        R-devel (2024-05-25 r86622)           Ubuntu 22.04.4 LTS
* 9 [CT] clang17        R-devel (2024-05-25 r86622)           Ubuntu 22.04.4 LTS
* 10 [CT] clang18        R-devel (2024-05-25 r86622)           Ubuntu 22.04.4 LTS
* 11 [CT] clang19        R-devel (2024-05-25 r86622)           Ubuntu 22.04.4 LTS
* 12 [CT] donttest       R-devel (2024-05-25 r86622)           Ubuntu 22.04.4 LTS
* 13 [CT] gcc13          R-devel (2024-05-26 r86629)           Fedora Linux 38 (Container Image)
* 14 [CT] gcc14          R-devel (2024-05-26 r86629)           Fedora Linux 40 (Container Image)
* 15 [CT] intel          R-devel (2024-05-26 r86629)           Fedora Linux 38 (Container Image)
* 16 [CT] mkl            R-devel (2024-05-26 r86629)           Fedora Linux 38 (Container Image)
* 17 [CT] nold           R-devel (2024-05-26 r86629)           Ubuntu 22.04.4 LTS
* 20 [CT] ubuntu-clang   R-devel (2024-05-26 r86629)           Ubuntu 22.04.4 LTS
* 21 [CT] ubuntu-gcc12   R-devel (2024-05-26 r86629)           Ubuntu 22.04.4 LTS
* 22 [CT] ubuntu-next    R-4.4.0 (patched) (2024-05-26 r86628) Ubuntu 22.04.4 LTS
* 23 [CT] ubuntu-release R-4.4.0 (2024-04-24)                  Ubuntu 22.04.4 LTS


See https://github.com/ccamlr/CCAMLRGIS/actions/runs/9261819776

## Check results

* There were no ERRORS, WARNINGS, or NOTES.

## Notes about CRAN edits

### V4.1.1

Optimized create_Arrow().

### Previous versions

* Modified add_Legend() behavior. Updated add_Cscale(), get_iso_polys() and Basemaps.
* Added create_Hashes() and add_Legend() functions. Modified get_iso_polys().
* Updated SmallBathy() and coastline accessed by load_Coastline().
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

