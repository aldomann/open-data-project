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


# UI -------------------------------------------------------

header <- dashboardHeader(
	title = "Crimes Hub"
)

sidebar <- dashboardSidebar(
	sidebarMenu(id = "sidebarmenu",
							menuItem("About this App", tabName = "home",  icon = icon("home")),
							menuItem("Single City", tabName = "single",  icon = icon("building"), selected = T),
							menuItem("Compare Cities", tabName = "compare", icon = icon("globe")),

							conditionalPanel("input.sidebarmenu === 'single'",
								checkboxGroupInput("categories", "Category",
																	 choices = c(
																		 "Total Crimes" = 1,
																		 "Property Crimes" = 2,
																		 "Violent Crimes" = 3
																	 ),
																	 selected = c(1,2,3)
								),
								selectInput("city", "City",
														choices = c(
															"Chicago",
															"New York City",
															"San Francisco"
														),
														selected = "Chicago",
														multiple = FALSE,
														selectize = TRUE
								)
							),

							conditionalPanel("input.sidebarmenu === 'compare'",
								checkboxInput("norm", "Normalise data",
															value = FALSE),
								selectInput("cities", "City",
														choices = c(
															"Chicago",
															"New York City",
															"San Francisco"
															),
														selected = c("Chicago", "New York City"),
														multiple = TRUE,
														selectize = TRUE
								)
							)
	)
)

body.cond <- dashboardBody(
	conditionalPanel(
		condition = "input.sidebarmenu === 'home'",
		h2("Home page")
	),

	conditionalPanel(
		condition = "input.sidebarmenu === 'single'",
		h2("Single city analysis"),
		dygraphOutput("plot1")
	),

	conditionalPanel(
		condition = "input.sidebarmenu === 'compare'",
		h2("Comparison between cities"),
		dygraphOutput("plot2")
	)
)

body <- dashboardBody(
	tabItems(
		tabItem(tabName = "home",
			h2("About this project")
		),

		tabItem(tabName = "single",
			h2("Single city analysis"),
			dygraphOutput("plot1")
		),

		tabItem(tabName = "compare",
			h2("Comparison between cities"),
			dygraphOutput("plot2")
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

	output$plot1 <- renderDygraph({
		lungDeaths <- cbind(ldeaths, mdeaths, fdeaths)
		dyRangeSelector(dygraph(lungDeaths, main = "Deaths from Lung Disease (UK)"), dateWindow = c("1974-01-01", "1980-01-01"))
	})

	output$plot2 <- renderDygraph({
		lungDeaths <- cbind(ldeaths, mdeaths, fdeaths)
		dyRangeSelector(dygraph(lungDeaths, main = "Births from Lung Disease (UK)"), dateWindow = c("1974-01-01", "1980-01-01"))
	})

}

shinyApp(ui, server)
