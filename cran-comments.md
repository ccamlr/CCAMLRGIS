## Test environments

* win-builder (devel and release, 64 and 32bit)
* R-hub

## R CMD check results

* there were no ERRORs, WARNINGs OR NOTES. 

## Notes about CRAN edits

* replaced T by TRUE and F by FALSE
* on.exit() was used in the get_depths function (option call is needed to produce acurate contours)
* cat() was replaced by either warning() or message() when needed
* replaced dontrun{} by donttest{} (necessary because some example are slow, because they use a call to load a GEOJSON file from an online source - and this seems slow during checks())
* modified par() calls as requested
* directed save() calls to temp directory
* added more details in description file

