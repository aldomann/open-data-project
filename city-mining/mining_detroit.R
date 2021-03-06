# Functions to deal with Detroit's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(lubridate)
library(data.table)


# Mining Detroit Data ------------------------------------------------

# setwd("city-mining/")

# Download raw data
detroit.crimes.file = "data/detroit_raw.csv"
if (!file.exists(detroit.crimes.file)) {
	# SRC: https://data.detroitmi.gov/Public-Safety/DPD-All-Crime-Incidents-January-1-2009-December-6-/invm-th67
	download.file("https://data.detroitmi.gov/api/views/invm-th67/rows.csv?accessType=DOWNLOAD", destfile = detroit.crimes.file)
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
detroit.df <- fread(file="data/detroit_clean.csv", sep = ",", header = TRUE, select = c(5,8))
detroit.df <- detroit.df %>%
	rename(Primary.Type = CATEGORY)

# Delete invalid rows
# detroit.df <- na.omit(detroit.df)
detroit.df <- detroit.df[!apply(is.na(detroit.df) | detroit.df == "", 1, all),]

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(detroit.df)

detroit.df <- detroit.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Select the most important variables
detroit.df <- detroit.df[, c(3,2)]

# Date formats
detroit.df$date <- as.Date(mdy_hms(detroit.df$INCIDENTDATE))
detroit.df$date <- format(detroit.df$date, "%Y-%m-%d")

# Selecting final variables
detroit.df <- detroit.df[, c(1,3)]

# Final Summary
colnames(detroit.df) <- c("Category", "Date")
detroit.df <- detroit.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N = n())

# detroit Population ------------------------------------------------------

pop.file = "pop-data/population_detroit.csv"
detroit.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
detroit.pop$population <- as.numeric(gsub(",", "", detroit.pop$population))

detroit.df <- merge(detroit.df, detroit.pop)
detroit.df$population <- detroit.df$population

# Delete incomplete data
detroit.df <- detroit.df[!(detroit.df$year==2016 & detroit.df$month==12),]

# Create definitive file
path = "final-data/detroit_final.csv"
if (!file.exists(path)){
	write_csv(detroit.df, path)
}
