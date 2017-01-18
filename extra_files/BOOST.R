#set wd
setwd("/Users/wnowak/wnowak10.github.io/extra_files")

# create training and test data
source('make_boost_data.R')
train_df=create_train_data(2000)
test_df=create_test_data(10000)

# train model using rpart
# single stumps. use rpart.control
library(rpart)
fit <- rpart(y ~ x1+x2+x3+x4+x5+
               x6+x7+x8+x9+x10,
             method="class", data=train_df,
             control=rpart.control(maxdepth=1))
library(rpart.plot)
rpart.plot(fit,type=0)

# find error rates
source('predict_error.R')
train_error(fit,train_df)
test_error(fit,test_df)



boost = function(m,training_df){
  n = length(training_df)
  w = 1/n where n is number of training obs
  for(i in seq(m)){
    # fit initial tree
    # assign(paste("err", i, sep = "_"), #sumwi* mistakes/ wi)
    # assign(paste("alpha", i, sep = "_"), log((1-err)/err)
    #  assign(paste("w", i, sep = ""), rnorm(n))
  }
}