# Functions to deal with Honolulu's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(data.table)
library(dplyr)
library(lubridate)


# Mining honolulu Data ------------------------------------------------

# Download raw data
honolulu.crimes.file = "data/honolulu_raw.csv"
if (!file.exists(honolulu.crimes.file)) {
	download.file("https://data.honolulu.gov/api/views/a96q-gyhq/rows.csv?accessType=DOWNLOAD", destfile = honolulu.crimes.file)
}

# Read interesting columns and save into a CSV
honolulu.crimes.file.clean = "data/honolulu_clean.csv"
if (file.exists(honolulu.crimes.file) & !file.exists(honolulu.crimes.file.clean)) {
	honolulu.df.clean <- fread(honolulu.crimes.file, sep = ",", header= TRUE, select=c(6, 7))
	write_csv(honolulu.df.clean, honolulu.crimes.file.clean)
	rm(honolulu.df.clean)
}
rm(honolulu.crimes.file, honolulu.crimes.file.clean)

honolulu.df <- fread(file="data/honolulu_clean.csv", sep = ",", header = TRUE)

# Clean formats and column names
honolulu.df <- honolulu.df %>%
	dplyr::rename(Primary.Type = `Type`) %>%
	mutate(Date = mdy_hms(Date))

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(honolulu.df)

honolulu.df <- honolulu.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Final Summary
honolulu.df <- honolulu.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N=n())

# Population ------------------------------------------------------
pop.file = "pop-data/population_honolulu.csv"
honolulu.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
honolulu.pop$population <- as.numeric(gsub(",", "", honolulu.pop$population))

honolulu.df <- merge(honolulu.df, honolulu.pop)
honolulu.df$population <- honolulu.df$population

# Create definitive file
path = "final-data/honolulu_final.csv"
if (!file.exists(path)){
	write_csv(honolulu.df, path)
}
