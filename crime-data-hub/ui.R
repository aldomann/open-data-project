# Libraries ------------------------------------------------

# UI Libs
library(shinydashboard)
library(dygraphs)

# UI -------------------------------------------------------

header <- dashboardHeader(
	title = "Crime Data Hub"
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
	sidebarMenu(
		id = "sidebarmenu",
		menuItem("About this App", tabName = "home",  icon = icon("home"), selected = T),
		menuItem("Single City", tabName = "single",  icon = icon("building")),
		menuItem("Compare Cities", tabName = "compare", icon = icon("globe")),

		conditionalPanel(
			condition = "input.sidebarmenu == 'single'",
			checkboxGroupInput(
				"categories", "Category",
				choices = c(
					"Total Crimes" = "Total",
					"Property Crimes" = "Property",
					"Violent Crimes" = "Violent",
					"Other Crimes" = "Other"
				),
				selected = c("Total", "Property", "Violent")
			),
			selectInput(
				"city.single", "City",
				choices = cities.list,
				selected = "Chicago",
				multiple = FALSE,
				selectize = TRUE
			)
		),

		conditionalPanel(
			condition = "input.sidebarmenu == 'compare'",
			radioButtons(
				"norm", "Normalisation",
				choices = c(
					"None" = "",
					"By crime mean" = "mean",
					"By population" = "pop"
				)),

			selectInput(
				"cities", "City",
				choices = cities.list,
				selected = c("Chicago", "San Francisco", "Philadelphia", "Atlanta"),
				multiple = TRUE,
				selectize = TRUE
			)
		)
	)
)

body <- dashboardBody(
	tabItems(
		tabItem(tabName = "home",
						h2("About this project"),
						includeMarkdown("body.md"),
						actionButton(
							inputId='ab1', label="Fork us",
							icon = icon("github"),
							onclick ="window.open(
							'https://github.com/aldomann/open-data-project', '_blank')"
							)
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
