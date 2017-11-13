# Functions to deal with Portland's crime data
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(lubridate)
library(data.table)


# Mining Portland Data ------------------------------------------------

# setwd("city-mining/")

# Download raw data
portland.crimes.file = "data/portland_raw.csv"
if (!file.exists(portland.crimes.file)) {
	# SRC: https://www.portlandoregon.gov/police/71978
	download.file("https://public.tableau.com/vizql/vud/sessions/4C330E7EAE5B4D0390ECCB8D2E5810EC-0:0/views/11785674312584914872_6350070509696140914?csv=true&summary=true", destfile = portland.crimes.file)
}

# Read interesting columns and save into a CSV
portland.crimes.file.clean = "data/portland_clean.csv"
if (file.exists(portland.crimes.file) & !file.exists(portland.crimes.file.clean)) {
	portland.df.clean <- fread(portland.crimes.file, sep = ",", header= TRUE)
	write_csv(portland.df.clean, portland.crimes.file.clean)
	rm(portland.df.clean)
}
rm(portland.crimes.file, portland.crimes.file.clean)

# Read cleaned data
portland.df <- fread(file="data/portland_clean.csv", sep = ",", header = TRUE, select = c(9,6))
portland.df <- portland.df %>%
	rename(Primary.Type = `Offense Type`)

# Delete invalid rows
# portland.df <- na.omit(portland.df)
portland.df <- portland.df[!apply(is.na(portland.df) | portland.df == "", 1, all),]

# Classify crimes in categories
source("prim_types_functions.R")
find_new_prim_type(portland.df)

portland.df <- portland.df %>%
	mutate(Category = find_prim_type(Primary.Type))

# Select the most important variables
portland.df <- portland.df[, c(3,2)]

# Date formats
portland.df$date <- as.Date(dmy(portland.df$`Occur Date`))
portland.df$date <- format(portland.df$date, "%Y-%m-%d")

# Selecting final variables
portland.df <- portland.df[, c(1,3)]

# Final Summary
colnames(portland.df) <- c("Category", "Date")
portland.df <- portland.df %>%
	group_by(Category, year = year(Date), month = month(Date)) %>%
	summarise(N = n())

# portland Population ------------------------------------------------------

pop.file = "pop-data/population_portland.csv"
portland.pop <- fread(pop.file, sep = ";", header= TRUE, select = c(1,2))
portland.pop$population <- as.numeric(gsub(",", "", portland.pop$population))

portland.df <- merge(portland.df, portland.pop)
portland.df$population <- portland.df$population

# Delete incomplete data
portland.df <- portland.df[!portland.df$year<2015,]
portland.df <- portland.df[!(portland.df$year==2015 & portland.df$month==1),]
portland.df <- portland.df[!(portland.df$year==2015 & portland.df$month==2),]
portland.df <- portland.df[!(portland.df$year==2015 & portland.df$month==3),]
portland.df <- portland.df[!(portland.df$year==2015 & portland.df$month==4),]


# Create definitive file
path = "final-data/portland_final.csv"
if (!file.exists(path)){
	write_csv(portland.df, path)
}
