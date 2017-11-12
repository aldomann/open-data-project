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

sidebar <- dashboardSidebar(
	sidebarMenu(id = "sidebarmenu",
							menuItem("About this App", tabName = "home",  icon = icon("home")),
							menuItem("Single City", tabName = "single",  icon = icon("building")),
							menuItem("Compare Cities", tabName = "compare", icon = icon("globe"), selected = T),

							conditionalPanel("input.sidebarmenu == 'single'",
								checkboxGroupInput("categories", "Category",
																	 choices = c(
																		 "Total Crimes" = "Total",
																		 "Property Crimes" = "Property",
																		 "Violent Crimes" = "Violent",
																		 "Other Crimes" = "Other"
																	 ),
																	 selected = c("Total", "Property", "Violent", "Other")
								),
								selectInput("city.single", "City",
														choices = c(
															"Chicago",
															"Detroit",
															"San Francisco"
														),
														selected = "Chicago",
														multiple = FALSE,
														selectize = TRUE
								)
							),

							conditionalPanel("input.sidebarmenu == 'compare'",
								# checkboxInput("norm", "Normalise data",
								# 							value = FALSE),
								radioButtons("norm", "Normalisation",
														 choices = c(
														 	"None" = "",
														 	"By mean" = "mean",
														 	"By population" = "pop"
														 )),

								selectInput("cities", "City",
														choices = c(
															"Chicago",
															"Detroit",
															"San Francisco"
															),
														selected = c("Chicago", "Detroit"),
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
		single.df <- read.csv(paste0("data/", tolower(input$city.single), ".csv")) %>%
			mutate(Date = as.Date(as.character(paste(year, month, 01, sep = "-"), "%Y-%m-%d")))

		# Clean data
		df.prop <- single.df %>%
			filter(Category == "PROPERTY CRIMES") %>%
			mutate(Property = N) %>%
			select(Date, Property)

		df.viol <- single.df %>%
			filter(Category == "VIOLENT CRIMES") %>%
			mutate(Violent = N) %>%
			select(Date, Violent)

		df.oth <- single.df %>%
			filter(Category == "QUALITY OF LIFE CRIMES") %>%
			mutate(Other = N) %>%
			select(Date, Other)

		# Merge data
		single.df <- Reduce(function(...) merge(..., all=TRUE), list(df.prop, df.viol, df.oth))
		single.df[is.na(single.df)] <- 0
		single.df <- single.df %>%
			mutate(Total = Property + Violent + Other)

		# Create time series
		single.ts <- xts(cbind(single.df[,input$categories]), order.by=single.df$Date)
		dyRangeSelector(dygraph(single.ts, main = paste("Crimes in", input$city.single)))
	})

	output$compare.plot <- renderDygraph({
		# Read and clean data
		cities.lst <- list()
		cities.df <- data.frame()
		for (city in input$cities) {
			cityname <- paste0(city)
			df <- read.csv(paste0("data/", tolower(city), ".csv"))
			df <- df %>%
				mutate(Date = as.Date(as.character(paste(year, month, 01, sep = "-"), "%Y-%m-%d"))) %>%
				group_by(Date) %>%
				dplyr::summarise(N = sum(N))

			if ( input$norm == "mean" ) {
				df <- df %>%
					mutate(!!cityname := N/mean(N)) %>%
					select(Date, !!cityname)
			} else if (input$norm == "pop" ){
				df <- df %>%
					mutate(!!cityname := N/mean(N)) %>%
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
		dyRangeSelector(dygraph(compare.ts, main = paste("Crimes in ...")))
	})

}

shinyApp(ui, server)
