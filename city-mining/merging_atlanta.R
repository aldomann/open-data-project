library(readxl)
library(tidyverse)

# SRC: http://www.atlantapd.org/i-want-to/crime-data-downloads

COBRA_YTD2009 <- read_excel("atlanta/COBRA-YTD2009.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

COBRA_YTD2010 <- read_excel("atlanta/COBRA-YTD2010.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

COBRA_YTD2011 <- read_excel("atlanta/COBRA-YTD2011.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

COBRA_YTD2012 <- read_excel("atlanta/COBRA-YTD2012.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

COBRA_YTD2013 <- read_excel("atlanta/COBRA-YTD2013.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

COBRA_YTD2014 <- read_excel("atlanta/COBRA-YTD2014.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

COBRA_YTD2015 <- read_excel("atlanta/COBRA-YTD2015.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

COBRA_YTD2016 <- read_excel("atlanta/COBRADATA2016.xlsx",
														sheet = "Query", col_types = c("skip", "skip", "skip", "text", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "skip", "skip", "skip",
																													 "skip", "text", "skip", "skip", "text", "text"))

atlanta.df <- rbind(COBRA_YTD2009, COBRA_YTD2010, COBRA_YTD2011, COBRA_YTD2012,
										COBRA_YTD2013, COBRA_YTD2014, COBRA_YTD2015, COBRA_YTD2016)

write_csv(atlanta.df, "atlanta_raw.csv")

