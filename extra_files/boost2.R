#boost2.R
# see wnowak10.github.io/data_science boosting post for more
#set wd
setwd("/Users/wnowak/wnowak10.github.io/extra_files")
set.seed(6)
# create training and test data
source('make_boost_data.R')
train_df=create_train_data(1000)
test_df=create_test_data(1000)
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
fit

# find error rates
source('predict_error.R')
predictions=predictions(fit,train_df)
train_error_rate(predictions,train_df)
test_error_rate(fit,test_df)
predictions

err=c()
alpha=c()
preds=c()
boost = function(m,train_df,test_df){
  n = nrow(train_df)
  #final_sum=rep(0,n)
  w = rep(1/n,n) #where n is number of training obs
  for(i in seq(m)){
    # set training_df to take into account weights
    boost_fit <-rpart(y ~ x1+x2+x3+x4+x5+
                          x6+x7+x8+x9+x10,
                          method="class", data=train_df,
                          weights = w,
                          control=rpart.control(maxdepth=1)) 
    source('predict_error.R')
    preds=c(preds,predictions(boost_fit,test_df))
    predictions=predictions(boost_fit,train_df) # find predictions on train to keep working on model
    
    # use matrix multiply to find sigma of products
    err=c(err,(w%*%(predictions!=train_df$y)) / (sum(w)) )
    # in line above, we are finding sigma (wi * indicator function)
    # what we are doing is finding the weighted error. 
    # finding predictions!=train_df$y gives errors, so the inital
    # round is just the raw error rate. 
    
    alpha=c(alpha,log((1-err[i])/(err[i]))) # reference first error (i=1)
    # if error rate high, this approaches neg inf
    # if error rate low (near 0), this approaches + inf
    
    numeric_mismatch=as.numeric(predictions!=train_df$y)
    w = w*exp(alpha[i]*numeric_mismatch) # set new weights
    # if we missed prediction, w changes to w* e^alpha. if error rate
    # was high, this was like e^-inf = 0...that doesnt make sense?
    
  }
  num_test_obs=dim(test_df)[1]
  summ=rep(0,num_test_obs)
  chunks = list()
  for(i in 1:m){
    chunks[[i]] = preds[(1+((i-1)*num_test_obs)) : (num_test_obs+((i-1)*num_test_obs))]
    summ = summ+alpha[i]*chunks[[i]]
  }
  vals=ifelse(summ>0,1,-1)
  return(vals) 
}

sum(boost(100,train_df,test_df)==test_df$y)/nrow(test_df) 

# run test for multiple m
boosting_iterations=c()
error_rates=c()
for(i in seq(50)){
   boosting_iterations=c(boosting_iterations,i)
   boosted_fit=boost(i,train_df,test_df)
   e=1-sum(boost(i,train_df,test_df)==test_df$y)/nrow(test_df) 
   error_rates=c(error_rates,e)
}

simulation_data=data.frame(boosting_iterations,error_rates)
library(ggplot2)
p <- ggplot(simulation_data, aes(boosting_iterations, error_rates))
p + geom_point(col='orange')+
  labs(title = "Error rate for 1 to 50 boosting iterations")
