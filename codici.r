ICQ_VL1 <- rep(3, 20)
ICQ_VL2<-rep(3, 20)
df = data.frame(ICQ_VL1,ICQ_VL2)
names(df)<-c("pippo","franco")

x<-rhandsontable(df)

hot_to_r(x)



mean1<-mean(df$ICQ_VL1)
mean2<-mean(df$ICQ_VL2)
sd1<-sd(df$ICQ_VL1)
sd2<-sd(df$ICQ_VL2)
cv1<-100*(sd1+2.8783/mean1)
cv2<-100*(sd2/mean2)

ttx<-rbind(tibble( "Level"="VL1","mean"=mean1, "sd"=sd1, "cv"=cv1),
      tibble("Level"="VL2","mean"=mean2, "sd"=sd2, "cv"=cv2))

t<-cbind("VL1",mean1,sd1,cv1)
tt<-cbind("VL2",mean2, sd2,cv2)
tt2<-rbind(t,tt)
ttx<-as.data.frame(tt2)


names(ttx)<-c("VL","Mean","SD","CV")


#MEDxChart#

ta<-read.csv("ta.csv")
z<-ta %>% 
  mutate(ta2=Ta/2,
         ta3=Ta/3,
         ta4=Ta/4,
         sl1=(Ta-0)/(0-ta4)) %>%
  filter(analita=="Albumin")
  
  #filter(analita==input$analita,LV==input$lv)
  
  


d=data.frame(x=0:z$Ta[1], y=c(0:z$Ta[1]))
ggplot(data=d, mapping=aes(x=x, y=y)) +
  geom_blank() +
  geom_segment(aes(x=0,xend=z$ta2[1],y=z$Ta[1],yend=0),color='red', linetype=1,size=0.2)+
  geom_segment(aes(x=0,xend=z$ta3[1],y=z$Ta[1],yend=0), color='blue', linetype=1,size=0.2)+
  geom_segment(aes(x=0,xend=z$ta4[1],y=z$Ta[1],yend=0),color='green', linetype=1,size=0.2)+
labs(x="Precision", y="Bias")+geom_point(aes(x=1.6, y=3.9), colour="blue")

ta<-data.frame( "Ta"=c(15, 20))

ta2<-ta %>% 
        mutate(ta2=Ta/2,
                       ta3=Ta/3,
                       ta4=Ta/4,
                       sl1=(Ta-0)/(0-ta4),
                       sl2=(Ta-0)/(0-ta3),
                       sl3=(Ta-0)/(0-ta2))


