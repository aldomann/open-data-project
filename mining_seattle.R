# Functions to deal with Seattle's crime data
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
seattle.crimes.file = "data/seattle_raw.csv"
if (!file.exists(seattle.crimes.file)) {
	# SRC: https://data.sfgov.org/Public-Safety/Police-Department-Incidents/tmnf-yvry
	download.file("https://data.seattle.gov/api/views/3k2p-39jp/rows.csv?accessType=DOWNLOAD", destfile = seattle.crimes.file)
}
# Read interesting columns and save into a CSV
seattle.crimes.file.clean = "data/seattle_clean.csv"
if (file.exists(seattle.crimes.file) & !file.exists(seattle.crimes.file.clean)) {
	seattle.df.clean <- fread(seattle.crimes.file, sep = ",", header= TRUE, select=c(6,8,13,14))
	write_csv(seattle.df.clean, seattle.crimes.file.clean)
	rm(seattle.df.clean)
}
rm(seattle.crimes.file, seattle.crimes.file.clean)

seattle.df <- fread(file="data/seattle_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
seattle.df <- seattle.df %>%
	dplyr::rename(Primary.Type = `Event Clearance SubGroup`) %>%
	dplyr::rename(Date = `Event Clearance Date`) %>%
	mutate(Date = mdy_hms(Date)) %>%
	filter(is.na(Longitude) != TRUE)

# Merge crime types in more general categories
seattle.df <- seattle.df %>% mutate(Category = ifelse(Primary.Type == "THEFT" | Primary.Type == "BURGLARY" | Primary.Type == "RESIDENTIAL BURGLARIES"| Primary.Type == "LIQUOR VIOLATIONS" | Primary.Type == "PROPERTY DAMAGE" | Primary.Type == "COMMERCIAL BURGLARIES" | Primary.Type == "AUTO THEFTS" | Primary.Type == "MOTOR VEHICLE THEFT" | Primary.Type == "ARSON" | Primary.Type == "CRIMINAL DAMAGE", "PROPERTY CRIMES", ifelse(Primary.Type == "BATTERY" | Primary.Type == "ROBBERY"| Primary.Type == "TRESPASS" | Primary.Type=="ASSAULT" | Primary.Type =="CRIM SEXUAL ASSAULT" | Primary.Type == "SEX OFFENSE" | Primary.Type == "STALKING" | Primary.Type == "KIDNAPPING" | Primary.Type == "THRESATS, HARASSMENT" | Primary.Type == "CASUALTIES" | Primary.Type == "HOMICIDE" | Primary.Type == "SEX OFFENSE" | Primary.Type == "INTIMIDATION" | Primary.Type == "HUMAN TRAFFICKING", "VIOLENT CRIMES", "QUALITY OF LIFE CRIMES")))

# Final columns
seattle.df <- seattle.df[,c(2,5)]

# Final summary
seattle.df <- seattle.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())


# Seattle Population ------------------------------------------------------

pop.file = "pop-data/population_seattle.csv"
seattle.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
seattle.pop$population <- as.numeric(gsub(",", "", seattle.pop$population))

seattle.df <- merge(seattle.df, seattle.pop)
seattle.df$population <- seattle.df$population

# Create definitive file
path = "pop-data/seattle_final.csv"
if (!file.exists(path)){
	write_csv(seattle.df, path)
}
