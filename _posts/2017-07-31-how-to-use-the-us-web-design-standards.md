---
title: How to use the U.S. Web Design Standards
tags: [uswds]
---
In past blog posts we have covered what exactly the U.S. Web Design Standards ARE, but now let's get into how we can use them. As mentioned previously, the Standards can either be used in part or in full, by picking and choosing the advice to follow and the code to deploy. But for this and future posts, I am going to be assuming the *full* use of the Standards.

## The assets

There are certain options for how to download and maintain the Standards code in your site, and rather than list them all here, I will simply refer you to the authoritative instructions on [getting started](https://standards.usa.gov/getting-started/developers/). After going through the steps on that page, you should have the Standards library being loaded onto your web pages.

## The markup

A lot of things will immediately change just by virtue of having the Standards loaded onto your pages. Things like form elements and button tags should look different right away. But in order to really see the Standards in action you'll also want to adjust some markup.

Unless you are using a framework's implementation of the Standards (such as the [Drupal theme](https://www.drupal.org/project/uswds), which will be covered in the next blog post) this is the part that you will need to do yourself. I recommend looking through the examples of [components](https://standards.usa.gov/components/) and [page templates](https://standards.usa.gov/page-templates/) for guidance. By duplicating the markup on your page, you'll be able to implement the various components and templates.

## Customize

You may want to customize various aspects of the design. This is fine and expected. It's a bit more elegant if you're using Sass - for example, changing the primary color of the site involves a one-line tweak in Sass; but if you're not using Sass, it will take 10-20 lines of CSS overrides. Either way, though, it amounts to adding some of your own styling to the mix.

Colors, in fact, are probably the first and most common customization you'll be asked (or want) to make. Be careful that you don't mess up the accessibility of the site with your color choices. See [this page](https://standards.usa.gov/components/colors/#section-/colors/02-text-accessibility) for more tips on accessibility through color.

You'll want to look at each proposed design change through the lense of the Standards. Keep going back to the [components](https://standards.usa.gov/components/) and [page templates](https://standards.usa.gov/page-templates/) pages for help.

For example, when asked "can you make the text extend all the way across the screen?", you might refer the requester [here](https://standards.usa.gov/components/typography/#section-/typography/03-typesetting).

Or if asked, "can you make the dropdown appear on hover?", you might refer the requester to the "Accessibility" section [here](https://standards.usa.gov/components/headers/#main-content).

But in any case, this is the part where you write your own CSS (Sass or not) on top of the Standards, with the goal of making it unique and personal, without sacrificing usability or accessibility.

## Create responsibly

While the above covers the technical parts of using the Standards, there is still the matter of creating content. This includes things like: writing articles, populating menus, adding hero images, deciding on a number of columns for a page, and deciding whether to add a sidebar navigation (among many others). We, of course, can't detail all of these tasks here, nor can we say how to do them properly, since each site is different. (For one site, a sidebar navigation may be absolutely necessary and natural, while for another site it is unneeded overkill).

But we can remind you here to keep the Standards in mind as you go through this process. Yet again, having read through the [components](https://standards.usa.gov/components/) and [page templates](https://standards.usa.gov/page-templates/) pages will pay off handsomely here.

For example, did you just add a seventh menu item to a dropdown? You might read the "Why use it?" on [this](https://standards.usa.gov/components/headers/#docs-header-basic-mega) section and decide to switch to a "megamenu".

Another example: are you being asked to put a lot of things in accordions? Perhaps too much? Keep an eye on the "when to consider something else" [here](https://standards.usa.gov/components/accordions/#documentation).

But in short, don't forget the Standards while you are adding content. Remember that they are more than just a library you include on your pages.