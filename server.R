library(shiny)

shinyServer(function(output,input, session){
  
## Creating a dataset with 3 column variables. Column C is sum of columns a and b.
## we will use this dataset to begin with and simulate formulas in editable rhandson data table
 # a=sample(1:20, replace=T)
#  b=sample(1:20, replace=T)
 # c=a+b
#df = data.frame(a=a, b=b, c=c)
  
  ICQ_VL1 <- rep(0, 20)
  ICQ_VL2<-rep(0, 20)
  df = data.frame(ICQ_VL1,ICQ_VL2)
## Defining a reactivevalues object so that whenever dataset value changes it affects everywhere in the scope of every reactive function
  datavalues <- reactiveValues(data=df)
  
  # Display the data using renderRHandsontable() function
  # It will display the data frame that was initialized in the reactiveValues()
  # This will display data in a excel like editable cells

  
  output$table <- renderRHandsontable({
   rhandsontable(datavalues$data)
  
  })
  

  
  # Watching any changes made to table cells in column variables a or b and then update column c based on formula
  
  observeEvent(
    input$table$changes$changes, # observe if any changes to the cells of the rhandontable
    {
      
      xi=input$table$changes$changes[[1]][[1]] # capture the row which is changed
      datavalues$data <- hot_to_r(input$table) # convert the rhandontable to R data frame object so manupilation / calculations could be done
      
      # Calculating the cell value of column C using cell values in column a and b
      # 1 is added to row index because change event row and column indices starts with zero vs R index which starts with 1
      
      #datavalues$data[xi+1,3] = datavalues$data[xi+1,1] + datavalues$data[xi+1,2] # calculate column varibale C values based on cell values in column variable a and b
     
    
      
      }
    )
  
  ## plot a histogram using plotly
  ## plotly graph also changes as the table cell values changes
 
  output$summary<-renderTable({   
    tm_lv1<-input$m1
    tm_lv2<-input$m2
    
  refm1<-input$m1
  refm2<-input$m2
  mean1<-mean(datavalues$data$ICQ_VL1)
  mean2<-mean(datavalues$data$ICQ_VL2)
  sd1<-sd(datavalues$data$ICQ_VL1)
  sd2<-sd(datavalues$data$ICQ_VL2)
  cv1<-100*(sd1/mean1)
  cv2<-100*(sd2/mean2)
  bias1<-(mean1-refm1)/refm1
  bias2<-(mean2-refm2)/refm2
  
  t<-cbind("VL1",refm1,mean1, sd1,cv1, bias1)
  tt<-cbind("VL2",refm2,mean2, sd2,cv2,bias2)
  tt2<-rbind(t,tt)
  ttx<-as.data.frame(tt2)
  #names(ttx)<-c("LV", "refMean", "TargetMean", "SD", "CV")
  })
  

  
  
  
  
   output$plot <- renderPlotly({
        plot_ly(data=datavalues$data, x=~c, type="histogram")
  })
  
  
  ## Save the changed data table to local 
  ## create the save function
  saveData <- function(){
    write.csv(datavalues$data, file = "MyData.csv", row.names = FALSE)
  }

  ## on save button click event, dataset will be saved to working directory
  observeEvent(input$saveBtn, saveData())
  
}
)