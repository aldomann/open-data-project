## app.R ##
library(shiny)

# Libraries ------------------------------------------------

# UI Libs
library(shinydashboard)
library(dygraphs)
library(leaflet)

# Server Libs
library(dplyr)
library(datasets)
library(curl) # make the jsonlite suggested dependency explicit
library(zoo)
library(xts)


# UI -------------------------------------------------------

header <- dashboardHeader(
	title = "Crimes Hub"
)

cities.list <- c(
	"Atlanta",
	"Austin",
	"Baltimore",
	"Chicago",
	"Dallas",
	"Detroit",
	"Los Angeles",
	"Minneapolis",
	"New York",
	"Philadelphia",
	"Portland",
	"San Francisco",
	"Seattle",
	"Washington"
)

sidebar <- dashboardSidebar(
	sidebarMenu(id = "sidebarmenu",
							menuItem("About this App", tabName = "home",  icon = icon("home")),
							menuItem("Single City", tabName = "single",  icon = icon("building"), selected = T),
							menuItem("Compare Cities", tabName = "compare", icon = icon("globe")),

							conditionalPanel("input.sidebarmenu == 'single'",
								checkboxGroupInput("categories", "Category",
																	 choices = c(
																		 "Total Crimes" = "Total",
																		 "Property Crimes" = "Property",
																		 "Violent Crimes" = "Violent",
																		 "Other Crimes" = "Other"
																	 ),
																	 selected = c("Total", "Property", "Violent")
								),
								selectInput("city.single", "City",
														choices = cities.list,
														selected = "Chicago",
														multiple = FALSE,
														selectize = TRUE
								)
							),

							conditionalPanel("input.sidebarmenu == 'compare'",
								radioButtons("norm", "Normalisation",
														 choices = c(
														 	"None" = "",
														 	"By crime mean" = "mean",
														 	"By population" = "pop"
														 )),

								selectInput("cities", "City",
														choices = cities.list,
														selected = c("Chicago", "San Francisco", "Philadelphia", "Atlanta"),
														multiple = TRUE,
														selectize = TRUE
								)
							)
	)
)

body.cond <- dashboardBody(
	conditionalPanel(
		condition = "input.sidebarmenu == 'home'",
		h2("Home page")
	),

	conditionalPanel(
		condition = "input.sidebarmenu == 'single'",
		h2("Single city analysis"),
		dygraphOutput("single.plot")
	),

	conditionalPanel(
		condition = "input.sidebarmenu == 'compare'",
		h2("Comparison between cities"),
		dygraphOutput("compare.plot")
	)
)

body <- dashboardBody(
	tabItems(
		tabItem(tabName = "home",
			h2("About this project")
		),

		tabItem(tabName = "single",
			h2("Single city analysis"),
			dygraphOutput("single.plot")
		),

		tabItem(tabName = "compare",
			h2("Comparison between cities"),
			dygraphOutput("compare.plot")
		)
	)
)

ui <- dashboardPage(
	skin = "purple",
	header,
	sidebar,
	body
)


# Server ---------------------------------------------------

server <- function(input, output) {

	output$single.plot <- renderDygraph({
		# Read data
		single.df <- read.csv(paste0("data/", gsub(" ", "", tolower(input$city.single)), "_final.csv")) %>%
			mutate(Date = as.Date(as.character(paste(year, month, 01, sep = "-"), "%Y-%m-%d")))

		# Clean data
		df.prop <- single.df %>%
			filter(Category == "PROPERTY") %>%
			mutate(Property = N) %>%
			select(Date, Property)

		df.viol <- single.df %>%
			filter(Category == "VIOLENT") %>%
			mutate(Violent = N) %>%
			select(Date, Violent)

		df.oth <- single.df %>%
			filter(Category == "OTHER") %>%
			mutate(Other = N) %>%
			select(Date, Other)

		# Merge data
		single.df <- Reduce(function(...) merge(..., all=TRUE), list(df.prop, df.viol, df.oth))
		single.df[is.na(single.df)] <- 0
		single.df <- single.df %>%
			mutate(Total = Property + Violent + Other)

		# Create time series
		single.ts <- xts(cbind(single.df[,input$categories]), order.by=single.df$Date)
		dyRangeSelector(
			dyOptions(
				dygraph(single.ts, main = paste("Evolution of crimes in", input$city.single)),
				strokeWidth = 2)
		)
	})

	output$compare.plot <- renderDygraph({
		# Read and clean data
		cities.lst <- list()
		cities.df <- data.frame()
		for (city in input$cities) {
			cityname <- paste0(city)
			df <- read.csv(paste0("data/", gsub(" ", "", tolower(city)), "_final.csv"))
			df <- df %>%
				mutate(Date = as.Date(as.character(paste(year, month, 01, sep = "-"), "%Y-%m-%d"))) %>%
				group_by(Date, population) %>%
				dplyr::summarise(N = sum(N))

			if ( input$norm == "mean" ) {
				meanN <- mean(df$N)
				df <- df %>%
					mutate(!!cityname := N/meanN) %>%
					select(Date, !!cityname)
			} else if (input$norm == "pop" ){
				df <- df %>%
					mutate(!!cityname := N/population) %>%
					select(Date, !!cityname)
			} else {
				df <- df %>%
					mutate(!!cityname := N) %>%
					select(Date, !!cityname)
			}

			cities.lst[[city]] <- df
		}

		# Merge data
		cities.df <- Reduce(function(...) merge(..., all = TRUE), cities.lst)

		# Create time series
		compare.ts <- xts(cbind(cities.df[,input$cities]), order.by=cities.df$Date)
		dyRangeSelector(
			dyOptions(
				dygraph(compare.ts, main = paste("Evolution of crimes")) %>%
					dyLegend(width = 400),
				strokeWidth = 2),
			dateWindow = c("2009-01-01", "2016-12-01")
		)
	})

}

shinyApp(ui, server)
