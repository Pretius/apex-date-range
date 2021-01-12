# Pretius Date Range Picker

The plugin is Oracle APEX item plugin providing new date picker supporting range of dates. The plugin is dedicated to work with Oracle APEX Universal Theme. Behaviour and appeareance of the plugin can be changed with various settings.

The plugin is implemented on top of the [Dan Grossman's](http://www.dangrossman.info/) javascript plugin "[Date Range Picker](http://www.daterangepicker.com/)". Not all functionalities of the original plugin were implemented in Pretius Date Range Picker plugin.

## Table of Contents
- [Preview](#preview)
- [License](#license)
- [Features at glance](#features-at-glance)
- [Roadmap](#roadmap)
- [Installation](#installation)
  - [Installation procedure](#installation-procedure)
- [Usage guide & Demo application](#usage-guide-demo-application)
- [Free support](#free-support)
  - [Bug reporting and change requests](#bug-reporting-and-change-requests)
  - [Implementation issues](#implementation-issues)
- [Become a contributor](#become-a-contributor)
- [Comercial support](#comercial-support)
- [Changelog](#changelog)
- [Known issues](#known-issues)
- [About Author](#about-author)
- [About Pretius](#about-pretius)

## Preview

![Preview gif](images/preview_demo.gif?raw=true "Preview")


## License

MIT

## Features at Glance

* compatible with Oracle APEX 5.1, 18.x, 19.x
* support for 
  * single and double items to store start and end date
  * PL/SQL date format masks
  * dynamic dates using apex syntax ( +1d, +1w etc )
  * min/max date
  * limiting no. of days in range
  * single/double calendars
* definable quick picks


## Roadmap
* [ ] Built-in validation on submit
* [ ] Support for HTML template instead of APEX item(s)
* [ ] Theme Roller integration
* [ ] Support for RTL

## Installation

### Installation procedure

To successfully install/update the plugin follow those steps:

1. Install the plugin file `dynamic_action_plugin_pretius_apex_date_ranger.sql` using Oracle APEX plugin import wizard
1. Configure application level componenets of the plugin

## Usage guide & Demo application

### Single APEX item

1. Create APEX item and set type to `Pretius Date Range Picker [Plug-In]`
1. Configure the plugin behaviour and appearance with available attributes
1. Save and run the page

### Double APEX items

1. Create two APEX items
    1. ```PX_DATE_FROM``` with type set to ```Pretius Date Range Picker [Plug-In]```
    1. ```PX_DATE_TO``` with type set to ```Text field```
1. For ```PX_DATE_FROM``` set 
    1. ```Mode``` to  ```Two fields for dates``` or ```Two fields for dates - alternative```
    1. ```Date to item``` to ```PX_DATE_TO```
1. Save and run the page

### Demo application
Check different plugin configurations and use cases in our  [Live Demo](http://apex.pretius.com/apex/f?p=PLUGINS:DATERANGE)

## Free support
Pretius provides free support for the plugins at the GitHub platform. 
We monitor raised issues, prepare fixes, and answer your questions. However, please note that we deliver the plug-ins free of charge, and therefore we will not always be able to help you immediately. 

Interested in better support? 
* [Become a contributor!](#become-a-contributor) We always prioritize the issues raised by our contributors and fix them for free.
* [Consider comercial support.](#comercial-support) Options and benefits are described in the chapter below.

### Bug reporting and change requests
Have you found a bug or have an idea of additional features that the plugin could cover? Firstly, please check the Roadmap and Known issues sections. If your case is not on the lists, please open an issue on a GitHub page following these rules:
* issue should contain login credentials to the application at apex.oracle.com where the problem is reproduced;
* issue should include steps to reproduce the case in the demo application;
* issue should contain description about its nature.

### Implementation issues
If you encounter a problem during the plug-in implementation, please check out our demo application. We do our best to describe each possible use case precisely. If you can not find a solution or your problem is different, contact us: apex-plugins@pretius.com.

## Become a contributor!
We consider our plugins as genuine open source products, and we encourage you to become a contributor. Help us improve plugins by fixing bugs and developing extra features. Comment one of the opened issues or register a new one, to let others know what you are working on. When you finish, create a new pull request. We will review your code and add the changes to the repository.

By contributing to this repository, you help to build a strong APEX community. We will prioritize any issues raised by you in this and any other plugins.

## Comercial support
We are happy to share our experience for free, but we also realize that sometimes response time, quick implementation, SLA, and instant release for the latest version are crucial. That’s why if you need extended support for our plug-ins, please contact us at apex-plugins@pretius.com.
We offer:
* enterprise-level assistance;
* support in plug-ins implementation and utilization;
* dedicated contact channel to our developers;
* SLA at the level your organization require;
* priority update to next APEX releases and features listed in the roadmap.

## Changelog

### 1.2.1

* ```PL/SQL``` support for `mm` and `yy` format mask
* ```PL/SQL``` support for `\` as format separator

### 1.2.0

* ```PL/SQL``` the plugin source has been extracted as external package
* ```PL/SQL``` input attributes such as ```size```, ```length``` etc are derivied by ```APEX_PLUGIN_UTIL.get_element_attributes``` function
* ```PL/SQL``` When APEX item is in ```readonly``` state it is rendering value only
* ```PL/SQL``` plugin rendering function has been changed to procedural API
* ```Plugin``` The plugin is now compatibile with APEX 5.1, 18.x and 19.x
* ```Plugin``` Support for ```Warn on Unsaved Changes``` has been added
* ```Plugin``` input reacts to APEX item template options such as ```Size```, ```Strech Form Item```
* ```Plugin``` input supports ```Floating``` template
* ```Plugin``` Support for ```Warn on Unsaved Changes``` has been added
* ```JS``` debugging messages has been added at 3 levels: ```DEBUG```, ```LEVEL6``` and ```LEVEL9```

### 1.1.0

* Calendar `z-index` is set to `700`. Calendar's div is on higher layer than Interactive Report headers and APEX left sidebar position.
* Hovering non-selectable calendar elements (week day names, week numbers) do not change cursor style.
* Creating range of dates from session values is fixed.
* Applying date value triggers Change event on APEX item.
* When ```Show days of other months``` is not checked, the hidden dates are not clickable.
* ```Plugin attributes``` Days names of the calendar are not shifted. Calendar renders day names in valid sequence in correlation to the real date. Translation string ```PRETIUS_DATERANGEPICKER_DAYS``` is changed from ```Mo,Tu,We,Th,Fr,Sa,Su``` to ```Su,Mo,Tu,We,Th,Fr,Sa``` - Sunday must be the first day of the week in the trasnlation list.

### 1.0.0

Initial release

## Known issues

* Date format mask `DY`, `Dy` return invalid string for selected date

## About Author
Author | Github | Twitter | E-mail
-------|--------|---------|-------
Bartosz Ostrowski | [@bostrowski](https://github.com/bostrowski) | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Pretius is a software company specialized in Java-based and low-code applications, with a dedicated team of over 25 Oracle APEX developers.
Members of our APEX team are technical experts, have excellent communication skills, and work directly with end-users / business owners of the software. Some of them are also well-known APEX community members, winners of APEX competitions, and speakers at international conferences.
We are the authors of the translate-apex.com project and some of the best APEX plug-ins available at the apex.world.
We are located in Poland, but working globally. If you need the APEX support, contact us right now.

Address | Website | E-mail
--------|---------|-------
Żwirki i Wigury 16A, 02-092 Warsaw, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)
