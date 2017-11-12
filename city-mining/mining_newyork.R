# Functions to deal with New York City's crime data
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
newyork.crimes.file = "data/newyork_raw.csv"
# SRC: https://www.kaggle.com/adamschroeder/crimes-new-york-city

# Read interesting columns and save into a CSV
newyork.crimes.file.clean = "data/newyork_clean.csv"
if (file.exists(newyork.crimes.file) & !file.exists(newyork.crimes.file.clean)) {
	newyork.df.clean <- fread(newyork.crimes.file, sep = ",", header= TRUE, select=c(2,8,22,23))
	write_csv(newyork.df.clean, newyork.crimes.file.clean)
	rm(newyork.df.clean)
}
rm(newyork.crimes.file, newyork.crimes.file.clean)

newyork.df <- fread(file="data/newyork_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
newyork.df <- newyork.df %>%
	dplyr::rename(Primary.Type = `OFNS_DESC`) %>%
	dplyr::rename(Date = `CMPLNT_FR_DT`) %>%
	mutate(Date = mdy(Date))

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(newyork.df)

newyork.df <- newyork.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Final columns
newyork.df <- newyork.df[,c(1,5)]

# Final summary
newyork.df <- newyork.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())


# City Population ------------------------------------------------------

pop.file = "pop-data/population_newyork.csv"
newyork.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
newyork.pop$population <- as.numeric(gsub(",", "", newyork.pop$population))

newyork.df <- merge(newyork.df, newyork.pop)
newyork.df$population <- newyork.df$population

newyork.df <- newyork.df[!newyork.df$year<2014,]

# Create definitive file
path = "final-data/newyork_final.csv"
if (!file.exists(path)){
	write_csv(newyork.df, path)
}
