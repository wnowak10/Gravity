# randomForest
# a function to return correlated variables
correlatedValue = function(x, r){
  r2 = r**2
  ve = 1-r2
  SD = sqrt(ve)
  e  = rnorm(length(x), mean=0, sd=SD)
  y  = r*x + e
  return(y)
}

# create training data 
make_train_data = function( n){
  #n=30 # number of variables in training set
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
  return(train_df)
}

# generate random test features
make_test_features = function(n){
  #test_n=2000
  test_x1 = rnorm(n)
  test_x2 = correlatedValue(x=test_x1, r=.95)
  test_x3  = correlatedValue(x=test_x1, r=.95)
  test_x4 = correlatedValue(x=test_x1, r=.95)
  test_x5 = correlatedValue(x=test_x1, r=.95)
  test_features=data.frame(test_x1,test_x2,
                           test_x3, test_x4,
                           test_x5)
  # rename cols so they match 'fit' model
  colnames(test_features)=c('x1','x2','x3','x4','x5')
  return(test_features)
}

# generate test y values, given features
make_test_label=function(features,n){
  outcomes=c(1,0)
  BER=.2
  test_greater=which(features$x1>.5)
  test_less=which(features$x1<.5)
  test_y=rep(0,n)
  test_y[test_greater]=sample(outcomes,length(test_greater),replace = T,prob = c(1-BER,BER))
  test_y[test_less]=sample(outcomes,length(test_less),replace = T,prob = c(BER,1-BER))
  return(test_y)  
}

# return success classified rate for forest model
forest_prediction= function(numTrees)
{
  # Classification Tree with rpart
  library(randomForest)
  train_df=make_train_data(30)
  forestFit <- randomForest(y ~ x1 + x2 + x3 +x4+x5,
                            data=train_df,
                            ntree=numTrees)

  tfs=make_test_features(2000)
  test_labs=make_test_label(tfs,2000)
 
  # how does model do on test data? what is error?
  p=predict(forestFit,newdata=tfs,type="response")
  # codes 0s as 2s for some reason
  # run this in order!
  p=replace(p, p==1, 0)
  p=replace(p, p==2, 1)
  head(p)
  head(test_labs)
  return(sum(p==test_labs)/length(p)) # test success!
}


success_rates=c()
for(i in seq(100)) {
  success_rates=c(success_rates,forest_prediction(5))
}
success_rates

title=sprintf("Distribution of Error Rates (mean = %s)", mean(1-success_rates))
hist(1-success_rates,breaks=seq(.1,.6,.05),
     main=title,xlab="Error Rate")
abline(v=mean(1-success_rates),col="red")

