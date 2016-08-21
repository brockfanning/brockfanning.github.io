---
title: Custom vs contrib, case studies
tags: [drupal]
---
The decision between custom and contrib needs to involve quite a few factors, so I thought it would helpful to write up a few case studies from past projects. Enjoy!

## Contrib module was overkill, custom wins

Though in general I try to err towards contrib, there will be exceptions, such as this one, on a large government Drupal site. The request was for a certain image to be used whenever a user shared a blog post on Facebook. Developers who have tackled this before know that it involves adding an "og:image" meta tag to blog post.

My first thought, unsurprisingly, was the Metatag module. It's well-used, mature, and it's intended for exactly this requirement. The only catch was, the site was not using Metatag yet. And the site was massive, and struggling with performance issues. So although Metatag was the clear contrib solution to try, I could not rule out a custom solution instead. So how did I decide?

First I did a quick once-over of the Metatag module's project page and issue queue. I didn't really need to, because I've used it many times before, and have never had a problem. But, I just wanted to be thorough. Everything checked out.

Next I checked with my managers about possible future uses of meta tags. This site had been doing quite fine without the Metatag module, so I had to wonder if this was a one-off meta tag request, or if there were going to be many more to come. The managers' response was that there were no other meta tag requests planned.

Next I did a quick audit of what would be involved in a custom solution. Since I've done this before, it didn't take long. It would have been about 15 lines of code, inside an implementation of hook_node_view_alter(), capped off with a call to drupal_add_html_head(). So, pretty easy.

But still, contrib, especially in a government contract situation, is preferable to custom, so I then tried installing Metatag locally and configuring it. It turned out to be something of a chore, because of a Features integration issue, and the fact that if it hijacked meta tags for one node type, it had to hijack meta tags for all node types. So I had to make sure that other node types weren't adversely affected. Eventually, though, I got it working.

Finally, I did load-testing. As I said early, this site was massive, and already struggling with performance issues. So I really didn't want to exacerbate that problem. I use some jmeter tests to impersonate users logging on, creating nodes, etc, and compared the runs with the contrib solution, the custom solution, and no solution.

The results were kind of surprising. The custom solution showed no noticeable effect, as I would have expected. But the contrib solution (Metatag) showed a 4% increase in page load times. Admittedly that's not a huge amount, but it was enough to make me think really hard.

This was only one of many (many) tickets, and if every ticket caused this kind of performance hit, the site would be in trouble fast. Add to that the fact that this was a relatively minor ticket, and quite possibly the first and last meta-related ticket we'd receive -- and I could not bring myself to use the contrib solution.

So, I deployed the custom solution and that was that. I'd like to clarify that I'm not saying the Metatag module is bad or poorly written - I've used it many times and will continue to do so. But, in this case, it was clearly overkill, given the feature request and the site involved.

## Custom seemed the only choice, but an obscure contrib combination won out

In another case, the request was for a system for automatically importing data into Drupal, and displaying it in arbitrary ways. For example, importing a continually updated phone directory, and displaying the data dynamically on a page in human-readable, sortable and filterable form. The catch here was that there would potentially be many of these feeds to import, and each one would have different fields and different display requirements.

So, this was a tough one to fit into any contrib solutions that I knew of. Of course, I could have created a node type for each feed, and given the node type the fields needed. This would have worked fine, but the problem of scaling complexity was a real fear. This was a huge site, with an already high number of content types (about 15). But if we went with the node approach, the number of content types would skyrocket. Though this technically may not have been horrible, for the content team this was too scary.

So I started thinking custom. My idea was to reach out to the external feed source with custom code, and cache the results for 24 hours. Then, each feed would have a corresponding page template which could be altered to display the data in different ways (tables, lists, etc). Sorting and filtering would have been a problem, but hey, it seemed like a fun custom solution to build, so I was gung-ho and ready to code.

Then a co-worker turned me on to the Data module, which is, in some ways, a UI for hook_schema. Using this, I could create effectively "mini" content types with fields (database columns) that could actually be queried with Views. The problem of importing the data into Drupal was solved with Feeds, and a sandbox module called Feeds Data. So, with this magic recipe of Data, Feeds, Feeds Data, and Views, were able to implement the request without any custom code.

There was a bit a of patching to do, but we got it working. In this case, I was not as worried about performance, since we already had Feeds and Views installed, and the modules involved would really only be doing work during cron runs. It's worth discussing the fact that I was OK with using a sandbox module. In my opinion, a sandbox module is as much "contrib" as a full project. Of course, I'd prefer it be a full project, but using a sandbox module is not fundamentally different from using a module's dev version.
