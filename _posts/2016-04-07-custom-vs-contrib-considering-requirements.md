---
title: Custom vs. contrib, considering requirements
tags: [drupal]
---
When deciding between custom code and Drupal contrib, it's important to consider the requirements. That's why I call this blog post, "Custom vs. contrib, considering requirements". Clever eh?

In a nutshell, the more exact the requirements, the higher the chance you need custom code. So, what do I mean by "exact" requirements? Well, to answer that, I'll need to place an apt header into the this blog post...

## What do I mean by "exact" requirements?

See what I did there? Well, here are some ways that requirements can be more or less exacting:

1. They gave you mockups

    How dare they?! Wait, they even gave you mobile and tablet mockups! Holy crap, you're gonna need custom code. Well not really, but you get the idea. If you've been given mockups that you are expected to match, to the pixel, the forecast for custom code (with a chance of patches) goes up significantly.

2. The mission-statement for the project includes the word "innovative"

    This is a dead give-away that the project is going to get customy. They're going to think outside the box... (in other words, they're going to think of non-useful ways to involve social networking). Dust off your text-editor, because you will not get out of this without writing some PHP.

3. The requester doesn't really know what they want until they see something

    You got your hopes up because the original request was a 2-sentence email. "Contrib will be fine," you say, "I won't even need to style this!". Wrong. After you install that module and submit it for QA, that's when the real requirements start pouring in. Time to write some alter hooks!

4. The project is incredibly complicated

    The more moving parts a site has, the higher the chance that customizations will be needed. Drupal is modular, sure, but eventually there will be incompatibilities and interactions that force you to customize.

So, you got some exacting requirements, and are going to need to write custom code. As you've come to believe from reading my other blog posts, custom code can be problematic, if it gets out of control. So how do you mitigate this problem? Maintain your custom code properly. Keep it to a minimum. Write documentation. But, that is a subject for another blog post.
