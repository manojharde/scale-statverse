library(shiny)

# Define UI for the app
ui <- fluidPage(
  titlePanel("Sum Calculator"),
  
  # Sidebar layout with input and output
  sidebarLayout(
    sidebarPanel(
      numericInput("num1", "Enter first number:", value = 0),
      numericInput("num2", "Enter second number:", value = 0),
      numericInput("num3", "Enter third number:", value = 0),
      actionButton("calculate", "Calculate Sum")
    ),
    
    mainPanel(
      h3("Sum of the numbers:"),
      textOutput("sum_result")
    )
  )
)

# Define server logic to calculate sum
server <- function(input, output) {
  observeEvent(input$calculate, {
    total_sum <- input$num1 + input$num2 + input$num3
    output$sum_result <- renderText({ total_sum })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
