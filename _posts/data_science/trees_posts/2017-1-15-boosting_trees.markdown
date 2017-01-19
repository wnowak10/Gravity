---
layout: post
title:  "Boosting with tree and forest classifiers"
date:   2017-1-19 19:45:31 +0530
categories: data_science
author: "wnowak10"
comments: true
---

XGBoost is a popular ML library. It's got the term boost in its name, so clearly the act of "boosting" is central to the performance of this algorithm. What does boosting mean with respect to decision trees and forests? Let's investigate this issue here.

Hastie et al describe boosting as "...a procedure that combines the outputs of many “weak” classifiers to produce a powerful “committee." As they make clear in their seminal [text](https://statweb.stanford.edu/~tibs/ElemStatLearn/), the boosting algorithm (due to Freund and Schapire (1997)) successively constructs weak classifiers (meaning they are pretty randomly generated and therefore don't do a good job of classification) on training data that differs in each successive step. In the end, we classify by weighting all of the weak classifiers according. Here's  a schematic from the ESL text.

![](/images/decision_trees/figure10.1.png?raw=true)

So what is this rule? How do we change the data, generate the next weak classifier, and weight this all when said and done? ESL outlines the pseudo-algorithm here:

![](/images/decision_trees/alg10.1.png?raw=true)

As in the [post on forests](https://wnowak10.github.io/data_science/2017/01/06/forests.html), I will try to recreate the simulation Hastie et al run. 

First, we generate the training and test data.

```
#make_boost_data

#boosting from ESL p. 339
# create train data creation function. n = # obs= user input

create_train_data = function(n){
  # create features x1 through x10 (random normal)
  for(i in 1:10){
    assign(paste("x", i, sep = ""), rnorm(n))    
  }
  
  # create label vay (y) as per ESL p. 339 (eq. 10.2)
  y_lim=qchisq(.5,10)
  y=ifelse(x1^2+x2^2+x3^2
           +x4^2+x5^2+x6^2
           +x7^2+x8^2
           +x9^2+x10^2>y_lim,1,-1)
  
  # combine into df
  df = data.frame(x1,x2,x3,x4,
                  x5,x6,x7,x8,
                  x9,x10,y)
  # make y as factor for rpart class prediction 
  df$y=as.factor(df$y)
  return(df)
  # sum(y==1) # should be around 1000 according to ESL.
  # it is
}
#train_df=create_train_data(2000)

# create test data creation function. same as train 
create_test_data = function(n_test){
  # create features
  for(i in 1:10){
    assign(paste("x", i, sep = ""), rnorm(n_test))    
  }
  
  # create label var (y)
  y_lim=qchisq(.5,10)
  y=ifelse(x1^2+x2^2+x3^2
           +x4^2+x5^2+x6^2
           +x7^2+x8^2
           +x9^2+x10^2>y_lim,1,-1)
  
  df = data.frame(x1,x2,x3,x4,
                  x5,x6,x7,x8,
                  x9,x10,y)
  df$y=as.factor(df$y)
  return(df)
  # sum(y==1) # should be around 1000 according to ESL.
  # it is
}

#test_df=create_test_data(10000)
```

If we use a 1 stump classifier, we can see the results on the test set match the ESL text. We use the rpart library's rpart function to fit a tree. We fit y on all features, using the class method (this is classification and not regression). We use our train_df created by the create_train_data function as our training observations. We use the rpart control option to limit the depth of the tree to 1. We are creating stumps.

```
library(rpart)
fit <- rpart::rpart(y ~ x1+x2+x3+x4+x5+
               x6+x7+x8+x9+x10,
             method="class", data=train_df,
             control=rpart.control(maxdepth=1))

```

If we use rpart.plot, we can see what this stump looks like.

```
library(rpart.plot)
rpart.plot(fit,type=0)
```

![](/images/decision_trees/stump.png?raw=true)

To understand what this image shows...

* We can see from the data generating function that one single split won't do well to model the data, so her a fairly arbitrary split is made. If x3 >= 1.2, then predict -1, else predict 1. 


We then create functions to return the error rates when fed a model and data. We split the train error function into two, as it will be useful to have a unique function to spit out predictions when we try to implement algorithm 10.1.

```
predictions = function(fit,train_df){
  train_p=predict(fit,data=train_df$y,type="vector")
  # replace to match -1 and 1 with training label
  train_p=replace(train_p, train_p==1, -1)
  train_p=replace(train_p, train_p==2, 1)
  return(train_p)
}

train_error_rate = function(train_p,train_df){
  train_success=sum(train_p==train_df$y)/length(train_p)
  return(1-train_success) # train success rate
}

test_error_rate = function(fit,test_df){
  p=predict(fit,newdata=test_df,type="vector")
  # codes 0s as 2s for some reason
  # run this in order!
  p=replace(p, p==1, -1)
  p=replace(p, p==2, 1)
  #head(p)
  #head(test_df$y)
  test_success = sum(p==test_df$y)/length(p) # test success!
  return(1-test_success) # test error rate matches ESL
}

predictions(fit,train_df)
train_error_rate(fit,train_df)
test_error_rate(fit,tes_df)
```

Now, we implement the algorithm. 

![](/images/decision_trees/alg10.1.png?raw=true)


```
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
```

Let's work through this step by step. First we create empty lists for us to compute err<sub>m</sub> and alpha<sub>m</sub>. In the boost function, we initialize the weights, so every observation has weight 1/n (with n the number of obs). Then, we enter the for loop as per line 2.

For 2a), we fit a stump:

```
boost_fit <- rpart(y ~ x1+x2+x3+x4+x5+
                   x6+x7+x8+x9+x10,
                 method="class", data=train_df,
                 weights = w,
                 control=rpart.control(maxdepth=1)) # fit initial tree
```

For 2b), we compute err<sub>m</sub>. To find the sum of w<sub>i</sub> * I, we use matrix multiplication to find the dot product. To generate the indicator function (such that I = 1 when we have MISpredicted, we run the following):

```
predictions!=train_df$y
``` 

For 2c), we compute alpha<sub>i</sub>. We can see from the function, that this gives a result approaching negative inf when our prediction is bad (if the error rate is near 1) and positive infinity when our prediction is good (error rate near 0). 

```
alpha=c(alpha,log((1-err[i])/(err[i]))) # reference first error (i=1)
```

![](/images/decision_trees/alpha.png?raw=true)

For 2d, we reassign weight values. If we made a mis-prediction in our model, numeric_mismatch = 1, and we therefore raise e to the power of alpha and then multiply by w. Given that w is initially small and positive, this will make w small (w*e^-inf is close to 0). Hmmm...this might be the problem. This doesn't make much since. I thought the goal was to give increasing weight to our misclassifications, so we can learn better from them in the future. 

```
w = w*exp(alpha[i]*numeric_mismatch) # set new weights
```

Clearly, something is amiss. When I try to recreate HSL's work with 50 boosting iterations, I get the following chart.

![](/images/decision_trees/boost_progress.png?raw=true)

Compare this to HSL, which shows neat progress in prediction as the number of boosting iterations goes up...

![](/images/decision_trees/figure10.2.png?raw=true)

Can anyone help me determine the problem? Here is the key algorithm code again (where I would guess the error is):

```
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
```




{% if page.comments %}

<div id="disqus_thread"></div>
<script>

/**
*  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
*  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables*/
/*
var disqus_config = function () {
this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
};
*/
(function() { // DON'T EDIT BELOW THIS LINE
var d = document, s = d.createElement('script');
s.src = '//wnowak10-github-io.disqus.com/embed.js';
s.setAttribute('data-timestamp', +new Date());
(d.head || d.body).appendChild(s);
})();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>

{% endif %}