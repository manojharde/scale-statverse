library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(rhandsontable)
library(shinyjs)
library(DT)

source("~/scale-statverse/modules/mod_summary.R")

ui <- dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Summary Statistics", tabName = "summary_stats", icon = icon("sliders")),
      menuItem("Data Visualization", tabName = "summary_stats", icon = icon("sliders"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "summary_stats",
              summary_module_ui("summary_val")
      )
    )
  )
)

server <- function(input, output, session) {
  
  rv <- reactiveValues(values = list(),
                       data = data.frame(Value = NA_real_))
  
  # summary_module_server("summary_val", rv = rv)
  callModule(summary_module_server, "summary_val", rv = rv)
}

shinyApp(ui = ui, server = server)
