% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Pies.R
\name{add_PieLegend}
\alias{add_PieLegend}
\title{Add a legend to Pies}
\usage{
add_PieLegend(
  Pies = NULL,
  bb = NULL,
  PosX = 0,
  PosY = 0,
  Size = 25,
  lwd = 1,
  Boxexp = c(0.2, 0.2, 0.12, 0.3),
  Boxbd = "white",
  Boxlwd = 1,
  Labexp = 0.3,
  fontsize = 1,
  LegSp = 0.5,
  Horiz = TRUE,
  PieTitle = "Pie chart",
  SizeTitle = "Size chart",
  PieTitleVadj = 0.5,
  SizeTitleVadj = 0.3,
  nSizes = 3,
  SizeClasses = NULL
)
}
\arguments{
\item{Pies}{Spatial object created using \link{create_Pies}.}

\item{bb}{Spatial object, sf bounding box created with \code{st_bbox()}. If provided,
the legend will be centered in that bb. Otherwise it is centered on the \code{min(Latitudes)}
and \code{median(Longitudes)} of coordinates found in the input \code{Pies}.}

\item{PosX}{numeric, horizontal adjustment of legend.}

\item{PosY}{numeric, vertical adjustment of legend.}

\item{Size}{numeric, controls the size of pies.}

\item{lwd}{numeric, line thickness of pies.}

\item{Boxexp}{numeric, vector of length 4 controls the expansion of the legend box, given
as \code{c(xmin,xmax,ymin,ymax)}.}

\item{Boxbd}{character, color of the background of the legend box.}

\item{Boxlwd}{numeric, line thickness of the legend box. Set to zero if no box is desired.}

\item{Labexp}{numeric, controls the distance of the pie labels to the center of the pie.}

\item{fontsize}{numeric, size of the legend font.}

\item{LegSp}{numeric, spacing between the pie and the size chart (only used if \code{SizeVar}
was specified in \link{create_Pies}).}

\item{Horiz}{logical. Set to FALSE for vertical layout (only used if \code{SizeVar}
was specified in \link{create_Pies}).}

\item{PieTitle}{character, title of the pie chart.}

\item{SizeTitle}{character, title of the size chart (only used if \code{SizeVar}
was specified in \link{create_Pies}).}

\item{PieTitleVadj}{numeric, vertical adjustment of the title of the pie chart.}

\item{SizeTitleVadj}{numeric, vertical adjustment of the title of the size chart (only used if \code{SizeVar}
was specified in \link{create_Pies}).}

\item{nSizes}{integer, number of size classes to display in the size chart. Minimum and maximum sizes are
displayed by default. (only used if \code{SizeVar} was specified in \link{create_Pies}).}

\item{SizeClasses}{numeric, vector (e.g. c(1,10,100)) of size classes to display in the size chart
(only used if \code{SizeVar} was specified in \link{create_Pies}). If set, overrides \code{nSizes}.}
}
\value{
Adds a legend to a pre-existing pie plot.
}
\description{
Adds a legend to pies created using \link{create_Pies}.
}
\examples{

# For more examples, see:
# https://github.com/ccamlr/CCAMLRGIS#23-create-pies

#Pies of constant size, all classes displayed:
#Create pies
MyPies=create_Pies(Input=PieData,
                   NamesIn=c("Lat","Lon","Sp","N"),
                   Size=50
                   )
#Plot Pies
plot(st_geometry(MyPies),col=MyPies$col)
#Add Pies legend
add_PieLegend(Pies=MyPies,PosX=-0.1,PosY=-1,Boxexp=c(0.5,0.45,0.12,0.45),
             PieTitle="Species")



}
\seealso{
\code{\link{create_Pies}}, \code{\link{PieData}}, \code{\link{PieData2}}.
}
