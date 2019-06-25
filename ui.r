# Demostration of rhandsontable()
# Load the shiny, plotly and rhandsontable packages.

library(shiny)
library(plotly)
library(rhandsontable)

ui <- fluidPage(
  
  # Application title
  titlePanel(""),
  
  
  ######## Sidebar with a slider input for number of bins######
  sidebarLayout(
          sidebarPanel(
            div(align="center",
                tags$img(src="logo.png",width = "200px", height = "50px")),
            
            div(align="center",
            h3("Unit Analytic Performances")),
            
            
            
            selectInput("analita",label="Select analyte:",
            choices=list("Albumin", "ALP", "ALT"),selected = ""),
            
       
            
            numericInput("m1", "Mean Target LV1", value=0),
            numericInput("sd1", "SD Target LV1", value=0), 
            hr(),
            numericInput("m2", "Mean Target LV2", value=0),
            numericInput("sd2", "SD Target LV2", value=0), 
            rHandsontableOutput('table'),
            hr(),
            actionButton(inputId="go", label="Show Performances"),
            
            actionButton('switchtab',"Reset"),
            textOutput('code_ran')
                      ),

          mainPanel(
          
            fluidPage(
            tableOutput("summary"),
            br(),
            plotOutput("MEDx1"),
            span(h3(textOutput("perform")),style="color:red", align="center"),
            plotOutput("MEDx2"),
            span(h3(textOutput("perform2")), style="color:red", align="center")
          )
              )
          
          )
  )











