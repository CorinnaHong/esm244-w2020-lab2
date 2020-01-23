# Attach packages

library(tidyverse)
library(shiny)
library(shinythemes)
library(here)

# Read in spooky_data.csv

spooky <- read_csv(here("data", "spooky_data.csv"))

# Create user interface

ui <- fluidPage(
  theme = shinytheme("united"), # google shiny themes for more themes!
  titlePanel("App Title"),
  sidebarLayout(
    sidebarPanel("My widgets",
                 selectInput(inputId = "state_select", # this name will be used to call it in the server
                             label = "Choose a location:",
                             choices = unique(spooky$state) # unique() calls all unique inputs in a column. Helpful for when many choices exist
                             )
                 ),
    mainPanel("My outputs",
              tableOutput(outputId = "candy_table")
              ))
)



server <- function(input, output) {
  state_candy <- reactive({
    spooky %>%
      filter(state == input$state_select) %>%
      select(candy, pounds_candy_sold)
  })

  output$candy_table <- renderTable({
    state_candy() # put parenthesis after this to indicate that it is reactive
  }) # create a name for output to call it in ui, renderTable for reactive data
}

shinyApp(ui = ui, server = server) # tells shiny app the name of your ui and server, in case you named it something different ui = name
