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

[- Part II -- The experts explanation of tree splitting (or, how this actually works)](#part2)




{: id="part2"}
# Part II: The way this all actually works...

Before, I was just writing about how I think decision trees can and should work, given my primitive understanding. I made up terms, and it was generally a mess. Though, hopefully there was some insight to be gained by others from walking through the concepts. 

Fortunately, lots of smart people have been working on this stuff for some time, now. So instead of figuring this out on my own, I can just take the internet and read about how this actually works. What is the current state of the field? I'll explain in this section. 

There are a lot of different methods for splitting that I read about. [Vidhya analytics](https://www.analyticsvidhya.com/blog/2016/04/complete-tutorial-tree-based-modeling-scratch-in-python/) briefly discusses them here. In particular:

- Gini index
- Chi square
- Information gain






















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
