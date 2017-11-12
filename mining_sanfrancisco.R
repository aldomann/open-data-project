# Functions to deal with San Francisco's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(data.table)
library(dplyr)
library(lubridate)


# Mining New York Data ------------------------------------------------

# Download raw data
sanfrancisco.crimes.file = "data/sanfrancisco_raw.csv"
if (!file.exists(sanfrancisco.crimes.file)) {
	# SRC: https://data.sfgov.org/Public-Safety/Police-Department-Incidents/tmnf-yvry
	download.file("https://data.sfgov.org/api/views/tmnf-yvry/rows.csv?accessType=DOWNLOAD", destfile = sanfrancisco.crimes.file)
}
# Read interesting columns and save into a CSV
sanfrancisco.crimes.file.clean = "data/sanfrancisco_clean.csv"
if (file.exists(sanfrancisco.crimes.file) & !file.exists(sanfrancisco.crimes.file.clean)) {
	sanfrancisco.df.clean <- fread(sanfrancisco.crimes.file, sep = ",", header= TRUE)
	write_csv(sanfrancisco.df.clean, sanfrancisco.crimes.file.clean)
	rm(sanfrancisco.df.clean)
}
rm(sanfrancisco.crimes.file, sanfrancisco.crimes.file.clean)

sanfrancisco.df <- fread(file="data/sanfrancisco_clean.csv", sep = ",", header = TRUE, select = c(2,5,10,11))

# Clean formats and column names
sanfrancisco.df <- sanfrancisco.df %>%
	dplyr::rename(Primary.Type = `Category`) %>%
	dplyr::rename(Longitude = `X`) %>%
	dplyr::rename(Latitude= `Y`) %>%
	mutate(Date = format(as.Date(sanfrancisco.df$Date, format="%m/%d/%Y"), "%Y-%m-%d")) %>%
	filter(is.na(Longitude) != TRUE)

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(sanfrancisco.df)

sanfrancisco.df <- sanfrancisco.df %>%
	mutate(Category = find_prim_type(Primary.Type))


# Final columns
sanfrancisco.df <- sanfrancisco.df[,-c(1)]

# Final summary
sanfrancisco.df <- sanfrancisco.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())

# San Francisco Population ------------------------------------------------------

pop.file = "pop-data/population_sanfrancisco.csv"
sanfrancisco.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
sanfrancisco.pop$population <- as.numeric(gsub(",", "", sanfrancisco.pop$population))

sanfrancisco.df <- merge(sanfrancisco.df, sanfrancisco.pop)
sanfrancisco.df$population <- sanfrancisco.df$population

# Create definitive file
path = "final-data/sanfrancisco_final.csv"
if (!file.exists(path)){
	write_csv(sanfrancisco.df, path)
}
