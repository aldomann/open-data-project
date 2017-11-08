# Functions to deal with Chicago's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(data.table)
library(dplyr)
library(lubridate)


# Mining Chicago Data Crime ------------------------------------------------

# Download raw data
chicago.crimes.file = "data/chicago_raw.csv"
if (!file.exists(chicago.crimes.file)) {
	# SRC: https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2
	download.file("https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD", destfile = chicago.crimes.file)
}

# Read interesting columns and save into a CSV
chicago.crimes.file.clean = "data/chicago_clean.csv"
if (file.exists(chicago.crimes.file) & !file.exists(chicago.crimes.file.clean)) {
	chicago.df.clean <- fread(chicago.crimes.file, sep = ",", header= TRUE, select = c(3,6,18,20,21))
	write_csv(chicago.df.clean, chicago.crimes.file.clean)
	rm(chicago.df.clean)
}
rm(chicago.crimes.file, chicago.crimes.file.clean)

chicago.df <- fread(file="data/chicago_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
chicago.df <- chicago.df %>%
	dplyr::rename(Primary.Type = `Primary Type`) %>%
	mutate(Date = mdy_hms(Date)) %>%
	filter(is.na(Longitude) != TRUE)

# Merge crime types in more general categories
chicago.df <- chicago.df %>% mutate(Category = ifelse(Primary.Type == "THEFT" | Primary.Type == "BURGLARY" | Primary.Type == "LIQUOR LAW VIOLATION" | Primary.Type == "MOTOR VEHICLE THEFT" | Primary.Type == "ARSON" | Primary.Type == "CRIMINAL DAMAGE", "PROPERTY CRIMES", ifelse(Primary.Type == "BATTERY" | Primary.Type == "ROBBERY" | Primary.Type=="ASSAULT" | Primary.Type =="CRIM SEXUAL ASSAULT" | Primary.Type == "SEX OFFENSE" | Primary.Type == "STALKING" | Primary.Type == "KIDNAPPING" | Primary.Type == "HOMICIDE" | Primary.Type == "INTIMIDATION" | Primary.Type == "HUMAN TRAFFICKING", "VIOLENT CRIMES", "QUALITY OF LIFE CRIMES")))

# Final columns
chicago.df <- chicago.df[,-c(2,3)]

# Final summary
chicago.df <- chicago.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())


# Chicago Population ------------------------------------------------------

pop.file = "data/population_chicago.csv"
chicago.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
chicago.pop$population <- as.numeric(gsub(",", "", chicago.pop$population))

chicago.df <- merge(chicago.df, chicago.pop)
chicago.df$population <- chicago.df$population

# Create definitive file
path = "data/chicago_final.csv"
if (!file.exists(path)){
	write_csv(chicago.df, path)
}

