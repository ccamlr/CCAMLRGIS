#' DMSToDD
#'
#' Convert Coordinates that are in Degrees and decimal minutes or Degrees, minutes and seconds to decimal degrees 
#'
#' @param Coords is a single vector of either Longitude or Latitude values in Degrees, minutes and seconds, but can also handle Degrees and Decimal minutes
#' @keywords Coordinates, Degrees Minutes Seconds
#' @export
#' 
DMSToDD = function(Coords){
  # replace strange text with text that R will recognise
  dm=gsub("\u2019","'",Coords)
  dm=gsub("\u201D",'',dm)
  # sub characters that R can split on to create consistent number of splits
  dm=gsub("([A-Z]+)","~\\1~",dm)
  
  dm=do.call(rbind, strsplit(as.character(dm), "[\u00B0\\'~]"))
  dm=trimws(dm)
  # replace blank strings with zero - this is mostly when only minutes have been provided and no seconds
  dm[nchar(dm)==0]=0
  dec= as.numeric(dm[,1]) + (as.numeric(dm[,2])/60) + (as.numeric(dm[,3])/3600)
  dec[dm[,4]=="W"|dm[,4]=="S"]=dec[dm[,4]=="W"|dm[,4]=="S"]*-1
  dec
}
