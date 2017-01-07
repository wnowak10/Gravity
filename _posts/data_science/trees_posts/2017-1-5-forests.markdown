---
layout: post
title:  "Random forest models explained"
date:   2017-1-6 19:45:31 +0530
categories: data_science
author: "wnowak10"
comments: true
---

In previous posts, I explained decision trees, and how various algorithms search for optimal split points, given training features and label data. Popular decision tree libraries often go further, having the ability to construct *forest* classifiers. What are random forests and why are they so popular? Let's figure this out:

<iframe src="//giphy.com/embed/TuptaxRZphuyA" width="680" height="520" frameBorder="0" class="giphy-embed" allowFullScreen></iframe>
<p><a href="http://giphy.com/gifs/forest-TuptaxRZphuyA"> GIPHY</a></p>

<!-- 	<img src="/images/decision_trees/forest.jpg" alt="Forest" style="width: 420; height: 300"/>
</a>
[Photo](http://shushi168.com/data/out/82/36353757-forest.jpg) -->

The idea of how random forests work isn't so confusing. As I understand it, to construct a forest, we simply generate many trees. To build each tree, we select both a random subset of the training data, and a random subset of features that we choose to use as predictors (hence the moniker RANDOM). We construct many of these random trees to create a forest. In the end, we average (or in some other way) these individual, predictive trees to create a final model. This can be through a simple vote (that is, we look at the predicted class from each tree and accept the prediction with the highest vote total) or some other way. Thales Sehn Körting explains this well in his youtube [video](https://www.youtube.com/watch?v=loNcrMjYh64).

<a>
	<img src="/images/decision_trees/vote.jpg" alt="Forest" style="width: 420; height: 300"/>
</a>

As I said, this isn't so hard to understand. What is more elusive, I think, is why this process is as valuable as it is. We'll need to dig deeper, and consider an example, to understand this. It should be pretty apparent, before we even begin, that random forests have an advantage with regards to scalability. Instead of searching through a full feature space and over all training data, forests simply construct many decision trees quickly (by using a subset of training data on a subset of all available features). In addition, forest construction can be done in parallel; for big data jobs, you could distribute tree construction to various machines and then, after, combine the results to generate your final forest model. 

But the claim is that forests are superior for their classification accuracy, too. This is not immediately obvious. Our examples from before had only two features, which I fear won't be too demonstrative here. So let's create some more training data and see how a random forest would work, when compared to a vanilla decision tree. 

<a>
	<img src="/images/decision_trees/sick_df.jpg" alt="First DF" style="width: 220; height: 100"/>
</a>

# Vanilla tree

First, let's look at the vanilla tree. How well does it do, and how computationally expensive is it? There are 20 training observations (n=20), and we have d=3 features. Since one of the features is numerical with 10 unique values, and the other two features are binary (cloudy or sunny, sick or not sick), our laborious information gain algorithm would have to check (10-1 + 1 + 1 = 11) potential split attributes. The best initial split is on "Sick". 

<a>
	<img src="/images/decision_trees/sick_df2.jpg" alt="Second DF" style="width: 420; height: 300"/>
</a>

At this point, the we have one pure node. The entropy of the "Not Sick" node is 0, so we would code our algorithm to stop searching for a further split when we have reached this state. For the "Sick" node, we'll still look for a second optimal split. We sort of lucked out, as there are only 2 unique temperature values (85 and 90), we only need to check 2 more potential splits (1 for the temperature feature and 1 for the cloud cover). We can easily see that splitting on "Cloudy" is the way to go.

<a>
	<img src="/images/decision_trees/sick_df3.jpg" alt="3rd DF" style="width: 420; height: 300"/>
</a>

After two splits, we have a pretty nice looking model. With a tree depth of 2, we have 3 pure end leaves. So how would the process work for a random forest? Could we achieve similar results?

# Random forest

Let's randomly pick 2 of our 3 features and we'll randomly select 5 of our training observations. Let's repeat this process 3 times and see what happens. My random generator produced {(1,2),(1,3),(1,3)}, so I'll look at these features. After randomly selecting 5 rows, we find the following for our subsetted dataframes:

Subset 1.
<a>
	<img src="/images/decision_trees/1.jpg" alt="sub DF" style="width: 320; height: 100"/>
</a>

![](/images/decision_trees/1.jpg?raw=true)

Subset 2.
<a>
	<img src="/images/decision_trees/2.jpg" alt="sub 2 DF" style="width: 220; height: 50"/>
</a>

Subset 3.
<a>
	<img src="/images/decision_trees/3.jpg" alt="sub 3DF" style="width: 220; height: 50"/>
</a>

For subset 1, the initial entropy is 0, so we don't have to evaluate any split points. The same is true of subset 3!

For subset 2, we do have some "Tea" outcomes, so let's consider the optimal split. There are 3 unique temperature values, and 2 outcomes for sick, so we need to check 3 (3- 1 + 1) potential split attributes. With a little consideration, we can see that splitting on sickness (or on temperature with the node between 60 and 90 degrees) results in the best information gain. If the individual is not sick, we have a pure leaf -- coffee. If the person is sick, it is a toss up (50-50) if coffee or tea is the breakfast beverage of choice. 

So, with this forest in place, let's see how our model does at predicting. Without much work, we can see that it does pretty poorly. Since two of the trees purely predict coffee, and we only made a 3-tree forest, 2/3 of the votes will be for coffee, regardless of the feature inputs. This model will only be right 14/20 times. 

So it seems that our forest was a bit small. We only looked at too few training obs or too few features. So I've still failed to convince anyone that forests do work with high accuracy. I suspect that my toy example was a bit too simplistic. Just like polling fails to work well when samples are too small, forests won't work with too few training observations or features or trees. It would be a pain to manually work through another example with more trees and features, so let's see if I can implement something in Python that makes the issue clear.  

[Elements of Statistical Learning](https://statweb.stanford.edu/~tibs/ElemStatLearn/) by Hastie and Tibshirani, section 8.7, gives a nice discussion of what we are discussing here. 

<a>
	<img src="/images/decision_trees/esl_forest_error.png" alt="ESL" style="width: 420; height: 300"/>
</a>


Let's try to recreate and expand upon their example. They fabricate some data and then compare a tree to a forest. The key result that they find is shown in the following chart...

The error rate of the forest drops well below the test error rate for an individual tree, once the number of trees in the forest gets to ~10.



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