% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CCAMLRGIS_DataDescription.R
\docType{data}
\name{SmallBathy}
\alias{SmallBathy}
\title{Small bathymetry dataset}
\format{
raster
}
\usage{
data(SmallBathy)
}
\description{
Bathymetry dataset derived from the \href{https://www.gebco.net/}{GEBCO 2020} dataset.
Subsampled using raster's \link[raster]{resample} function, using the nearest neighbor method
at a 10,000m resolution. Projected using the CCAMLR standard projection (\code{\link{CCAMLRp}}).
To highlight the Fishable Depth range, use \code{\link{Depth_cols2}} and \code{\link{Depth_cuts2}}.
\strong{To be only used for large scale illustrative purposes}. Please refer to the package's vignette
(\code{browseVignettes("CCAMLRGIS")}; see Section 1) to produce a higher resolution raster, suitable for analyses.
}
\examples{
plot(SmallBathy,breaks=Depth_cuts,col=Depth_cols,axes=FALSE,box=FALSE)
}
\references{
GEBCO Compilation Group (2020) GEBCO 2020 Grid (doi:10.5285/a29c5465-b138-234d-e053-6c86abc040b9)
}
\seealso{
\code{\link{add_col}}, \code{\link{add_Cscale}}, \code{\link{Depth_cols}}, \code{\link{Depth_cuts}},
\code{\link{Depth_cols2}}, \code{\link{Depth_cuts2}}, \code{\link{get_depths}}, \code{\link{create_Stations}}.
}
