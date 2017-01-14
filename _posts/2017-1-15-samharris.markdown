---
layout: post
title:  "AI and the value alignment problem"
date:   2017-1-15 19:45:31 +0530
categories: other
author: "wnowak10"
comments: true
---

![](/images//midas.jpg?raw=true)


I was recently listening to the following podacst with Sam Harris and Stuart Russell. It's a nice discussion of the future of AI and superintelligence. They give a good basic introduction, while also introducing some thoughts I hadn't heard before.

<iframe width="100%" height="166" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/294502396&amp;color=ff5500"></iframe>

They discuss what is currently known as the "value alignment problem" in AI. That is, if (when?) we create a super-intelligent computer, we could be SoL if we don't embed the proper values within it. Russell makes a fun analogy to Midas (whose wish to have all he touched turn to gold demonstrated a lack of foresight). Though we might hope our superintelligent overlords / overseers will promote flourishing, many in the AI community rightly feel that we have no clear way to convey our sense of what human flourishing is to the robot. 

Here is my solution: add randomness to the AI's objective function. At least traditionally, AI's have some sort of objective. They try to balance upright, or yield high stock returns, or maximize [paperclip production](https://en.wikipedia.org/wiki/Instrumental_convergence#Paperclip_maximizer). Things go wrong, because we can't perfectly and parsimoniously state a rule for an AI to follow, because we human beings can't (and wouldn't want) to do this for ourselves. 

So perhaps we introduce a bit or randomness into the objective function. Aim for f<sub>1</sub>, and then f<sub>2</sub>. By confusing an AI in this way, can't we introduce a balance in its goal seeking? Thoughts?


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