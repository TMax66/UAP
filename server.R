library(shiny)
library(tidyverse)

shinyServer(function(output,input, session){
  # print("Initializing")
  
  observeEvent(input$switchtab,{
    aggg_result = -1
    if(aggg_result == -1)
    {
      session$reload()
      return()
      print("session reload not working")
    }
    
    print("Code running this line")
    
    output$code_ran <- renderText("code Ran this line without refreshing")
    
  })

  
  ta<-read.csv("ta.csv")
  ICQ_VL1 <- rep(0.0, 20)
  ICQ_VL2<-rep(0.0, 20)
  df = data.frame(ICQ_VL1,ICQ_VL2)
  
  ta2<-reactive(ta %>% 
                mutate(ta2=Ta/2,
                       ta3=Ta/3,
                       ta4=Ta/4,
                       sl1=(Ta-0)/(0-ta4),
                       sl2=(Ta-0)/(0-ta3),
                       sl3=(Ta-0)/(0-ta2)) %>% 
                filter(analita==input$analita))
## Defining a reactivevalues object so that whenever dataset value changes it affects everywhere in the scope of every reactive function
datavalues <- reactiveValues(data=df)
  
  
output$table <- renderRHandsontable({
   rhandsontable(datavalues$data) %>% 
  hot_cols(format = "0.00")
   
    
  
  })
observeEvent(
    
    input$table$changes$changes, # observe if any changes to the cells of the rhandontable
    {
      xi=input$table$changes$changes[[1]][[1]] 
      datavalues$data <- hot_to_r(input$table) 

      }
    )
ttx<-reactive({
              tm_lv1<-input$m1
              tm_lv2<-input$m2
              refm1<-input$m1
              refm2<-input$m2
              sdref1<-input$sd1
              sdref2<-input$sd2
              mean1<-mean(datavalues$data$ICQ_VL1)
              mean2<-mean(datavalues$data$ICQ_VL2)
              sd1<-sd(datavalues$data$ICQ_VL1)
              sd2<-sd(datavalues$data$ICQ_VL2)
              cv1<-100*(sd1/mean1)
              cv2<-100*(sd2/mean2)
              bias1<-100*(mean1-refm1)/refm1
              bias2<-100*(mean2-refm2)/refm2
              teobs1<-abs(bias1)+2*cv1
              teobs2<-abs(bias1)+2*cv1
              sigma1<-(ta2()$Ta[1]-bias1)/cv1 
              sigma2<-(ta2()$Ta[2]-bias2)/cv2
              qgi1<-abs(bias1)/1.5*cv1
              qgi2<-abs(bias2)/1.5*cv2
              slope1<-(ta2()$Ta[1]-abs(bias1))/(0-cv1)
              slope2<-(ta2()$Ta[2]-abs(bias2))/(0-cv2)
              ttx<-rbind(tibble( "Level"="IQC LV1","refMean"=refm1, "refSD"=sdref1, "MEAN"=mean1, 
                                 "SD"=sd1, "CV"=cv1, "BIAS"=bias1,"TEobs95%"=teobs1,"Sigma"=sigma1,
                                 "QGI"=qgi1, "Slope"=slope1),
                         tibble( "Level"="IQC LV2","refMean"=refm2, "refSD"=sdref2,"MEAN"=mean2, 
                                 "SD"=sd2, "CV"=cv2, "BIAS"=bias2,"TEobs95%"=teobs2,"Sigma"=sigma2,
                                 "QGI"=qgi2, "Slope"=slope2)
              )})

observeEvent(input$go, {   
output$summary<-renderTable({   
    ttx() }, type = "html",
    bordered = TRUE, striped = TRUE, align = "c", width = NULL, digits=2)

output$MEDx1 <- renderPlot({
     d=data.frame(x=0:ta2()$Ta[1], y=c(0:ta2()$Ta[1]))
     ggplot(data=d, mapping=aes(x=x, y=y)) +
       geom_blank() +
       geom_segment(aes(x=0,xend=ta2()$ta2[1],y=ta2()$Ta[1],yend=0),color='red', linetype=1,size=0.2)+
       geom_segment(aes(x=0,xend=ta2()$ta3[1],y=ta2()$Ta[1],yend=0), color='blue', linetype=1,size=0.2)+
       geom_segment(aes(x=0,xend=ta2()$ta4[1],y=ta2()$Ta[1],yend=0),color='green', linetype=1,size=0.2)+
       labs(x="Precision", y="Bias", title = "Analyte IQC 1 MEDx Chart")+
       geom_point(aes(x=ttx()$CV[1], y=abs(ttx()$BIAS[1])), colour="blue", size=3)
     
  })
output$MEDx2 <- renderPlot({
     d=data.frame(x=0:ta2()$Ta[2], y=c(0:ta2()$Ta[2]))
     ggplot(data=d, mapping=aes(x=x, y=y)) +
       geom_blank() +
       geom_segment(aes(x=0,xend=ta2()$ta2[2],y=ta2()$Ta[2],yend=0),color='red', linetype=1,size=0.2)+
       geom_segment(aes(x=0,xend=ta2()$ta3[2],y=ta2()$Ta[2],yend=0), color='blue', linetype=1,size=0.2)+
       geom_segment(aes(x=0,xend=ta2()$ta4[2],y=ta2()$Ta[2],yend=0),color='green', linetype=1,size=0.2)+
       labs(x="Precision", y="Bias", title = "Analyte IQC 2 MEDx Chart")+
       geom_point(aes(x=ttx()$CV[2], y=abs(ttx()$BIAS[2])), colour="blue",size =3)
     
   })

output$perform <- renderText({ 
  
  if (ttx()$Slope[1]<ta2()$sl1[1])
  {"Excellent Performance"}
    else if (ttx()$Slope[1]<ta2()$sl2[1])
    {"Good Performance"}
      else if (ttx()$Slope[1]<ta2()$sl3[1])
      {"Marginal Performance"}
  else
  {"Poor Performance"}
})

output$perform2 <- renderText({ 
  
  if (ttx()$Slope[2]<ta2()$sl1[2])
  {"Excellent Performance"}
  else if (ttx()$Slope[2]<ta2()$sl2[2])
  {"Good Performance"}
  else if (ttx()$Slope[2]<ta2()$sl3[2])
  {"Marginal Performance"}
  else
  {"Poor Performance"}
})



}



)
}
)