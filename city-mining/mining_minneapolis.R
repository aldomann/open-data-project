# Functions to deal with Minneapolis's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(lubridate)
library(data.table)


# Mining Minneapolis Data ------------------------------------------------

setwd("city-mining/")

# Download raw data
minneapolis.crimes.file = "data/minneapolis_raw.csv"
# SRC: https://www.kaggle.com/mrisdal/minneapolis-incidents-crime

# Read interesting columns and save into a CSV
minneapolis.crimes.file.clean = "data/minneapolis_clean.csv"
if (file.exists(minneapolis.crimes.file) & !file.exists(minneapolis.crimes.file.clean)) {
	minneapolis.df.clean <- fread(minneapolis.crimes.file, sep = ",", header= TRUE)
	write_csv(minneapolis.df.clean, minneapolis.crimes.file.clean)
	rm(minneapolis.df.clean)
}
rm(minneapolis.crimes.file, minneapolis.crimes.file.clean)

# Read cleaned data
minneapolis.df <- fread(file="data/minneapolis_clean.csv", sep = ",", header = TRUE, select = c(9,5,12,13))
minneapolis.df <- minneapolis.df %>%
	rename(Primary.Type = Description)

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(minneapolis.df)

minneapolis.df <- minneapolis.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Select the most important variables
minneapolis.df <- minneapolis.df[, c(2,5)]

# Date formats
minneapolis.df$date <- as.Date(ymd_hms(minneapolis.df$ReportedDate))
minneapolis.df$date <- format(minneapolis.df$date, "%Y-%m-%d")

# Selecting final variables
minneapolis.df <- minneapolis.df[, c(3,2)]

# Delete invalid rows
minneapolis.df <- na.omit(minneapolis.df)

# Final Summary
colnames(minneapolis.df) <- c("Date","Category")
minneapolis.df <- minneapolis.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N = n())

# Minneapolis Population ------------------------------------------------------

pop.file = "pop-data/population_minneapolis.csv"
minneapolis.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
minneapolis.pop$population <- as.numeric(gsub(",", "", minneapolis.pop$population))

minneapolis.df <- merge(minneapolis.df, minneapolis.pop)
minneapolis.df$population <- minneapolis.df$population

# Delete incomplete data
minneapolis.df <- minneapolis.df[!(minneapolis.df$year==2016 & minneapolis.df$month==07),]

# Create definitive file
path = "final-data/minneapolis_final.csv"
if (!file.exists(path)){
	write_csv(minneapolis.df, path)
}
