ICQ_VL1 <- rep(0, 20)
ICQ_V2<-rep(0, 20)
df = data.frame(ICQ_VL1,ICQ_V2)


x<-rhandsontable(df)

hot_to_r(x)
