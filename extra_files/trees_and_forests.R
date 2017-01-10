

correlatedValue = function(x, r){
  r2 = r**2
  ve = 1-r2
  SD = sqrt(ve)
  e  = rnorm(length(x), mean=0, sd=SD)
  y  = r*x + e
  return(y)
}

# credit:
# http://stats.stackexchange.com/questions/38856/how-to-generate-correlated-random-numbers-given-means-variances-and-degree-of

#set.seed(6)
n=30
x1 = rnorm(n)
x2 = correlatedValue(x=x1, r=.95)
x3  = correlatedValue(x=x1, r=.95)
x4 = correlatedValue(x=x1, r=.95)
x5 = correlatedValue(x=x1, r=.95)

outcomes=c(1,0)
BER = .2
greater=which(x1>.5)
less=which(x1<.5)
y=rep(0,n)
y[greater]=sample(outcomes,length(greater),replace = T,prob = c(1-BER,BER))
y[less]=sample(outcomes,length(less),replace = T,prob = c(BER,1-BER))

# bayes error = .2 because y 
# is symmetric with a bayes error of .2. if we had a<.5 and
# p(y=1|x>.5)= .5 and P(y=1|x<.5) = .7, then bayes error would be
# average of .5 and .3 = .4. ya? ya. 
train_df
train_df=data.frame(x1,x2,x3,x4,x5,y)
head(train_df)
train_df$y=as.factor(train_df$y)

# Classification Tree with rpart
library(rpart)
library(rpart.plot)
# grow tree 
fit <- rpart(y ~ x1 + x2 + x3 +x4+x5,
             method="class", data=train_df
             , minbucket=5)


#rpart.plot(fit,type=0)

#printcp(fit) # display the results 
#plotcp(fit) # visualize cross-validation results 
#summary(fit) # detailed summary of splits

test_n=2000
test_x1 = rnorm(2000)
test_x2 = correlatedValue(x=test_x1, r=.95)
test_x3  = correlatedValue(x=test_x1, r=.95)
test_x4 = correlatedValue(x=test_x1, r=.95)
test_x5 = correlatedValue(x=test_x1, r=.95)
test_features=data.frame(test_x1,test_x2,
                         test_x3, test_x4,
                         test_x5)
colnames(test_features)=c('x1','x2','x3','x4','x5')
head(test_features)
test_greater=which(test_features$x1>.5)
test_less=which(test_features$x1<.5)
test_y=rep(0,test_n)
test_y[test_greater]=sample(outcomes,length(test_greater),replace = T,prob = c(1-BER,BER))
test_y[test_less]=sample(outcomes,length(test_less),replace = T,prob = c(BER,1-BER))
test_y
sum(test_y)


p=predict(fit,newdata=test_features,type="vector")
# codes 0s as 2s for some reason
# run this in order!
p=replace(p, p==1, 0)
p=replace(p, p==2, 1)
head(p)
head(test_y)
sum(p==test_y)/length(p) # test error!


# now construct forest annd do again
# then record # trees and test error in list to plot



# next steps
# make tree with set depth
# make forest with boot strap vs samples from data
# make forest with various # features
# compare test accuracy of these
#test_x1
# does rpart use classification vote or probabilities to classify?
#summary(test_features)
#head(test_features)
#dim(test_features)
