library(shiny)
library(shinyjs)



# Get table metadata. For now, just the fields
# Further development: also define field types
# and create inputs generically
GetTableMetadata <- function() {
  fields <- c(id = "Id", 
              name = "Name", 
              used_shiny = "Used Shiny", 
              r_num_years = "R Years")
  
  result <- list(fields = fields)
  return (result)
}

# Find the next ID of a new record
# (in mysql, this could be done by an incremental index)
GetNextId <- function() {
  if (exists("responses") && nrow(responses) > 0) {
    max(as.integer(rownames(responses))) + 1
  } else {
    return (1)
  }
}

#C
CreateData <- function(data) {
  
  data <- CastData(data)
  rownames(data) <- GetNextId()
  if (exists("responses")) {
    responses <<- rbind(responses, data)
  } else {
    responses <<- data
  }
}

#R
ReadData <- function() {
  if (exists("responses")) {
    responses
  }
}



#U
UpdateData <- function(data) {
  data <- CastData(data)
  responses[row.names(responses) == row.names(data), ] <<- data
}

#D
DeleteData <- function(data) {
  responses <<- responses[row.names(responses) != unname(data["id"]), ]
}




# Cast from Inputs to a one-row data.frame
CastData <- function(data) {
  datar <- data.frame(name = data["name"], 
                      used_shiny = as.logical(data["used_shiny"]), 
                      r_num_years = as.integer(data["r_num_years"]),
                      stringsAsFactors = FALSE)
  
  rownames(datar) <- data["id"]
  return (datar)
}




# Return an empty, new record
CreateDefaultRecord <- function() {
  mydefault <- CastData(list(id = "0", name = "", used_shiny = FALSE, r_num_years = 2))
  return (mydefault)
}

# Fill the input fields with the values of the selected record in the table
UpdateInputs <- function(data, session) {
  updateTextInput(session, "id", value = unname(rownames(data)))
  updateTextInput(session, "name", value = unname(data["name"]))
  updateCheckboxInput(session, "used_shiny", value = as.logical(data["used_shiny"]))
  updateSliderInput(session, "r_num_years", value = as.integer(data["r_num_years"]))
}