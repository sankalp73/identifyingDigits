library(png)
library(colorspace)
final<-NULL
pixel<-NULL
for(i in seq(0,48999,1))
{
  img<- readPNG(paste("C:\\Users\\MAHE\\Downloads\\Train_HI6auGp\\Train\\Images\\train\\",i,".png", sep=""))
  y <- rgb(img[,,1], img[,,2], img[,,3], alpha = img[,,4])
  yg <- desaturate(y)
  yn <- col2rgb(yg)[1, ]/255
  #m<-matrix(yn,nrow = 28 ,byrow = TRUE)
  #m1<-t(apply(m,1,rev))
  pixel<-rbind(pixel,yn)
  
}
final<-as.data.frame(train)
final<-data.frame(final,pixel)
write.csv(final,"final.csv")

#sample few of the digits
par(mfrow=c(2,3))
lapply(1:6, 
       function(x) 
         image(t(apply(matrix(unlist(final[x,3:786]),nrow = 28 ,byrow = TRUE),1,rev)),col= grey.colors(255),xlab = final[x,1])
      )

