---
title: What exactly ARE the U.S. Web Design Standards?
tags: [uswds]
---
To circumvent my sudden case of writer's block, let's kick things off with the official blurb from the [U.S. Web Design Standards site](https://standards.usa.gov):

> The Standards are a design system that allows federal agencies to quickly prototype and deploy digital products using a baseline of design patterns.

Blog post over? Nah, I still have some expounding to do. Let's actually start, however, with what the Standards are *not*:

## The Standards are not a government requirement

This is not another Section 508. Nobody is going to be auditing your site and scoring you on "U.S. Web Design Standards compliance". Admittedly the word "Standards" does tend to conjure thoughts of compliance and requirements, but rest assured that using the Standards is *not* a requirement.

The team responsible for the Standards chose the goal of "making the right thing the easiest thing" (paraphrasing from [this video](https://www.youtube.com/watch?v=iLD4Bu6I2I8). Clearly they would *like* for all U.S. government sites to use the Standards. But rather than making it mandatory, they tried to make the Standards so great and easy that everyone would *want* to use them.

And I think they've done a great job (or else I wouldn't be writing this blog series) of realizing that goal. At times including members of the [USDS](https://www.usds.gov/) and [18F](https://18f.gsa.gov/), the U.S. Web Design Standards team has produced a 100% optional no-brainer, in my opinion.

## So what is it then?

The Standards are a one-two punch of awesomeness:

1. Advice: Their [site](https://standards.usa.gov) are full of great advice and guidance about web usability and accessibility.
1. Code: A fully-functional front-end library that (when combined with the suggested markup) produces usable, accessible, and responsive websites.

You can pick and choose the advice that you want to follow, and the code is open-source, so can be used just as easily in part or in whole. The "one-two punch" I alluded to earlier lies in the fact that following the Advice is easier (effortless, really) if you use the Code. This is huge.

A great example is this piece of [typesetting advice](https://standards.usa.gov/components/typography/#typesetting-docs):

> Controlling the length of lines of text in extended copy makes reading more comfortable by helping readers’ eyes flow easily from one line to the next. Somewhere between 50 and 75 characters per line is broadly considered to be a readable line length, while 66 characters is considered the ideal.

We could follow that advice by simply putting a max-width on our content. The Standards facilitate this by providing a `usa-content` class with the ideal max width. But what about cases where the narrow content leaves your site with awkward whitespace? The Standards have solutions for this as well, by providing an easy-to-use [grid system](https://standards.usa.gov/components/grids/).

Rather than copy-paste all that the Standards provides, I'm going to recommend that you read through [this entire section](https://standards.usa.gov/components/). This is the best way to get a full picture of what the Standards are. Happily it will also give you a great free education in usability and accessibility.

Give it a read, and then check out my next post about how to use the Standards.
