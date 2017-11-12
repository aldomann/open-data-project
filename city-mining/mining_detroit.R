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
detroit.df <- detroit.df %>%
	rename(Primary.Type = CATEGORY)

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(detroit.df)

detroit.df <- detroit.df %>%
	mutate(Category = find_prim_type(Primary.Type))

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

# Final Summary
colnames(detroit.df) <- c("Category", "Latitude", "Longitude",  "Date", "Hour")
detroit.df <- detroit.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())

# Detroit Population ------------------------------------------------------

pop.file = "pop-data/population_detroit.csv"
detroit.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
detroit.pop$population <- as.numeric(gsub(",", "", detroit.pop$population))

detroit.df <- merge(detroit.df, detroit.pop)
detroit.df$population <- detroit.df$population


# Create definitive file
path = "data/detroit_final.csv"
if (!file.exists(path)){
	write_csv(detroit.df, path)
}
