
#- can we use stringsAsFactors = FALSE
#- imports from maptools, utils, methods
#- Coastline_data EEZ_data RefAreas SSMU_data  does not exist
#- non-ascii characters

x <- readLines("R/DMStoDD.R")
cat(stringi::stri_escape_unicode(x), "R/DMStoDD.R")

# x <- ASD_data$GAR_Description
# ASD_data$GAR_DESCRIPTION <- stringi::stri_escape_unicode(x)
ASD_data$GAR_Description <- stringi::stri_escape_unicode(ASD_data$GAR_Description)
ASD_data$GAR_End_Date <- NULL
ASD_data$GAR_End_Date <- NA_character_
devtools::use_data(ASD_data, overwrite = TRUE)

SSRU_data$GAR_Description <- stringi::stri_escape_unicode(SSRU_data$GAR_Description )
SSRU_data$GAR_End_Date <- NULL
SSRU_data$GAR_End_Date <- NA_character_
devtools::use_data(SSRU_data, overwrite = TRUE)

MPA_data$GAR_Description <- stringi::stri_escape_unicode(MPA_data$GAR_Description )
MPA_data$GAR_End_Date <- NULL
MPA_data$GAR_End_Date <- NA_character_
devtools::use_data(MPA_data, overwrite = TRUE)

SSMU_data$GAR_Description <- stringi::stri_escape_unicode(SSMU_data$GAR_Description)
SSMU_data$GAR_End_Date <- NULL
SSMU_data$GAR_End_Date <- NA_character_
devtools::use_data(SSMU_data, overwrite = TRUE)

EEZ_data$GAR_Description <- stringi::stri_escape_unicode(EEZ_data$GAR_Description)
EEZ_data$GAR_End_Date <- NULL
EEZ_data$GAR_End_Date <- NA_character_
devtools::use_data(EEZ_data, overwrite = TRUE)

# - size of data reduced, not enough
tools::resaveRdaFiles("data", compress = "auto")


