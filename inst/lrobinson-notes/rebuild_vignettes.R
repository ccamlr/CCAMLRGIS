# vignette rebuilding 

devtools::build()

rmarkdown::render("vignettes/CCAMLRGIS_R.Rmd")

pkgdown::build_site()
