$.widget('pretius.apexdaterangepicker', {
  options: {
    pretius: {
      //
    },
    daterangepicker: {
      //
    }
  },
  C_LOG_DEBUG    : apex.debug.LOG_LEVEL.INFO,
  C_LOG_WARNING  : apex.debug.LOG_LEVEL.WARN,
  C_LOG_ERROR    : apex.debug.LOG_LEVEL.ERROR,
  C_LOG_LEVEL6   : apex.debug.LOG_LEVEL.APP_TRACE,
  C_LOG_LEVEL9   : apex.debug.LOG_LEVEL.ENGINE_TRACE,

  _create: function(){
    this.logPrefix = '# ('+this.element.get(0).id+') ';//+this.options.plugin.name+':';

    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_create', 'this.options', this.options );

    //required for fixing position
    this.orginal = {
      opens: this.options.daterangepicker.opens,
      drops: this.options.daterangepicker.drops
    };

    this.apex = {
      item: this.element,
      datepickerButton: this.element.nextAll( 'button' ).first()
    };

    this.dateTo = {
      item: $(this.options.pretius.dateToItem),
      datepickerButton: null
    };

    //should display custom range label?
    if ( this._hasCustomRangeLabel() ) {
      this.options.daterangepicker.showCustomRangeLabel = this._hasCustomRangeLabel();
      delete this.options.daterangepicker.ranges.Custom;
    }

    //check ranges
    if ( this.options.pretius.onlyOneCalendar ) {
      this.options.daterangepicker.linkedCalendars = false;
    }
     

    //create dateTo button as clone of apex datepicker buttom
    this.dateTo.datepickerButton = this.apex.datepickerButton.clone();
    //insert dateTo button after dateTo item
    this.dateTo.datepickerButton.insertAfter( this.dateTo.item );

    if ( this.options.pretius.overlay && this.dateTo.item.length == 0 ) {
      throw "Nie znalazl wymaganego itema data do";
    }

    //min & max date
    this.options.daterangepicker.minDate = this.options.daterangepicker.minDate != undefined ? this.getMinMaxDateFromString( this.options.daterangepicker.minDate ) : undefined;
    this.options.daterangepicker.maxDate = this.options.daterangepicker.maxDate != undefined ? this.getMinMaxDateFromString( this.options.daterangepicker.maxDate ) : undefined;

    //date range picker init
    this.apex.item.daterangepicker( this.options.daterangepicker, function(start, end, label){
      //console.log('---Callback function---');
    });

    this.picker = this.apex.item.data('daterangepicker');

    this.apex.item
      .on( 'show.daterangepicker'         , $.proxy( this._commonShow             , this , 'dateFrom' ) )
      .on( 'showCalendar.daterangepicker' , $.proxy( this._commonShow             , this , 'dateFrom' ) )
      
      .on( 'hide.daterangepicker' , $.proxy( this._commonHide             , this , 'dateFrom' ) )
      .on( 'calendarUpdated.apex' , $.proxy( this._common_calerndarUpdate , this , 'dateFrom' ) );

    if ( this.options.daterangepicker.showMethod == 'onIconClick' ) {
      
      this.apex.item
        .off( 'click.daterangepicker' )
        .off( 'focus.daterangepicker' );

      this.apex.datepickerButton.on( 'click' , $.proxy(this._nativeShowPickerOnButtonClick, this) );

      if ( this.options.pretius.overlay ) {
        this.dateTo.datepickerButton.on( 'click' , $.proxy(this._overlay_showPickerOnButtonClick, this) );
      }

    }
    else if ( this.options.daterangepicker.showMethod == 'onFocus' ) {

      if ( this.options.pretius.overlay ) {
        this.dateTo.item.on( 'focus' , $.proxy( this._overlay_focusOnDateTo, this));
      }

    }
    else if ( this.options.daterangepicker.showMethod == 'both' ) {
      this.apex.datepickerButton.on( 'click' , $.proxy( this._nativeShowPickerOnButtonClick, this ) );

      if ( this.options.pretius.overlay ) {
        this.dateTo.datepickerButton.on( 'click' , $.proxy( this._overlay_showPickerOnButtonClick , this ) );
        this.dateTo.item            .on( 'focus' , $.proxy( this._overlay_focusOnDateTo           , this ) );
      }

    }
    else {
      throw "Unknown this.options.daterangepicker.showMethod = '"+this.options.daterangepicker.showMethod+"'";
    }

    if ( this.options.pretius.overlay ) {

      this.apex.item
        .on('apply.daterangepicker'   , $.proxy( this._overlayApply,  this ) )
        .on('cancel.daterangepicker'  , $.proxy( this._overlayCancel, this ) )
        .on('focus'  , $.proxy( this._overlayFocus, this ) )
      
      this.dateTo.item
        .on('show.daterangepicker '         , $.proxy( this._commonShow             , this , 'dateTo' ) )
        .on('showCalendar.daterangepicker'  , $.proxy( this._commonShow             , this , 'dateTo' ) )
        .on('hide.daterangepicker'          , $.proxy( this._overlay_dateToHide     , this            ) )
        .on('hide.daterangepicker'          , $.proxy( this._commonHide             , this , 'dateTo' ) )
        .on('calendarUpdated.apex'          , $.proxy( this._common_calerndarUpdate , this , 'dateTo' ) );

      this.dateTo.item.data('parentItem', this.apex.item);
      this._apex_da( this.dateTo.item );

    }
    else {
      this.apex.item
        .on('apply.daterangepicker' , $.proxy( this._nativeApply  , this ) )
        .on('cancel.daterangepicker', $.proxy( this._nativeCancel , this ) )
        .on('focus.daterangepicker' , $.proxy( this._nativeFocus  , this ) )
    }

    this._apex_da( this.apex.item );

  },
  _destroy: function(){

  },
  _overlayFocus: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_overlayFocus' );

    var startDate, endDate;

    if ( this.apex.item.val().trim().length == 0 && this.dateTo.item.val().trim().length == 0 ) {
      startDate = moment().startOf('day');
      endDate   = moment().endOf('day');
      
    }
    else if ( this.apex.item.val().trim().length > 0 && this.dateTo.item.val().trim().length == 0 ) {
      startDate = moment( this.apex.item.val(),   this.options.daterangepicker.locale.format );
      endDate   = startDate.endOf('day');
      
    }
    else if ( this.apex.item.val().trim().length == 0 && this.dateTo.item.val().trim().length > 0 ) {
      endDate   = moment( this.dateTo.item.val(), this.options.daterangepicker.locale.format );
      startDate = endDate.startOf('day');      
      
    }
    else { // >0 > 0
      startDate = moment( this.apex.item.val(),   this.options.daterangepicker.locale.format );      
      endDate   = moment( this.dateTo.item.val(), this.options.daterangepicker.locale.format );
      
    }

    this.picker.setStartDate( startDate );
    this.picker.setEndDate( endDate );

    this.picker.updateView();

  },
  _nativeFocus: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_nativeFocus' );

    if ( this.picker.endDate.isValid() == false || this.picker.startDate.isValid() == false) {
      this.picker.endDate = moment().startOf('day');
      this.picker.startDate = moment().endOf('day');

      //this.picker.hide();
      //this.picker.show();
      this.picker.updateView();
    }
  },
  //
  //-------------------------------------------------------------------------------------------------
  //

  _setOption: function( key, value ) {
    apex.debug.message( this.C_LOG_LEVEL9, this.logPrefix, '_setOption' );

    if ( key === "value" ) {
      value = this._constrain( value );
    }

    this._super( key, value );
  },  
  //
  //-------------------------------------------------------------------------------------------------
  //

  _setOptions: function( options ) {
    apex.debug.message( this.C_LOG_LEVEL9, this.logPrefix, '_setOptions' );
    
    options.daterangepicker.minDate = options.daterangepicker.minDate != undefined ? this.getMinMaxDateFromString( options.daterangepicker.minDate ) : undefined;
    options.daterangepicker.maxDate = options.daterangepicker.maxDate != undefined ? this.getMinMaxDateFromString( options.daterangepicker.maxDate ) : undefined;

    this._super( options );
  },
  _hasCustomRangeLabel: function(){
    apex.debug.message( this.C_LOG_LEVEL9, this.logPrefix, '_hasCustomRangeLabel' );

    try {
      return this.options.daterangepicker.ranges.Custom === true
    } catch(error) {
      return false;
    }
    
  },

  enable: function( elem ){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'enable' );
    


    if ( elem.get(0) == this.apex.item.get(0) ) {
      this.apex.item.removeAttr('disabled');
      this.apex.datepickerButton.removeClass('disabled');
    }
    else if ( elem.get(0) == this.dateTo.item.get(0) ) {
      this.dateTo.item.removeAttr('disabled');
      this.dateTo.datepickerButton.removeClass('disabled');
    }
    else {
      throw "Unknown item to disable: "+elem.attr('id');
    }

  },
  disable: function( elem ){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'disable' );

    if ( elem.get(0) == this.apex.item.get(0) ) {
      this.apex.item.prop('disabled', true);
      this.apex.datepickerButton.addClass('disabled');
    }
    else if ( elem.get(0) == this.dateTo.item.get(0) ) {
      this.dateTo.item.prop('disabled', true);
      this.dateTo.datepickerButton.addClass('disabled');
    }
    else {
      throw "Unknown item to disable: "+elem.attr('id');
    }

  },
  setDateRange: function( pDateRange ){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'setDateRange' );

    var 
      dateRange = pDateRange.split( ' - ' ),
      dateFrom = dateRange[0],
      dateTo = dateRange[1];

    this.picker.setStartDate( dateFrom );
    this.picker.setEndDate( dateTo );

  },
  _apex_da: function( daElem ) {
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_apex_da' );

    var 
      pName = daElem.attr('id'),
      pOptions = {
        setValue: function( pValue, pDisplayValue ) {
          var daItem = $(this.node);
          var pluginItem = undefined;

          if ( daItem.data('parentItem') != undefined ) {
            //dateTo item
            pluginItem = daItem.data('parentItem');
          }
          else {
            //plugin item
            pluginItem = daItem;
          }

          if ( pluginItem.apexdaterangepicker('option', 'pretius').overlay == false ) {
            daItem.val( pValue );
            pluginItem.apexdaterangepicker('setDateRange', pValue);
          }
          else {
            if ( pValue.trim().length == 0 ) {
              daItem.val("");
            }
            else {
              
              if ( /([\+-]{1}\d{1,}[y|m|d|w]{1})/g.test( pValue ) ) {
                daItem.val( pluginItem.apexdaterangepicker('calculateMomentFromPattern', pValue, true) );    
              }
              else {
                daItem.val( pValue ); 
              }
              
            }
            
          }

        },        
        //Specify a value that to be used to determine if the item is null. 
        //This is used when the item supports definition of a List of Values, 
        //where a developer can define a Null Return Value for the item and 
        //where the default item handling needs to know this in order to assert if the item is null or empty.
        nullValue:  "",
        enable: function() {
          apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'enable' );

          var 
            daItem = $(this.node),
            pluginItem = undefined;

          if ( daItem.data('parentItem') != undefined ) {
            //dateTo item
            pluginItem = daItem.data('parentItem');
          }
          else {
            //plugin item
            pluginItem = daItem;
          }

          pluginItem.apexdaterangepicker('enable', daItem);
        },
        disable: function() {
          apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'disable' );
          
          var 
            daItem = $(this.node),
            pluginItem = undefined;

          if ( daItem.data('parentItem') != undefined ) {
            //dateTo item
            pluginItem = daItem.data('parentItem');
          }
          else {
            //plugin item
            pluginItem = daItem;
          }

          pluginItem.apexdaterangepicker('disable', daItem);
        },
        afterModify: function(){
          // code to always fire after the item has been modified (value set, enabled, etc.)
        },
        loadingIndicator: function( pLoadingIndicator$ ){
          // code to add the loading indicator in the best place for the item
          return pLoadingIndicator$;
        }

        
        /*
        //setFocusTo: $( "<some jQuery selector>" ),
        setFocusTo: function(){

          var daItem = $(this.node);

        },
        setStyleTo: $( "<some jQuery selector>" ),    
        getValue: function() {

          var daItem = $(this.node);
          return daItem.val();
        },
        show: function() {

          // code that shows the item type
        },
        hide: function() {

          // code that hides the item type
        },
        addValue: function( pValue ) {

          // code that adds pValue to the values already in the item type
        },

        */

      };

    apex.widget.initPageItem( pName, pOptions);    
  },
  /*
    *
    * NATIVE
    *
  */
  //
  //-------------------------------------------------------------------------------------------------
  //

  //
  //-------------------------------------------------------------------------------------------------
  //

  _nativeApply: function(pEvent) {
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_nativeApply' );

    var 
      format = this.options.daterangepicker.locale.format,
      value = this.picker.startDate.format( format ) + ' - ' + this.picker.endDate.format( format );

    this.element.val( value ).trigger('change');
  },
  //
  //-------------------------------------------------------------------------------------------------
  //

  _nativeCancel: function(pEvent) {
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_nativeCancel' );

    this.element.val('');
  },
  //
  //-------------------------------------------------------------------------------------------------
  //

  _nativeShowPickerOnButtonClick: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_nativeShowPickerOnButtonClick' );

    if ( this.apex.datepickerButton.is('.disabled') ) {
      return false;
    }

    this.picker.show();
  },

  /*
    *
    * COMMON
    *
  */

  //
  //-------------------------------------------------------------------------------------------------
  //

  _common_hideOtherMonthDays: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_common_hideOtherMonthDays' );

    var 
      leftCalendar = this.picker.container.find('.calendar.left'),
      rightCalendar = this.picker.container.find('.calendar.right'),
      rightTds,
      resultTds,
      tr2remove;
      resultTds = leftCalendar.find('td.off').filter($.proxy(function(index, elem){
        if ( this._getDateFromCalendar( $(elem), leftCalendar ).month() != this.picker.leftCalendar.month.month() ) {
          return true;
        }
        else {
          return false;
        }
      }, this));

      resultTds

      if ( this.options.pretius.onlyOneCalendar == false ) {
        rightTds = rightCalendar.find('td.off').filter($.proxy(function(index, elem){
          if ( this._getDateFromCalendar( $(elem), rightCalendar ).month() != this.picker.rightCalendar.month.month() ) {
            return true;
          }
          else {
            return false;
          }

        }, this));

        resultTds = resultTds.add(rightTds);
      }
      
      resultTds.empty().removeAttr('class').addClass('otherMonth').bind('click mousedown mouseenter mouseleave', function(e){
        e.preventDefault();
        e.stopImmediatePropagation();
      });

  

      tr2remove = this.picker.container.find('.calendar tr').filter(function( index, elem){
        return $(elem).children('.otherMonth').length == 7 ? true : false;
      });

      tr2remove.remove();

    },  
  //
  //-------------------------------------------------------------------------------------------------
  //
  _common_showMonthsDistance: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_common_showMonthsDistance' );

    if (
         this.picker.leftCalendar.month.format('YYYY-MM') == this.picker.rightCalendar.month.format('YYYY-MM')
      || this.picker.leftCalendar.month.clone().add(1, 'month').format('YYYY-MM') == this.picker.rightCalendar.month.format('YYYY-MM')
    ) {
      this.picker.container.removeClass('monthsDiffersMoreThanOne');
    }
    else {
      this.picker.container.addClass('monthsDiffersMoreThanOne');
    }
  },
  _common_calerndarUpdate: function( pTriggeringElement ){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_common_calerndarUpdate', 'triggeringElement', pTriggeringElement );

    //replace icons
    this.picker.container.find('.next i').removeAttr('class').addClass('ui-icon ui-icon-circle-triangle-e');
    this.picker.container.find('.prev i').removeAttr('class').addClass('ui-icon ui-icon-circle-triangle-w');
    

    if ( this.options.pretius.hideOtherMonthDays ) {
      this._common_hideOtherMonthDays();
    }

    if ( 
      this.options.daterangepicker.linkedCalendars == false 
      && this.options.pretius.onlyOneCalendar == false
    ) {
      this._common_showMonthsDistance();
    }

    if ( pTriggeringElement == 'dateTo' && this.options.pretius.altDateToSelect ) {

      if ( this.picker.element == this.dateTo.item ) {

        this.picker.container.find('.dateFrom :input').removeClass('active');
        this.picker.container.find('.dateTo :input').addClass('active');

        //this.picker.container.find('.calendar').off('mouseenter.daterangepicker');
        this.picker.container.find('.calendar td').not('.week').bind('mouseenter.daterangepicker', $.proxy( this._overlay_updateDateTo_input, this ));
      
      }
  
      this.picker.container.find('.calendar td').bind('mousedown.test click.test', $.proxy( this._overlay_dateToShow_forceDateToSelection, this ) );

    }
  },

  /*
    *
    * OVERLAY
    *
  */

  _overlay_dateToHide: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_overlay_dateToHide' );

    this.dateTo.item.blur();
    this.picker.element = this.element;
  },
  //
  //-------------------------------------------------------------------------------------------------
  //
  _moveRanges: function(  ){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_moveRanges' );

    var
      container = this.picker.container,
      left = this.picker.container.find('.calendar.left'),
      right = this.picker.container.find('.calendar.right'),
      ranges = this.picker.container.find('.ranges'),
      bodyWidth = $('body').outerWidth();

    ranges = ranges.detach();

    right.after( ranges );

  },
  _isOneLine: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_isOneLine' );

    var 
      container = this.picker.container,
      //te odwolania wypadaloby zmergowac do _create i odwolywac sie do juz istniejacych instancji
      left = this.picker.container.find('.calendar.left'),
      right = this.picker.container.find('.calendar.right'),
      ranges = this.picker.container.find('.ranges');

    if (
      //pojedynczy i wlaczone ranges
      this.options.pretius.onlyOneCalendar    == true   && this.options.daterangepicker.ranges != undefined          && left.offset().top == ranges.offset().top
      //pojedynczy i ranges jako pierwsze
      || this.options.pretius.onlyOneCalendar == true   && this.options.daterangepicker.alwaysShowCalendars == false && !left.is(':visible')
      //pojedynczy i wylaczone ranges
      || this.options.pretius.onlyOneCalendar == true   && this.options.daterangepicker.ranges == undefined
      //podwojny i wlaczone ranges
      || this.options.pretius.onlyOneCalendar == false  && left.offset().top == right.offset().top      && left.offset().top == ranges.offset().top
      //podwojny i wylaczone ranges
      || this.options.pretius.onlyOneCalendar == false  && left.offset().top == right.offset().top      && this.options.daterangepicker.ranges == undefined
      //podwojny i ranges jako pierwsze
      || this.options.pretius.onlyOneCalendar == false  && this.options.daterangepicker.alwaysShowCalendars == false && !left.is(':visible') && !right.is(':visible')
    ){
      return true;
    }
    else {
      return false;
    }
  },
  fixCalendarPositionVertical: function(){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'fixCalendarPositionVertical' );

    //pomocnicze
    var fixedNavBarHeight = $('.t-Body-content').length > 0 ? parseInt($('.t-Body-content').css('marginTop')) : 0;

    var item = this.picker.element;
    //a offset top item 
    var itemOffsetTop = item.offset().top - fixedNavBarHeight;
    //c ile jest przewinieta strona
    var windowScrollHeight = $(window).scrollTop();//$('body').scrollTop();
    //d wysokosc okna przegladarki
    var windowHeight = $(window).outerHeight();
    //e wysokosc item
    var itemHeight = item.outerHeight();
    //b = a - c // ile zostalo miejsca ponad item
    var spaceAboveItem = itemOffsetTop - windowScrollHeight;
    //f = d-b-e //ile zostalo miejsca pod item
    var spaceBeloweItem = windowHeight - spaceAboveItem - itemHeight;
    //g wysokosc kotnenera kalendarzy //jesli 
    var calendarHeight = this.picker.container.outerHeight();
    //i offset top kalendarzy
    var calendarOffsetTop = this.picker.container.offset().top;
    //h = i - c //ile zostalo miejsca nad kalendarzem
    var spaceAboceCalendar = calendarOffsetTop - windowScrollHeight;
    //j jesli wiekszy od zera to wystaje powyzej
    var calendarOverflowAboveHeight = windowScrollHeight - calendarOffsetTop; 
    //jesli wiekszy od zera to wystaje ponizej
    var calendarOverflowBelowHeight = (calendarHeight + calendarOffsetTop) - (windowScrollHeight + windowHeight); 

    if ( calendarOverflowAboveHeight >= 0  ) {
      //always drop down if calendar is cut from above
      this.picker.container.removeClass('dropup');
      this.picker.drops = 'down';
      this.picker.move();
    }
    else if ( calendarOverflowBelowHeight >= 0 ) {
      //cut from down
      if ( spaceAboveItem >= calendarHeight ) {
        this.picker.container.addClass('dropup');
        this.picker.drops = 'up';
        this.picker.move();
      }
      else {
        //there is no space above, scroll the broswer
        null;
      }
    }
  },
  fixCalendarPositionHorizontal: function(){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'fixCalendarPositionHorizontal' );

    var 
      opens = this.picker.opens,
      openerOffset = this.picker.element.offset();

    if ( this._isOneLine() == false && !this.picker.container.is('.forceOneColumn')) {
      //when calendars and ranges are not in the same line;
      //right -->  left   --> center --> force one column
      //left  -->  right  --> center --> force one column
      //center --> right  --> left   --> force one column

      if ( this.orginal.opens == 'right' ) {
        //when popup should be opened in right position
        if ( opens == 'right' ) {
          this.picker.container.removeClass('opensright').addClass('opensleft');
          this.picker.opens = 'left';
          this.picker.move();
        }
        else if ( opens == 'left' ) {
          this.picker.container.removeClass('opensleft').addClass('opensleft');
          this.picker.opens = 'center';
          this.picker.move();
        }
        else {
          this.picker.container.addClass('forceOneColumn')
        }
      }
      else if ( this.orginal.opens == 'left' ) {
        //when popup should be opened in left position
        if ( opens == 'left' ) {
          this.picker.container.removeClass('opensleft').addClass('opensright');
          this.picker.opens = 'right';
          this.picker.move();
        }
        else if ( opens == 'right' ) {
          this.picker.container.removeClass('opensright').addClass('openscenter');
          this.picker.opens = 'center';
          this.picker.move();
        }
        else {
          this.picker.container.addClass('forceOneColumn')
        }
      }
      else {
        //when popup should be opened in center position
        if ( opens == 'center' ) {
          this.picker.container.removeClass('openscenter').addClass('opensright');
          this.picker.opens = 'right';
          this.picker.move();
        }
        else if ( opens == 'right' ) {
          this.picker.container.removeClass('opensright').addClass('opensleft');
          this.picker.opens = 'left';
          this.picker.move();
        }
        else {
          this.picker.container.addClass('forceOneColumn')
        }

      }

      this.fixCalendarPositionHorizontal();

    } 
    else {
      //exception for right/center position
      if ( 
        this.orginal.opens == 'right' && parseInt( this.picker.container.css('right') ) == 0 
        || this.orginal.opens == 'center' && parseInt( this.picker.container.css('right') ) == 0 
      ) {

        this.picker.container.removeClass('opensright openscenter').addClass('opensleft');
        this.picker.opens = 'left';
        this.picker.move();
        this.fixCalendarPositionHorizontal();
        return;
      }

      this.picker.move();
    }
  
  },
  _commonHide: function() {
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_commonHide' );

    this.picker.drops = this.orginal.drops;
    this.picker.opens = this.orginal.opens;
    this.picker.container.removeClass('forceOneColumn');

  },
  _commonShow: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_commonShow' );

    var rightInput = this.picker.container.find('.calendar.right .daterangepicker_input').addClass('dateTo');
    var leftInput = this.picker.container.find('.calendar.left .daterangepicker_input').addClass('dateFrom');

    this._moveRanges();

    if ( this.options.pretius.onlyOneCalendar ) {
      this.picker.container.removeClass('hideRightCalendar ').addClass( 'hideRightCalendar' );
      
      rightInput.detach();
      rightInput.insertAfter( leftInput );
    } 

    if ( this.options.daterangepicker.autoApply ) {
      this.picker.container.addClass('hasAutoApply');
    }

    if ( this.options.daterangepicker.showWeekNumbers ) {
      this.picker.container.addClass('hasShowWeekNumbers');
    }

    if ( this.options.daterangepicker.ranges ) {
      this.picker.container.addClass('hasRanges');
    }

    if ( this.options.pretius.hideCalendarDateInputs ) {
      this.picker.container.addClass('hideCalendarDateInputs');
    }

    this.fixCalendarPositionHorizontal();
    this.fixCalendarPositionVertical();



  },

  //
  //-------------------------------------------------------------------------------------------------
  //
  _overlay_showPickerOnButtonClick: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_overlay_showPickerOnButtonClick' );

    if ( this.dateTo.datepickerButton.is('.disabled') ) {
      return false;
    }

    this._overlay_focusOnDateTo();
  },

  //
  //-------------------------------------------------------------------------------------------------
  //
  _overlay_focusOnDateTo: function(){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_overlay_focusOnDateTo' );


    var 
      targetEndDate,
      targetStartDate;

    //jesli data od jest pusta
    if ( this.element.val().trim().length == 0 ) {
      //wymus pokazanie najpierw daty od
      //this.picker.show();
      this.picker.startDate = moment().startOf('day');
      this.apex.item.focus();
    }
    //jesli data od nie jest pusta
    else {
      this.picker.element = this.dateTo.item;
      this.picker.show();

      targetStartDate = this.getMomentFromStringLocaleFormat( this.element.val() );
      targetEndDate   = this.getMomentFromStringLocaleFormat( this.dateTo.item.val().trim().length == 0 ? this.element.val() : this.dateTo.item.val() );

      this.picker.setStartDate( targetStartDate );
      this.picker.setEndDate( targetEndDate );
      //this.picker.updateView();      

      this._updateCalendarView( targetStartDate, targetEndDate );


    }
  },

  //
  //-------------------------------------------------------------------------------------------------
  //
  _updateCalendarView: function( pTargetStartDate, pTargetEndDate ) {
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_updateCalendarView', 'parameters('+arguments.length+')' );
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_updateCalendarView', 'pTargetStartDate', pTargetStartDate );
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_updateCalendarView', 'pTargetEndDate', pTargetEndDate );


    if ( this.options.pretius.onlyOneCalendar ) {
      //when using only one calendar
      this.picker.leftCalendar.month.set( 'year', pTargetEndDate.year() );
      this.picker.leftCalendar.month.set( 'month', pTargetEndDate.month() );  
    }
    else {
      //when using two calendars
      if ( this.options.daterangepicker.linkedCalendars ) {
        //when calendars are linked
        if ( 
          pTargetStartDate.month() == pTargetEndDate.month() 
          && pTargetStartDate.year() == pTargetEndDate.year() 
        ) {
          //when start and end date are in the same month
          this.picker.leftCalendar.month.set('year', pTargetEndDate.clone().year() )
          this.picker.leftCalendar.month.set('month', pTargetEndDate.clone().month() )

          this.picker.rightCalendar.month.set('year', pTargetEndDate.clone().add(1, 'month').year() )
          this.picker.rightCalendar.month.set('month', pTargetEndDate.clone().add(1, 'month').month() )

        }
        else {
          //when start and and date are in different months
          this.picker.leftCalendar.month.set('year', pTargetEndDate.clone().subtract(1, 'month').year() )
          this.picker.leftCalendar.month.set('month', pTargetEndDate.clone().subtract(1, 'month').month() )

          this.picker.rightCalendar.month.set('year', pTargetEndDate.year() )
          this.picker.rightCalendar.month.set('month', pTargetEndDate.month() )
        }
      }
      else { 
        //when calendars are not linked

        if (
          pTargetStartDate.month() == pTargetEndDate.month() 
          && pTargetStartDate.year() == pTargetEndDate.year() 
        ) {
          //when start and end date are in the same month
          this.picker.leftCalendar.month.set('year', pTargetEndDate.clone().year() )
          this.picker.leftCalendar.month.set('month', pTargetEndDate.clone().month() )

          this.picker.rightCalendar.month.set('year', pTargetEndDate.clone().add(1, 'month').year() )
          this.picker.rightCalendar.month.set('month', pTargetEndDate.clone().add(1, 'month').month() )

        } 
        else {
          //when start and and date are in different months
          this.picker.leftCalendar.month.set('year', pTargetStartDate.year() )
          this.picker.leftCalendar.month.set('month', pTargetStartDate.month() )
          
          this.picker.rightCalendar.month.set('year', pTargetEndDate.year() )
          this.picker.rightCalendar.month.set('month', pTargetEndDate.month() )

        }

      }      
    }

    this.picker.renderCalendar('left');
    this.picker.renderCalendar('right');

  },

  //
  //-------------------------------------------------------------------------------------------------
  //
  _overlay_updateDateTo_input: function( pEvent ) {
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_overlay_updateDateTo_input', 'pEvent', pEvent );

    var 
      date = this._getDateFromCalendar( $(pEvent.target) ),
      format = this.options.daterangepicker.locale.format;

    this.picker.container.find('.dateTo :input').val( date.format( format ) );

    pEvent.preventDefault();
    pEvent.stopImmediatePropagation();

  },
  _overlay_dateToShow_forceDateToSelection: function( pEvent ){
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_overlay_dateToShow_forceDateToSelection', 'pEvent', pEvent );

    var 
      targetStartDate = this.getMomentFromStringLocaleFormat( this.element.val() ),
      targetEndDate = this._getDateFromCalendar( $(pEvent.target) );

    pEvent.preventDefault();
    pEvent.stopImmediatePropagation();

    if ( targetEndDate.isBefore( targetStartDate ) ) {
      //workaround at the moment. Should be changed in next versions
      $(pEvent.target).addClass('odd disabled');
      return;
    }
    else {
      apex.debug.message( this.C_LOG_WARNING, this.logPrefix, 'Selected date is after current date', 'pEvent', pEvent );
    }

    this.picker.setStartDate( targetStartDate );
    this.picker.setEndDate( targetEndDate );

    this._updateCalendarView( targetStartDate, targetEndDate );

    this.picker.renderCalendar('left');
    this.picker.renderCalendar('right');

    this.picker.container.find('.calendar td').not('.week')
      .bind( 'mousedown.test click.test'  , $.proxy( this._overlay_dateToShow_forceDateToSelection  , this ) )
      .bind( 'mouseenter.daterangepicker' , $.proxy( this._overlay_updateDateTo_input               , this ) );

    if ( this.options.daterangepicker.autoApply ) {
      this.picker.calculateChosenLabel();
      this.picker.clickApply();          
    }
  },

  //
  //-------------------------------------------------------------------------------------------------
  //
  _overlayApply: function(pEvent) {
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_overlayApply', 'pEvent', pEvent );
    
    var 
      format = this.options.daterangepicker.locale.format;

    this.element.val( this.picker.startDate.format( format ) ).trigger('change');
    this.dateTo.item.val( this.picker.endDate.format( format ) ).trigger('change');
  },
  //
  //-------------------------------------------------------------------------------------------------
  //
  _overlayCancel: function(pEvent) {
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, '_overlayCancel', 'pEvent', pEvent );
    //
  },

  //
  //-------------------------------------------------------------------------------------------------
  //
  getMomentFromStringLocaleFormat: function( pString ){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'getMomentFromStringLocaleFormat', 'pString', pString );

    return moment( pString , this.options.daterangepicker.locale.format );    
  },

  _getDateFromCalendar: function( pElem, pCalendar ) {
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_getDateFromCalendar', 'parameters = "'+arguments.length+'"');
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_getDateFromCalendar', 'pElem', pElem);
    apex.debug.message( this.C_LOG_LEVEL6, this.logPrefix, '_getDateFromCalendar', 'pCalendar', pCalendar);

    var 
      tdClicked = pElem,
      title = tdClicked.attr('data-title'),
      row = title.substr(1, 1),
      col = title.substr(3, 1),
      cal = pCalendar == undefined ? tdClicked.parents('.calendar') : pCalendar,
      date = cal.hasClass('left') ? this.picker.leftCalendar.calendar[row][col] : this.picker.rightCalendar.calendar[row][col];

    return date.clone();
  },

  getMinMaxDateFromString: function( pStringToDate ){
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'getMinMaxDateFromString', 'pStringToDate', pStringToDate);

    var formatedDate;

    if ( pStringToDate == 'today' ) {
      formatedDate = moment();
    }
    else if ( /\d{4}-\d{2}-\d{2}/.test( pStringToDate ) ) {
      formatedDate = moment( pStringToDate, 'YYYY-MM-DD' );
    }
    else {
      formatedDate = this.calculateMomentFromPattern( pStringToDate );
    }

    return formatedDate;
  },

  calculateMomentFromPattern: function( pString, pReturnInFormat ) {
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'calculateMomentFromPattern', 'parameters="'+arguments.length+'"');
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'calculateMomentFromPattern', 'pString', pString);
    apex.debug.message( this.C_LOG_DEBUG, this.logPrefix, 'calculateMomentFromPattern', 'pReturnInFormat', pReturnInFormat);

    var 
      re = /([\+-]{1}\d{1,}[y|m|d|w]{1})/g,
      matches,
      matched = [],
      destDate = moment().startOf('day'),
      expression,
      operation,
      howMany,
      unit;

    while ((matches = re.exec(pString)) != null) {
      matched.push(matches[1]);
    }

    for ( var i = 0; i < matched.length; i++) {
      expression = matched[i];
      operation = expression.substr(0, 1),
      howMany = parseInt( expression.substr(1, expression.length) ),
      unit = expression.substr(-1, expression.length);

      if ( unit == 'm' ) {
        unit = 'M';
      }

      if ( operation == '+' ) {
        destDate.add( howMany, unit );
      }else {
        destDate.subtract( howMany, unit );
      }
    }

    if ( pReturnInFormat == false || pReturnInFormat == undefined ) {
      return destDate;  
    }
    else {
      return destDate.format( this.options.daterangepicker.locale.format )
    }
    
  },
  //
  //-----------------------DO UTYLIZACJI
  //


});