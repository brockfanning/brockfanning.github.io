---
title: Behat for multi-site Drupal
tags: [drupal, behat]
---
Each of the sites in the ARHU multisite installation are built in a different way. But they have many similarities. To be as efficient as possible with our Behat setup, we try to share tests, but also allow for differences.

The basic idea is that all tests are run on all the sites. This means we don't have to write a test separately for each ARHU site. You just write it once, and then run it again all the sites. The challenge comes when each site has slight differences that complicate things. For example, we may write a test to assert that the calendar works, but on one of the sites, the calendar module is disabled. So, we need a way to customize or exclude tests for certain sites.

There are several files and folders or files that help achieve this.

## behat.yml

This is the default configuration file for how Behat runs.

These are some of the things that are typically configured in behat.yml:

* the URL of the site to run the tests against
* the "context" (step/hook definition) files to include
* the paths on disk where the tests are located
* any filters to control which tests are run (or not run)
* any text strings for the Drupal extension (more on that later)
* any javascript-browsing configuration (Selenium)

## behat.yml for other environments

These are any number of optional .yml files for each other environment that you would like to run Behat against. Typically these import behat.yml and then have a few minor differences, like different URLs. In practice, you will probably find that you only ever run Behat against your local install, so the important file to look at would be vagrant.yml. When running the behat binary (/vendor/bin/behat from the project root) you use the "-c" flag to specify a configuration file to use. So for example, to run Behat against your local install, you would do something like:

```
vendor/bin/behat -c tests/behat/vagrant.yml
```

## about Behat "profiles"

In the .yml files mentioned above, at the highest level the configurations are sectioned off by site. These sections are called "profiles". For example, there is an "apply" profile, an "english" profile, a "music" profile, etc. When you run Behat, if you don't specify a profile, the "default" profile is used. In addition to specifying a configuration file as above, you also specify a profile with the "-p" flag, like so:

```
vendor/bin/behat -c tests/behat/vagrant.yml -p music
```

## about Behat "suites"

In the .yml files mentioned above, there is yet another sectioning of configuration called "suites". We don't currently make use of different suites, and so all profiles use only one suite: "default".

## step definitions

Out of the box, Behat has no idea what the human-readable steps mean, and so it relies on step definitions that are defined in PHP. Behat calls these PHP files "contexts". All the ARHU profiles load the "Drupal\DrupalExtension\Context\MinkContext" context. This is a class you can find in the "vendor" folder. In addition, each profile loads the "GlobalContext" context, passing a parameter identifying that site. This is a class you can find in tests/behat/contexts. Finally, each profile can specify any number of additional context files. For example, the "english" profile also loads the "EnglishContext" context.

You can see a list of all the defined step definitions with the "-di" flag. For example:

```
vendor/bin/behat -c tests/behat/vagrant.yml -di
```

If you ever need to write a new step definition, the easiest way is to first write out the human-readable step in a feature, as if it were already implemented. For example, you might write:

```
Given I click on the second item in the main menu
```

Then, when you next run that test, Behat will see that step and will not know what to do with it. It will stop that test with an exception. However, it will also output some example code for how you would implement that step in a context file. This output might look someting like:

```
--- GlobalContext has missing steps. Define them with these snippets:

    /**
     * @Given I click on the second item in the main menu
     */
    public function iClickOnTheSecondItemInTheMainMenu()
    {
        throw new PendingException();
    }
```

You can then copy that snippet into a context file, and then fill in whatever code is necessary to actually run the step. We'll go into more detail later about writing the code for custom step definitions.

## step variables

Some step definitions use no variables. The example above, "Given I click on the second item in the main menu" is a good example of that. This is fine. However, by adding variables, step definitions can be more reusable. For example, the above might be changed to:

```
Given I click on the second item in the "main" menu
```

Now, the name of the menu is a variable, and can be changed each time that step definition is used. Behat is smart enough to notice those double-quotes, and will adjust its auto-generated snippet accordingly. For example, the snippet would now be something like:

```
--- GlobalContext has missing steps. Define them with these snippets:

    /**
     * @Given I click on the second item in the :arg1 menu
     */
    public function iClickOnTheSecondItemInTheMenu($arg1)
    {
        throw new PendingException();
    }

```

You can also change "arg1" in the snippet to something more meaningful, such as "menu_name". Notice that it is passed into the function itself, so the code of the step definition can react to the dynamic variable value.

## data/global.yml

In Behat tests it is a best practice to prefer human-readable language over technical jargon or machine names. For example, instead of saying "click on #main-button-2" say "click on the main button". The data/global.yml file serves as a mapping of these human-readable words to machine-readable strings. There are currently 3 categories of mappings: selectors, paths, and roles. More categories can be added as needed.

## data/*.yml

All the other .yml files in the data/ folder serve to override or extend the global.yml data for each individual site. This is a great way to account for the differences between the sites.

## about these data/* files

FYI, this is not typical Behat functionality. This data/* system was implemented just for ARHU. To see the mechanism for this, see tests/behat/contexts/GlobalContext::__construct().

## features, scenarios, and tags

In Behat the term "feature" refers to a file that contains one or more "scenarios". A scenario is essentially a test. Scenarios are like "stories" in agile development. (Similarly, features are like agile's "epics".) In Behat, you can add tags above any scenario, in the form of the "@" character and a string. For example, you might put "@events" above all scenarios related to events. This will be useful later, when you might want to run only the events-related tests, or exclude the events-related tests.

You can also add these tags to the very top of a feature file. This is the same as adding that tag to all the scenarios in the file.

There are a couple of special tags:

* @javascript: Normally Behat runs tests by making HTTP requests and examining the markup that is returned in the response. However, some tests may require interaction with javascript. Putting the @javascript tag on a scenario tells Behat to run the scenario in an actual browser, so that it can make use of javascript. Note: This is slower than normal, so you should only add this tag when it is actually needed. It also requires something like Selenium to be running. (If you use the DrupalVM vagrant box, Selenium will be running automatically.)
* @api: Adding the @api tag allows you to use a lot of Drupal-specific steps in your scenarios. You can find some examples [here](http://behat-drupal-extension.readthedocs.io/en/3.1/drupalapi.html). Many of these involve actually creating Drupal content for use during the test. Note that you need to be on the actual server in order to run these tests. Ie, if you want to run these tests on Acquia's development server, you need to SSH into Acquia. In general, it is best to run them locally, since you will likely be making changes that you want to test immediately. Also note that any content/users/etc that is created by these steps gets automatically cleaned up afterwards.

## features/global and features/*

The "paths" section of the configuration files (eg, vagrant.yml) tells Behat which tests to run. Behat will recursively look through each of the indicated folders and run all the features it finds. You'll notice that all the profiles specify the features/global folder, as well as a specify folder for that site, such as features/english. When creating new features, this allows you to either put them in features/global, if you think they are applicable to every site, or put them in the site-specific folder, if you think otherwise.

Since Behat looks through these folders recursively, the structure of the sub-folders is completely arbitrary, and you are encouraged to organize the files in whatever hierarchy makes it easier to maintain.

## more about filters

A common problem is that you may write a feature that applies to all the sites except one. You would love to put the test in the features/global folder, but you know that it will fail on that one site that is not applicable. The solution is to go ahead and put the feature in features/global, but give it a unique tag, such as @mytag. Then, go into the behat.yml file, and adjust the "filters" section for that problem site. By adding "~mytag", you can tell Behat to exclude all "mytag" scenarios.

## more about coding step definitions

A common need in a step definition is to select some element on the page and examine or interact with it. For example, suppose you need to find a link with the id of "my-link". This is an example of how you might do that inside a step definition in a context file:

```
$link = $this->getSession()->getPage()->find('css', '#my-link');
```

The "css" literal above is telling the find() method that '#my-link' should be treated like a CSS selector. The getSession() and getPage() methods are common ones that you will use frequently. As you do this kind of coding, you will become more familiar with the APIs. Here are the places where you can find the methods used above:

* getSession(): As you can see, this method is called on the $this object. Let's follow $this down the inheritance chain to find out where this method is actually defined:
    * GlobalContext ($this) extends Drupal\DrupalExtension\Context\DrupalContext
    * DrupalContext extends Drupal\DrupalExtension\Context\RawDrupalContext
    * RawDrupalContext extends Behat\MinkExtension\Context\RawMinkContext
    * The getSession() method is in RawMinkContext, and returns a Behat\Mink\Session object
* getPage(): Since getSession() above returned a Behat\Mink\Session object, as you might expect, this method can be found in Behat\Mink\Session. It returns a Behat\Mink\Element\DocumentElement object.
* find(): Since getPage() above returned a Behat\Mink\Element\DocumentElement object, as you might expect, this method can be found in that classes inheritance chain:
    * DocumentElement extends Behat\Mink\Element\TraversableElement
    * TraversableElement extends Behat\Mink\Element\Element
    * The find() methid is in Element, and returns a Behat\Mink\Element\NodeElement object.

As you look through NodeElement and its inherited methods, you can see some of the things you might do with the $link variable above. For example:

```
// Would you like to click the link?
$link->click();
// Or maybe you want to get the link's href?
$href = $link->getAttribute('href');
// etc...
```

## Indicating failure in step definitions

It's important to indicate when a step fails. In Behat this is done by throwing an exception. For example:

```
$link = $this->getSession()->getPage()->find('css', '#my-link');
if (empty($link)) {
  throw new Exception('The link could not be found.');
}
```

Even better, try to also give some details about the failure. For example:
```
$link = $this->getSession()->getPage()->find('css', '#my-link');
if (empty($link)) {
  throw new Exception('A link with the id 'my-link' could not be found.');
}
```

## Using existing steps within step definitions

Sometimes you want to use a step within a step. This is totally fine, as long as that step definition itself exists in the inheritance chain of $this. It is a great way to prevent code duplication. Simply call the method for the step definition directly, from $this.

## About the DrupalExtension's text strings

The DrupalExtension assumes various text strings in its step definitions, but these can be override in the configuration. An example of this is the step definition: Drupal\DrupalExtension\Context\RawDrupalContext::login(). This step needs some text to assert that the username and password fields are there. It has defaults, but these can be overridden. To see an override of this kind of thing, look at the "english" profile in behat.yml, for this section:

```
    Drupal\DrupalExtension:
      text:
        username_field: "Directory ID"
        password_field: "Directory Password"
```

## Behat 2 vs Behat 3

When you are looking for answers on the internet, you should be aware that we use Behat 3, but much of the documentation/tutorials/etc you'll find on the internet are for Behat 2. Just something to watch out for, as there are significant differences.
