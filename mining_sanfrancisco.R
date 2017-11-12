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


# Merge crime types in more general categories
sanfrancisco.df <- sanfrancisco.df %>% mutate(Category = ifelse(Primary.Type == "THEFT" | Primary.Type == "BURGLARY" | Primary.Type == "LIQUOR LAW VIOLATION" | Primary.Type == "MOTOR VEHICLE THEFT" | Primary.Type == "ARSON" | Primary.Type == "CRIMINAL DAMAGE", "PROPERTY CRIMES", ifelse(Primary.Type == "BATTERY" | Primary.Type == "ROBBERY" | Primary.Type=="ASSAULT" | Primary.Type =="CRIM SEXUAL ASSAULT" | Primary.Type == "SEX OFFENSE" | Primary.Type == "STALKING" | Primary.Type == "KIDNAPPING" | Primary.Type == "HOMICIDE" | Primary.Type == "INTIMIDATION" | Primary.Type == "HUMAN TRAFFICKING", "VIOLENT CRIMES", "QUALITY OF LIFE CRIMES")))

# Final columns
sanfrancisco.df <- sanfrancisco.df[,-c(1)]

# Final summary
sanfrancisco.df <- sanfrancisco.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())

# Create definitive file
path = "final-data/sanfrancisco_final.csv"
if (!file.exists(path)){
	write_csv(sanfrancisco.df, path)
}
