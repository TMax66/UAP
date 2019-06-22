# Demostration of rhandsontable()
# Load the shiny, plotly and rhandsontable packages.

library(shiny)
library(plotly)
library(rhandsontable)

ui <- fluidPage(
  
  # Application title
  titlePanel("Unit Analytic Performances"),
  
  ######## Sidebar with a slider input for number of bins######
  sidebarLayout(
          sidebarPanel(
            
            numericInput("m1", "Mean Target LV1", value=0),
            numericInput("m2", "Mean Target LV2", value=0),
            
            rHandsontableOutput('table')
                      ),

          mainPanel("",
            fluidPage(
            tableOutput("summary")
          )
          )
  )
)







  

# shinyUI(fluidPage(h2("Demo - Unit Analytic Performances"),
#                
# fluidRow(column(4, rHandsontableOutput('table'), offset = 2),
#          column(4, tableOutput("summary")),
# column(4,plotlyOutput("plot") , offset = 2))
#   
#   ))

