# Functions to deal with Los Angeles's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(lubridate)
library(data.table)


# Mining Los Angeles Data ------------------------------------------------

# setwd("city-mining/")

# Download raw data
losangeles.crimes.file = "data/losangeles_raw.csv"
if (!file.exists(losangeles.crimes.file)) {
	# SRC: https://data.lacity.org/A-Safe-City/Crime-Data-from-2010-to-Present/y8tr-7khq
	download.file("https://data.lacity.org/api/views/y8tr-7khq/rows.csv?accessType=DOWNLOAD", destfile = losangeles.crimes.file)
}

# Read interesting columns and save into a CSV
losangeles.crimes.file.clean = "data/losangeles_clean.csv"
if (file.exists(losangeles.crimes.file) & !file.exists(losangeles.crimes.file.clean)) {
	losangeles.df.clean <- fread(losangeles.crimes.file, sep = ",", header= TRUE)
	write_csv(losangeles.df.clean, losangeles.crimes.file.clean)
	rm(losangeles.df.clean)
}
rm(losangeles.crimes.file, losangeles.crimes.file.clean)

# Read cleaned data
losangeles.df <- fread(file="data/losangeles_clean.csv", sep = ",", header = TRUE, select = c(9,3))
losangeles.df <- losangeles.df %>%
	rename(Primary.Type = `Crime Code Description`)

# Delete invalid rows
# losangeles.df <- na.omit(losangeles.df)
losangeles.df <- losangeles.df[!apply(is.na(losangeles.df) | losangeles.df == "", 1, all),]

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(losangeles.df)

losangeles.df <- losangeles.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Select the most important variables
losangeles.df <- losangeles.df[, c(3,2)]

# Date formats
losangeles.df$date <- as.Date(mdy(losangeles.df$`Date Occurred`))
losangeles.df$date <- format(losangeles.df$date, "%Y-%m-%d")

# Selecting final variables
losangeles.df <- losangeles.df[, c(1,3)]

# Final Summary
colnames(losangeles.df) <- c("Category", "Date")
losangeles.df <- losangeles.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N = n())

# losangeles Population ------------------------------------------------------

pop.file = "pop-data/population_losangeles.csv"
losangeles.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
losangeles.pop$population <- as.numeric(gsub(",", "", losangeles.pop$population))

losangeles.df <- merge(losangeles.df, losangeles.pop)
losangeles.df$population <- losangeles.df$population

# Delete incomplete data
# losangeles.df <- losangeles.df[!losangeles.df$year<2015,]
# losangeles.df <- losangeles.df[!(losangeles.df$year==2015 & losangeles.df$month==1),]
# losangeles.df <- losangeles.df[!(losangeles.df$year==2015 & losangeles.df$month==2),]
# losangeles.df <- losangeles.df[!(losangeles.df$year==2015 & losangeles.df$month==3),]
# losangeles.df <- losangeles.df[!(losangeles.df$year==2015 & losangeles.df$month==4),]


# Create definitive file
path = "final-data/losangeles_final.csv"
if (!file.exists(path)){
	write_csv(losangeles.df, path)
}
