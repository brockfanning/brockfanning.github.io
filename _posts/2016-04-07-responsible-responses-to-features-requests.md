---
title: Responsible responses to feature requests
tags: [drupal]
---
A lot of us web developers, especially in the open source community, are an unfortunate hybrid of people-pleasers, optimists, and puzzle-enthusiasts. This means that when asked, "Is XYZ possible?", we usually say "Yes". And when asked "How long will XYZ take?", we usually, "That shouldn't be too hard!". And then we proceed to over-work and over-engineer so that we can live up to our promise. Those late-night and weekend git commits... yeah, it's a dead give-away.

But when we do this, we're not only screwing over ourselves, but we're also screwing over the manager that made the request. They are going to probably end up with a highly customized feature (which we know from other posts has definite costs) and will go forward with that understanding that... a) this level of customization is easy and fast, and b) this level of customization is the only option.

But there are usually other options, and we owe it to the managers to make sure they are aware of them. When you are asked if something is possible, you should always qualify your "Yes" with "but it will take X hours". And even better, offer some alternatives: "If we did ABC instead of XYZ, we could use this contrib module and it will only take Y hours."

Sometimes though, there are no other options. It's just got to be custom. That's fine, but we need to a) take into account the time spent on documentation for customizations, and b) make sure the manager is aware of the ongoing costs of custom code. Once managers are aware of the pitfalls of custom code, you can save some time by saying, "Yes, that is possible, but it will require custom code. Would you like me to give an estimate?". Sometimes, that warning will discourage the feature request.

This post may be sounding more like "How to avoid doing feature requests", but I promise that's not what I'm going for. This is really about accurately communicating the _costs_ of a feature request to the requester. It's a known fact that developers tend to underestimate the level of effort for tasks. Add to that the fact that we (developers) like to customize, and that we underplay the long-term costs of custom code -- now the managers are really in trouble.

So in conclusion, be realistic about time estimates, be honest about the level of customization needed, offer contrib alternatives (even if they don't quite meet the requirements), and educate your managers about the costs of custom code. That is the responsible way to respond to feature requests.
