summary_module_ui <- function(id) {
  
  ns <- NS(id)
  fluidPage(
    shinyjs::useShinyjs(),
    
    fluidRow(
      column(4,
             selectInput(ns("select_type"), label = "Select a type of data",
                         choices = c("Grouped Data","Ungrouped Data"))),
      
      column(4,
             selectInput(ns("select_stats"), label = "Select a Stats",
                         choices = c("Mean", "Median", "Mode", "Standrad Deviation", "Variance", "Minimum",
                                     "Maximum", "First Quartile", "Third Quartile"),
                         multiple = TRUE,
                         selectize = TRUE)),
      
      column(4,
             selectInput(ns("data_input_type"), label = "Select the data input",
                         choices = c("Enter Data manually", "Upload file")))
    )
    ,
    br(),
    fluidRow(
      column(6, box(title = "Data Input", width = NULL, status = "primary", solidHeader = TRUE,
                    shinyjs::hidden(numericInput(ns("enter_dt"), label = "Enter number of data points you wish to enter", value = 1)),
                    fileInput(ns("upload_file"), label = "Upload data file") %>%
                      shinyjs::hidden(),
                    # h4("Enter the data in following table") %>%,
                    rHandsontableOutput(ns("table")))),
      column(6, box(title = "Result", width = NULL, status = "primary", solidHeader = TRUE, 
                    rHandsontableOutput(ns("res_tab"))))
    )
  )
} 

summary_module_server <- function(input, output, session, rv) {
  
  output$selection <- renderText({
    selected_values <- paste(input$select_stats, collapse = ", ")
    paste("You selected:", selected_values)
  })
  
  observe({
    
    if(input$data_input_type == "Enter Data manually") {
      shinyjs::show("enter_dt")
      shinyjs::hide("upload_file")
      
    } else {
      shinyjs::hide("enter_dt")
      shinyjs::show("upload_file")
    }
  })
  
  dis_dt <- reactive({
    if(input$data_input_type == "Enter Data manually") {
      
      if (input$enter_dt > 1 && input$enter_dt > nrow(rv$data)) {
        data <- rbind(rv$data, data.frame(Value = rep(NA_real_, input$enter_dt - nrow(rv$data))))
      } else if (input$enter_dt < nrow(rv$data)) {
        
        data <- head(rv$data, -(nrow(rv$data) - input$enter_dt))
        
      } else {
        data <- rv$data
      }
      
    } else if(input$data_input_type == "Upload file") {
      
      req(input$upload_file)

      file_path <- input$upload_file$datapath
      # if(!is.null(file_path)){
      #   data <- read.csv(file_path)
      # }
      data <- read.csv(file_path)
    } else {
      data <- rv$data
    } 
    
    data
    
  })    
  
  output$table <- renderRHandsontable({
    #browser()
    rhandsontable(dis_dt())
  })
  
  observe({
    if(!is.null(input$table)){
      rv$data <- hot_to_r(input$table)
    }
  })
  
  # observeEvent(input$data_input_type, {
  #   
  #   if (input$data_input_type == "Enter Data manually" ){
  #     #browser()
  #     rv$data <- data.frame(Value = NA_real_)
  #     # rv$data <- NULL
  # 
  #   } 
  #   else if (input$data_input_type == "Upload file"){
  # 
  #     rv$data <- data.frame(Value = NA_real_)
  # 
  # 
  #   }
  #   
  #   rv$data <- data.frame(Value = NA_real_)
  # })
  
  observeEvent(input$data_input_type, {
    rv$data <- data.frame(Value = NA_real_)

  })
  
  
  
}