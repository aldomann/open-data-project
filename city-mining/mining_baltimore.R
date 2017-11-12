# Functions to deal with Baltimore's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(data.table)
library(dplyr)
library(lubridate)


# Mining Baltimore Data ------------------------------------------------

# Download raw data
baltimore.crimes.file = "data/baltimore_raw.csv"
	# SRC: https://www.kaggle.com/sohier/crime-in-baltimore

# Read interesting columns and save into a CSV
baltimore.crimes.file.clean = "data/baltimore_clean.csv"
if (file.exists(baltimore.crimes.file) & !file.exists(baltimore.crimes.file.clean)) {
	baltimore.df.clean <- fread(baltimore.crimes.file, sep = ",", header= TRUE, select=c(1,5,11,12))
	write_csv(baltimore.df.clean, baltimore.crimes.file.clean)
	rm(baltimore.df.clean)
}
rm(baltimore.crimes.file, baltimore.crimes.file.clean)

baltimore.df <- fread(file="data/baltimore_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
baltimore.df <- baltimore.df %>%
	dplyr::rename(Primary.Type = `Description`) %>%
	dplyr::rename(Date = `CrimeDate`) %>%
	mutate(Date = mdy(Date))

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(baltimore.df)

baltimore.df <- baltimore.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Final columns
baltimore.df <- baltimore.df[,c(1,5)]

# Final summary
baltimore.df <- baltimore.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())


# Baltimore Population ------------------------------------------------------

pop.file = "pop-data/population_baltimore.csv"
baltimore.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
baltimore.pop$population <- as.numeric(gsub(",", "", baltimore.pop$population))

baltimore.df <- merge(baltimore.df, baltimore.pop)
baltimore.df$population <- baltimore.df$population

# Create definitive file
path = "final-data/baltimore_final.csv"
if (!file.exists(path)){
	write_csv(baltimore.df, path)
}
