% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load.R
\name{load_EEZs}
\alias{load_EEZs}
\title{Load Exclusive Economic Zones}
\usage{
load_EEZs()
}
\description{
Download the up-to-date spatial layer from the online CCAMLRGIS (\url{https://gis.ccamlr.org/}) and load it to your environment.
See examples for offline use. All layers use the Lambert azimuthal equal-area projection
 (\code{\link{CCAMLRp}})
}
\examples{
 
\donttest{

#When online:
EEZs=load_EEZs()
plot(st_geometry(EEZs))

#For offline use, see:
#https://github.com/ccamlr/CCAMLRGIS#32-offline-use

}

}
\seealso{
\code{\link{load_ASDs}}, \code{\link{load_SSRUs}}, \code{\link{load_RBs}},
\code{\link{load_SSMUs}}, \code{\link{load_MAs}}, \code{\link{load_Coastline}},
\code{\link{load_MPAs}}.
}
