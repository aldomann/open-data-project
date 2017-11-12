# Functions to deal with Philadelphia's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(data.table)
library(dplyr)
library(lubridate)


# Mining Crime Data ------------------------------------------------

# Download raw data
philadelphia.crimes.file = "data/philadelphia_raw.csv"
# SRC: https://www.kaggle.com/mchirico/philadelphiacrimedata

# Read interesting columns and save into a CSV
philadelphia.crimes.file.clean = "data/philadelphia_clean.csv"
if (file.exists(philadelphia.crimes.file) & !file.exists(philadelphia.crimes.file.clean)) {
	philadelphia.df.clean <- fread(philadelphia.crimes.file, sep = ",", header= TRUE, select=c(3,10,13,14))
	write_csv(philadelphia.df.clean, philadelphia.crimes.file.clean)
	rm(philadelphia.df.clean)
}
rm(philadelphia.crimes.file, philadelphia.crimes.file.clean)

philadelphia.df <- fread(file="data/philadelphia_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
philadelphia.df <- philadelphia.df %>%
	dplyr::rename(Primary.Type = `Text_General_Code`) %>%
	dplyr::rename(Date = `Dispatch_Date_Time`) %>%
	dplyr::rename(Longitude = `Lon`) %>%
	dplyr::rename(Latitude = `Lat`) %>%
	mutate(Date = ymd_hms(Date))

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(philadelphia.df)

philadelphia.df <- philadelphia.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Final columns
philadelphia.df <- philadelphia.df[,c(1,5)]

# Final summary
philadelphia.df <- philadelphia.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())


# City Population ------------------------------------------------------

pop.file = "pop-data/population_philadelphia.csv"
philadelphia.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
philadelphia.pop$population <- as.numeric(gsub(",", "", philadelphia.pop$population))

philadelphia.df <- merge(philadelphia.df, philadelphia.pop)
philadelphia.df$population <- philadelphia.df$population

# Create definitive file
path = "final-data/philadelphia_final.csv"
if (!file.exists(path)){
	write_csv(philadelphia.df, path)
}
