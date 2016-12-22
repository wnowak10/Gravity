---
layout: post
title:  "How to: Split"
date:   2016-12-18 19:45:31 +0530
categories: data_science
author: "wnowak10"
---

This is the second part of a series where I intend to explain how decision trees work. In this, I will cover part 2 (How do vanilla tree algorithms really work?). Parts 3-5 will be in subsequent posts.

* Part 1: A beginner's take on decision trees and splitting strategies. 
* Part 2: How do vanilla tree algorithms even work?
* Part 3: Why random forests are useful and what ensembles are
* Part 4: How gradient boosting applies
* Part 5: What bagging is


Before, I was just writing about how I think decision trees can and should work, given my primitive understanding. I made up terms, and it was generally a mess. Though, hopefully there was some insight to be gained by others from walking through the concepts. Fortunately, lots of smart people have been working on this stuff for some time, now. So instead of figuring this out on my own, I can just take to the internet and read about how this actually works. What is the current state of the field? I'll explain in this section. 

I'll start by looking at how we deal with numeric dependent variables, since this is where we left off in the last post. I'll move on to how the experts handle categorical dependent variables in section 2. 

# Section 1: Numeric dependent variables

As seen in Part 1 of this series, Hastie and Tibshirani explain how this is solved in their book, *Elements of Statistical Learning*. 

<a>
	<img src="/images/decision_trees/esl.png" alt="ESL" style="width: 350; height: 250"/>
</a>

They go on to write: "For each splitting variable, the determination of the split point s can be done very quickly and hence by scanning through all of the inputs, determination of the best pair (j, s) is feasible."

So, let's be clear on both what this means, and how it is implemented. As always, an example would probably help. Let's try to predict earnings from education and gender. Our data looks like this: 

<a>
	<img src="/images/decision_trees/earn.png" alt="EARN" style="width: 350; height: 250"/>
</a>

In this case, we generate a cost function, with split variable (j) and split point (s) as parameters to be optimized. Let's split our numerical feature (years of education) at the median. Then, we'll find the average earnings for each half plane. In this case, we split at a median of 15 (I just chose the median for funsies). I'll use excel to find the average for region 1 and 2. 

<a>
	<img src="/images/decision_trees/avg.png" alt="AVG" style="width: 350; height: 250"/>
</a>

Now, we can use excel to find the sum of squared residuals for this proposed split. It looks like the following. 

<a>
	<img src="/images/decision_trees/ssr.png" alt="AVG" style="width: 350; height: 250"/>
</a>

 I am puzzled, because this doesn't seem too computationally cheap to me. For any given split point, we need to a) find two averages, b) find the deviation for each training observation, c) square these deviations, and d) sum the squares. But, as far as I can tell, this is how things are actually done.

 Part of the success of XGBoost, though, was that they altered this approach. The authors of the XGBoost package refer to this as their "Approximate Algorithm" on [page 3](https://arxiv.org/pdf/1603.02754.pdf). Ideally, I'll get around to investigating that innovation in another post. For now, let's move ahead to think about how we deal with categorical dependent variables. 

# Section 2: Categorical dependent variables

There are a lot of different methods for splitting that I read about. [Vidhya analytics](https://www.analyticsvidhya.com/blog/2016/04/complete-tutorial-tree-based-modeling-scratch-in-python/) briefly discusses them here. In particular, 1.) Gini index, 2.) Chi square, and 3.) Information gain are addressed. I'll talk about each here.

## Gini Index

For a given variable j with split points s<sub>i</sub>...s<sub>k</sub>, the Gini Index is given by:

<p><span class="math display">\[\sum_{n=1}^{\infty} 2^{-n} = 1\]</span></p>

- formula
- Let's work an example and explain how gini index tells us useful information

http://www.hypertextbookshop.com/dataminingbook/working_version/contents/chapters/chapter001/section003/blue/page002.html

## Chi Square

## Information gain






















<br>

<br>
<br>
<br>
<br>
<br>


- greediness?





Some further references that touch on these ideas:

Thales Sehn Körting discusses this some in this helpful [video](https://www.youtube.com/watch?v=Qdi0GBWrDO8), but I want to expound upon and clarify his ideas here. 

David MacKay's [*Infomation Theory, Inference, and Learning Algorithms*](http://www.inference.phy.cam.ac.uk/itprnn/book.pdf) gives a good explanation of information and entropy, so you can look 



<br>
<br>

---
<br>
<br>


<a>
	<img src="/images/peewee.gif" alt="Drawing" style="width: 350; height: 350"/>
</a>

Other useful resources:

- [XGBoost docs](http://xgboost.readthedocs.io/en/latest/model.html)
- [Vidhya](https://www.analyticsvidhya.com/blog/2016/04/complete-tutorial-tree-based-modeling-scratch-in-python/)
- [Quora](https://www.quora.com/topic/Random-Forests-Algorithm)
