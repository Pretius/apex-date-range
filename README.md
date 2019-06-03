# Pretius APEX Date Range

The plugin is Oracle APEX item plugin providing new date picker supporting range of dates. The plugin is dedicated to work with Oracle APEX Universal Theme. Behaviour and appeareance of the plugin can be changed with various settings.

The plugin is implemented on top of the [Dan Grossman's](http://www.dangrossman.info/) javascript plugin "[Date Range Picker](http://www.daterangepicker.com/)". Not all functionalities of the original plugin were implemented in Pretius APEX Date Range plugin.


## Preview

![Alt text](images/preview_demo.gif?raw=true "Preview")

## Table of Contents

- [License](#license)
- [Demo application](#demo-application)
- [Features at Glance](#features-at-glance)
- [Roadmap](#roadmap)
- [Install](#install)
  - [Install package](#install-package)
  - [Install procedure](#install-procedure)
- [Usage guide](#usage-guide)
- [Plugin Settings](#plugin-settings)
  - [Plugin Events](#plugin-events)
  - [Manual Events](#manual-events)
- [Changelog](#changelog)
- [Known issues](#known-issues)
- [About author](#about-author)
- [About Pretius](#about-pretius)


## License

MIT

## Demo application

[Demo application](http://apex.pretius.com/apex/f?p=PLUGINS:DATERANGE)

## Features at Glance

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

## Install
TBD

### Install package
TBD

### Install procedure 

To successfully install/update the plugin follow those steps:

1. Install package PRETIUS_APEX_DATE_RANGE in Oracle APEX Schema owner (ie. via SQL Workshop)
1. Install the plugin file dynamic_action_plugin_pretius_apex_date_ranger.sql using Oracle APEX plugin import wizard
1. Configure application level componenets of the plugin

## Usage guide

### Single APEX item

1. Create APEX item and set type to ```Pretius APEX Date Range [Plug-In]```
1. Configure the plugin behaviour and appearance with available attributes
1. Save and run the page

### DOUBLE APEX items

1. Create two APEX items
    1. ```PX_DATE_FROM``` with type set to ```Pretius APEX Date Range [Plug-In]```
    1. ```PX_DATE_TO``` with type set to ```Text field```
1. For ```PX_DATE_FROM``` set 
    1. ```Mode``` to  ```Two fields for dates``` or ```Two fields for dates - alternative```
    1. ```Date to item``` to ```PX_DATE_TO```
1. Save and run the page

## Plugin Settings

Detailed information about how to use every attribute of the plugin is presented in built-in help texts in APEX Application Builder.

![Alt text](images/preview_helptext.gif?raw=true "Built-in help texts")

### Plugin Events
The plugin doesn't expose any new events. 

## Changelog


## Known issues
TBD

## About Author
Author | Github | Twitter | E-mail
-------|--------|---------|-------
Bartosz Ostrowski | [@bostrowski](https://github.com/bostrowski) | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Address | Website | E-mail
--------|---------|-------
Przy Parku 2/2 Warsaw 02-384, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)
