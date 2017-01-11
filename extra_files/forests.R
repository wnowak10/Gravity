# randomForest

# create function called predd that returns test accuracy
# arguments of function include minTreeDepth

correlatedValue = function(x, r){
  r2 = r**2
  ve = 1-r2
  SD = sqrt(ve)
  e  = rnorm(length(x), mean=0, sd=SD)
  y  = r*x + e
  return(y)
}


forest_prediction= function(numTrees)
{
  #set.seed(6)
  
  n=30 # number of variables in training set
  x1 = rnorm(n) # random normal, mean 1, sd 1
  x2 = correlatedValue(x=x1, r=.95) #4 other correlated features
  x3  = correlatedValue(x=x1, r=.95)
  x4 = correlatedValue(x=x1, r=.95)
  x5 = correlatedValue(x=x1, r=.95)
  
  # create label variable.
  outcomes=c(1,0)
  BER = .2 # bayes error rate of 20%
  greater=which(x1>.5)
  less=which(x1<.5)
  y=rep(0,n)
  y[greater]=sample(outcomes,length(greater),replace = T,prob = c(1-BER,BER))
  y[less]=sample(outcomes,length(less),replace = T,prob = c(BER,1-BER))
  
  # bayes error = .2 because y 
  # is symmetric with a bayes error of .2. if we had a<.5 and
  # p(y=1|x>.5)= .5 and P(y=1|x<.5) = .7, then bayes error would be
  # average of .5 and .3 = .4. ya? ya. 
  train_features=data.frame(x1,x2,x3,x4,x5)
  train_df=data.frame(x1,x2,x3,x4,x5,y)
  train_df$y=as.factor(train_df$y)
  
  # Classification Tree with rpart
  library(randomForest)
  #library(rpart.plot)
  # grow tree 
  #numTrees=500
  forestFit <- randomForest(y ~ x1 + x2 + x3 +x4+x5,
                            data=train_df,
                            ntree=numTrees)
  
  # if i want to plot
  #rpart.plot(fit,type=0)
  
  #printcp(fit) # display the results 
  #plotcp(fit) # visualize cross-validation results 
  #summary(fit) # detailed summary of splits
  
  # generate test set. ESL uses 2000 obs
  test_n=2000
  test_x1 = rnorm(2000)
  test_x2 = correlatedValue(x=test_x1, r=.95)
  test_x3  = correlatedValue(x=test_x1, r=.95)
  test_x4 = correlatedValue(x=test_x1, r=.95)
  test_x5 = correlatedValue(x=test_x1, r=.95)
  test_features=data.frame(test_x1,test_x2,
                           test_x3, test_x4,
                           test_x5)
  # rename cols so they match 'fit' model
  colnames(test_features)=c('x1','x2','x3','x4','x5')
  test_greater=which(test_features$x1>.5)
  test_less=which(test_features$x1<.5)
  test_y=rep(0,test_n)
  test_y[test_greater]=sample(outcomes,length(test_greater),replace = T,prob = c(1-BER,BER))
  test_y[test_less]=sample(outcomes,length(test_less),replace = T,prob = c(BER,1-BER))
  
  # how does model do on training data? what is error?
  train_p=predict(forestFit,newdata=train_features,type="response")
  # codes 0s as 2s for some reason
  # run this in order!
  train_p=replace(train_p, train_p==1, 0)
  train_p=replace(train_p, train_p==2, 1)
  head(train_p)
  head(y)
  sum(train_p==y)/length(train_p) # train success rate
  
  # how does model do on test data? what is error?
  p=predict(forestFit,newdata=test_features,type="response")
  # codes 0s as 2s for some reason
  # run this in order!
  p=replace(p, p==1, 0)
  p=replace(p, p==2, 1)
  head(p)
  head(test_y)
  sum(p==test_y)/length(p) # test success!
  
  
  # now construct forest annd do again
  # then record # trees and test error in list to plot
  
  
  
  # next steps
  # make tree with set depth
  # make forest with boot strap vs samples from data
  # make forest with various # features
  # compare test accuracy of these
  
  
}


success_rates=c()
for(i in seq(10)) {
  success_rates=c(success_rates,forest_prediction(2))
}
success_rates

title=sprintf("Distribution of Error Rates (mean = %s)", mean(1-success_rates))
hist(1-success_rates,breaks=seq(.1,.6,.05),main=title)
abline(v=mean(1-success_rates),col="red")

