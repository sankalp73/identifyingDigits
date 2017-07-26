library(caret)
library(h2o)
local.h2o <- h2o.init(ip = "localhost", port = 54321, startH2O = TRUE, nthreads=-1)
training <- read.csv ("C:\\Users\\MAHE\\Documents\\train.csv") 
testing  <- read.csv ("C:\\Users\\MAHE\\Documents\\test.csv")

# convert digit labels to factor for classification
training[,2]<-as.factor(training[,2])

# pass dataframe from inside of the R environment to the H2O instance
trData<-as.h2o(training[,2:786])
tsData<-as.h2o(testing)
res.dl <- h2o.deeplearning(x = 2:786, y = 1, trData, activation = "RectifierWithDropout",
                           input_dropout_ratio=0.2,
                           hidden_dropout_ratios=c(0.5,0.5),balance_classes = TRUE ,
                           hidden=c(100,100),
                           momentum_stable = 0.99,
                           nesterov_accelerated_gradient = T,
                           epochs = 20)

#use model to predict testing dataset
h2o.confusionMatrix(res.dl)

h2o_y_test <- h2o.predict( res.dl, tsData)

df_y_test <- as.data.frame( h2o_y_test )
f<-as.data.frame(paste(seq( 49000 , 69999 , 1),".png",sep=""))

df_y_test <- data.frame( filename= f, label = df_y_test$Label )

write.csv(df_y_test, file = "C:\\Users\\MAHE\\Documents\\submission.csv", row.names=F)

# shut down virtual H2O cluster
h2o.shutdown(prompt = FALSE)

