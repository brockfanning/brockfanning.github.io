---
title: When are contrib solutions overkill?
tags: [drupal]
---
I often argue the benefits of using contrib modules over custom code, but let's explore the other side of the coin here: when are contrib solutions overkill?

First off, we should define overkill. Here are some candidates:

1. The contrib module does what you want, plus 346 other things.

    This isn't horrible in itself, but it should at least give you pause. Maybe it gives you that block you wanted, but it also adds javascript to every page and downloads the contents of Flickr on every cron run. If a module does 346 more things than you need, it's very possible that it is a performance killer. This brings up...

2. The contrib module does what you want, but it is a performance killer.

    This is where tools like jmeter really come in handy. Unless you do consistent load testing, you probably have no way to make this judgment. But if you do, you can prove that a module is a soul-eating memory hog, aka overkill. Drupal gurus can also probably reach this conclusion just by looking at the code. Lesser drupalists may also be able get suspicious by perusing the module's open issues.

3. The contrib module does what you want, but requires a PhD to configure it.

    The module may be exactly what you need, and it may be hyper-efficient and expertly coded, but the problem is that you need to buy a book to figure out how to use it. Of course, if you're serious about Drupal, and you are confident that this module is worth the time investment, you should probably go ahead and drink the koolaid. But otherwise, if you're deciding between 20 minutes of custom coding, versus 5 hours of watching (ultimately uninformative) Youtube videos, reading outdated documentation on Drupal.org, googling Stack Overflow posts, and finally breaking down and looking at the module's code (in that order), it's really easy to opt with the former. Life is short, after all.

4. The custom solution is insanely easy.

    This has nothing to do with the contrib module - it's just that the custom solution is _super_ easy. In fact, it would be faster to write the custom code, commit it, deploy it, and boil and consume 2 artichokes, than it would be to analyze the contrib options, pick one, install it, and configure it.

It's important to remember all the costs of custom code, like the need for documentation, support, training, maintenance, etc. But if you keep all that in mind and still feel that the contrib options are overkill, custom code is definitely an acceptable choice. (And more fun, to boot.)
