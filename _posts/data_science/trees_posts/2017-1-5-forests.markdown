---
layout: post
title:  "Random forest models explained"
date:   2017-1-6 19:45:31 +0530
categories: data_science
author: "wnowak10"
comments: true
---

In previous posts, I explained decision trees, and how various algorithms search for optimal split points, given training features and label data. Popular decision tree libraries often go further, having the ability to construct *forest* classifiers. What are random forests and why are they so popular? Let's figure this out:

<a>
	<img src="/images/decision_trees/forest.jpg" alt="Forest" style="width: 420; height: 300"/>
</a>
[Photo](http://shushi168.com/data/out/82/36353757-forest.jpg)

The idea of how random forests work isn't so confusing. As I understand it, to construct a forest, we simply generate many trees. To build each tree, we select both a random subset of the training data, and a random subset of features that we choose to use as predictors (hence the moniker RANDOM). We construct many of these random trees to create a forest. In the end, we average (or in some other way) these individual, predictive trees to create a final model. This can be through a simple vote (that is, we look at the predicted class from each tree and accept the prediction with the highest vote total) or some other way. Thales Sehn Körting explains this well in his youtube [video](https://www.youtube.com/watch?v=loNcrMjYh64).

<a>
	<img src="/images/decision_trees/vote.jpg" alt="Forest" style="width: 420; height: 300"/>
</a>

As I said, this isn't so hard to understand. What is more elusive, I think, is why this process is as valuable as it is. We'll need to dig deeper, and consider an example, to understand this. It should be pretty apparent, before we even begin, that random forests have an advantage with regards to scalability. Instead of searching through a full feature space and over all training data, forests simply construct many decision trees quickly (by using a subset of training data on a subset of all available features). In addition, forest construction can be done in parallel; for big data jobs, you could distribute tree construction to various machines and then, after, combine the results to generate your final forest model. 

But the claim is that forests are superior for their classification accuracy, too. This is not immediately obvious. Our examples from before had only two features, which I fear won't be too demonstrative here. So let's create some more training data and see how a random forest would work, when compared to a vanilla decision tree. 

<a>
	<img src="/images/decision_trees/sick_df.jpg" alt="DF" style="width: 220; height: 100"/>
</a>

# Vanilla tree

First, let's look at the vanilla tree. How well does it do, and how computationally expensive is it? There are 20 training observations (n=20), and we have d=3 features. Since one of the features is numerical with 10 unique values, and the other two features are binary (cloudy or sunny, sick or not sick), our laborious information gain algorithm would have to check (10-1 + 1 + 1 = 11) potential split attributes. The best initial split is on "Sick". 

<a>
	<img src="/images/decision_trees/sick_df2.jpg" alt="DF" style="width: 420; height: 300"/>
</a>

At this point, the we have one pure node. The entropy of the "Not Sick" node is 0, so we would code our algorithm to stop searching for a further split when we have reached this state. For the "Sick" node, we'll still look for a second optimal split. We sort of lucked out, as there are only 2 unique temperature values (85 and 90), we only need to check 2 more potential splits (1 for the temperature feature and 1 for the cloud cover). We can easily see that splitting on "Cloudy" is the way to go.

<a>
	<img src="/images/decision_trees/sick_df3.jpg" alt="DF" style="width: 420; height: 300"/>
</a>

After two splits, we have a pretty nice looking model. With a tree depth of 2, we have 3 pure end leaves. So how would the process work for a random forest? Could we achieve similar results?

# Random forest

Let's randomly pick 2 of our 3 features and we'll randomly select 5 of our training observations. Let's repeat this process 3 times and see what happens. My random generator produced {(1,2),(1,3),(1,3)}, so I'll look at these features. After randomly selecting 5 rows, we find the following for our subsetted dataframes:

Subset 1.
<a>
	<img src="/images/decision_trees/1.jpg" alt="DF" style="width: 220; height: 100"/>
</a>

Subset 2.
<a>
	<img src="/images/decision_trees/2.jpg" alt="DF" style="width: 220; height: 100"/>
</a>

Subset 3.
<a>
	<img src="/images/decision_trees/3.jpg" alt="DF" style="width: 220; height: 100"/>
</a>

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