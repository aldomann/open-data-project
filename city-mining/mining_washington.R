# Functions to deal with Washington's crime data
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
washington.crimes.file = "data/washington_raw.csv"
# SRC: https://www.kaggle.com/vinchinzu/dc-metro-crime-data

# Read interesting columns and save into a CSV
washington.crimes.file.clean = "data/washington_clean.csv"
if (file.exists(washington.crimes.file) & !file.exists(washington.crimes.file.clean)) {
	washington.df.clean <- fread(washington.crimes.file, sep = ",", header= TRUE, select=c(22, 5, 19, 20))
	write_csv(washington.df.clean, washington.crimes.file.clean)
	rm(washington.df.clean)
}
rm(washington.crimes.file, washington.crimes.file.clean)

washington.df <- fread(file="data/washington_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
washington.df <- washington.df %>%
	dplyr::rename(Primary.Type = `OFFENSE`) %>%
	dplyr::rename(Date = `date`) %>%
	dplyr::rename(Longitude = `XBLOCK`) %>%
	dplyr::rename(Latitude = `YBLOCK`) %>%
	mutate(Date = ymd_hms(Date))

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(washington.df)

washington.df <- washington.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Final columns
washington.df <- washington.df[,c(3,5)]

# Final summary
washington.df <- washington.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())


# City Population ------------------------------------------------------

pop.file = "pop-data/population_washington.csv"
washington.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
washington.pop$population <- as.numeric(gsub(",", "", washington.pop$population))

washington.df <- merge(washington.df, washington.pop)
washington.df$population <- washington.df$population

# Create definitive file
path = "final-data/washington_final.csv"
if (!file.exists(path)){
	write_csv(washington.df, path)
}
