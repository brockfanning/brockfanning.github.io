---
title: Setting up media-embed functionality in Drupal 8, from scratch
tags: [drupal]
---
The core/contrib capabilities for "embedding media" (eg, images inside the Body field) in Drupal 8 are getting a lot of attention and improvements. The generally accepted solution revolves around Entity Embed, Entity Browser, Views, and Media Entity (soon to be usable in core). However, the "recipe" involved is extremely complicated, in my opinion. Because of this, distributions like Lightning are becoming more popular, because they enable a site builder to hit the ground running, with everything pre-configured.

As a professional Drupal developer trying to ramp up on Drupal 8, I have avoided these distributions for a simple reason: I want to learn this stuff. Using Lightning for all my sites would be similar to trying to learn Bash while using someone else's library of custom Bash aliases. Or, put less geekily, it would be similar to learning to be an artist while relying on stencils. It's the same idea behind my (and many others') principle of always typing code, and never copying/pasting it.

This great and noble and educational and all, but the downside is that it's hard. And one of the many things that consistently gives me trouble is the media-embed setup. So, I'm writing this post to document that process once and for all. Enjoy!

## Note about types of media

I'll only cover one type of media here: Images. But, of course, the same procedure can be used for any entity.

## Installing and enabling the modules

I'm going to assume the use of the [Drupal composer project](https://github.com/drupal-composer/drupal-project) approach here. First we'll install the necessary modules.

```
composer require drupal/entity_embed
composer require drupal/entity_browser
composer require drupal/media_entity
composer require drupal/media_entity_image
```

Next we'll enable the modules. No need to list them all, when Drush will also enable the dependencies.

`drush en media_entity_image entity_browser entity_embed`

## Adding the "image" media bundle

Go to `/admin/structure/media/add` and set the Label and Type Provider to "Image". Leave everything else blank (for now).

Add new fields to the image bundle at `/admin/structure/media/manage/image/fields/add-field`:

* "Text (plain)" field called "MIME Type"
* "Number (integer)" field called "Width"
* "Number (integer)" field called "Height"
* "Image" field called "Image"

Go back and update the bundle settings at `/admin/structure/media/manage/image` to set the drop-downs appropriately in the "FIELD MAPPING" section.

Go to "Manage Form Display" at `/admin/structure/media/manage/image/form-display` and drag everything to disabled except for "Media name" and "Image", and then click "Save".

Editorial note: There is probably good reason, but I don't see why the `media_entity_image` module wouldn't do this on install?

## Creating some view modes for images

This part is certainly open to customization depending on your preferences, but I generally want to set up three sizes of image: Small, Medium, and Large. I also generally allow for the image to be displayed at its original size.

Go to `/admin/structure/display-modes/view/add/media` to add a view mode for media, and call it "Original". Repeat this for "Small", "Medium", and "Large".

## Go BACK to the image bundle and configure the display

This part, again, is open to customization depending on your preferences. But for now I will describe a simple usage of the 3 image styles that Drupal ships with, out of the box.

Go to `/admin/structure/media/manage/image/display` and drag everything except "Image" to "Disabled", and then click "Save".

Next expand the "Custom Display Settings". Check all the boxes and click "Save".

This may be fixed at some point, but it seems you need to clear the cache here in order to see the new tabs for each view mode: `drush cr`.

For each of the "Large", "Medium", and "Small" tabs, click the gear icon across from the image field, change it to a corresponding image style. For example, for the "Small" view mode I generally use the "Thumbnail" image style. Don't forget to click "Save" each time before switching to another tab!

## Configuring the View for the Entity Browser

Go to `/admin/structure/views/add` to create new view. Fill in (or choose) these options:

* View name: Image Browser
* Show: Media
* of type: Image

Then click "Save and edit". Continue with these changes:

* Under "Display" click "Add" and "Entity browser".
* Under "Format" change "Format" to "Grid".
* Under "Fields" click "Add" and choose "Entity browser bulk select form".
* Under "Fields" click "Add" and choose "Thumbnail", and set the image style to "Thumbnail".
* Remove the "Media name" field (optional).

Finally click "Save".

## Configuring the Entity Browser

Go to `/admin/config/content/entity_browser/add` to create a new Entity Browser. Fill in (or choose) these options:

* Label: Image Browser
* Display plugin: iFrame

Click "Next" and continue with these options:

* Width of the iFrame: 100%
* Height of the iFrame: 640
* Link text: Click here to browse or upload images
* Auto open entity browser: yes (checked)

Click "Next" three times, and then continue with these options:

* Add widget plugin: Upload images (DO NOT chose "Upload", DO choose "Upload images")
    * Label (Upload images): Upload
    * Submit button text: Select image
    * Upload location: public://images
* Add widget plugin (again): View
    * Label (View): View
    * Submit button text: Select image
    * View display: Image Browser

Finally click "Finish".

## Configuring the Entity Embed button

Create a new entity embed button here: `/admin/config/content/embed/button/add`. Fill in (or choose) these options:

* Label: Image
* Embed type: Entity
* Entity type: Media
* Media bundle: Image
* Allowed entity embed display plugins: [check all the view modes you created earlier]
* Entity Browser: Image Browser
* Button icon: [upload any appropriate icon]

## Configure the text format

Assuming you want the "Basic HTML" format to be able to embed images, go to `/admin/config/content/formats/manage/basic_html` and fill in (or choose) these options:

* Toolbar configuration: [remove the normal Image button and add the new Image button, which may be confusing since they're both called "Image"...]
* Enabled filters
    * Display embedded entities: yes (checked)
    * Track images uploaded via a Text Editor: no (unchecked)

Click "Save configuration". Repeat as needed for any other text formats that need to be able to embed images.
