# Functions to deal with Detroit's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(data.table)


# Mining Detroit Data ------------------------------------------------

# Download raw data
detroit.crimes.file = "data/detroit_raw.csv"
if (!file.exists(detroit.crimes.file)) {
	# SRC: https://data.detroitmi.gov/Public-Safety/DPD-Reported-Major-Crimes-2011-2014/75yu-k3gj
	download.file("https://data.detroitmi.gov/api/views/75yu-k3gj/rows.csv", destfile = detroit.crimes.file)
}

# Read interesting columns and save into a CSV
detroit.crimes.file.clean = "data/detroit_clean.csv"
if (file.exists(detroit.crimes.file) & !file.exists(detroit.crimes.file.clean)) {
	detroit.df.clean <- fread(detroit.crimes.file, sep = ",", header= TRUE)
	write_csv(detroit.df.clean, detroit.crimes.file.clean)
	rm(detroit.df.clean)
}
rm(detroit.crimes.file, detroit.crimes.file.clean)

# Read cleaned data
detroit.df <- fread(file="data/detroit_clean.csv", sep = ",", header = TRUE, select = c(2, 5,6,9,11))

# Merge crime types in more general categories
detroit.df <- detroit.df %>% mutate(Category = ifelse(CATEGORY == "LARCENY" | CATEGORY == "BURGLARY" | CATEGORY == "LIQUOR LAW VIOLATION" | CATEGORY == "STOLEN VEHICLE" | CATEGORY == "ARSON" | CATEGORY == "CRIMINAL DAMAGE", "PROPERTY CRIMES", ifelse(CATEGORY == "BATTERY" | CATEGORY == "ROBBERY" | CATEGORY=="ASSAULT" | CATEGORY =="AGGRAVATED ASSAULT" | CATEGORY == "SEX OFFENSE" | CATEGORY == "STALKING" | CATEGORY == "KIDNAPPING" | CATEGORY == "HOMICIDE" | CATEGORY == "INTIMIDATION" | CATEGORY == "HUMAN TRAFFICKING", "VIOLENT CRIMES", "QUALITY OF LIFE CRIMES")))

# Select the most important variables
detroit.df <- detroit.df[, c(2,3,5,6)]

# Functions gathering geolocalization data
longitude <- function(x){
	a <- strsplit(x, "\\(", fixed = FALSE, perl = FALSE, useBytes = FALSE)[[1]][2]
	a <- gsub(")","", a)
	longitude <- as.numeric(strsplit(a, ",")[[1]][1])
}

latitude <- function(x){
	a <- strsplit(x, "\\(", fixed = FALSE, perl = FALSE, useBytes = FALSE)[[1]][2]
	a <- gsub(")","", a)
	latitude <- as.numeric(strsplit(a, ",")[[1]][2])
}

# Extracting longitude and latitude
detroit.df$longitude <- sapply(detroit.df$LOCATION, function(x) longitude(x) )
detroit.df$latitude <- sapply(detroit.df$LOCATION, function(x) latitude(x) )

# Selecting the even more important variables
detroit.df <- detroit.df[,c(1,2,4,5,6)]

# Date formats
detroit.df$date <- as.Date(detroit.df$INCIDENTDATE , "%m/%d/%Y %H:%M:%S")
detroit.df$date <- format(detroit.df$date, "%Y-%m-%d")

# Selecting final variables
detroit.df <- detroit.df[, c(3, 4, 5, 6, 2)]
colnames(detroit.df)[5] <- "hour"

# Delete invalid rows
detroit.df <- detroit.df[ ! detroit.df$latitude > 1000, ]
detroit.df <- na.omit(detroit.df)

# Create definitive file
path = "data/detroit_final.csv"
if (!file.exists(path)){
	write_csv(detroit.df, path)
}
