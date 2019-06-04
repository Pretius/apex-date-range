create or replace package body PRETIUS_APEX_DATE_RANGE as

  function formatExceptions(
    pi_format in varchar2,
    pi_mode in varchar2 default 'decode'
  ) return varchar2 is
    v_temp_format varchar2(200);
  begin
    v_temp_format := pi_format;

    if pi_mode = 'encode' then
      v_temp_format := replace( v_temp_format, 'fmMonth', 'fmM0nth'); --fmMonth nie ma sensu
      v_temp_format := replace( v_temp_format, 'fmDD',    'fm0AY'  ); 
      v_temp_format := replace( v_temp_format, 'fmDay',   'fm0ay'  ); --tu nie ma sensu fm, usunac?
      v_temp_format := replace( v_temp_format, 'DD',      '0AY'    );
      v_temp_format := replace( v_temp_format, 'MONTH',   'M@ONTH' );
      v_temp_format := replace( v_temp_format, 'HH24',    'H@H24'  );
    else
      v_temp_format := replace( v_temp_format, 'fmM0nth', 'fmMonth'); 
      v_temp_format := replace( v_temp_format, 'fm0ay',   'fmDay'  );
      v_temp_format := replace( v_temp_format, 'fm0AY',   'fmDD'   );
      v_temp_format := replace( v_temp_format, '0AY',     'DD'     );
      v_temp_format := replace( v_temp_format, 'M@ONTH',  'MONTH'  );
      v_temp_format := replace( v_temp_format, 'H@H24',   'HH24'   );
    end if;

    return v_temp_format;
  end;

  function translateOracleJs(
    pi_format in varchar2
  ) return varchar2 is
    v_temp_format varchar2(200);
  begin
    --encode exceptions
    v_temp_format := formatExceptions( pi_format, 'encode' );

    v_temp_format := replace( v_temp_format, 'DAY',   'dddd' ); --MON -> Mon
    v_temp_format := replace( v_temp_format, 'Day',   'dddd' ); --Mon -> Mon
    v_temp_format := replace( v_temp_format, 'HH24',  'HH' );
    v_temp_format := replace( v_temp_format, 'HH12',  'hh' );
    v_temp_format := replace( v_temp_format, 'HH',    'hh' );
    v_temp_format := replace( v_temp_format, 'MI',    'mm' );
    v_temp_format := replace( v_temp_format, 'SS',    'ss' );
    v_temp_format := replace( v_temp_format, 'fmMM',  'M'  );
    v_temp_format := replace( v_temp_format, 'MM',    'MM' );
    v_temp_format := replace( v_temp_format, 'WW',    'w'  );
    v_temp_format := replace( v_temp_format, 'IW',    'W'  );
    v_temp_format := replace( v_temp_format, 'DAY',   'dd' );
    v_temp_format := replace( v_temp_format, 'D',     'E'  );
    v_temp_format := replace( v_temp_format, 'AM',    'A'  );
    v_temp_format := replace( v_temp_format, 'PM',    'A'  );
    v_temp_format := replace( v_temp_format, 'RR',    'YY'  );

    --restore exceptions
    v_temp_format := formatExceptions( v_temp_format, 'decode' );

    --decode exceptions
    --v_temp_format := replace( v_temp_format, 'DD',     'DD' );
    v_temp_format := replace( v_temp_format, 'MONTH',    'MMMM' ); --JANUARY -> January
    v_temp_format := replace( v_temp_format, 'fmMonth',  'MMMM' ); --January -> January
    v_temp_format := replace( v_temp_format, 'Month',    'MMMM' ); --January -> January
    v_temp_format := replace( v_temp_format, 'MON',      'MMM'  ); --JAN -> Jan
    v_temp_format := replace( v_temp_format, 'Mon',      'MMM'  ); --Jan -> Jan
    v_temp_format := replace( v_temp_format, 'HH24',     'HH'   );
    v_temp_format := replace( v_temp_format, 'fmDD',     'D'    );
    v_temp_format := replace( v_temp_format, 'fmDay',    'dddd' );

    return v_temp_format;
  end;

  function getTranslation(
    pi_lang_text in varchar2,
    pi_plugin_default in varchar2
  ) return varchar2
  is
  begin
    return replace( APEX_LANG.MESSAGE( pi_lang_text ),  pi_lang_text, pi_plugin_default );
  end;

  procedure json_write_array(
    pi_array_string in varchar2,
    pi_separator in varchar2 default ','
  )
  is
    v_array APEX_APPLICATION_GLOBAL.VC_ARR2;
    v_result_array_elements varchar2(4000);

  begin
    v_array := APEX_UTIL.STRING_TO_TABLE(pi_array_string, ',');
    
    for i in 1..v_array.count LOOP
      apex_json.write( v_array(i) ); 
    end loop;
  end;  

  function getJSON(
    p_item   in apex_plugin.t_page_item,
    p_plugin in apex_plugin.t_plugin
  ) return clob 
  is 
    --translateable
    lang_month_names            varchar2(4000) := getTranslation('PRETIUS_DATERANGEPICKER_MONTHS'       , 'January,February,March,April,May,June,July,August,September,October,November,December');
    lang_app_days_of_week       varchar2(200)  := getTranslation('PRETIUS_DATERANGEPICKER_DAYS'         , 'Su,Mo,Tu,We,Th,Fr,Sa');
    lang_apply_label            varchar2(50)   := getTranslation('PRETIUS_DATERANGEPICKER_APPLYLABEL'   , 'Apply');
    lang_cancel_label           varchar2(50)   := getTranslation('PRETIUS_DATERANGEPICKER_CANCELLABEL'  , 'Cancel');  
    lang_app_custom_range_label varchar2(100)  := getTranslation('PRETIUS_DATERANGEPICKER_CUSTOM_RANGE' , 'Custom');
    lang_app_week_label         varchar2(10)   := getTranslation('PRETIUS_DATERANGEPICKER_WEEK_LABEL'   , 'W');
    
    --plugin application scope attributes
    --JavaScript uses index starting from 0, and PL/SQL from 1
    attr_app_first_day          number         := p_plugin.attribute_03-1; 
    attr_app_btn_class          varchar2(100)  := p_plugin.attribute_04;
    attr_app_btn_apply_class    varchar2(100)  := p_plugin.attribute_05;
    attr_app_btn_cancel_class   varchar2(100)  := p_plugin.attribute_06;

    --plugin custom attributes
    attr_mode                   varchar2(5)    := p_item.attribute_01;
    --                                            p_item.attribute_02;
    --                                            p_item.attribute_03;
    attr_min_date               varchar2(200)  := p_item.attribute_04;
    attr_max_date               varchar2(200)  := p_item.attribute_05;
    attr_settings               varchar2(4000) := p_item.attribute_06;  
    attr_display_options        varchar2(2)    := p_item.attribute_07;
    attr_date_limit             number         := p_item.attribute_08;
    
    attr_appearance             varchar2(4000) := p_item.attribute_10;
    --                                            p_item.attribute_11;
    --                                            p_item.attribute_12;
    --                                            p_item.attribute_13;
    attr_dateto_item            varchar2(200)  := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY( p_item.attribute_14 );
    attr_showMethod             varchar2(15)   := p_item.attribute_15;

    --do wywalenia, zastapione bedzie przez atrybut 1
    attr_settings_altDateToSelect   boolean         := case when attr_mode = 'PDPA'          then true else false end;
    attr_settings_overlay           boolean         := case when instr(attr_mode, 'PDP') > 0 then true else false end;
    --
    
    attr_settings_autoApply         boolean         := case when instr(attr_settings, 'autoApply')              > 0 then true else false end;
    attr_settings_ranges            boolean         := case when instr(attr_settings, 'ranges')                 > 0 then true else false end;

    --wyglad
    attr_look_dropdowns         boolean         := case when instr(attr_appearance, 'showDropdowns')          > 0 then true else false end;
    attr_look_isoWeeks          boolean         := case when instr(attr_appearance, 'showISOWeekNumbers')     > 0 then true else false end;
    attr_look_weekNumber        boolean         := case when instr(attr_appearance, 'showWeekNumbers')        > 0 then true else false end;  
    attr_look_linkedCalendards  boolean         := case when instr(attr_appearance, 'linkedCalendars')        > 0 then true else false end;
    attr_look_showCalendars     boolean         := case when instr(attr_appearance, 'alwaysShowCalendars')    > 0 then false else true end;
    attr_look_onlyOneCalendar   boolean         := case when instr(attr_appearance, 'onlyOneCalendar')        > 0 then true else false end;
    attr_look_showDateInputs    boolean         := case when instr(attr_appearance, 'hideCalendarDateInputs') > 0 then false else true end;
    attr_look_showOtherDays     boolean         := case when instr(attr_appearance, 'hideOtherMonthDays')     > 0 then false else true end;


    attr_display_options_opens    varchar2(9)     := case when instr( attr_display_options, 'R' ) > 0 then 'right' when instr( attr_display_options, 'C' ) > 0 then 'center' else 'left' end;
    attr_display_options_drops    varchar2(9)     := case when instr( attr_display_options, 'U' ) > 0 then 'up' else 'down' end;

    attr_date_format              varchar2(100)   := NVL(p_item.format_mask, 'YYYY-MM-DD');
    attr_date_format_timePicker   boolean         := case when instr(attr_date_format, 'HH') > 0 then true else false end;
    attr_date_format_timePicker24 boolean         := case when instr(attr_date_format, 'HH24') > 0 then true else false end;
    attr_date_format_timePickerSS boolean         := case when instr(attr_date_format, 'SS') > 0 then true else false end;

    v_json clob;
  begin
    --utworz obiekt
    apex_json.initialize_clob_output;
    apex_json.open_object();
      apex_json.open_object('pretius');
        apex_json.write( 'overlay',                 attr_settings_overlay );
        apex_json.write( 'dateToItem',              attr_dateto_item );
        apex_json.write( 'applyRanges',             attr_settings_ranges );
        apex_json.write( 'onlyOneCalendar',         attr_look_onlyOneCalendar );
        apex_json.write( 'hideCalendarDateInputs',  attr_look_showDateInputs );
        apex_json.write( 'hideOtherMonthDays',      attr_look_showOtherDays );
        apex_json.write( 'altDateToSelect',         attr_settings_altDateToSelect );
        
        --apex_json.write( 'dateFromItem',  v_jquery_base_item );
      apex_json.close_object; --apex

      apex_json.open_object('daterangepicker');
        --apex_json.write( 'startDate', );
        --apex_json.write( 'endDate', );
        apex_json.write( 'alwaysShowCalendars', attr_look_showCalendars );
        apex_json.write( 'autoApply',           attr_settings_autoApply );
        apex_json.write( 'autoUpdateInput',     false );
        apex_json.write( 'applyClass',          attr_app_btn_apply_class );
        apex_json.write( 'buttonClasses',       attr_app_btn_class );
        apex_json.write( 'cancelClass',         attr_app_btn_cancel_class );
        apex_json.write( 'drops',               attr_display_options_drops );
        apex_json.write( 'linkedCalendars',     attr_look_linkedCalendards );      
        apex_json.write( 'minDate',             attr_min_date );
        apex_json.write( 'maxDate',             attr_max_date );
        apex_json.write( 'opens',               attr_display_options_opens );
        apex_json.write( 'singleDatePicker',    false );
        apex_json.write( 'showMethod',          attr_showMethod );
        apex_json.write( 'showDropdowns',       attr_look_dropdowns );
        
        apex_json.write( 'showWeekNumbers',     attr_look_weekNumber );
        apex_json.write( 'showISOWeekNumbers',  attr_look_isoWeeks );

        --timepicker to be dont as application component 
        apex_json.write( 'timePicker',          attr_date_format_timePicker );
        apex_json.write( 'timePicker24Hour',    attr_date_format_timePicker24 );
        apex_json.write( 'timePickerSeconds',   attr_date_format_timePickerSS );
        apex_json.write( 'showCustomRangeLabel', false );

        apex_json.open_object('locale'); 
          apex_json.write( 'applyLabel',        lang_apply_label );
          apex_json.write( 'cancelLabel',       lang_cancel_label );
          apex_json.write( 'customRangeLabel',  lang_app_custom_range_label);
          apex_json.open_array('daysOfWeek');
            json_write_array( lang_app_days_of_week );
          apex_json.close_array;
          apex_json.write( 'firstDay',          attr_app_first_day);
          apex_json.write( 'format',            translateOracleJs( attr_date_format ) );
          --js reference not exists
          apex_json.write( 'fromLabel',         'From' );
          --js reference not exists
          apex_json.write( 'toLabel',           'To' );
          apex_json.open_array('monthNames');
            json_write_array( lang_month_names );
          apex_json.close_array; 
          apex_json.write( 'weekLabel',         lang_app_week_label );
        apex_json.close_object;
        
        --if maximum no of days is limited
        if instr(attr_settings, 'dateLimit') > 0 then
          apex_json.open_object('dateLimit');
            apex_json.write( 'days', attr_date_limit );
          apex_json.close_object;
        end if;

      apex_json.close_object; --daterangepicker
    apex_json.close_object;

    v_json := apex_json.get_clob_output;

    apex_json.free_output;

    return v_json;
  end;

  procedure render_daterange (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result 
  ) is
    v_escaped_value    varchar2(32767) := wwv_flow_escape.html(p_param.value);
    attr_ranges        varchar2(4000)  := case when p_item.attribute_09 is null then '{}' else '{"daterangepicker": {"ranges": '||p_item.attribute_09||'}}' end;
    v_jquery_base_item varchar2(200)   := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(p_item.name);
    v_json             clob;
  begin

    if p_param.value_set_by_controller and p_param.is_readonly then
      return;
    end if;

    apex_plugin_util.debug_page_item (
      p_plugin    => p_plugin,
      p_page_item => p_item 
    );

    if p_param.is_readonly or p_param.is_printer_friendly then

      APEX_PLUGIN_UTIL.print_hidden_if_readonly (
        p_item  => p_item,
        p_param => p_param 
      );      

      wwv_flow_plugin_util.print_display_only (
        p_item             => p_item,
        p_display_value    => p_param.value,
        p_show_line_breaks => false,
        p_escape           => true 
      );
    else

      htp.p('
        <input '||
        'type="text"'||

        apex_plugin_util.get_element_attributes(
          p_item => p_item,
          p_name => apex_plugin.get_input_name_for_page_item(p_is_multi_value => false),
          p_default_class => 'text_field apex-item-text pretius_date_range',
          p_add_id => true,
          p_add_labelledby => true
        )||

        'size="'||p_item.element_width||'" '||
        'maxlength="'||p_item.element_max_length||'" '||
        --'value="'||htf.escape_sc(p_value)||'">'||
        'value="'||v_escaped_value||'">'||
        '<button type="button" class="ui-datepicker-trigger a-Button a-Button--calendar pretius-apexdaterangepicker">
          <span class="a-Icon icon-calendar"></span>
        </button>    
      ');
      
      --tbd
      --p_result.is_navigable := true;

      v_json := getJSON(
        p_item => p_item,
        p_plugin => p_plugin
      );

      apex_javascript.add_onload_code(
        p_code => '
          $("'||v_jquery_base_item||'").apexdaterangepicker('||v_json||', '||attr_ranges||');
        ',
        p_key => 'apexdaterangepicker_'||p_item.name
      );

    end if;

  end;

end;
