# Functions to deal with Dallas's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(lubridate)
library(data.table)


# Mining Dallas Data ------------------------------------------------

# setwd("city-mining/")

# Download raw data
dallas.crimes.file = "data/dallas_raw.csv"
if (!file.exists(dallas.crimes.file)) {
	# SRC: https://data.cityofdallas.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2
	download.file("https://www.dallasopendata.com/api/views/p9zb-d4n6/rows.csv?accessType=DOWNLOAD", destfile = dallas.crimes.file)
}

# Read interesting columns and save into a CSV
dallas.crimes.file.clean = "data/dallas_clean.csv"
if (file.exists(dallas.crimes.file) & !file.exists(dallas.crimes.file.clean)) {
	dallas.df.clean <- fread(dallas.crimes.file, sep = ",", header= TRUE)
	write_csv(dallas.df.clean, dallas.crimes.file.clean)
	rm(dallas.df.clean)
}
rm(dallas.crimes.file, dallas.crimes.file.clean)

# Read cleaned data
dallas.df <- fread(file="data/dallas_clean.csv", sep = ",", header = TRUE, select = c(2,4))
dallas.df <- dallas.df %>%
	rename(Primary.Type = `UCR Offense Name`)

# Delete invalid rows
# dallas.df <- na.omit(dallas.df)
dallas.df <- dallas.df[!apply(is.na(dallas.df) | dallas.df == "", 1, all),]

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(dallas.df)

dallas.df <- dallas.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Select the most important variables
dallas.df <- dallas.df[, c(3,2)]

# Date formats
dallas.df$date <- as.Date(parse_date_time(dallas.df$`Date1 of Occurrence`, "mdYHMS"))
dallas.df$date <- format(dallas.df$date, "%Y-%m-%d")

# Selecting final variables
dallas.df <- dallas.df[, c(1,3)]

# Final Summary
colnames(dallas.df) <- c("Category", "Date")
dallas.df <- dallas.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N = n())

# dallas Population ------------------------------------------------------

pop.file = "pop-data/population_dallas.csv"
dallas.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
dallas.pop$population <- as.numeric(gsub(",", "", dallas.pop$population))

dallas.df <- merge(dallas.df, dallas.pop)
dallas.df$population <- dallas.df$population

# Delete incomplete data
dallas.df <- dallas.df[!dallas.df$year<2014,]
dallas.df <- dallas.df[!(dallas.df$year==2014 & dallas.df$month==1),]
dallas.df <- dallas.df[!(dallas.df$year==2014 & dallas.df$month==2),]
dallas.df <- dallas.df[!(dallas.df$year==2014 & dallas.df$month==3),]
dallas.df <- dallas.df[!(dallas.df$year==2014 & dallas.df$month==4),]
dallas.df <- dallas.df[!(dallas.df$year==2014 & dallas.df$month==5),]

# Create definitive file
path = "final-data/dallas_final.csv"
if (!file.exists(path)){
	write_csv(dallas.df, path)
}
