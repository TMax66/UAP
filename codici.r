ICQ_VL1 <- rep(0, 20)
ICQ_VL2<-rep(0, 20)
df = data.frame(ICQ_VL1,ICQ_VL2)
names(df)<-c("pippo","franco")

x<-rhandsontable(df)

hot_to_r(x)



mean1<-mean(df$ICQ_VL1)
mean2<-mean(df$ICQ_VL2)
sd1<-sd(df$ICQ_VL1)
sd2<-sd(df$ICQ_VL2)
cv1<-100*(sd1/mean1)
cv2<-100*(sd2/mean2)

t<-cbind("VL1",mean1,sd1,cv1)
tt<-cbind("VL2",mean2, sd2,cv2)
tt2<-rbind(t,tt)
ttx<-as.data.frame(tt2)


names(ttx)<-c("VL","Mean","SD","CV")


#MEDxChart#

ta<-read.csv("ta.csv")
ta %>% 
  mutate(ta2=Ta/2,
         ta3=Ta/3,
         ta4=Ta/4) %>% 
  filter(analita=="Albumin",LV==1)
  
  #filter(analita==input$analita,LV==input$lv)
  
  


d=data.frame(x=0:z$Ta, y=c(0:z$Ta))
ggplot(data=d, mapping=aes(x=x, y=y)) +
  geom_blank() +
  geom_segment(aes(x=0,xend=z$ta2,y=z$Ta,yend=0),color='red', linetype=1,size=0.2)+
  geom_segment(aes(x=0,xend=z$ta3,y=z$Ta,yend=0), color='blue', linetype=1,size=0.2)+
  geom_segment(aes(x=0,xend=z$ta4,y=z$Ta,yend=0),color='green', linetype=1,size=0.2)+
labs(x="Precision", y="Bias")+geom_point(aes(x=1.6, y=3.9), colour="blue")



