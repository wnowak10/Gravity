---
layout: post
title:  "Boosting with tree and forest classifiers"
date:   2017-1-15 19:45:31 +0530
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

```
fit weak classifier
```

With this step done, we find err<sub>m</sub> (2b), \alpha<sub>m</sub> (2c), and we update the weights (2d).

```
2b
2c
2d
``` 

Explain what was just done.



It has to do with residuals. Residuals are the errors in prediction from regression models. More on them [here](https://www.khanacademy.org/math/ap-statistics/bivariate-data-ap/least-squares-regression/a/introduction-to-residuals).



In previous posts, I explained decision trees, and how various algorithms search for optimal split points, given training features and label data. Popular decision tree libraries often go further, having the ability to construct *forest* classifiers. What are random forests and why are they so popular? Let's figure this out:

<iframe src="//giphy.com/embed/TuptaxRZphuyA" width="680" height="520" frameBorder="0" class="giphy-embed" allowFullScreen></iframe>
<p><a href="http://giphy.com/gifs/forest-TuptaxRZphuyA"> GIPHY</a></p>

</a>
 -->
![](/images/decision_trees/1.jpg?raw=true)





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