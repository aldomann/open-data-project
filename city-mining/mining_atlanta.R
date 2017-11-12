# Functions to deal with Atlanta's crime data
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
atlanta.crimes.file = "data/atlanta_raw.csv"
# SRC: hhttp://www.atlantapd.org/i-want-to/crime-data-downloads

if (!file.exists(atlanta.crimes.file)) source("mergint_atlanta.R")

# Read interesting columns and save into a CSV
atlanta.crimes.file.clean = "data/atlanta_clean.csv"
if (file.exists(atlanta.crimes.file) & !file.exists(atlanta.crimes.file.clean)) {
	atlanta.df.clean <- fread(atlanta.crimes.file, sep = ",", header= TRUE)
	write_csv(atlanta.df.clean, atlanta.crimes.file.clean)
	rm(atlanta.df.clean)
}
rm(atlanta.crimes.file, atlanta.crimes.file.clean)

atlanta.df <- fread(file="data/atlanta_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
atlanta.df <- atlanta.df %>%
	dplyr::rename(Primary.Type = `UC2 Literal`) %>%
	dplyr::rename(Date = `occur_date`) %>%
	dplyr::rename(Longitude = `x`) %>%
	dplyr::rename(Latitude = `y`) %>%
	mutate(Date = mdy(Date))

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(atlanta.df)

atlanta.df <- atlanta.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Final columns
atlanta.df <- atlanta.df[,c(1,5)]

# Final summary
atlanta.df <- atlanta.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())


# City Population ------------------------------------------------------

pop.file = "pop-data/population_atlanta.csv"
atlanta.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
atlanta.pop$population <- as.numeric(gsub(",", "", atlanta.pop$population))

atlanta.df <- merge(atlanta.df, atlanta.pop)
atlanta.df$population <- atlanta.df$population

atlanta.df <- atlanta.df[!atlanta.df$year<2009,]

# Create definitive file
path = "final-data/atlanta_final.csv"
if (!file.exists(path)){
	write_csv(atlanta.df, path)
}
