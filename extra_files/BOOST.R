#set wd
setwd("/Users/wnowak/wnowak10.github.io/extra_files")
set.seed(6)
# create training and test data
source('make_boost_data.R')
train_df=create_train_data(2000)
test_df=create_test_data(10000)
sum(train_df$y==1)

# train model using rpart
# single stumps. use rpart.control
library(rpart)
fit <- rpart::rpart(y ~ x1+x2+x3+x4+x5+
               x6+x7+x8+x9+x10,
             method="class", data=train_df,
             control=rpart.control(maxdepth=1))
library(rpart.plot)
rpart.plot(fit,type=0)

# find error rates
source('predict_error.R')
predictions=predictions(fit,train_df)
train_error_rate(predictions,train_df)
test_error_rate(fit,test_df)


err=c()
alpha=c()
boost = function(m,train_df){
  n = nrow(train_df)
  w = rep(1/n,n) #where n is number of training obs
  for(i in seq(m)){
    # set training_df to take into account weights
    boost_fit <- rpart(y ~ x1+x2+x3+x4+x5+
                   x6+x7+x8+x9+x10,
                 method="class", data=train_df,
                 weights = w,
                 control=rpart.control(maxdepth=1)) # fit initial tree
    source('predict_error.R')
    predictions=predictions(boost_fit,train_df) # find predictions
    # use matrix multiply to find sigma of products
    err=c(err,(w%*%(predictions!=train_df$y)) / (sum(w)) )
      # in line above, we are finding sigma (wi * indicator function)
      # what we are doing is finding the weighted error. 
      # finding predictions!=train_df$y gives errors, so the inital
      # round is just the raw error rate. afterwards, ....
    alpha=c(alpha,log((1-err[i])/(err[i]))) # reference first error (i=1)
      # if error rate high, this approaches neg inf
      # if error rate low (near 0), this approaches + inf
    numeric_mismatch=as.numeric(predictions!=train_df$y)
    w = w*exp(alpha[i]*numeric_mismatch) # set new weights
     # if we missed prediction, w changes to w* e^alpha. if error rate
     # was high, this was like e^-inf = 0...that doesnt make sense?
  }
  return(boost_fit)
}

boosting_iterations=c()
error_rates=c()
for(i in seq(50)){
  boosting_iterations=c(boosting_iterations,i)
  boosted_fit=boost(i,train_df)
  e=test_error_rate(boosted_fit,test_df)
  error_rates=c(error_rates,e)
}

plot(boosting_iterations,error_rates,type='line',col='orange')
boosting_iterations
error_rates
