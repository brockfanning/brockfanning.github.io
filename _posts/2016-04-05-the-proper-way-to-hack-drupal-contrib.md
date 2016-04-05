---
title: The proper way to hack Drupal contrib
tags: [drupal]
---
At my day job, I maintain a single site, albeit a very large and complex one. The site was built with a strong bias towards contributed code over custom code, and that mandate has continued into the maintenance phase. Every day there are new bugs found and new features requested, so I spend a good chunk of my time wrangling contrib modules to try to do what I need.

But there's a problem: contrib rarely cooperates. There's always some problem, some incompatibility, some inefficiency, some inadequacy, or just some hardcoded annoyance. So what can I do? Well, ditching contrib and going custom is out of the question. So I have to "hack" contrib. But wait! Before you dismiss me as an irresponsible amateur, let me assure you: I hack properly.

What does that mean? I patch. Then I patch some more. I've hacked quite a few contrib modules, but I've never changed a contrib module without creating an issue in the project queue and posting a patch. Every hack I've made is sitting somewhere in the databases of drupal.org.

"Brock," you may say, "you are a true hero! A selfless Drupal vigilante dedicated to improving the community above all else!". Well... I'm not entirely unselfish. You see, posting patches works in my favor: It legitimizes my hacks. It documents my hacks. It gives me happier clients. And above all else: it lets me code. (Which, let's face it, is a crap-ton funner than Googling for a contrib module...)

So what does it mean to "hack properly". Well, here are a few guidelines:

1. Always do a healthy amount of searching in the issue queue before you start working on something. I've lost track of the number of times I've worked up a full patch before checking the issue queue, and then afterwards realized that someone has already posted a similar patch.
2. Never make changes that apply only to your team or site. Never change a module's template file to say "Jimmy's Tofu Shack!". Never hack a module's preprocess function to add some variables to all "beverage" nodes. Never insert a call to `_our_supercool_helper_function()` into a contrib .module file. If it isn't universally useful, or at least configurable, then it doesn't belong as a patch.
3. Maintain your contrib code in a drush make file. Never apply a patch manually. Instead, list patches in your make file and regenerate with a `drush make`. Since there are a multitude of drush make tutorials online, I won't go into details on the syntax and procedures. But I will give these tips about drush make:
    * If you are applying a patch to a module, most of the time it means you need to start with the dev version. However, don't just put "7.x-1.x-dev" (for example). Instead, choose a git commit and use that. For example, instead of this:

          projects[media][version] = 7.x-2.x-dev

        You should use something like this:

          projects[media][download][type] = git  
          projects[media][download][revision] = b88290c  
          projects[media][download][branch] = 7.x-2.x  

        The reason is that every time you run drush make, if you only specify a dev version, it will always download the latest dev version, which will be constantly changing. Specifying a git commit ("revision") lets you freeze the project in time for consistent behavior.

    * Organize your make file alphabetically, for extra sanity.
    * Keep in mind that if you mess up the syntax of an entry, drush will sometimes quietly download the current stable version, which in many cases will not be what you want. Common mistakes are forgetting the "[version]" if you're targeting a release, or forgetting the "[branch]" if you're targeting a git commit.
4. Follow the Drupal coding standards. A great way to do this is to install phpcs and then set up a "git hook" to lint your code every time you make a commit.
5. If you are considering adding an optional feature to a module, consider whether or not the module already has a configuration page. If the module does NOT have a configuration page (ie, it is a zero-configuration module) then consider making a submodule. Zero-configuration modules are cool, and in my opinion something that Drupal needs more of. On the other hand, if the module DOES have a configuration page, feel free to add a new option to it.
6. Make patches as short as humanly possible. For example, resist the urge to fix other people's code standards, spelling mistakes, indentation problems, etc. That stuff can be in its own patch. Don't refactor something unrelatd to your purpose. Make your patches single-minded and tightly focused. The shorter the patch, the more likely that other people will help you test it out, and the more likely it will eventually make it into the project.
7. Install the browser plugin Dreditor. Among other things, this provides a nice "Insert template" button that helps to make more readable and thorough issues. Even better is the "Patchname suggestion" button, which you can use to get names for your patch files.
8. Don't pester module maintainers about committing your patches. You don't really care if your patch gets committed. You can always just use your patch. The best you can do is set the issue to "Needs Review". If the patch is severely needed, a nudge or two is acceptable. But keep in mind that it's also acceptable to create a patch that depends on another patch. (As long as you make that clear.)
9. If your change is something that only developers would benefit from, consider doing it in a more free-form way by adding a call to module_invoke_all() or drupal_alter() to expose a new hook. If you do this, don't forget to update the mymodule.api.php file with an example of the hook usage.

In closing I want just mention the Drupal 7 lame duck effect. Most module maintainers are much more interested in Drupal 8, over Drupal 7. It's really just those of us maintaining/improving existing sites that care about Drupal 7. Given that, I don't feel bad if very few of your patches get committed. Remember, you can still use it. As long as your hack - I mean, _patch_ - is on Drupal.org, it is official and correct and perfectly acceptable to use.
