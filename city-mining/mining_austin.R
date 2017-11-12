# Functions to deal with austin's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(lubridate)
library(data.table)


# Mining austin Data ------------------------------------------------

# setwd("city-mining/")

# Download raw data
austin.crimes.file = "data/austin_raw.csv"
# SRC: https://www.kaggle.com/jboysen/austin-crime

# Read interesting columns and save into a CSV
austin.crimes.file.clean = "data/austin_clean.csv"
if (file.exists(austin.crimes.file) & !file.exists(austin.crimes.file.clean)) {
	austin.df.clean <- fread(austin.crimes.file, sep = ",", header= TRUE)
	write_csv(austin.df.clean, austin.crimes.file.clean)
	rm(austin.df.clean)
}
rm(austin.crimes.file, austin.crimes.file.clean)

# Read cleaned data
austin.df <- fread(file="data/austin_clean.csv", sep = ",", header = TRUE, select = c(12,13))
austin.df <- austin.df %>%
	rename(Primary.Type = primary_type)

# Delete invalid rows
# austin.df <- na.omit(austin.df)
austin.df <- austin.df[!apply(is.na(austin.df) | austin.df == "", 1, all),]

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(austin.df)

austin.df <- austin.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Select the most important variables
austin.df <- austin.df[, c(3,2)]

# Date formats
austin.df$date <- as.Date(ymd_hms(austin.df$timestamp))
austin.df$date <- format(austin.df$date, "%Y-%m-%d")

# Selecting final variables
austin.df <- austin.df[, c(1,3)]

# Final Summary
colnames(austin.df) <- c("Category", "Date")
austin.df <- austin.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N = n())

# austin Population ------------------------------------------------------

pop.file = "pop-data/population_austin.csv"
austin.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
austin.pop$population <- as.numeric(gsub(",", "", austin.pop$population))

austin.df <- merge(austin.df, austin.pop)
austin.df$population <- austin.df$population

# Delete incomplete data
# austin.df <- austin.df[!(austin.df$year==2016 & austin.df$month==07),]

# Create definitive file
path = "final-data/austin_final.csv"
if (!file.exists(path)){
	write_csv(austin.df, path)
}
