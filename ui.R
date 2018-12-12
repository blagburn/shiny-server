library(shiny)
library(shinyjs)


ui <- fluidPage(
  #use shiny js to disable the ID field
  shinyjs::useShinyjs(),
  
  #data table
  DT::dataTableOutput("responses", width = 600),
  downloadButton("save", label = "Download"),
  
  #input fields
  tags$hr(),
  shinyjs::disabled(textInput("id", "Id", "0")),
  textInput("name", "Name", ""),
  checkboxInput("used_shiny", "Used Shiny", FALSE),
  sliderInput("r_num_years", "R Years", 0, 25, 2, ticks = FALSE),
  
  #action buttons
  actionButton("submit", "Submit"),
  actionButton("new", "New"),
  actionButton("delete", "Delete")
)

