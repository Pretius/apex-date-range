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
  - [Attributes](#attributes)
  - [Component settings](#component-settings)
  - [Translations](#translations)
  - [plugin events](#plugin-events)
  - [Quick Picks](#quick-picks)
  - [Plugin Events](#plugin-events)
- [Changelog](#changelog)
- [Known issues](#known-issues)
- [About author](#about-author)
- [About Pretius](#about-pretius)


## License

MIT

## Demo application

[Demo application](http://apex.pretius.com/apex/f?p=PLUGINS:DATERANGE)

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

## Install

### Install package
1. `src/PRETIUS_APEX_DATE_RANGE.sql` - the plugin package specification
1. `src/PRETIUS_APEX_DATE_RANGE.plb` - the plugin package body
1. `src/dynamic_action_plugin_pretius_apex_nested_reports.sql` - the plugin installation files for Oracle APEX 5.1 or higher

### Install procedure 

To successfully install/update the plugin follow those steps:

1. Install package `PRETIUS_APEX_DATE_RANGE` in Oracle APEX Schema owner (ie. via SQL Workshop)
1. Install the plugin file `dynamic_action_plugin_pretius_apex_date_ranger.sql` using Oracle APEX plugin import wizard
1. Configure application level componenets of the plugin

## Usage guide

### Single APEX item

1. Create APEX item and set type to `Pretius APEX Date Range [Plug-In]`
1. Configure the plugin behaviour and appearance with available attributes
1. Save and run the page

### Double APEX items

1. Create two APEX items
    1. ```PX_DATE_FROM``` with type set to ```Pretius APEX Date Range [Plug-In]```
    1. ```PX_DATE_TO``` with type set to ```Text field```
1. For ```PX_DATE_FROM``` set 
    1. ```Mode``` to  ```Two fields for dates``` or ```Two fields for dates - alternative```
    1. ```Date to item``` to ```PX_DATE_TO```
1. Save and run the page

## Plugin Settings

### Attributes

Detailed information about how to use every attribute of the plugin is presented in built-in help texts in APEX Application Builder.

![Alt text](images/preview_helptext.gif?raw=true "Built-in help texts")

### Component Settings

Component settings can be changed in `Sharec components > Plugins > Pretius APEX date range > Component Settings`

Attribute | Default | Description
----------|---------------|------------
First day | `2` | Use this attribute to determine which day of week should be rendered as first day of the week. While default day names are defined as `Su, Mo,Tu,We,Th,Fr,Sa`, default value `2` refers Mo. Value `7` refers `Sa`.
Button classes | `t-Button t-Button--small` | Use this attribute to determine what classes will be applied to date picker buttons.
Apply class | `t-Button--hot` | Use this attribute to determine what classes will be applied to Apply button.
Cancel class |` t-Cancel` | Use this attribute to determine what classes will be applied to Cancel button.

### Translations

To add new translations use `Shared Componentes> Globalization > Text Messages`.

![Alt text](images/preview_daterange_translations.jpg?raw=true "Translations")

Translation string | Example | Description
-------------------|---------|-------------
PRETIUS_DATERANGEPICKER_DAYS | `Su,Mo,Tu,We,Th,Fr,Sa` | Names of days separated with coma.
PRETIUS_DATERANGEPICKER_MONTHS | `January,February,March,April,May, June,July,August,September, October,November,December` | Names of months separated witm coma
PRETIUS_DATERANGEPICKER_APPLYLABEL | `Apply` | Label of button confirming selected date range
PRETIUS_DATERANGEPICKER_CANCELLABEL | `Cancel` | Label of button closing date range picker
PRETIUS_DATERANGEPICKER_CUSTOM_RANGE | `Custom` | Label of quick pick used to select custom date range
PRETIUS_DATERANGEPICKER_WEEK_LABEL | `W` | Header for column presenting week numbers

### Plugin Events
The plugin doesn't expose any custom events. 

### Quick picks

Quick pick(s) are defined as JSON object (Quick pick(s) attribute). JSON object keys represent available quick pick labels. Each key is defined as Array with two elements - start and end of a predefined range. ```Start``` and ```end``` date are instances of ```Moment.js``` JavaScript library. To learn more about Moment.js visit its [home page](http://http://momentjs.com/).

![Alt text](images/preview_quickpicks.gif?raw=true "Quick picks")

## Changelog

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

Address | Website | E-mail
--------|---------|-------
Przy Parku 2/2 Warsaw 02-384, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)
