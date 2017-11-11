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
							menuItem("Single City", tabName = "single",  icon = icon("building"), selected = T),
							menuItem("Compare Cities", tabName = "compare", icon = icon("globe")),

							conditionalPanel("input.sidebarmenu === 'single'",
								checkboxGroupInput("categories", "Category",
																	 choices = c(
																		 "Total Crimes" = "Total",
																		 "Property Crimes" = "Property",
																		 "Violent Crimes" = "Violent",
																		 "Other Crimes" = "Other"
																	 ),
																	 selected = c("Total")
								),
								selectInput("city.single", "City",
														choices = c(
															"Chicago",
															"Detroit",
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
		dygraphOutput("single.plot")
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
			dygraphOutput("single.plot")
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

	output$single.plot <- renderDygraph({

	single.df <- read.csv(paste0("data/", tolower(input$city.single), ".csv")) %>%
		mutate(Date = as.Date(as.character(paste(year, month, 01, sep = "-"), "%Y-%m-%d")))

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

	single.df <- merge(merge(df.prop, df.viol, all = TRUE), df.oth, all = TRUE)
	single.df[is.na(single.df)] <- 0
	single.df <- single.df %>%
		mutate(Total = Property + Violent + Other)

		single.ts <- xts(cbind(single.df[,input$categories]), order.by=single.df$Date)
		dyRangeSelector(dygraph(single.ts, main = paste("Crimes in", input$city.single)))
	})

	output$plot2 <- renderDygraph({
		lungDeaths <- cbind(ldeaths, mdeaths, fdeaths)
		dyRangeSelector(dygraph(lungDeaths, main = "Births from Lung Disease (UK)"), dateWindow = c("1974-01-01", "1980-01-01"))
	})

}

shinyApp(ui, server)
