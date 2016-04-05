---
title: Custom vs contrib, considering hand-offs
tags: [drupal]
---
One of the drawbacks of developing Drupal sites with custom code is the eventual headache for the next developer that works on it. It's an easy drawback to ignore, because hey, it's not your problem right? Well, it can be. If you work for an agency that shuffles developers between projects like hot potatoes, this can be a real problem. In that kind of agency, it's really in your best interests to foster a culture of limited customization.

Even in a contracting situation, you probably want to curb your customization urges. If you leave a client with a highly customized site that they have no idea how to maintain, you've got to do a lot of extra work training and documenting. Or if you just peace out, you'll get a ding on your reputation that will probably catch up with you.

I have personally been on both sides of these situations. The site I currently maintain was developed with an absolute minimum of customization, and that has been a huge help in figuring things out. By contrast, at a previous job I went _way_ off the deep end customizing a Drupal site, with custom modules, object-oriented entity hierarchies, compiled entity templates, and json-powered PatternPal integrations. It was awesome. But, after I was gone, the agency was pretty much stumped when they needed to add new features. My bad!

So in short, when you get that urge to create a new module folder, think twice. As much as you may hate doing it, you may want to look around for a contrib solution first.
