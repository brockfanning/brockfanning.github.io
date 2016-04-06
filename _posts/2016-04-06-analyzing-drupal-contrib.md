---
title: Analyzing Drupal Contrib
tags: [drupal]
---
In a Drupal project, when you're trying to decide between custom and contrib, it can help to have a standard operating procedure for analyzing contributed modules. It comes up a lot, so I'll talk here about a few of the most efficient ways to judge a Drupal module. But first let's cover the red flags that you're looking for when analyzing a module.

## Red flags

1. Module breaks your site

    I like to start with the obvious. You don't wanna install a module that will break your site. The Drupal community is really good about weeding these out, but you never know. This can result from bad code, outdated code, or just unfortunate interaction with other modules.

2. Module severely impacts performance

    The Drupal API can be utilized/bypassed/misused/etc in a variety of ways, which means that modules can range from sleek and efficient to insane performance killers. Avoid the latter.

3. Module is no longer supported

    The module maintainer has left the building, and the bugs are moving in. This is another area where the Drupal community can come together and help, but this is definitely a hurdle.

4. Module has a lot of possibly show-stopping bugs

    Bugs happen. If the module isn't going to do what you need it to do, it's not worth your time to install and configure it, so you may want to just move on.

5. Module does not have a stable release

    Many modules on drupal.org are still in alpha or beta releases, or even still being developed. This is not the end of the world, and sometimes just means the maintainer hasn't had 30 minutes to give it a stable release. But it is something to keep in mind. All things being equal, err towards the modules with stable releases.

6. Module has other similar modules on drupal.org

    The Drupal community is great about discouraging this, but sometimes there will be multiple modules that do essentially the same thing. Take note of this, as it means you'll have to analyze all of your options.

So those are the red flags to look for. Now how about some strategies for rooting them out?

## Tips for analysis

1. Go to the module's project page on Drupal.org

    Did I mention I like to start with the obvious? Read the README, browse any installation and usage instructions. This should give you a quick idea of whether the module is even feasible at all.

2. Look at the number of sites that are using the module.

    At the bottom of the project page you can see a general idea of how many live sites are using the module. This is a helpful thing to know that can save you time in your analysis. For example if a module is being used by 50,000 sites, you can at least be sure it's not broken, and it's probably not a performance killer either. Don't give up on a module just because less than 10 sites are using, but do keep that in mind.

3. Look at the date of the last commit

    At the top of the right sidebar on the project page you'll see the dates of the last commits. If nobody has done a commit in more than a year, that's something to be aware of. Maybe it's fine because the maintainer just kept the module's scope small and got it working. But often it can mean that the module is no longer supported.

4. Look at the issue queue

    Go to the issues page for the project, and filter by your version of Drupal. Look at the open issues. Do you see a lot of year-old posts like "This module doesn't work" or "What is this module supposed to do?"? If so, that's a bad sign: it means that people have probably given up on a broken or unsupported module. On the other hand, if you see a lot of recent posts like "Support latest version of Media" or "Use composer manager", that's a good sign: it means that people are using and improving the module. If you see zero issues, I would be a little suspicious.

 5. Look at the releases available

    If a module only has a dev release, that is a little questionable. It is not the end of the world, but especially for Drupal 7 (this late in the Drupal 7 lifetime) a module should at least have a beta release. On the other hand, if the module has a stable release that was last updated in 2014, that's questionable as well.

6. Try the module out

    Install the module on your local site if you can, or otherwise use [https://simplytest.me](https://simplytest.me/). This is mainly to get a feel for the configuration options, if any, and see the functionality first-hand.

7. Benchmark the module on your site

    If performance is important to you, it never hurts to do a benchmark of the site. I would recommend getting comfortable with jmeter, so that when necessary you can do more complicated tests with authenticated traffic. [This](https://github.com/erikwebb/drupal-jmeter-tricks) is a good starting place for Drupal jmeter tests. If you just want quick anonymous tests, something like Apache Bench works too. Make sure that each set of tests starts from an identical database state, so that you don't get fooled by warm/cold caches.

8. Look at the module code

    This step may not be for everyone, but if you're comfortable with the Drupal API, this can bolster (or crush) your confidence in the module. Hopefully what you see is not like [this](https://www.drupal.org/project/fail).

## Go forth and judge

After all of this, you should have a pretty good idea of whether a module is worth trying or not. It may seem like a lot to do and think about, but you will quickly find that you can zero in on the deal-breakers pretty quickly. Good luck! And if you ever get frustrated, just remember that it could be worse: you could be analyzing Wordpress plugins.
