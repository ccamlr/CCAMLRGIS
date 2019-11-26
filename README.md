
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CCAMLRGIS R package

The CCAMLRGIS package was developed to simplify the production of maps
in the CCAMLR Convention Area. It provides two categories of functions:
load functions and create functions. Load functions are used to import
spatial layers from the online CCAMLR GIS (<https://gis.ccamlr.org/>)
such as the ASD boundaries. Create functions are used to create layers
from user data such as polygons and grids.

## Installation

You can install the CCAMLRGIS R package from CRAN with:

``` r
install.packages("CCAMLRGIS")
```

You can install the CCAMLRGIS R package from github with:

``` r
#You'll need Rtools:
https://cran.r-project.org/bin/windows/Rtools/
#In R, first install devtools:
install.packages("devtools")
#rlang is also needed:
install.packages("rlang")
#Then install the package:
devtools::install_github("ccamlr/CCAMLRGIS",build_vignettes=TRUE)
```
