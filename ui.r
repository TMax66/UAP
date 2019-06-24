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
            
            selectInput("analita",label="Select analyte:",
            choices=list("Albumin", "ALP", "ALT","Amyase"),selected = ""),
            
            #radioButtons("lv", "select LV:",
                        # c("LV1" = 1,
                        #  "LV2" = 2)),
            
            numericInput("m1", "Mean Target LV1", value=0),
            numericInput("sd1", "SD Target LV1", value=0), 
            hr(),
            numericInput("m2", "Mean Target LV2", value=0),
            numericInput("sd2", "SD Target LV2", value=0), 
            rHandsontableOutput('table'),
            hr(),
            actionButton(inputId="go", label="Show Performances")
                      ),

          mainPanel(
            #conditionalPanel( 
             # condition="input.go==1",
          
            fluidPage(
            tableOutput("summary"),
            hr(),
            br(),
            plotOutput("MEDx1"),
            textOutput("perform"),
            hr(),
            plotOutput("MEDx2")
          )
              )
          
          )
  )
#)








  

# shinyUI(fluidPage(h2("Demo - Unit Analytic Performances"),
#                
# fluidRow(column(4, rHandsontableOutput('table'), offset = 2),
#          column(4, tableOutput("summary")),
# column(4,plotlyOutput("plot") , offset = 2))
#   
#   ))

