set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.1.00.06'
,p_default_workspace_id=>10518555994626445
,p_default_application_id=>105
,p_default_owner=>'OSTROWB_SCHEMA'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/item_type/pretius_apex_range_date
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(2057511222487066919)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'PRETIUS_APEX_RANGE_DATE'
,p_display_name=>'Pretius APEX Date Range'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#moment.min.js',
'#PLUGIN_FILES#daterangepicker.js',
'#PLUGIN_FILES#pretiusapexdaterangepicker.js'))
,p_css_file_urls=>'#PLUGIN_FILES#pretiusapexdaterangepicker.css'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'function formatExceptions(',
'  pi_format in varchar2,',
'  pi_mode in varchar2 default ''decode''',
') return varchar2 is',
'  v_temp_format varchar2(200);',
'begin',
'  v_temp_format := pi_format;',
'',
'  if pi_mode = ''encode'' then',
'    --wyeleminuj wyjatki',
'    v_temp_format := replace( v_temp_format, ''fmMonth'', ''fmM0nth''); --fmMonth nie ma sensu',
'    v_temp_format := replace( v_temp_format, ''fmDD'',    ''fm0AY''  ); ',
'    v_temp_format := replace( v_temp_format, ''fmDay'',   ''fm0ay''  ); --tu nie ma sensu fm, usunac?',
'    v_temp_format := replace( v_temp_format, ''DD'',      ''0AY''    );',
'    v_temp_format := replace( v_temp_format, ''MONTH'',   ''M@ONTH'' );',
'    v_temp_format := replace( v_temp_format, ''HH24'',    ''H@H24''  );',
'  else',
'    v_temp_format := replace( v_temp_format, ''fmM0nth'', ''fmMonth''); ',
'    v_temp_format := replace( v_temp_format, ''fm0ay'',   ''fmDay''  );',
'    v_temp_format := replace( v_temp_format, ''fm0AY'',   ''fmDD''   );',
'    v_temp_format := replace( v_temp_format, ''0AY'',     ''DD''     );',
'    v_temp_format := replace( v_temp_format, ''M@ONTH'',  ''MONTH''  );',
'    v_temp_format := replace( v_temp_format, ''H@H24'',   ''HH24''   );',
'  end if;',
'',
'  return v_temp_format;',
'end;',
'',
'function translateOracleJs(',
'  pi_format in varchar2',
') return varchar2 is',
'  v_temp_format varchar2(200);',
'begin',
'  --zabezpiecz wyjatki',
'  v_temp_format := formatExceptions( pi_format, ''encode'' );',
'',
'  --wykonaj konwersje do js',
'  v_temp_format := replace( v_temp_format, ''DAY'',   ''dddd'' ); --MON -> Mon',
'  v_temp_format := replace( v_temp_format, ''Day'',   ''dddd'' ); --Mon -> Mon',
'  v_temp_format := replace( v_temp_format, ''HH24'',  ''HH'' );',
'  v_temp_format := replace( v_temp_format, ''HH12'',  ''hh'' );',
'  v_temp_format := replace( v_temp_format, ''HH'',    ''hh'' );',
'  v_temp_format := replace( v_temp_format, ''MI'',    ''mm'' );',
'  v_temp_format := replace( v_temp_format, ''SS'',    ''ss'' );',
'  v_temp_format := replace( v_temp_format, ''fmMM'',  ''M''  );',
'  v_temp_format := replace( v_temp_format, ''MM'',    ''MM'' );',
'  v_temp_format := replace( v_temp_format, ''WW'',    ''w''  );',
'  v_temp_format := replace( v_temp_format, ''IW'',    ''W''  );',
'  v_temp_format := replace( v_temp_format, ''DAY'',   ''dd'' );',
'  v_temp_format := replace( v_temp_format, ''D'',     ''E''  );',
'  v_temp_format := replace( v_temp_format, ''AM'',    ''A''  );',
'  v_temp_format := replace( v_temp_format, ''PM'',    ''A''  );',
'  v_temp_format := replace( v_temp_format, ''RR'',    ''YY''  );',
'',
'  --przywroc wyjatki',
'  v_temp_format := formatExceptions( v_temp_format, ''decode'' );',
'',
'  --przetlumacz wyjatki',
'  --v_temp_format := replace( v_temp_format, ''DD'',     ''DD'' );',
'  v_temp_format := replace( v_temp_format, ''MONTH'',    ''MMMM'' ); --JANUARY -> January',
'  v_temp_format := replace( v_temp_format, ''fmMonth'',  ''MMMM'' ); --January -> January',
'  v_temp_format := replace( v_temp_format, ''Month'',    ''MMMM'' ); --January -> January',
'  v_temp_format := replace( v_temp_format, ''MON'',      ''MMM''  ); --JAN -> Jan',
'  v_temp_format := replace( v_temp_format, ''Mon'',      ''MMM''  ); --Jan -> Jan',
'  v_temp_format := replace( v_temp_format, ''HH24'',     ''HH''   );',
'  v_temp_format := replace( v_temp_format, ''fmDD'',     ''D''    );',
'  v_temp_format := replace( v_temp_format, ''fmDay'',    ''dddd'' );',
'  ',
'',
'',
'  return v_temp_format;',
'end;',
'',
'function getTranslation(',
'  pi_lang_text in varchar2,',
'  pi_plugin_default in varchar2',
') return varchar2',
'is',
'begin',
'  return replace( APEX_LANG.MESSAGE( pi_lang_text ),  pi_lang_text, pi_plugin_default );',
'end;',
'',
'procedure json_write_array(',
'  pi_array_string in varchar2,',
'  pi_separator in varchar2 default '',''',
')',
'is',
'  v_array APEX_APPLICATION_GLOBAL.VC_ARR2;',
'  v_result_array_elements varchar2(4000);',
'',
'begin',
'  v_array := APEX_UTIL.STRING_TO_TABLE(pi_array_string, '','');',
'  ',
'  for i in 1..v_array.count LOOP',
'    apex_json.write( v_array(i) ); ',
'  end loop;',
'end;  ',
'',
'function render_daterange (',
'  p_item in apex_plugin.t_page_item,',
'  p_plugin in apex_plugin.t_plugin,',
'  p_value in varchar2,',
'  p_is_readonly in boolean,',
'  p_is_printer_friendly in boolean',
') return apex_plugin.t_page_item_render_result',
'is',
'  l_result apex_plugin.t_page_item_render_result;',
'',
'  --translateable',
'  lang_month_names            varchar2(4000) := getTranslation(''PRETIUS_DATERANGEPICKER_MONTHS''       , ''January,February,March,April,May,June,July,August,September,October,November,December'');',
'  lang_app_days_of_week       varchar2(200)  := getTranslation(''PRETIUS_DATERANGEPICKER_DAYS''         , ''Mo,Tu,We,Th,Fr,Sa,Su'');',
'  lang_apply_label            varchar2(50)   := getTranslation(''PRETIUS_DATERANGEPICKER_APPLYLABEL''   , ''Apply'');',
'  lang_cancel_label           varchar2(50)   := getTranslation(''PRETIUS_DATERANGEPICKER_CANCELLABEL''  , ''Cancel'');  ',
'  lang_app_custom_range_label varchar2(100)  := getTranslation(''PRETIUS_DATERANGEPICKER_CUSTOM_RANGE'' , ''Custom'');',
'  lang_app_week_label         varchar2(10)   := getTranslation(''PRETIUS_DATERANGEPICKER_WEEK_LABEL''   , ''W'');',
'  --plugin application scope attributes',
'  attr_app_first_day          number         := p_plugin.attribute_03-1; --JavaScript uses index starting from 0, and PL/SQL from 1',
'  attr_app_btn_class          varchar2(100)  := p_plugin.attribute_04;',
'  attr_app_btn_apply_class    varchar2(100)  := p_plugin.attribute_05;',
'  attr_app_btn_cancel_class   varchar2(100)  := p_plugin.attribute_06;',
'  --plugin custom attributes',
'  attr_mode                   varchar2(5)    := p_item.attribute_01;',
'  --                                            p_item.attribute_02;',
'  --                                            p_item.attribute_03;',
'  attr_min_date               varchar2(200)  := p_item.attribute_04;',
'  attr_max_date               varchar2(200)  := p_item.attribute_05;',
'  attr_settings               varchar2(4000) := p_item.attribute_06;  ',
'  attr_display_options        varchar2(2)    := p_item.attribute_07;',
'  attr_date_limit             number         := p_item.attribute_08;',
'  attr_ranges                 varchar2(4000) := case when p_item.attribute_09 is null then ''{}'' else ''{"daterangepicker": {"ranges": ''||p_item.attribute_09||''}}'' end;',
'  attr_appearance             varchar2(4000) := p_item.attribute_10;',
'  --                                            p_item.attribute_11;',
'  --                                            p_item.attribute_12;',
'  --                                            p_item.attribute_13;',
'  attr_dateto_item            varchar2(200)  := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY( p_item.attribute_14 );',
'  attr_showMethod             varchar2(15)   := p_item.attribute_15;',
'',
'  --do wywalenia, zastapione bedzie przez atrybut 1',
'  attr_settings_altDateToSelect   boolean         := case when attr_mode = ''PDPA''          then true else false end;',
'  attr_settings_overlay           boolean         := case when instr(attr_mode, ''PDP'') > 0 then true else false end;',
'  --',
'  ',
'  attr_settings_autoApply         boolean         := case when instr(attr_settings, ''autoApply'')              > 0 then true else false end;',
'  attr_settings_ranges            boolean         := case when instr(attr_settings, ''ranges'')                 > 0 then true else false end;',
'',
'  --wyglad',
'  attr_look_dropdowns         boolean         := case when instr(attr_appearance, ''showDropdowns'')          > 0 then true else false end;',
'  attr_look_isoWeeks          boolean         := case when instr(attr_appearance, ''showISOWeekNumbers'')     > 0 then true else false end;',
'  attr_look_weekNumber        boolean         := case when instr(attr_appearance, ''showWeekNumbers'')        > 0 then true else false end;  ',
'  attr_look_linkedCalendards  boolean         := case when instr(attr_appearance, ''linkedCalendars'')        > 0 then true else false end;',
'  attr_look_showCalendars     boolean         := case when instr(attr_appearance, ''alwaysShowCalendars'')    > 0 then false else true end;',
'  attr_look_onlyOneCalendar   boolean         := case when instr(attr_appearance, ''onlyOneCalendar'')        > 0 then true else false end;',
'  attr_look_showDateInputs    boolean         := case when instr(attr_appearance, ''hideCalendarDateInputs'') > 0 then false else true end;',
'  attr_look_showOtherDays     boolean         := case when instr(attr_appearance, ''hideOtherMonthDays'')     > 0 then false else true end;',
'',
'',
'  attr_display_options_opens      varchar2(9)     := case when instr( attr_display_options, ''R'' ) > 0 then ''right'' when instr( attr_display_options, ''C'' ) > 0 then ''center'' else ''left'' end;',
'  attr_display_options_drops      varchar2(9)     := case when instr( attr_display_options, ''U'' ) > 0 then ''up'' else ''down'' end;',
'',
'  attr_date_format                varchar2(100)   := NVL(p_item.format_mask, ''YYYY-MM-DD'');',
'  attr_date_format_timePicker     boolean         := case when instr(attr_date_format, ''HH'') > 0 then true else false end;',
'  attr_date_format_timePicker24   boolean         := case when instr(attr_date_format, ''HH24'') > 0 then true else false end;',
'  attr_date_format_timePickerSS   boolean         := case when instr(attr_date_format, ''SS'') > 0 then true else false end;',
'',
'  --wymagany do zainicjowania pluginu',
'  v_jquery_base_item   varchar2(200)      := APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(p_item.name);',
'  v_json clob;',
'begin',
'  --t_page_item atrybuty itema',
'  --t_plugin atrybuty aplikacji',
'',
'    --"timePicker": true,',
'    --"timePicker24Hour": true,',
'',
'  apex_plugin_util.debug_page_item (',
'    p_plugin    => p_plugin,',
'    p_page_item => p_item ',
'  );',
'',
'  --utworz obiekt',
'  apex_json.initialize_clob_output;',
'  apex_json.open_object();',
'    apex_json.open_object(''pretius'');',
'      apex_json.write( ''overlay'',                 attr_settings_overlay );',
'      apex_json.write( ''dateToItem'',              attr_dateto_item );',
'      apex_json.write( ''applyRanges'',             attr_settings_ranges );',
'      apex_json.write( ''onlyOneCalendar'',         attr_look_onlyOneCalendar );',
'      apex_json.write( ''hideCalendarDateInputs'',  attr_look_showDateInputs );',
'      apex_json.write( ''hideOtherMonthDays'',      attr_look_showOtherDays );',
'      apex_json.write( ''altDateToSelect'',         attr_settings_altDateToSelect );',
'      ',
'      --apex_json.write( ''dateFromItem'',  v_jquery_base_item );',
'    apex_json.close_object; --apex',
'',
'    apex_json.open_object(''daterangepicker'');',
'      --apex_json.write( ''startDate'', );',
'      --apex_json.write( ''endDate'', );',
'      apex_json.write( ''alwaysShowCalendars'', attr_look_showCalendars );',
'      apex_json.write( ''autoApply'',           attr_settings_autoApply );',
'      apex_json.write( ''autoUpdateInput'',     false );',
'      apex_json.write( ''applyClass'',          attr_app_btn_apply_class );',
'      apex_json.write( ''buttonClasses'',       attr_app_btn_class );',
'      apex_json.write( ''cancelClass'',         attr_app_btn_cancel_class );',
'      apex_json.write( ''drops'',               attr_display_options_drops );',
'      apex_json.write( ''linkedCalendars'',     attr_look_linkedCalendards );      ',
'      apex_json.write( ''minDate'',             attr_min_date );',
'      apex_json.write( ''maxDate'',             attr_max_date );',
'      apex_json.write( ''opens'',               attr_display_options_opens );',
'      apex_json.write( ''singleDatePicker'',    false );',
'      apex_json.write( ''showMethod'',          attr_showMethod );',
'      apex_json.write( ''showDropdowns'',       attr_look_dropdowns );',
'      --apex_json.write( ''ranges'',            null ); -- przekazywany przy inicjalizacji pluginu',
'      ',
'      apex_json.write( ''showWeekNumbers'',     attr_look_weekNumber );',
'      apex_json.write( ''showISOWeekNumbers'',  attr_look_isoWeeks );',
'      --timepicker do wyjdzielenia app scope',
'',
'      apex_json.write( ''timePicker'',          attr_date_format_timePicker );',
'      apex_json.write( ''timePicker24Hour'',    attr_date_format_timePicker24 );',
'      apex_json.write( ''timePickerSeconds'',   attr_date_format_timePickerSS );',
'      apex_json.write( ''showCustomRangeLabel'', false );',
'      apex_json.open_object(''locale''); --utworz obiekt locale',
'        apex_json.write( ''applyLabel'',        lang_apply_label );',
'        apex_json.write( ''cancelLabel'',       lang_cancel_label );',
'        apex_json.write( ''customRangeLabel'',  lang_app_custom_range_label);',
'        apex_json.open_array(''daysOfWeek'');',
'          json_write_array( lang_app_days_of_week );',
'        apex_json.close_array;',
'        apex_json.write( ''firstDay'',          attr_app_first_day);',
'        apex_json.write( ''format'',            translateOracleJs( attr_date_format ) );',
'        apex_json.write( ''fromLabel'',         ''From'' );',
'        apex_json.write( ''toLabel'',           ''To'' );',
'        apex_json.open_array(''monthNames'');',
'          json_write_array( lang_month_names );',
'        apex_json.close_array; ',
'        apex_json.write( ''weekLabel'',         lang_app_week_label );',
'      apex_json.close_object; --//end of locale',
'      ',
'      --utwórz obiekt datelimit',
'      if instr(attr_settings, ''dateLimit'') > 0 then',
'        --utworz obiekt dateLimit',
'        apex_json.open_object(''dateLimit'');',
'          apex_json.write( ''days'', attr_date_limit );',
'        apex_json.close_object;',
'        --//end of dateLimit',
'      end if;',
'',
'      --//end of date limit',
'    apex_json.close_object; --daterangepicker',
'  apex_json.close_object;',
'',
'  --przechwyc JSON',
'  v_json := apex_json.get_clob_output;',
'  --zwolnij JSON',
'  apex_json.free_output;',
'',
'/*',
'  htp.p(''',
'    <textarea id="''||p_item.name||''_TEXTAREA" style="display: block">',
'      ',
'    </textarea>   ',
'    <script>',
'      document.getElementById("''||p_item.name||''_TEXTAREA").value = ( JSON.stringify(''||v_json||'', null, 2) );',
'    </script> ',
'  '');',
'*/',
'',
'',
'  htp.p(''',
'    <input ''||',
'    ''type="text"''||',
'    ''name="''||apex_plugin.get_input_name_for_page_item(p_is_multi_value => false)||''" ''||',
'    ''id="''||p_item.name||''" ''||',
'    ''size="''||p_item.element_width||''" ''||',
'    ''maxlength="''||p_item.element_max_length||''" ''||',
'    p_item.element_attributes||'' ''||',
'    p_item.element_option_attributes||'' ''||',
'    case when p_is_readonly = true then ''readonly="readonly" '' else '' '' end ||',
'    ''placeholder="''||p_item.placeholder||''" ''||',
'    ''value="''||htf.escape_sc(p_value)||''">''||',
'    ''<button type="button" class="ui-datepicker-trigger a-Button a-Button--calendar pretius-apexdaterangepicker">',
'      <span class="a-Icon icon-calendar"></span>',
'    </button>    ',
'  '');',
'',
'',
'  apex_javascript.add_onload_code(',
'    p_code => ''',
'      $("''||v_jquery_base_item||''").apexdaterangepicker(''||v_json||'', ''||attr_ranges||'');',
'    '',',
'    p_key => ''apexdaterangepicker_''||p_item.name',
'  );',
'',
'  ',
'  return l_result;',
'exception ',
'    when others then',
'      apex_json.free_output;',
'end;',
''))
,p_render_function=>'render_daterange'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:SOURCE:FORMAT_MASK_DATE:ELEMENT:WIDTH:PLACEHOLDER'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>69
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057552201228099949)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'First day'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_default_value=>'1'
,p_max_length=>1
,p_is_translatable=>false
,p_help_text=>'Use this attribute to determine which day of week should be rendered as first day of the week. While default day names are defined as <code>"Mo,Tu,We,Th,Fr,Sa,Su"</code>, default value <code>"1"</code> refers <code>"Mo"</code>. Value <code>"7"</code>'
||' refers <code>"Su"</code>.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057553468364121865)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Button classes'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'t-Button t-Button--small'
,p_is_translatable=>false
,p_help_text=>'Use this attribute to determine what classes will be applied to date picker buttons.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057555214046129477)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Apply class'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'t-Button--hot'
,p_is_translatable=>false
,p_help_text=>'Use this attribute to determine what classes will be applied to <code>"Apply"</code> button.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057556246960136410)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Cancel class'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'t-Cancel'
,p_is_translatable=>false
,p_help_text=>'Use this attribute to determine what classes will be applied to <code>"Cancel"</code> button.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1208022388030826418)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Mode'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'NDP'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Picked option defines whether starting and ending date will be stored in one or two APEX items.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208029081841831212)
,p_plugin_attribute_id=>wwv_flow_api.id(1208022388030826418)
,p_display_sequence=>20
,p_display_value=>'One field'
,p_return_value=>'NDP'
,p_is_quick_pick=>true
,p_help_text=>'Starting and ending date will be stored within the plugin APEX item. Dates are separated with <code>" - "</code> string.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208029454700833220)
,p_plugin_attribute_id=>wwv_flow_api.id(1208022388030826418)
,p_display_sequence=>30
,p_display_value=>'Two fields'
,p_return_value=>'PDP'
,p_is_quick_pick=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'Starting and ending date will be stored within separate APEX items. Attribute <b>Date to item</b> must be specified. Given APEX item will store ending date.',
'</p>',
'<ul>',
'<li>',
'When items don''t have values, clicking <code>date to</code> item results in showing date picker for item representing a starting date. ',
'</li>',
'<li>',
'When items have values set, clicking <code>date to</code> item results in showing date picker for item representing ending date - clicking on a date in calendar(s) starts a new range of dates.',
'</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208047753927844555)
,p_plugin_attribute_id=>wwv_flow_api.id(1208022388030826418)
,p_display_sequence=>40
,p_display_value=>'Two fields - alternative'
,p_return_value=>'PDPA'
,p_is_quick_pick=>true
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'Similar to <b>Two fields</b> except that clicking on <code>Date to</code> item results in selecting only ending date of the range. ',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057512867176359655)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>145
,p_prompt=>'Minimum date'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'setMinDate'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<ul>',
'  <li><code>2012-12-25</code></li>',
'  <li><code>+1y+1m+1w</code></li>',
'  <li><code>-1m-1w</code></li>',
'  <li><code>+1m-1d</code></li>',
'  <li><code>today</code></li>',
'</ul>'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Enter the minimum date that can be selected.<br/><br/>',
'',
'The date value can be an absolute value in <code>"YYYY-MM-DD"</code> format or a relative value with respect to today''s date, such as <code>"+7d"</code> or <code>today</code> string.<br/><br/>',
'',
'Relative date values include:',
'',
'<dl>',
'  <dt>y</dt>',
'    <dd>+ / - years from today''s date</dd>',
'  <dt>m</dt>',
'    <dd>+ / - months from today''s date</dd>',
'  <dt>w</dt>',
'    <dd>+ / - weeks from today''s date</dd>',
'  <dt>d</dt>',
'    <dd>+ / - days from today''s date</dd>',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057513098331360629)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>150
,p_prompt=>'Maximum date'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'setMaxDate'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<ul>',
'  <li><code>2012-12-25</code></li>',
'  <li><code>+1y+1m+1w</code></li>',
'  <li><code>-1m-1w</code></li>',
'  <li><code>+1m-1d</code></li>',
'  <li><code>today</code></li>',
'</ul>'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Enter the maximum date that can be selected.<br/><br/>',
'',
'The date value can be an absolute value in <code>"YYYY-MM-DD"</code> format or a relative value with respect to today''s date, such as <code>"+7d"</code> or <code>today</code> string.<br/><br/>',
'',
'Relative date values include:',
'',
'<dl>',
'  <dt>y</dt>',
'    <dd>+ / - years from today''s date</dd>',
'  <dt>m</dt>',
'    <dd>+ / - months from today''s date</dd>',
'  <dt>w</dt>',
'    <dd>+ / - weeks from today''s date</dd>',
'  <dt>d</dt>',
'    <dd>+ / - days from today''s date</dd>',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057513429798362367)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>125
,p_prompt=>'Settings'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'This attribute allows you to configure the plugin behavior.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057513760986363243)
,p_plugin_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_display_sequence=>0
,p_display_value=>'Auto apply'
,p_return_value=>'autoApply'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'If checked, buttons <b>Apply</b> and <b>Cancel</b> are not displayed. ',
'Selecting ending date automatically close the date range picker and insert values to proper APEX item(s).'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057999516229220344)
,p_plugin_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_display_sequence=>1
,p_display_value=>'Minimum date'
,p_return_value=>'setMinDate'
,p_help_text=>'If checked, minimum date must be specified as the <b>Minimum date</b> attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057999980724221592)
,p_plugin_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_display_sequence=>5
,p_display_value=>'Maximum date'
,p_return_value=>'setMaxDate'
,p_help_text=>'If checked, maximum date must be specified as the <b>Maximum date</b> attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057516961865367259)
,p_plugin_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_display_sequence=>7
,p_display_value=>'Limit date range'
,p_return_value=>'dateLimit'
,p_help_text=>'If checked, range of dates can be limited to the given number of days. The value must be specified as the <b>Limit date range</b> attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057517658359372349)
,p_plugin_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_display_sequence=>10
,p_display_value=>'Quick pick(s)'
,p_return_value=>'ranges'
,p_help_text=>'If checked, the plugin will use predefined ranges of dates. Ranges can be defined in <b>Quick pick(s)</b> attribute.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057519865424390227)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>109
,p_prompt=>'Display options'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'DR'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Picked option defines preferred position of the calendar(s) in relation to the APEX item. <br/><br/>',
'<b>Preferred</b> means that if there is no space for calendar(s) (above / below or left / right to the APEX item), the plugin will try to fit calendar(s) to the current position and available space. If the plugin can''t find the position (allowing all'
||' elements to be in-line), the plugin displays elements in one column one by one.'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057544394202859531)
,p_plugin_attribute_id=>wwv_flow_api.id(2057519865424390227)
,p_display_sequence=>10
,p_display_value=>'Up left'
,p_return_value=>'UL'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057544819787860126)
,p_plugin_attribute_id=>wwv_flow_api.id(2057519865424390227)
,p_display_sequence=>20
,p_display_value=>'Up center'
,p_return_value=>'UC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057545199908860999)
,p_plugin_attribute_id=>wwv_flow_api.id(2057519865424390227)
,p_display_sequence=>30
,p_display_value=>'Up right'
,p_return_value=>'UR'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057545645867861628)
,p_plugin_attribute_id=>wwv_flow_api.id(2057519865424390227)
,p_display_sequence=>40
,p_display_value=>'Down left'
,p_return_value=>'DL'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057546007105862321)
,p_plugin_attribute_id=>wwv_flow_api.id(2057519865424390227)
,p_display_sequence=>50
,p_display_value=>'Down center'
,p_return_value=>'DC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057546416309863692)
,p_plugin_attribute_id=>wwv_flow_api.id(2057519865424390227)
,p_display_sequence=>60
,p_display_value=>'Down right'
,p_return_value=>'DR'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057548294551896683)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>130
,p_prompt=>'Limit date range'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'7'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'dateLimit'
,p_help_text=>'If checked, maximum number of days in range is limited to given number. Narrowing range starts after picking first date.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057548788371917700)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>290
,p_prompt=>'Quick pick(s)'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_default_value=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'{',
' ''Custom'': true,',
' ''Today'': [moment(), moment()],',
' ''Yesterday'': [moment().subtract(1, ''days''), moment().subtract(1, ''days'')],',
' ''Last 7 Days'': [moment().subtract(6, ''days''), moment()],',
' ''Last 30 Days'': [moment().subtract(29, ''days''), moment()],',
' ''This Month'': [moment().startOf(''month''), moment().endOf(''month'')],',
' ''Last Month'': [moment().subtract(1, ''month'').startOf(''month''), moment().subtract(1, ''month'').endOf(''month'')]',
'}'))
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(2057513429798362367)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'ranges'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<h4>Default value</h4>',
'<pre>{ ',
'  ''Custom'': true,',
'  ''Today'': [',
'    moment(), ',
'    moment()',
'  ],',
'  ''Yesterday'': [',
'    moment().subtract(1, ''days''), ',
'    moment().subtract(1, ''days'')',
'  ],',
'  ''Last 7 Days'': [',
'    moment().subtract(6, ''days''), ',
'    moment()',
'  ],',
'  ''Last 30 Days'': [',
'    moment().subtract(29, ''days''), ',
'    moment()',
'  ],',
'  ''This Month'': [',
'    moment().startOf(''month''), ',
'    moment().endOf(''month'')',
'  ],',
'  ''Last Month'': [',
'    moment().subtract(1, ''month'').startOf(''month''), ',
'    moment().subtract(1, ''month'').endOf(''month'')',
'  ]',
'}</pre>',
'<h4>Tommorow</h4>',
'<pre>{  ',
'  ''Tommorow'': [',
'     moment().add(1, ''day'').startOf(''day''), ',
'     moment().add(1, ''day'').endOf(''day'')',
'  ]',
'}</pre>',
'',
'<h4>Next month</h4>',
'<pre>{  ',
'  ''Next Month'': [',
'     moment().add(1, ''month'').startOf(''month''), ',
'     moment().add(1, ''month'').endOf(''month'')',
'  ]',
'}</pre>',
'<p>',
'  Read <code>Moment.js</code> docs to learn more about manipulating dates - http://momentjs.com/docs/#/manipulating/ .',
'</p>'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'Quick pick(s) are defined as JSON object. ',
'JSON object keys represent available quick pick labels displayed to the user. ',
'Each key is defined as <code>Array</code> with two elements - <code>"start"</code> and <code>"end"</code> of a predefined range. ',
'<code>"Start"</code> and <code>"end"</code> date are instances of Moment.js JavaScript library. ',
'</p>',
'<p>',
'To learn more about Moment.js visit its home page - http://momentjs.com/ .',
'</p>',
'',
'<h4>About "Custom range"</h4>',
'<p>',
'"Custom range" allows user to pick his own range of dates when quick picks are displayed without calendar(s). Showing "Custom range" label is possible when JSON object key <code>"Custom"</code> has value set to <code>"true"</code>. ',
'</p>',
'',
'<h4>"Custom range" with custom text</h4>',
'<p>',
'To change "Custom range" label text it is needed to add new text message <code>PRETIUS_DATERANGEPICKER_CUSTOM_RANGE</code> to APEX translations ("Shared components > Globalization > Text Messages")',
'</p>'))
);
end;
/
begin
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1208178868492137464)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>127
,p_prompt=>'Appearance'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'This attribute allows you to configure the plugin appearance.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208191431378139855)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>10
,p_display_value=>'Quick pick(s) without calendar'
,p_return_value=>'alwaysShowCalendars'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'If checked, only quick pick(s) will be displayed after focusing the plugin item. <br/><br/>',
'',
'Exceptions:',
'<ul>',
'<li>Clicking on <b>Custom</b> quick pick results in showing calendars.</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208191848992140709)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>20
,p_display_value=>'Single calendar'
,p_return_value=>'onlyOneCalendar'
,p_help_text=>'If checked, only one month (calendar) is displayed.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208192266023141359)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>30
,p_display_value=>'Link calendars'
,p_return_value=>'linkedCalendars'
,p_help_text=>'If checked, months are rendered one after the other. Using navigation arrows results in presenting consecutive months.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208192658590142116)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>40
,p_display_value=>'Show days of other months'
,p_return_value=>'hideOtherMonthDays'
,p_help_text=>'If checked, starting/ending days of next/previous month are rendered in calendar(s).'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208193048790143001)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>50
,p_display_value=>'Show calendar inputs'
,p_return_value=>'hideCalendarDateInputs'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'If checked, inputs for date and timpepicker* are displayed.<br/><br/>',
'',
'*Timepicker is rendered when "HH12" or "HH24" is used in date format. "MI", "SS" and "PM/AM" formats are supported also'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208193406511143700)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>60
,p_display_value=>'Show month as dropdown'
,p_return_value=>'showDropdowns'
,p_help_text=>'If checked, month and year names are rendered as select lists. Selecting month or year results in jumping to the selected month / year.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208193809256144402)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>70
,p_display_value=>'Show week numbers'
,p_return_value=>'showWeekNumbers'
,p_help_text=>'If checked, week numbers are rendered as first column in calendar(s).'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1208194216025145328)
,p_plugin_attribute_id=>wwv_flow_api.id(1208178868492137464)
,p_display_sequence=>80
,p_display_value=>'ISO week numbers'
,p_return_value=>'showISOWeekNumbers'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'If checked, ISO week numbers rendered as first column in calendar(s).<br/><br/>',
'Requires <b>Show week numbers</b> to be unchecked.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057608657622409838)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>14
,p_prompt=>'Date to item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(1208022388030826418)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'PDP,PDPA'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'Pick or enter name of the APEX item that will store ending date of the selected range.',
'</p> ',
'<p>',
'Provided APEX item must be declared with <code>"Type"</code> set to <code>"Text field"</code>.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(2057627421880474914)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>103
,p_prompt=>'Show'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'onIconClick'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select when the date picker pop-up calendar displays.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057628488214476586)
,p_plugin_attribute_id=>wwv_flow_api.id(2057627421880474914)
,p_display_sequence=>10
,p_display_value=>'On focus'
,p_return_value=>'onFocus'
,p_is_quick_pick=>true
,p_help_text=>'The calendar pop-up displays as soon as the item receives focus.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057628968980477419)
,p_plugin_attribute_id=>wwv_flow_api.id(2057627421880474914)
,p_display_sequence=>20
,p_display_value=>'On icon click'
,p_return_value=>'onIconClick'
,p_is_quick_pick=>true
,p_help_text=>'The calendar pop-up displays when the icon is clicked.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(2057629987117478828)
,p_plugin_attribute_id=>wwv_flow_api.id(2057627421880474914)
,p_display_sequence=>30
,p_display_value=>'Both'
,p_return_value=>'both'
,p_is_quick_pick=>true
,p_help_text=>'The calendar pop-up displays as soon as the item receives focus and subsequently when the icon is clicked.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E6461746572616E67657069636B65722E64726F707570207B0D0A20206D617267696E2D746F703A202D3570783B200D0A7D0D0A20202E6461746572616E67657069636B65722E64726F7075703A6265666F7265207B0D0A20202020746F703A20696E69';
wwv_flow_api.g_varchar2_table(2) := '7469616C3B0D0A20202020626F74746F6D3A202D3770783B0D0A20202020626F726465722D626F74746F6D3A20696E697469616C3B0D0A20202020626F726465722D746F703A2037707820736F6C696420236363633B200D0A20207D0D0A20202E646174';
wwv_flow_api.g_varchar2_table(3) := '6572616E67657069636B65722E64726F7075703A6166746572207B0D0A20202020746F703A20696E697469616C3B0D0A20202020626F74746F6D3A202D3670783B0D0A20202020626F726465722D626F74746F6D3A20696E697469616C3B0D0A20202020';
wwv_flow_api.g_varchar2_table(4) := '626F726465722D746F703A2036707820736F6C696420236666663B200D0A20207D0D0A0D0A627574746F6E2E707265746975732D617065786461746572616E67657069636B65722E64697361626C6564207B0D0A20206F7061636974793A20302E353B0D';
wwv_flow_api.g_varchar2_table(5) := '0A7D0D0A2F2A0D0A0D0A2A2F0D0A0D0A2E6461746572616E67657069636B6572207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A2020636F6C6F723A20233339333933393B0D0A20206261636B67726F756E643A20236666663B0D0A20';
wwv_flow_api.g_varchar2_table(6) := '20626F726465722D7261646975733A203270783B0D0A2020646973706C61793A206E6F6E653B0D0A20202F2A77696474683A2032373870783B2A2F0D0A202070616464696E673A203870783B0D0A20206D617267696E2D746F703A203170783B0D0A2020';
wwv_flow_api.g_varchar2_table(7) := '746F703A202D313030253B0D0A20206C6566743A202D313030253B0D0A7D0D0A0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E646172202E63616C656E6461722E7269676874207B0D0A20202020646973706C61';
wwv_flow_api.g_varchar2_table(8) := '793A206E6F6E653B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E6461722E68617352616E676573202E72616E676573207B0D0A2020202070616464696E672D6C6566743A203870783B0D0A20';
wwv_flow_api.g_varchar2_table(9) := '207D0D0A0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E646172202E63616C656E6461722E6C656674207B0D0A202020206D617267696E2D72696768743A203070783B0D0A20207D0D0A0D0A20202E6461746572';
wwv_flow_api.g_varchar2_table(10) := '616E67657069636B65722E68696465526967687443616C656E646172202E6461746572616E67657069636B65725F696E707574207B0D0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0D0A20207D0D0A0D0A20202E6461746572616E';
wwv_flow_api.g_varchar2_table(11) := '67657069636B65722E68696465526967687443616C656E646172202E6461746572616E67657069636B65725F696E7075742E6461746546726F6D207B0D0A202020206D617267696E2D72696768743A203070783B0D0A20207D0D0A0D0A20202E64617465';
wwv_flow_api.g_varchar2_table(12) := '72616E67657069636B65722E68696465526967687443616C656E646172202E6461746572616E67657069636B65725F696E7075742E6461746546726F6D2C0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E646172';
wwv_flow_api.g_varchar2_table(13) := '202E6461746572616E67657069636B65725F696E7075742E64617465546F2C0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E6461722E68617353686F775765656B4E756D62657273202E6461746572616E676570';
wwv_flow_api.g_varchar2_table(14) := '69636B65725F696E7075742E6461746546726F6D2C0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E6461722E68617353686F775765656B4E756D62657273202E6461746572616E67657069636B65725F696E7075';
wwv_flow_api.g_varchar2_table(15) := '742E64617465546F7B0D0A2020202077696474683A2031303370783B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E646172202E6461746572616E67657069636B65725F696E7075742E646174';
wwv_flow_api.g_varchar2_table(16) := '6546726F6D207B0D0A202020206D617267696E2D6C6566743A20313670783B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E646172202E6461746572616E67657069636B65725F696E7075742E';
wwv_flow_api.g_varchar2_table(17) := '64617465546F2C0D0A20202E6461746572616E67657069636B65722E68696465526967687443616C656E6461722E68617353686F775765656B4E756D62657273202E6461746572616E67657069636B65725F696E7075742E64617465546F207B0D0A2020';
wwv_flow_api.g_varchar2_table(18) := '20206D617267696E2D6C6566743A203870783B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E6861734175746F4170706C79202E72616E67655F696E70757473207B0D0A20202020646973706C61793A206E6F6E653B0D0A20207D';
wwv_flow_api.g_varchar2_table(19) := '0D0A0D0A0D0A20202E6461746572616E67657069636B65722E6D6F6E746873446966666572734D6F72655468616E4F6E65202E63616C656E6461722E6C656674207B0D0A202020206D617267696E2D72696768743A203070783B0D0A2020202070616464';
wwv_flow_api.g_varchar2_table(20) := '696E672D72696768743A203770783B0D0A20202020626F726465722D72696768743A2032707820736F6C696420726762612833372C203132302C203230372C20302E33293B0D0A20202020626F726465722D72696768743A2032707820736F6C69642074';
wwv_flow_api.g_varchar2_table(21) := '72616E73706172656E742021696D706F7274616E743B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E6D6F6E746873446966666572734D6F72655468616E4F6E65202E63616C656E6461722E7269676874207B0D0A202020207061';
wwv_flow_api.g_varchar2_table(22) := '6464696E672D6C6566743A203170783B0D0A202020206D617267696E2D6C6566743A203070783B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E6869646543616C656E64617244617465496E70757473202E6461746572616E6765';
wwv_flow_api.g_varchar2_table(23) := '7069636B65725F696E707574207B0D0A20202020646973706C61793A206E6F6E653B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E68617353686F775765656B4E756D62657273202E6461746572616E67657069636B65725F696E';
wwv_flow_api.g_varchar2_table(24) := '707574207B0D0A202020206D617267696E2D6C6566743A20323870783B0D0A20207D0D0A0D0A20202E6461746572616E67657069636B65722E68617352616E676573202E72616E676573207B0D0A20202020666C6F61743A2072696768743B0D0A202020';
wwv_flow_api.g_varchar2_table(25) := '2070616464696E673A20303B0D0A202020206D617267696E3A20303B0D0A2020202070616464696E672D6C6566743A203870783B0D0A2020202070616464696E672D746F703A203870783B0D0A20202020636C6561723A206E6F6E653B0D0A20207D0D0A';
wwv_flow_api.g_varchar2_table(26) := '0D0A2E63616C656E646172207B0D0A2020646973706C61793A206E6F6E653B0D0A2020666C6F61743A206C6566743B0D0A7D0D0A20202E63616C656E6461722E7269676874207B0D0A202020206D617267696E2D6C6566743A203270783B0D0A20207D0D';
wwv_flow_api.g_varchar2_table(27) := '0A20202E63616C656E6461722E6C656674207B0D0A202020206D617267696E2D72696768743A203870783B0D0A20207D0D0A0D0A20202E63616C656E646172207461626C652E7461626C652D636F6E64656E736564207B0D0A2020202077696474683A20';
wwv_flow_api.g_varchar2_table(28) := '32343270783B0D0A20207D0D0A0D0A0D0A200D0A0D0A0D0A0D0A0D0A2F2A0D0A202A2052414E4745530D0A2A2F0D0A0D0A20202E6461746572616E67657069636B6572202E72616E676573207B0D0A20202020666F6E742D73697A653A20313170783B0D';
wwv_flow_api.g_varchar2_table(29) := '0A20202020666C6F61743A206E6F6E653B0D0A202020206D617267696E3A203470783B0D0A20202020746578742D616C69676E3A206C6566743B0D0A2020202070616464696E673A203470783B0D0A20202020636C6561723A20626F74683B0D0A202020';
wwv_flow_api.g_varchar2_table(30) := '20666C6F61743A206E6F6E653B0D0A20207D0D0A20202E6461746572616E67657069636B6572202E72616E67657320756C207B0D0A2020202020206C6973742D7374796C653A206E6F6E653B0D0A2020202020206D617267696E3A2030206175746F3B0D';
wwv_flow_api.g_varchar2_table(31) := '0A20202020202070616464696E673A20303B0D0A20202020202077696474683A20313030253B0D0A20207D0D0A202020202E6461746572616E67657069636B6572202E72616E676573206C69207B0D0A2020202020202020636F6C6F723A202333383338';
wwv_flow_api.g_varchar2_table(32) := '33383B0D0A20202020202020206261636B67726F756E642D636F6C6F723A20236638663866383B0D0A20202020202020206D617267696E2D626F74746F6D3A203870783B0D0A2020202020202020637572736F723A20706F696E7465723B0D0A20202020';
wwv_flow_api.g_varchar2_table(33) := '20202020666F6E742D73697A653A20313170783B0D0A20202020202020206C696E652D6865696768743A20323070783B0D0A202020202020202070616464696E672D6C6566743A203870783B0D0A202020202020202070616464696E672D72696768743A';
wwv_flow_api.g_varchar2_table(34) := '203870783B0D0A20202020202020206D617267696E2D626F74746F6D3A203870783B0D0A2020202020202020626F726465723A2031707820736F6C6964207267626128302C302C302C2E313235293B0D0A202020207D0D0A0D0A202020202E6461746572';
wwv_flow_api.g_varchar2_table(35) := '616E67657069636B6572202E72616E676573206C692E616374697665207B0D0A2020202020206261636B67726F756E643A20233235373863663B0D0A202020202020626F726465723A2031707820736F6C696420233038633B0D0A202020202020636F6C';
wwv_flow_api.g_varchar2_table(36) := '6F723A20236666663B0D0A202020207D0D0A0D0A202020202E6461746572616E67657069636B6572202E72616E676573206C693A686F766572207B0D0A2020202020206261636B67726F756E643A20233439393264653B0D0A202020202020636F6C6F72';
wwv_flow_api.g_varchar2_table(37) := '3A20236666663B0D0A202020207D0D0A0D0A2F2A0D0A20204E617479776E65204353530D0A2A2F0D0A0D0A2E6461746572616E67657069636B65722E73686F772D63616C656E646172202E63616C656E646172207B0D0A2020646973706C61793A20626C';
wwv_flow_api.g_varchar2_table(38) := '6F636B3B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722E64726F70646F776E2D6D656E75207B0D0A2020626F782D736861646F773A20302032707820367078207267626128302C302C302C2E3035293B0D0A2020626F726465723A20317078';
wwv_flow_api.g_varchar2_table(39) := '20736F6C696420236562656265623B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722E64726F70646F776E2D6D656E753A686F766572207B0D0A2020626F782D736861646F773A20302032707820367078207267626128302C302C302C2E3129';
wwv_flow_api.g_varchar2_table(40) := '3B0D0A2020626F726465723A2031707820736F6C696420236434643464340D0A7D0D0A0D0A0D0A2E6461746572616E67657069636B65723A6265666F72652C0D0A2E6461746572616E67657069636B65723A6166746572207B0D0A20202020706F736974';
wwv_flow_api.g_varchar2_table(41) := '696F6E3A206162736F6C7574653B0D0A20202020646973706C61793A20696E6C696E652D626C6F636B3B0D0A20202020626F726465722D626F74746F6D2D636F6C6F723A207267626128302C20302C20302C20302E32293B0D0A20202020636F6E74656E';
wwv_flow_api.g_varchar2_table(42) := '743A2027273B0D0A7D0D0A2E6461746572616E67657069636B65723A6265666F7265207B0D0A20202020746F703A202D3770783B0D0A20202020626F726465722D72696768743A2037707820736F6C6964207472616E73706172656E743B0D0A20202020';
wwv_flow_api.g_varchar2_table(43) := '626F726465722D6C6566743A2037707820736F6C6964207472616E73706172656E743B0D0A20202020626F726465722D626F74746F6D3A2037707820736F6C696420236363633B0D0A7D0D0A2E6461746572616E67657069636B65723A6166746572207B';
wwv_flow_api.g_varchar2_table(44) := '0D0A20202020746F703A202D3670783B0D0A20202020626F726465722D72696768743A2036707820736F6C6964207472616E73706172656E743B0D0A20202020626F726465722D626F74746F6D3A2036707820736F6C696420236666663B0D0A20202020';
wwv_flow_api.g_varchar2_table(45) := '626F726465722D6C6566743A2036707820736F6C6964207472616E73706172656E743B0D0A7D0D0A2E6461746572616E67657069636B65722E6F70656E736C6566743A6265666F7265207B0D0A2020202072696768743A203970783B0D0A7D0D0A2E6461';
wwv_flow_api.g_varchar2_table(46) := '746572616E67657069636B65722E6F70656E736C6566743A6166746572207B0D0A2020202072696768743A20313070783B0D0A7D0D0A2E6461746572616E67657069636B65722E6F70656E7363656E7465723A6265666F7265207B0D0A202020206C6566';
wwv_flow_api.g_varchar2_table(47) := '743A20303B0D0A2020202072696768743A20303B0D0A2020202077696474683A20303B0D0A202020206D617267696E2D6C6566743A206175746F3B0D0A202020206D617267696E2D72696768743A206175746F3B0D0A7D0D0A2E6461746572616E676570';
wwv_flow_api.g_varchar2_table(48) := '69636B65722E6F70656E7363656E7465723A6166746572207B0D0A202020206C6566743A20303B0D0A2020202072696768743A20303B0D0A2020202077696474683A20303B0D0A202020206D617267696E2D6C6566743A206175746F3B0D0A202020206D';
wwv_flow_api.g_varchar2_table(49) := '617267696E2D72696768743A206175746F3B0D0A7D0D0A2E6461746572616E67657069636B65722E6F70656E7372696768743A6265666F7265207B0D0A202020206C6566743A203970783B0D0A7D0D0A2E6461746572616E67657069636B65722E6F7065';
wwv_flow_api.g_varchar2_table(50) := '6E7372696768743A6166746572207B0D0A202020206C6566743A20313070783B0D0A7D0D0A0D0A2E64726F70646F776E2D6D656E752E70756C6C2D7269676874207B0D0A202072696768743A20303B0D0A20206C6566743A206175746F0D0A7D0D0A2E64';
wwv_flow_api.g_varchar2_table(51) := '726F70646F776E2D6D656E75202E64697669646572207B0D0A20206865696768743A203170783B0D0A20206D617267696E3A2039707820303B0D0A20206F766572666C6F773A2068696464656E3B0D0A20206261636B67726F756E642D636F6C6F723A20';
wwv_flow_api.g_varchar2_table(52) := '236535653565350D0A7D0D0A2E64726F70646F776E2D6D656E753E6C693E61207B0D0A2020646973706C61793A20626C6F636B3B0D0A202070616464696E673A2033707820323070783B0D0A2020636C6561723A20626F74683B0D0A2020666F6E742D77';
wwv_flow_api.g_varchar2_table(53) := '65696768743A203430303B0D0A20206C696E652D6865696768743A20312E34323835373134333B0D0A2020636F6C6F723A20233333333B0D0A202077686974652D73706163653A206E6F777261700D0A7D0D0A2E64726F70646F776E2D6D656E75203E20';
wwv_flow_api.g_varchar2_table(54) := '6C69203E20613A666F6375732C0D0A2E64726F70646F776E2D6D656E75203E206C69203E20613A686F766572207B0D0A2020636F6C6F723A20233236323632363B0D0A2020746578742D6465636F726174696F6E3A206E6F6E653B0D0A20206261636B67';
wwv_flow_api.g_varchar2_table(55) := '726F756E642D636F6C6F723A20236635663566350D0A7D0D0A2E64726F70646F776E2D6D656E753E2E6163746976653E612C0D0A2E64726F70646F776E2D6D656E753E2E6163746976653E613A666F6375732C0D0A2E64726F70646F776E2D6D656E753E';
wwv_flow_api.g_varchar2_table(56) := '2E6163746976653E613A686F766572207B0D0A2020636F6C6F723A20236666663B0D0A2020746578742D6465636F726174696F6E3A206E6F6E653B0D0A20206261636B67726F756E642D636F6C6F723A20233333376162373B0D0A20206F75746C696E65';
wwv_flow_api.g_varchar2_table(57) := '3A20300D0A7D0D0A2E64726F70646F776E2D6D656E753E2E64697361626C65643E612C0D0A2E64726F70646F776E2D6D656E753E2E64697361626C65643E613A666F6375732C0D0A2E64726F70646F776E2D6D656E753E2E64697361626C65643E613A68';
wwv_flow_api.g_varchar2_table(58) := '6F766572207B0D0A2020636F6C6F723A20233737370D0A7D0D0A2E64726F70646F776E2D6D656E753E2E64697361626C65643E613A666F6375732C0D0A2E64726F70646F776E2D6D656E753E2E64697361626C65643E613A686F766572207B0D0A202074';
wwv_flow_api.g_varchar2_table(59) := '6578742D6465636F726174696F6E3A206E6F6E653B0D0A2020637572736F723A206E6F742D616C6C6F7765643B0D0A20206261636B67726F756E642D636F6C6F723A207472616E73706172656E743B0D0A20206261636B67726F756E642D696D6167653A';
wwv_flow_api.g_varchar2_table(60) := '206E6F6E653B0D0A202066696C7465723A2070726F6769643A204458496D6167655472616E73666F726D2E4D6963726F736F66742E6772616469656E7428656E61626C65643D66616C7365290D0A7D0D0A0D0A0D0A0D0A2F2A2A2F0D0A0D0A2F2A2A2F0D';
wwv_flow_api.g_varchar2_table(61) := '0A2E6461746572616E67657069636B6572202E696E7075742D6D696E69207B0D0A2020666F6E742D73697A653A20313270783B0D0A20206C696E652D6865696768743A20323370783B20200D0A2020626F726465723A2031707820736F6C696420236363';
wwv_flow_api.g_varchar2_table(62) := '633B0D0A2020626F726465722D7261646975733A203470783B0D0A2020636F6C6F723A20233535353B0D0A2020646973706C61793A20626C6F636B3B0D0A2020766572746963616C2D616C69676E3A206D6964646C653B0D0A20206D617267696E3A2030';
wwv_flow_api.g_varchar2_table(63) := '3B0D0A202070616464696E673A203020367078203020323870783B0D0A202077696474683A20313030253B0D0A7D0D0A2E6461746572616E67657069636B6572202E696E7075742D6D696E692E616374697665207B0D0A20202020626F726465723A2031';
wwv_flow_api.g_varchar2_table(64) := '707820736F6C6964207267626128302C203133362C203230342C20302E3531293B0D0A20202020626F726465722D7261646975733A203470783B0D0A7D0D0A0D0A2E6461746572616E67657069636B6572202E6461746572616E67657069636B65725F69';
wwv_flow_api.g_varchar2_table(65) := '6E707574207B0D0A202020206D617267696E3A203070783B0D0A2020202070616464696E673A203070783B0D0A20202020706F736974696F6E3A2072656C61746976653B0D0A202020206D617267696E2D746F703A203870783B0D0A7D0D0A2E64617465';
wwv_flow_api.g_varchar2_table(66) := '72616E67657069636B6572202E6461746572616E67657069636B65725F696E7075742069207B0D0A20202020706F736974696F6E3A206162736F6C7574653B0D0A202020206C6566743A203870783B0D0A20202020746F703A203670783B0D0A7D0D0A0D';
wwv_flow_api.g_varchar2_table(67) := '0A2E6461746572616E67657069636B65722074723A6E74682D6368696C64283229207468207B0D0A2020666F6E742D73697A653A20313170783B0D0A2020666F6E742D7765696768743A203430303B0D0A2020636F6C6F723A20677261793B0D0A202062';
wwv_flow_api.g_varchar2_table(68) := '6F726465722D626F74746F6D3A2031707820736F6C6964207267626128302C302C302C2E31293B0D0A202070616464696E673A203470782038707820387078203870783B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074642E7765656B2C';
wwv_flow_api.g_varchar2_table(69) := '0D0A2E6461746572616E67657069636B65722074682E7765656B7B0D0A2020666F6E742D73697A653A203830253B0D0A2020666F6E742D7765696768743A203430303B0D0A2020636F6C6F723A207267626128302C302C302C20302E35293B0D0A202062';
wwv_flow_api.g_varchar2_table(70) := '6F726465722D72696768743A2031707820736F6C6964207267626128302C302C302C2E3035293B0D0A20200D0A7D0D0A0D0A0D0A2E6461746572616E67657069636B6572207461626C65207B0D0A2020626F726465722D73706163696E673A2030707820';
wwv_flow_api.g_varchar2_table(71) := '200D0A7D0D0A0D0A2E6461746572616E67657069636B65722074682E707265762C0D0A2E6461746572616E67657069636B65722074682E6E6578742C0D0A2E6461746572616E67657069636B65722074682E6D6F6E7468207B0D0A202070616464696E67';
wwv_flow_api.g_varchar2_table(72) := '3A20387078203070783B0D0A20200D0A7D0D0A0D0A2E6461746572616E67657069636B65722074682E70726576207B0D0A2020746578742D616C69676E3A6C6566743B0D0A202070616464696E672D6C6566743A20313670783B0D0A7D0D0A0D0A2E6461';
wwv_flow_api.g_varchar2_table(73) := '746572616E67657069636B65722074682E6E657874207B0D0A2020746578742D616C69676E3A72696768743B0D0A202070616464696E672D72696768743A203870783B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074682E6D6F6E746820';
wwv_flow_api.g_varchar2_table(74) := '7B0D0A2020636F6C6F723A7267622836312C2036312C203631293B0D0A2020666F6E742D66616D696C793A2248656C766574696361204E657565222C2048656C7665746963612C20417269616C2C2073616E732D73657269663B0D0A2020666F6E742D73';
wwv_flow_api.g_varchar2_table(75) := '697A653A313670783B0D0A2020666F6E742D7765696768743A3230303B0D0A2020746578742D616C69676E3A63656E7465723B0D0A2020746578742D73697A652D61646A7573743A313030253B0D0A20207669736962696C6974793A76697369626C653B';
wwv_flow_api.g_varchar2_table(76) := '0D0A20202D7765626B69742D626F726465722D686F72697A6F6E74616C2D73706163696E673A3070783B0D0A20202D7765626B69742D626F726465722D766572746963616C2D73706163696E673A3070783B0D0A7D0D0A0D0A2E6461746572616E676570';
wwv_flow_api.g_varchar2_table(77) := '69636B65722074682E6D6F6E74682073656C6563742E6D6F6E746873656C656374207B0D0A20206D617267696E2D72696768743A3470783B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074682E6D6F6E74682073656C6563742E6D6F6E74';
wwv_flow_api.g_varchar2_table(78) := '6873656C6563742C200D0A2E6461746572616E67657069636B65722074682E6D6F6E74682073656C6563742E7965617273656C656374207B0D0A2020626F726465723A2031707820736F6C6964207267626128302C302C302C302E31293B0D0A7D0D0A0D';
wwv_flow_api.g_varchar2_table(79) := '0A0D0A2E6461746572616E67657069636B65722074642C0D0A2E6461746572616E67657069636B6572207468207B0D0A2020666F6E742D73697A653A20313170783B0D0A20206C696E652D6865696768743A20323070783B0D0A202070616464696E673A';
wwv_flow_api.g_varchar2_table(80) := '203870783B0D0A2020746578742D616C69676E3A2072696768743B0D0A202077686974652D73706163653A206E6F777261703B0D0A2020637572736F723A20706F696E7465723B0D0A2020626F726465723A206E6F6E653B0D0A7D0D0A0D0A2E64617465';
wwv_flow_api.g_varchar2_table(81) := '72616E67657069636B65722074642E64697361626C6564207B0D0A2020746578742D6465636F726174696F6E3A206C696E652D7468726F7567683B0D0A2020637572736F723A206E6F742D616C6C6F7765643B0D0A7D0D0A0D0A0D0A0D0A2E6461746572';
wwv_flow_api.g_varchar2_table(82) := '616E67657069636B65722074642E6F66663A686F7665722C0D0A2E6461746572616E67657069636B65722074642E617661696C61626C653A686F766572207B0D0A2020666F6E742D7765696768743A206E6F726D616C3B0D0A2020666F6E742D73697A65';
wwv_flow_api.g_varchar2_table(83) := '3A20313170783B0D0A20206261636B67726F756E643A20236632663266323B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074642E696E2D72616E6765207B0D0A20206261636B67726F756E643A20726762612833372C203132302C203230';
wwv_flow_api.g_varchar2_table(84) := '372C20302E32293B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074642E696E2D72616E67653A686F766572207B0D0A20206261636B67726F756E643A20726762612833372C203132302C203230372C20302E3333293B200D0A7D0D0A0D0A';
wwv_flow_api.g_varchar2_table(85) := '2E6461746572616E67657069636B65722074642E6F66663A686F766572207B0D0A2020636F6C6F723A20233339333933393B0D0A7D0D0A0D0A0D0A2F2A20706F637A6174656B2069206B6F6E696563207A616B72657375202A2F0D0A2E6461746572616E';
wwv_flow_api.g_varchar2_table(86) := '67657069636B65722074642E6163746976652E73746172742D646174652C0D0A2E6461746572616E67657069636B65722074642E6163746976652E656E642D646174652C0D0A2E6461746572616E67657069636B65722074642E6163746976652E737461';
wwv_flow_api.g_varchar2_table(87) := '72742D646174653A686F7665722C0D0A2E6461746572616E67657069636B65722074642E6163746976652E656E642D646174653A686F766572207B0D0A2020636F6C6F723A20236666663B0D0A20206261636B67726F756E642D636F6C6F723A20202332';
wwv_flow_api.g_varchar2_table(88) := '35373863663B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074642E6163746976652E73746172742D64617465207B0D0A2020626F726465722D7261646975733A203470782030707820307078203070783B0D0A7D0D0A0D0A2E6461746572';
wwv_flow_api.g_varchar2_table(89) := '616E67657069636B65722074642E6163746976652E656E642D64617465207B0D0A2020626F726465722D7261646975733A203070782030707820347078203070783B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074642E6163746976652E';
wwv_flow_api.g_varchar2_table(90) := '73746172742D646174652E656E642D64617465207B0D0A2020626F726465722D7261646975733A203470783B0D0A7D0D0A0D0A0D0A0D0A2E6461746572616E67657069636B65722074642E6F746865724D6F6E74682E696E2D72616E6765207B0D0A2020';
wwv_flow_api.g_varchar2_table(91) := '6261636B67726F756E643A207472616E73706172656E743B0D0A7D0D0A0D0A2E6461746572616E67657069636B65722074642E6F66662C200D0A2E6461746572616E67657069636B65722074642E6F66662E696E2D72616E67652C200D0A2E6461746572';
wwv_flow_api.g_varchar2_table(92) := '616E67657069636B65722074642E6F66662E73746172742D646174652C200D0A2E6461746572616E67657069636B65722074642E6F66662E656E642D64617465207B0D0A2020636F6C6F723A207267626128302C302C302C20302E33293B0D0A20206261';
wwv_flow_api.g_varchar2_table(93) := '636B67726F756E642D636F6C6F723A207267626128302C302C302C302E3032293B0D0A7D0D0A0D0A0D0A0D0A2E6461746572616E67657069636B6572202E63616C656E6461722D74696D65207B0D0A2020746578742D616C69676E3A206C6566743B0D0A';
wwv_flow_api.g_varchar2_table(94) := '20206D617267696E3A20357078206175746F3B0D0A20206C696E652D6865696768743A20333070783B0D0A2020706F736974696F6E3A2072656C61746976653B0D0A202070616464696E672D6C6566743A20323870783B0D0A7D0D0A0D0A2E6461746572';
wwv_flow_api.g_varchar2_table(95) := '616E67657069636B6572202E63616C656E6461722D74696D652069207B0D0A2020746F703A203970783B0D0A7D0D0A0D0A2F2A2064726F70646F776E2A2F0D0A0D0A2E6461746572616E67657069636B65722E666F7263654F6E65436F6C756D6E202E63';
wwv_flow_api.g_varchar2_table(96) := '616C656E6461722C0D0A2E6461746572616E67657069636B65722E666F7263654F6E65436F6C756D6E202E72616E676573207B0D0A2020666C6F61743A206E6F6E652021696D706F7274616E743B0D0A20206D617267696E3A20302021696D706F727461';
wwv_flow_api.g_varchar2_table(97) := '6E743B0D0A20206D617267696E2D626F74746F6D3A203870782021696D706F7274616E743B0D0A7D0D0A0D0A2F2A0D0A406D6564696120286D61782D77696474683A20373330707829207B0D0A20202E6461746572616E67657069636B6572202E63616C';
wwv_flow_api.g_varchar2_table(98) := '656E6461722C0D0A20202E6461746572616E67657069636B6572202E72616E676573207B0D0A20202020666C6F61743A206E6F6E652021696D706F7274616E743B0D0A202020206D617267696E3A20302021696D706F7274616E743B0D0A202020206D61';
wwv_flow_api.g_varchar2_table(99) := '7267696E2D626F74746F6D3A203870782021696D706F7274616E743B0D0A20207D0D0A7D0D0A2A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(173323216446288185)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_file_name=>'pretiusapexdaterangepicker.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '242E7769646765742827707265746975732E617065786461746572616E67657069636B6572272C207B0D0A20206F7074696F6E733A207B0D0A20202020707265746975733A207B0D0A2020202020202F2F0D0A202020207D2C0D0A202020206461746572';
wwv_flow_api.g_varchar2_table(2) := '616E67657069636B65723A207B0D0A2020202020202F2F0D0A202020207D0D0A20207D2C0D0A20205F6372656174653A2066756E6374696F6E28297B0D0A0D0A202020202F2F726571756972656420666F7220666978696E6720706F736974696F6E0D0A';
wwv_flow_api.g_varchar2_table(3) := '20202020746869732E6F7267696E616C203D207B0D0A2020202020206F70656E733A20746869732E6F7074696F6E732E6461746572616E67657069636B65722E6F70656E732C0D0A20202020202064726F70733A20746869732E6F7074696F6E732E6461';
wwv_flow_api.g_varchar2_table(4) := '746572616E67657069636B65722E64726F70730D0A202020207D3B0D0A0D0A20202020746869732E61706578203D207B0D0A2020202020206974656D3A20746869732E656C656D656E742C0D0A202020202020646174657069636B6572427574746F6E3A';
wwv_flow_api.g_varchar2_table(5) := '20746869732E656C656D656E742E6E657874416C6C282027627574746F6E2720292E666972737428290D0A202020207D3B0D0A0D0A20202020746869732E64617465546F203D207B0D0A2020202020206974656D3A202428746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(6) := '2E707265746975732E64617465546F4974656D292C0D0A202020202020646174657069636B6572427574746F6E3A206E756C6C0D0A202020207D3B0D0A0D0A202020202F2F73686F756C6420646973706C617920637573746F6D2072616E6765206C6162';
wwv_flow_api.g_varchar2_table(7) := '656C3F0D0A202020206966202820746869732E5F686173437573746F6D52616E67654C6162656C28292029207B0D0A202020202020746869732E6F7074696F6E732E6461746572616E67657069636B65722E73686F77437573746F6D52616E67654C6162';
wwv_flow_api.g_varchar2_table(8) := '656C203D20746869732E5F686173437573746F6D52616E67654C6162656C28293B0D0A20202020202064656C65746520746869732E6F7074696F6E732E6461746572616E67657069636B65722E72616E6765732E437573746F6D3B0D0A202020207D0D0A';
wwv_flow_api.g_varchar2_table(9) := '0D0A202020202F2F636865636B2072616E6765730D0A202020206966202820746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E6461722029207B0D0A202020202020746869732E6F7074696F6E732E6461746572616E67';
wwv_flow_api.g_varchar2_table(10) := '657069636B65722E6C696E6B656443616C656E64617273203D2066616C73653B0D0A202020207D0D0A20202020200D0A0D0A202020202F2F6372656174652064617465546F20627574746F6E20617320636C6F6E65206F66206170657820646174657069';
wwv_flow_api.g_varchar2_table(11) := '636B657220627574746F6D0D0A20202020746869732E64617465546F2E646174657069636B6572427574746F6E203D20746869732E617065782E646174657069636B6572427574746F6E2E636C6F6E6528293B0D0A202020202F2F696E73657274206461';
wwv_flow_api.g_varchar2_table(12) := '7465546F20627574746F6E2061667465722064617465546F206974656D0D0A20202020746869732E64617465546F2E646174657069636B6572427574746F6E2E696E7365727441667465722820746869732E64617465546F2E6974656D20293B0D0A0D0A';
wwv_flow_api.g_varchar2_table(13) := '202020206966202820746869732E6F7074696F6E732E707265746975732E6F7665726C617920262620746869732E64617465546F2E6974656D2E73697A652829203D3D20302029207B0D0A2020202020207468726F7720224E6965207A6E616C617A6C20';
wwv_flow_api.g_varchar2_table(14) := '77796D6167616E65676F206974656D61206461746120646F223B0D0A202020207D0D0A0D0A202020202F2F6D696E2026206D617820646174650D0A20202020746869732E6F7074696F6E732E6461746572616E67657069636B65722E6D696E4461746520';
wwv_flow_api.g_varchar2_table(15) := '3D20746869732E6F7074696F6E732E6461746572616E67657069636B65722E6D696E4461746520213D20756E646566696E6564203F20746869732E6765744D696E4D61784461746546726F6D537472696E672820746869732E6F7074696F6E732E646174';
wwv_flow_api.g_varchar2_table(16) := '6572616E67657069636B65722E6D696E446174652029203A20756E646566696E65643B0D0A20202020746869732E6F7074696F6E732E6461746572616E67657069636B65722E6D617844617465203D20746869732E6F7074696F6E732E6461746572616E';
wwv_flow_api.g_varchar2_table(17) := '67657069636B65722E6D61784461746520213D20756E646566696E6564203F20746869732E6765744D696E4D61784461746546726F6D537472696E672820746869732E6F7074696F6E732E6461746572616E67657069636B65722E6D6178446174652029';
wwv_flow_api.g_varchar2_table(18) := '203A20756E646566696E65643B0D0A0D0A0D0A202020202F2F646174652072616E6765207069636B657220696E69740D0A20202020746869732E617065782E6974656D2E6461746572616E67657069636B65722820746869732E6F7074696F6E732E6461';
wwv_flow_api.g_varchar2_table(19) := '746572616E67657069636B65722C2066756E6374696F6E2873746172742C20656E642C206C6162656C297B0D0A2020202020202F2F636F6E736F6C652E6C6F6728272D2D2D43616C6C6261636B2066756E6374696F6E2D2D2D27293B0D0A202020207D29';
wwv_flow_api.g_varchar2_table(20) := '3B0D0A0D0A20202020746869732E7069636B6572203D20746869732E617065782E6974656D2E6461746128276461746572616E67657069636B657227293B0D0A0D0A20202020746869732E617065782E6974656D0D0A2020202020202E6F6E2820277368';
wwv_flow_api.g_varchar2_table(21) := '6F772E6461746572616E67657069636B6572272020202020202020202C20242E70726F78792820746869732E5F636F6D6D6F6E53686F77202020202020202020202020202C2074686973202C20276461746546726F6D27202920290D0A2020202020202E';
wwv_flow_api.g_varchar2_table(22) := '6F6E28202773686F7743616C656E6461722E6461746572616E67657069636B657227202C20242E70726F78792820746869732E5F636F6D6D6F6E53686F77202020202020202020202020202C2074686973202C20276461746546726F6D27202920290D0A';
wwv_flow_api.g_varchar2_table(23) := '2020202020200D0A2020202020202E6F6E282027686964652E6461746572616E67657069636B657227202C20242E70726F78792820746869732E5F636F6D6D6F6E48696465202020202020202020202020202C2074686973202C20276461746546726F6D';
wwv_flow_api.g_varchar2_table(24) := '27202920290D0A2020202020202E6F6E28202763616C656E646172557064617465642E6170657827202C20242E70726F78792820746869732E5F636F6D6D6F6E5F63616C65726E646172557064617465202C2074686973202C20276461746546726F6D27';
wwv_flow_api.g_varchar2_table(25) := '202920293B0D0A0D0A202020206966202820746869732E6F7074696F6E732E6461746572616E67657069636B65722E73686F774D6574686F64203D3D20276F6E49636F6E436C69636B272029207B0D0A2020202020200D0A202020202020746869732E61';
wwv_flow_api.g_varchar2_table(26) := '7065782E6974656D0D0A20202020202020202E6F6666282027636C69636B2E6461746572616E67657069636B65722720290D0A20202020202020202E6F6666282027666F6375732E6461746572616E67657069636B65722720293B0D0A0D0A2020202020';
wwv_flow_api.g_varchar2_table(27) := '20746869732E617065782E646174657069636B6572427574746F6E2E6F6E282027636C69636B27202C20242E70726F787928746869732E5F6E617469766553686F775069636B65724F6E427574746F6E436C69636B2C20746869732920293B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(28) := '20202020206966202820746869732E6F7074696F6E732E707265746975732E6F7665726C61792029207B0D0A2020202020202020746869732E64617465546F2E646174657069636B6572427574746F6E2E6F6E282027636C69636B27202C20242E70726F';
wwv_flow_api.g_varchar2_table(29) := '787928746869732E5F6F7665726C61795F73686F775069636B65724F6E427574746F6E436C69636B2C20746869732920293B0D0A2020202020207D0D0A0D0A202020207D0D0A20202020656C7365206966202820746869732E6F7074696F6E732E646174';
wwv_flow_api.g_varchar2_table(30) := '6572616E67657069636B65722E73686F774D6574686F64203D3D20276F6E466F637573272029207B0D0A0D0A2020202020206966202820746869732E6F7074696F6E732E707265746975732E6F7665726C61792029207B0D0A2020202020202020746869';
wwv_flow_api.g_varchar2_table(31) := '732E64617465546F2E6974656D2E6F6E282027666F63757327202C20242E70726F78792820746869732E5F6F7665726C61795F666F6375734F6E44617465546F2C207468697329293B0D0A2020202020207D0D0A0D0A202020207D0D0A20202020656C73';
wwv_flow_api.g_varchar2_table(32) := '65206966202820746869732E6F7074696F6E732E6461746572616E67657069636B65722E73686F774D6574686F64203D3D2027626F7468272029207B0D0A202020202020746869732E617065782E646174657069636B6572427574746F6E2E6F6E282027';
wwv_flow_api.g_varchar2_table(33) := '636C69636B27202C20242E70726F78792820746869732E5F6E617469766553686F775069636B65724F6E427574746F6E436C69636B2C2074686973202920293B0D0A0D0A2020202020206966202820746869732E6F7074696F6E732E707265746975732E';
wwv_flow_api.g_varchar2_table(34) := '6F7665726C61792029207B0D0A2020202020202020746869732E64617465546F2E646174657069636B6572427574746F6E2E6F6E282027636C69636B27202C20242E70726F78792820746869732E5F6F7665726C61795F73686F775069636B65724F6E42';
wwv_flow_api.g_varchar2_table(35) := '7574746F6E436C69636B202C2074686973202920293B0D0A2020202020202020746869732E64617465546F2E6974656D2020202020202020202020202E6F6E282027666F63757327202C20242E70726F78792820746869732E5F6F7665726C61795F666F';
wwv_flow_api.g_varchar2_table(36) := '6375734F6E44617465546F20202020202020202020202C2074686973202920293B0D0A2020202020207D0D0A0D0A202020207D0D0A20202020656C7365207B0D0A2020202020207468726F772022556E6B6E6F776E20746869732E6F7074696F6E732E64';
wwv_flow_api.g_varchar2_table(37) := '61746572616E67657069636B65722E73686F774D6574686F64203D2027222B746869732E6F7074696F6E732E6461746572616E67657069636B65722E73686F774D6574686F642B2227223B0D0A202020207D0D0A0D0A202020206966202820746869732E';
wwv_flow_api.g_varchar2_table(38) := '6F7074696F6E732E707265746975732E6F7665726C61792029207B0D0A0D0A202020202020746869732E617065782E6974656D0D0A20202020202020202E6F6E28276170706C792E6461746572616E67657069636B6572272020202C20242E70726F7879';
wwv_flow_api.g_varchar2_table(39) := '2820746869732E5F6F7665726C61794170706C792C202074686973202920290D0A20202020202020202E6F6E282763616E63656C2E6461746572616E67657069636B65722720202C20242E70726F78792820746869732E5F6F7665726C617943616E6365';
wwv_flow_api.g_varchar2_table(40) := '6C2C2074686973202920290D0A20202020202020202E6F6E2827666F6375732720202C20242E70726F78792820746869732E5F6F7665726C6179466F6375732C2074686973202920290D0A2020202020200D0A202020202020746869732E64617465546F';
wwv_flow_api.g_varchar2_table(41) := '2E6974656D0D0A20202020202020202E6F6E282773686F772E6461746572616E67657069636B657220272020202020202020202C20242E70726F78792820746869732E5F636F6D6D6F6E53686F77202020202020202020202020202C2074686973202C20';
wwv_flow_api.g_varchar2_table(42) := '2764617465546F27202920290D0A20202020202020202E6F6E282773686F7743616C656E6461722E6461746572616E67657069636B65722720202C20242E70726F78792820746869732E5F636F6D6D6F6E53686F77202020202020202020202020202C20';
wwv_flow_api.g_varchar2_table(43) := '74686973202C202764617465546F27202920290D0A20202020202020202E6F6E2827686964652E6461746572616E67657069636B657227202020202020202020202C20242E70726F78792820746869732E5F6F7665726C61795F64617465546F48696465';
wwv_flow_api.g_varchar2_table(44) := '20202020202C20746869732020202020202020202020202920290D0A20202020202020202E6F6E2827686964652E6461746572616E67657069636B657227202020202020202020202C20242E70726F78792820746869732E5F636F6D6D6F6E4869646520';
wwv_flow_api.g_varchar2_table(45) := '2020202020202020202020202C2074686973202C202764617465546F27202920290D0A20202020202020202E6F6E282763616C656E646172557064617465642E6170657827202020202020202020202C20242E70726F78792820746869732E5F636F6D6D';
wwv_flow_api.g_varchar2_table(46) := '6F6E5F63616C65726E646172557064617465202C2074686973202C202764617465546F27202920293B0D0A0D0A202020202020746869732E64617465546F2E6974656D2E646174612827706172656E744974656D272C20746869732E617065782E697465';
wwv_flow_api.g_varchar2_table(47) := '6D293B0D0A202020202020746869732E5F617065785F64612820746869732E64617465546F2E6974656D20293B0D0A0D0A202020207D0D0A20202020656C7365207B0D0A202020202020746869732E617065782E6974656D0D0A20202020202020202E6F';
wwv_flow_api.g_varchar2_table(48) := '6E28276170706C792E6461746572616E67657069636B657227202C20242E70726F78792820746869732E5F6E61746976654170706C7920202C2074686973202920290D0A20202020202020202E6F6E282763616E63656C2E6461746572616E6765706963';
wwv_flow_api.g_varchar2_table(49) := '6B6572272C20242E70726F78792820746869732E5F6E617469766543616E63656C202C2074686973202920290D0A20202020202020202E6F6E2827666F6375732E6461746572616E67657069636B657227202C20242E70726F78792820746869732E5F6E';
wwv_flow_api.g_varchar2_table(50) := '6174697665466F63757320202C2074686973202920290D0A202020207D0D0A0D0A20202020746869732E5F617065785F64612820746869732E617065782E6974656D20293B0D0A0D0A20207D2C0D0A20205F64657374726F793A2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(51) := '297B0D0A0D0A20207D2C0D0A20205F6F7665726C6179466F6375733A2066756E6374696F6E28297B0D0A20202020766172207374617274446174652C20656E64446174653B0D0A0D0A202020206966202820746869732E617065782E6974656D2E76616C';
wwv_flow_api.g_varchar2_table(52) := '28292E7472696D28292E6C656E677468203D3D203020262620746869732E64617465546F2E6974656D2E76616C28292E7472696D28292E6C656E677468203D3D20302029207B0D0A202020202020737461727444617465203D206D6F6D656E7428292E73';
wwv_flow_api.g_varchar2_table(53) := '746172744F66282764617927293B0D0A202020202020656E64446174652020203D206D6F6D656E7428292E656E644F66282764617927293B0D0A202020207D0D0A20202020656C7365206966202820746869732E617065782E6974656D2E76616C28292E';
wwv_flow_api.g_varchar2_table(54) := '7472696D28292E6C656E677468203E203020262620746869732E64617465546F2E6974656D2E76616C28292E7472696D28292E6C656E677468203D3D20302029207B0D0A202020202020737461727444617465203D206D6F6D656E742820746869732E61';
wwv_flow_api.g_varchar2_table(55) := '7065782E6974656D2E76616C28292C202020746869732E6F7074696F6E732E6461746572616E67657069636B65722E6C6F63616C652E666F726D617420293B0D0A202020202020656E64446174652020203D207374617274446174652E656E644F662827';
wwv_flow_api.g_varchar2_table(56) := '64617927293B0D0A202020207D0D0A20202020656C7365206966202820746869732E617065782E6974656D2E76616C28292E7472696D28292E6C656E677468203D3D203020262620746869732E64617465546F2E6974656D2E76616C28292E7472696D28';
wwv_flow_api.g_varchar2_table(57) := '292E6C656E677468203E20302029207B0D0A202020202020656E64446174652020203D206D6F6D656E742820746869732E64617465546F2E6974656D2E76616C28292C20746869732E6F7074696F6E732E6461746572616E67657069636B65722E6C6F63';
wwv_flow_api.g_varchar2_table(58) := '616C652E666F726D617420293B0D0A202020202020737461727444617465203D20656E64446174652E73746172744F66282764617927293B2020202020200D0A202020207D0D0A20202020656C7365207B202F2F203E30203E20300D0A20202020202073';
wwv_flow_api.g_varchar2_table(59) := '7461727444617465203D206D6F6D656E742820746869732E617065782E6974656D2E76616C28292C202020746869732E6F7074696F6E732E6461746572616E67657069636B65722E6C6F63616C652E666F726D617420293B2020202020200D0A20202020';
wwv_flow_api.g_varchar2_table(60) := '2020656E64446174652020203D206D6F6D656E742820746869732E64617465546F2E6974656D2E76616C28292C20746869732E6F7074696F6E732E6461746572616E67657069636B65722E6C6F63616C652E666F726D617420293B0D0A202020207D0D0A';
wwv_flow_api.g_varchar2_table(61) := '0D0A20202020746869732E7069636B65722E736574537461727444617465282073746172744461746520293B0D0A20202020746869732E7069636B65722E736574456E64446174652820656E644461746520293B0D0A0D0A20202020746869732E706963';
wwv_flow_api.g_varchar2_table(62) := '6B65722E7570646174655669657728293B0D0A0D0A20207D2C0D0A20205F6E6174697665466F6375733A2066756E6374696F6E28297B0D0A202020202F2F636F6E736F6C652E6C6F6728275F6E6174697665466F63757327293B0D0A0D0A202020206966';
wwv_flow_api.g_varchar2_table(63) := '202820746869732E7069636B65722E656E64446174652E697356616C69642829203D3D2066616C7365207C7C20746869732E7069636B65722E7374617274446174652E697356616C69642829203D3D2066616C736529207B0D0A20202020202074686973';
wwv_flow_api.g_varchar2_table(64) := '2E7069636B65722E656E6444617465203D206D6F6D656E7428292E73746172744F66282764617927293B0D0A202020202020746869732E7069636B65722E737461727444617465203D206D6F6D656E7428292E656E644F66282764617927293B0D0A0D0A';
wwv_flow_api.g_varchar2_table(65) := '2020202020202F2F746869732E7069636B65722E6869646528293B0D0A2020202020202F2F746869732E7069636B65722E73686F7728293B0D0A202020202020746869732E7069636B65722E7570646174655669657728293B0D0A202020207D0D0A2020';
wwv_flow_api.g_varchar2_table(66) := '7D2C0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(67) := '2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A0D0A20205F7365744F7074696F6E3A2066756E6374696F6E28206B65792C2076616C75652029207B0D0A2020202069662028206B6579203D3D3D202276616C7565222029207B0D0A20202020202076616C';
wwv_flow_api.g_varchar2_table(68) := '7565203D20746869732E5F636F6E73747261696E282076616C756520293B0D0A202020207D0D0A0D0A20202020746869732E5F737570657228206B65792C2076616C756520293B0D0A20207D2C20200D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(69) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(70) := '5F7365744F7074696F6E733A2066756E6374696F6E28206F7074696F6E732029207B0D0A2020202020202F2F636F6E736F6C652E6C6F6728275F7365744F7074696F6E7327293B0D0A2020202020206F7074696F6E732E6461746572616E67657069636B';
wwv_flow_api.g_varchar2_table(71) := '65722E6D696E44617465203D206F7074696F6E732E6461746572616E67657069636B65722E6D696E4461746520213D20756E646566696E6564203F20746869732E6765744D696E4D61784461746546726F6D537472696E6728206F7074696F6E732E6461';
wwv_flow_api.g_varchar2_table(72) := '746572616E67657069636B65722E6D696E446174652029203A20756E646566696E65643B0D0A2020202020206F7074696F6E732E6461746572616E67657069636B65722E6D617844617465203D206F7074696F6E732E6461746572616E67657069636B65';
wwv_flow_api.g_varchar2_table(73) := '722E6D61784461746520213D20756E646566696E6564203F20746869732E6765744D696E4D61784461746546726F6D537472696E6728206F7074696F6E732E6461746572616E67657069636B65722E6D6178446174652029203A20756E646566696E6564';
wwv_flow_api.g_varchar2_table(74) := '3B0D0A0D0A202020202020746869732E5F737570657228206F7074696F6E7320293B0D0A20207D2C0D0A20205F686173437573746F6D52616E67654C6162656C3A2066756E6374696F6E28297B0D0A20202020747279207B0D0A20202020202072657475';
wwv_flow_api.g_varchar2_table(75) := '726E20746869732E6F7074696F6E732E6461746572616E67657069636B65722E72616E6765732E437573746F6D203D3D3D20747275650D0A202020207D206361746368286572726F7229207B0D0A20202020202072657475726E2066616C73653B0D0A20';
wwv_flow_api.g_varchar2_table(76) := '2020207D0D0A202020200D0A20207D2C0D0A0D0A2020656E61626C653A2066756E6374696F6E2820656C656D20297B0D0A202020202F2F636F6E736F6C652E6C6F6728277075626C696320656E61626C6527293B0D0A0D0A0D0A20202020696620282065';
wwv_flow_api.g_varchar2_table(77) := '6C656D2E676574283029203D3D20746869732E617065782E6974656D2E6765742830292029207B0D0A2020202020202F2F636F6E736F6C652E6C6F67282764697361626C6520706C7567696E206974656D27293B0D0A202020202020746869732E617065';
wwv_flow_api.g_varchar2_table(78) := '782E6974656D2E72656D6F766541747472282764697361626C656427293B0D0A202020202020746869732E617065782E646174657069636B6572427574746F6E2E72656D6F7665436C617373282764697361626C656427293B0D0A0D0A202020207D0D0A';
wwv_flow_api.g_varchar2_table(79) := '20202020656C7365206966202820656C656D2E676574283029203D3D20746869732E64617465546F2E6974656D2E6765742830292029207B0D0A2020202020202F2F636F6E736F6C652E6C6F67282764697361626C6520706C7567696E20646174652074';
wwv_flow_api.g_varchar2_table(80) := '6F206974656D27293B0D0A202020202020746869732E64617465546F2E6974656D2E72656D6F766541747472282764697361626C656427293B0D0A202020202020746869732E64617465546F2E646174657069636B6572427574746F6E2E72656D6F7665';
wwv_flow_api.g_varchar2_table(81) := '436C617373282764697361626C656427293B0D0A0D0A202020207D0D0A20202020656C7365207B0D0A2020202020202F2F636F6E736F6C652E6C6F672820656C656D2E67657428302920293B0D0A2020202020207468726F772022556E6B6E6F776E2069';
wwv_flow_api.g_varchar2_table(82) := '74656D20746F2064697361626C653A20222B656C656D2E617474722827696427293B0D0A202020207D0D0A0D0A20207D2C0D0A202064697361626C653A2066756E6374696F6E2820656C656D20297B0D0A202020202F2F636F6E736F6C652E6C6F672827';
wwv_flow_api.g_varchar2_table(83) := '7075626C69632064697361626C65202720293B0D0A0D0A202020206966202820656C656D2E676574283029203D3D20746869732E617065782E6974656D2E6765742830292029207B0D0A2020202020202F2F636F6E736F6C652E6C6F6728276469736162';
wwv_flow_api.g_varchar2_table(84) := '6C6520706C7567696E206974656D27293B0D0A202020202020746869732E617065782E6974656D2E70726F70282764697361626C6564272C2074727565293B0D0A202020202020746869732E617065782E646174657069636B6572427574746F6E2E6164';
wwv_flow_api.g_varchar2_table(85) := '64436C617373282764697361626C656427293B0D0A0D0A202020207D0D0A20202020656C7365206966202820656C656D2E676574283029203D3D20746869732E64617465546F2E6974656D2E6765742830292029207B0D0A2020202020202F2F636F6E73';
wwv_flow_api.g_varchar2_table(86) := '6F6C652E6C6F67282764697361626C6520706C7567696E206461746520746F206974656D27293B0D0A202020202020746869732E64617465546F2E6974656D2E70726F70282764697361626C6564272C2074727565293B0D0A202020202020746869732E';
wwv_flow_api.g_varchar2_table(87) := '64617465546F2E646174657069636B6572427574746F6E2E616464436C617373282764697361626C656427293B0D0A0D0A202020207D0D0A20202020656C7365207B0D0A2020202020202F2F636F6E736F6C652E6C6F672820656C656D2E676574283029';
wwv_flow_api.g_varchar2_table(88) := '20293B0D0A2020202020207468726F772022556E6B6E6F776E206974656D20746F2064697361626C653A20222B656C656D2E617474722827696427293B0D0A202020207D0D0A0D0A20207D2C0D0A20207365744461746552616E67653A2066756E637469';
wwv_flow_api.g_varchar2_table(89) := '6F6E2820704461746552616E676520297B0D0A20202020766172206461746552616E6765203D20704461746552616E67652E73706C6974282027202D202720293B0D0A20202020766172206461746546726F6D203D206461746552616E67655B305D3B0D';
wwv_flow_api.g_varchar2_table(90) := '0A202020207661722064617465546F203D206461746552616E67655B315D3B0D0A0D0A20202020746869732E7069636B65722E73657453746172744461746528206461746546726F6D20293B0D0A20202020746869732E7069636B65722E736574456E64';
wwv_flow_api.g_varchar2_table(91) := '44617465282064617465546F20293B0D0A0D0A20207D2C0D0A20205F617065785F64613A2066756E6374696F6E28206461456C656D2029207B0D0A202020202F2F636F6E736F6C652E6C6F6728206461456C656D2E6174747228276964272920293B0D0A';
wwv_flow_api.g_varchar2_table(92) := '20202020766172200D0A202020202020704E616D65203D206461456C656D2E617474722827696427292C0D0A202020202020704F7074696F6E73203D207B0D0A202020202020202073657456616C75653A2066756E6374696F6E28207056616C75652C20';
wwv_flow_api.g_varchar2_table(93) := '70446973706C617956616C75652029207B0D0A202020202020202020202F2F636F6E736F6C652E6C6F67282773657456616C75652C207056616C75653D22272B7056616C75652B272227293B0D0A202020202020202020207661722064614974656D203D';
wwv_flow_api.g_varchar2_table(94) := '202428746869732E6E6F6465293B0D0A2020202020202020202076617220706C7567696E4974656D203D20756E646566696E65643B0D0A0D0A20202020202020202020696620282064614974656D2E646174612827706172656E744974656D272920213D';
wwv_flow_api.g_varchar2_table(95) := '20756E646566696E65642029207B0D0A2020202020202020202020202F2F64617465546F206974656D0D0A202020202020202020202020706C7567696E4974656D203D2064614974656D2E646174612827706172656E744974656D27293B0D0A20202020';
wwv_flow_api.g_varchar2_table(96) := '2020202020207D0D0A20202020202020202020656C7365207B0D0A2020202020202020202020202F2F706C7567696E206974656D0D0A202020202020202020202020706C7567696E4974656D203D2064614974656D3B0D0A202020202020202020207D0D';
wwv_flow_api.g_varchar2_table(97) := '0A0D0A202020202020202020206966202820706C7567696E4974656D2E617065786461746572616E67657069636B657228276F7074696F6E272C20277072657469757327292E6F7665726C6179203D3D2066616C73652029207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(98) := '2020202064614974656D2E76616C28207056616C756520293B0D0A202020202020202020202020706C7567696E4974656D2E617065786461746572616E67657069636B657228277365744461746552616E6765272C207056616C7565293B0D0A20202020';
wwv_flow_api.g_varchar2_table(99) := '2020202020207D0D0A20202020202020202020656C7365207B0D0A20202020202020202020202069662028207056616C75652E7472696D28292E6C656E677468203D3D20302029207B0D0A202020202020202020202020202064614974656D2E76616C28';
wwv_flow_api.g_varchar2_table(100) := '2222293B0D0A2020202020202020202020207D0D0A202020202020202020202020656C7365207B0D0A20202020202020202020202020200D0A202020202020202020202020202069662028202F285B5C2B2D5D7B317D5C647B312C7D5B797C6D7C647C77';
wwv_flow_api.g_varchar2_table(101) := '5D7B317D292F672E7465737428207056616C756520292029207B0D0A2020202020202020202020202020202064614974656D2E76616C2820706C7567696E4974656D2E617065786461746572616E67657069636B6572282763616C63756C6174654D6F6D';
wwv_flow_api.g_varchar2_table(102) := '656E7446726F6D5061747465726E272C207056616C75652C20747275652920293B202020200D0A20202020202020202020202020207D0D0A2020202020202020202020202020656C7365207B0D0A2020202020202020202020202020202064614974656D';
wwv_flow_api.g_varchar2_table(103) := '2E76616C28207056616C756520293B200D0A20202020202020202020202020207D0D0A20202020202020202020202020200D0A2020202020202020202020207D0D0A2020202020202020202020200D0A202020202020202020207D0D0A0D0A2020202020';
wwv_flow_api.g_varchar2_table(104) := '2020207D2C20202020202020200D0A20202020202020202F2F5370656369667920612076616C7565207468617420746F206265207573656420746F2064657465726D696E6520696620746865206974656D206973206E756C6C2E200D0A20202020202020';
wwv_flow_api.g_varchar2_table(105) := '202F2F546869732069732075736564207768656E20746865206974656D20737570706F72747320646566696E6974696F6E206F662061204C697374206F662056616C7565732C200D0A20202020202020202F2F7768657265206120646576656C6F706572';
wwv_flow_api.g_varchar2_table(106) := '2063616E20646566696E652061204E756C6C2052657475726E2056616C756520666F7220746865206974656D20616E64200D0A20202020202020202F2F7768657265207468652064656661756C74206974656D2068616E646C696E67206E656564732074';
wwv_flow_api.g_varchar2_table(107) := '6F206B6E6F77207468697320696E206F7264657220746F2061737365727420696620746865206974656D206973206E756C6C206F7220656D7074792E0D0A20202020202020206E756C6C56616C75653A202022222C0D0A2020202020202020656E61626C';
wwv_flow_api.g_varchar2_table(108) := '653A2066756E6374696F6E2829207B0D0A202020202020202020202F2F636F6E736F6C652E6C6F6728276170657820656E61626C6527293B0D0A202020202020202020207661722064614974656D203D202428746869732E6E6F6465293B0D0A20202020';
wwv_flow_api.g_varchar2_table(109) := '20202020202076617220706C7567696E4974656D203D20756E646566696E65643B0D0A0D0A20202020202020202020696620282064614974656D2E646174612827706172656E744974656D272920213D20756E646566696E65642029207B0D0A20202020';
wwv_flow_api.g_varchar2_table(110) := '20202020202020202F2F64617465546F206974656D0D0A202020202020202020202020706C7567696E4974656D203D2064614974656D2E646174612827706172656E744974656D27293B0D0A202020202020202020207D0D0A2020202020202020202065';
wwv_flow_api.g_varchar2_table(111) := '6C7365207B0D0A2020202020202020202020202F2F706C7567696E206974656D0D0A202020202020202020202020706C7567696E4974656D203D2064614974656D3B0D0A202020202020202020207D0D0A0D0A20202020202020202020706C7567696E49';
wwv_flow_api.g_varchar2_table(112) := '74656D2E617065786461746572616E67657069636B65722827656E61626C65272C2064614974656D293B0D0A20202020202020207D2C0D0A202020202020202064697361626C653A2066756E6374696F6E2829207B0D0A202020202020202020202F2F63';
wwv_flow_api.g_varchar2_table(113) := '6F6E736F6C652E6C6F672827617065782064697361626C6527293B0D0A202020202020202020207661722064614974656D203D202428746869732E6E6F6465293B0D0A2020202020202020202076617220706C7567696E4974656D203D20756E64656669';
wwv_flow_api.g_varchar2_table(114) := '6E65643B0D0A0D0A20202020202020202020696620282064614974656D2E646174612827706172656E744974656D272920213D20756E646566696E65642029207B0D0A2020202020202020202020202F2F64617465546F206974656D0D0A202020202020';
wwv_flow_api.g_varchar2_table(115) := '202020202020706C7567696E4974656D203D2064614974656D2E646174612827706172656E744974656D27293B0D0A202020202020202020207D0D0A20202020202020202020656C7365207B0D0A2020202020202020202020202F2F706C7567696E2069';
wwv_flow_api.g_varchar2_table(116) := '74656D0D0A202020202020202020202020706C7567696E4974656D203D2064614974656D3B0D0A202020202020202020207D0D0A0D0A20202020202020202020706C7567696E4974656D2E617065786461746572616E67657069636B6572282764697361';
wwv_flow_api.g_varchar2_table(117) := '626C65272C2064614974656D293B0D0A20202020202020207D2C0D0A202020202020202061667465724D6F646966793A2066756E6374696F6E28297B0D0A202020202020202020202F2F636F6E736F6C652E6C6F67282761667465724D6F646966792729';
wwv_flow_api.g_varchar2_table(118) := '3B0D0A202020202020202020202F2F20636F646520746F20616C77617973206669726520616674657220746865206974656D20686173206265656E206D6F646966696564202876616C7565207365742C20656E61626C65642C206574632E290D0A202020';
wwv_flow_api.g_varchar2_table(119) := '20202020207D2C0D0A20202020202020206C6F6164696E67496E64696361746F723A2066756E6374696F6E2820704C6F6164696E67496E64696361746F722420297B0D0A202020202020202020202F2F20636F646520746F2061646420746865206C6F61';
wwv_flow_api.g_varchar2_table(120) := '64696E6720696E64696361746F7220696E20746865206265737420706C61636520666F7220746865206974656D0D0A2020202020202020202072657475726E20704C6F6164696E67496E64696361746F72243B0D0A20202020202020207D0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(121) := '2020202020200D0A20202020202020202F2A0D0A20202020202020202F2F736574466F637573546F3A20242820223C736F6D65206A51756572792073656C6563746F723E2220292C0D0A2020202020202020736574466F637573546F3A2066756E637469';
wwv_flow_api.g_varchar2_table(122) := '6F6E28297B0D0A202020202020202020202F2F636F6E736F6C652E6C6F672827736574466F637573546F27293B0D0A202020202020202020207661722064614974656D203D202428746869732E6E6F6465293B0D0A202020202020202020202F2F636F6E';
wwv_flow_api.g_varchar2_table(123) := '736F6C652E6C6F67282064614974656D20290D0A20202020202020207D2C0D0A20202020202020207365745374796C65546F3A20242820223C736F6D65206A51756572792073656C6563746F723E2220292C202020200D0A202020202020202067657456';
wwv_flow_api.g_varchar2_table(124) := '616C75653A2066756E6374696F6E2829207B0D0A202020202020202020202F2F636F6E736F6C652E6C6F67282767657456616C756527293B0D0A202020202020202020207661722064614974656D203D202428746869732E6E6F6465293B0D0A20202020';
wwv_flow_api.g_varchar2_table(125) := '20202020202072657475726E2064614974656D2E76616C28293B0D0A20202020202020207D2C0D0A202020202020202073686F773A2066756E6374696F6E2829207B0D0A202020202020202020202F2F636F6E736F6C652E6C6F67282773686F7727293B';
wwv_flow_api.g_varchar2_table(126) := '0D0A202020202020202020202F2F20636F646520746861742073686F777320746865206974656D20747970650D0A20202020202020207D2C0D0A2020202020202020686964653A2066756E6374696F6E2829207B0D0A202020202020202020202F2F636F';
wwv_flow_api.g_varchar2_table(127) := '6E736F6C652E6C6F6728276869646527293B0D0A202020202020202020202F2F20636F6465207468617420686964657320746865206974656D20747970650D0A20202020202020207D2C0D0A202020202020202061646456616C75653A2066756E637469';
wwv_flow_api.g_varchar2_table(128) := '6F6E28207056616C75652029207B0D0A202020202020202020202F2F636F6E736F6C652E6C6F67282761646456616C756527293B0D0A202020202020202020202F2F20636F646520746861742061646473207056616C756520746F207468652076616C75';
wwv_flow_api.g_varchar2_table(129) := '657320616C726561647920696E20746865206974656D20747970650D0A20202020202020207D2C0D0A0D0A20202020202020202A2F0D0A0D0A2020202020207D3B0D0A0D0A20202020617065782E7769646765742E696E6974506167654974656D282070';
wwv_flow_api.g_varchar2_table(130) := '4E616D652C20704F7074696F6E73293B202020200D0A20207D2C0D0A20202F2A0D0A202020202A0D0A202020202A204E41544956450D0A202020202A0D0A20202A2F0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(131) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A0D0A20202F2F0D0A20202F2F2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(132) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A';
wwv_flow_api.g_varchar2_table(133) := '0D0A20205F6E61746976654170706C793A2066756E6374696F6E28704576656E7429207B0D0A20202020766172200D0A202020202020666F726D6174203D20746869732E6F7074696F6E732E6461746572616E67657069636B65722E6C6F63616C652E66';
wwv_flow_api.g_varchar2_table(134) := '6F726D61742C0D0A20202020202076616C7565203D20746869732E7069636B65722E7374617274446174652E666F726D61742820666F726D61742029202B2027202D2027202B20746869732E7069636B65722E656E64446174652E666F726D6174282066';
wwv_flow_api.g_varchar2_table(135) := '6F726D617420293B0D0A0D0A20202020746869732E656C656D656E742E76616C282076616C756520293B0D0A20207D2C0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(136) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A0D0A20205F6E617469766543616E63656C3A2066756E6374696F6E28704576656E7429';
wwv_flow_api.g_varchar2_table(137) := '207B0D0A20202020746869732E656C656D656E742E76616C282727293B0D0A20207D2C0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(138) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A0D0A20205F6E617469766553686F775069636B65724F6E427574746F6E436C69636B3A2066756E6374696F6E28297B0D';
wwv_flow_api.g_varchar2_table(139) := '0A202020202F2F636F6E736F6C652E6C6F6728275F6E617469766553686F775069636B65724F6E427574746F6E436C69636B27290D0A0D0A202020206966202820746869732E617065782E646174657069636B6572427574746F6E2E697328272E646973';
wwv_flow_api.g_varchar2_table(140) := '61626C656427292029207B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A0D0A20202020746869732E7069636B65722E73686F7728293B0D0A20207D2C0D0A0D0A20202F2A0D0A202020202A0D0A202020202A20434F4D4D4F';
wwv_flow_api.g_varchar2_table(141) := '4E0D0A202020202A0D0A20202A2F0D0A0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(142) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A0D0A20205F636F6D6D6F6E5F686964654F746865724D6F6E7468446179733A2066756E6374696F6E28297B0D0A202020202F2F636F6E736F6C652E6C6F6728275F636F';
wwv_flow_api.g_varchar2_table(143) := '6D6D6F6E5F686964654F746865724D6F6E74684461797327293B0D0A20202020766172200D0A2020202020206C65667443616C656E646172203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E6461722E6C6566';
wwv_flow_api.g_varchar2_table(144) := '7427292C0D0A202020202020726967687443616C656E646172203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E6461722E726967687427292C0D0A20202020202072696768745464732C0D0A20202020202072';
wwv_flow_api.g_varchar2_table(145) := '6573756C745464732C0D0A20202020202074723272656D6F76653B0D0A202020202020726573756C74546473203D206C65667443616C656E6461722E66696E64282774642E6F666627292E66696C74657228242E70726F78792866756E6374696F6E2869';
wwv_flow_api.g_varchar2_table(146) := '6E6465782C20656C656D297B0D0A20202020202020206966202820746869732E6765744461746546726F6D43616C656E64617228202428656C656D292C206C65667443616C656E64617220292E6D6F6E7468282920213D20746869732E7069636B65722E';
wwv_flow_api.g_varchar2_table(147) := '6C65667443616C656E6461722E6D6F6E74682E6D6F6E746828292029207B0D0A2020202020202020202072657475726E20747275653B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A2020202020202020202072657475726E20';
wwv_flow_api.g_varchar2_table(148) := '66616C73653B0D0A20202020202020207D0D0A2020202020207D2C207468697329293B0D0A0D0A202020202020726573756C745464730D0A0D0A2020202020206966202820746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C';
wwv_flow_api.g_varchar2_table(149) := '656E646172203D3D2066616C73652029207B0D0A20202020202020207269676874546473203D20726967687443616C656E6461722E66696E64282774642E6F666627292E66696C74657228242E70726F78792866756E6374696F6E28696E6465782C2065';
wwv_flow_api.g_varchar2_table(150) := '6C656D297B0D0A202020202020202020206966202820746869732E6765744461746546726F6D43616C656E64617228202428656C656D292C20726967687443616C656E64617220292E6D6F6E7468282920213D20746869732E7069636B65722E72696768';
wwv_flow_api.g_varchar2_table(151) := '7443616C656E6461722E6D6F6E74682E6D6F6E746828292029207B0D0A20202020202020202020202072657475726E20747275653B0D0A202020202020202020207D0D0A20202020202020202020656C7365207B0D0A2020202020202020202020207265';
wwv_flow_api.g_varchar2_table(152) := '7475726E2066616C73653B0D0A202020202020202020207D0D0A0D0A20202020202020207D2C207468697329293B0D0A0D0A2020202020202020726573756C74546473203D20726573756C745464732E616464287269676874546473293B0D0A20202020';
wwv_flow_api.g_varchar2_table(153) := '20207D0D0A2020202020200D0A202020202020726573756C745464732E656D70747928292E72656D6F7665417474722827636C61737327292E616464436C61737328276F746865724D6F6E746827293B0D0A0D0A20202020202074723272656D6F766520';
wwv_flow_api.g_varchar2_table(154) := '3D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E64617220747227292E66696C7465722866756E6374696F6E2820696E6465782C20656C656D297B0D0A202020202020202072657475726E202428656C656D292E';
wwv_flow_api.g_varchar2_table(155) := '6368696C6472656E28272E6F746865724D6F6E746827292E73697A652829203D3D2037203F2074727565203A2066616C73653B0D0A2020202020207D293B0D0A0D0A20202020202074723272656D6F76652E72656D6F766528293B0D0A0D0A202020207D';
wwv_flow_api.g_varchar2_table(156) := '2C20200D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(157) := '2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20205F636F6D6D6F6E5F73686F774D6F6E74687344697374616E63653A2066756E6374696F6E28297B0D0A20202020696620280D0A202020202020202020746869732E7069636B65722E6C6566744361';
wwv_flow_api.g_varchar2_table(158) := '6C656E6461722E6D6F6E74682E666F726D61742827595959592D4D4D2729203D3D20746869732E7069636B65722E726967687443616C656E6461722E6D6F6E74682E666F726D61742827595959592D4D4D27290D0A2020202020207C7C20746869732E70';
wwv_flow_api.g_varchar2_table(159) := '69636B65722E6C65667443616C656E6461722E6D6F6E74682E636C6F6E6528292E61646428312C20276D6F6E746827292E666F726D61742827595959592D4D4D2729203D3D20746869732E7069636B65722E726967687443616C656E6461722E6D6F6E74';
wwv_flow_api.g_varchar2_table(160) := '682E666F726D61742827595959592D4D4D27290D0A2020202029207B0D0A202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276D6F6E746873446966666572734D6F72655468616E4F6E6527293B0D0A';
wwv_flow_api.g_varchar2_table(161) := '202020207D0D0A20202020656C7365207B0D0A202020202020746869732E7069636B65722E636F6E7461696E65722E616464436C61737328276D6F6E746873446966666572734D6F72655468616E4F6E6527293B0D0A202020207D0D0A20207D2C0D0A20';
wwv_flow_api.g_varchar2_table(162) := '205F636F6D6D6F6E5F63616C65726E6461725570646174653A2066756E6374696F6E28207054726967676572696E67456C656D656E7420297B0D0A202020202F2F636F6E736F6C652E6C6F6728275F636F6D6D6F6E5F63616C65726E6461725570646174';
wwv_flow_api.g_varchar2_table(163) := '6527293B0D0A0D0A202020202F2F706F646D69656E207374727A616C6B690D0A20202020746869732E7069636B65722E636F6E7461696E65722E66696E6428272E6E657874206927292E72656D6F7665417474722827636C61737327292E616464436C61';
wwv_flow_api.g_varchar2_table(164) := '7373282775692D69636F6E2075692D69636F6E2D636972636C652D747269616E676C652D6527293B0D0A20202020746869732E7069636B65722E636F6E7461696E65722E66696E6428272E70726576206927292E72656D6F7665417474722827636C6173';
wwv_flow_api.g_varchar2_table(165) := '7327292E616464436C617373282775692D69636F6E2075692D69636F6E2D636972636C652D747269616E676C652D7727293B0D0A202020200D0A0D0A202020206966202820746869732E6F7074696F6E732E707265746975732E686964654F746865724D';
wwv_flow_api.g_varchar2_table(166) := '6F6E7468446179732029207B0D0A202020202020746869732E5F636F6D6D6F6E5F686964654F746865724D6F6E74684461797328293B0D0A202020207D0D0A0D0A2020202069662028200D0A202020202020746869732E6F7074696F6E732E6461746572';
wwv_flow_api.g_varchar2_table(167) := '616E67657069636B65722E6C696E6B656443616C656E64617273203D3D2066616C7365200D0A202020202020262620746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E646172203D3D2066616C73650D0A202020202920';
wwv_flow_api.g_varchar2_table(168) := '7B0D0A202020202020746869732E5F636F6D6D6F6E5F73686F774D6F6E74687344697374616E636528293B0D0A202020207D0D0A0D0A2020202069662028207054726967676572696E67456C656D656E74203D3D202764617465546F2720262620746869';
wwv_flow_api.g_varchar2_table(169) := '732E6F7074696F6E732E707265746975732E616C7444617465546F53656C6563742029207B0D0A0D0A2020202020206966202820746869732E7069636B65722E656C656D656E74203D3D20746869732E64617465546F2E6974656D2029207B0D0A0D0A20';
wwv_flow_api.g_varchar2_table(170) := '20202020202020746869732E7069636B65722E636F6E7461696E65722E66696E6428272E6461746546726F6D203A696E70757427292E72656D6F7665436C617373282761637469766527293B0D0A2020202020202020746869732E7069636B65722E636F';
wwv_flow_api.g_varchar2_table(171) := '6E7461696E65722E66696E6428272E64617465546F203A696E70757427292E616464436C617373282761637469766527293B0D0A0D0A20202020202020202F2F746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E6461';
wwv_flow_api.g_varchar2_table(172) := '7227292E6F666628276D6F757365656E7465722E6461746572616E67657069636B657227293B0D0A2020202020202020746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E64617220746427292E62696E6428276D6F75';
wwv_flow_api.g_varchar2_table(173) := '7365656E7465722E6461746572616E67657069636B6572272C20242E70726F78792820746869732E5F6F7665726C61795F75706461746544617465546F5F696E7075742C20746869732029293B0D0A2020202020200D0A2020202020207D0D0A20200D0A';
wwv_flow_api.g_varchar2_table(174) := '202020202020746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E64617220746427292E62696E6428276D6F757365646F776E2E7465737420636C69636B2E74657374272C20242E70726F78792820746869732E5F6F76';
wwv_flow_api.g_varchar2_table(175) := '65726C61795F64617465546F53686F775F666F72636544617465546F53656C656374696F6E2C2074686973202920293B0D0A0D0A202020207D0D0A20207D2C0D0A0D0A20202F2A0D0A202020202A0D0A202020202A204F5645524C41590D0A202020202A';
wwv_flow_api.g_varchar2_table(176) := '0D0A20202A2F0D0A0D0A20205F6F7665726C61795F64617465546F486964653A2066756E6374696F6E28297B0D0A202020202F2F636F6E736F6C652E6C6F6728275F6F7665726C61795F64617465546F4869646527293B0D0A20202020746869732E6461';
wwv_flow_api.g_varchar2_table(177) := '7465546F2E6974656D2E626C757228293B0D0A20202020746869732E7069636B65722E656C656D656E74203D20746869732E656C656D656E743B0D0A20207D2C0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(178) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20205F6D6F766552616E6765733A2066756E63';
wwv_flow_api.g_varchar2_table(179) := '74696F6E282020297B0D0A202020202F2F636F6E736F6C652E6C6F6728275F6D6F766552616E67657327293B0D0A202020207661720D0A202020202020636F6E7461696E6572203D20746869732E7069636B65722E636F6E7461696E65722C0D0A202020';
wwv_flow_api.g_varchar2_table(180) := '2020206C656674203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E6461722E6C65667427292C0D0A2020202020207269676874203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E';
wwv_flow_api.g_varchar2_table(181) := '63616C656E6461722E726967687427292C0D0A20202020202072616E676573203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E72616E67657327292C0D0A202020202020626F64795769647468203D20242827626F647927';
wwv_flow_api.g_varchar2_table(182) := '292E6F75746572576964746828293B0D0A0D0A2020202072616E676573203D2072616E6765732E64657461636828293B0D0A0D0A2020202072696768742E6166746572282072616E67657320293B0D0A0D0A20207D2C0D0A20205F69734F6E654C696E65';
wwv_flow_api.g_varchar2_table(183) := '3A2066756E6374696F6E28297B0D0A20202020766172200D0A202020202020636F6E7461696E6572203D20746869732E7069636B65722E636F6E7461696E65722C0D0A2020202020202F2F7465206F64776F6C616E6961207779706164616C6F6279207A';
wwv_flow_api.g_varchar2_table(184) := '6D6572676F77616320646F205F6372656174652069206F64776F6C797761632073696520646F206A757A206973746E69656A616379636820696E7374616E636A690D0A2020202020206C656674203D20746869732E7069636B65722E636F6E7461696E65';
wwv_flow_api.g_varchar2_table(185) := '722E66696E6428272E63616C656E6461722E6C65667427292C0D0A2020202020207269676874203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E6461722E726967687427292C0D0A20202020202072616E6765';
wwv_flow_api.g_varchar2_table(186) := '73203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E72616E67657327293B0D0A0D0A20202020696620280D0A2020202020202F2F706F6A6564796E637A79206920776C61637A6F6E652072616E6765730D0A202020202020';
wwv_flow_api.g_varchar2_table(187) := '746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E646172202020203D3D2074727565202020262620746869732E6F7074696F6E732E6461746572616E67657069636B65722E72616E67657320213D20756E646566696E65';
wwv_flow_api.g_varchar2_table(188) := '64202020202020202020202626206C6566742E6F666673657428292E746F70203D3D2072616E6765732E6F666673657428292E746F700D0A2020202020202F2F706F6A6564796E637A7920692072616E676573206A616B6F207069657277737A650D0A20';
wwv_flow_api.g_varchar2_table(189) := '20202020207C7C20746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E646172203D3D2074727565202020262620746869732E6F7074696F6E732E6461746572616E67657069636B65722E616C7761797353686F7743616C';
wwv_flow_api.g_varchar2_table(190) := '656E64617273203D3D2066616C736520262620216C6566742E697328273A76697369626C6527290D0A2020202020202F2F706F6A6564796E637A7920692077796C61637A6F6E652072616E6765730D0A2020202020207C7C20746869732E6F7074696F6E';
wwv_flow_api.g_varchar2_table(191) := '732E707265746975732E6F6E6C794F6E6543616C656E646172203D3D2074727565202020262620746869732E6F7074696F6E732E6461746572616E67657069636B65722E72616E676573203D3D20756E646566696E65640D0A2020202020202F2F706F64';
wwv_flow_api.g_varchar2_table(192) := '776F6A6E79206920776C61637A6F6E652072616E6765730D0A2020202020207C7C20746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E646172203D3D2066616C736520202626206C6566742E6F666673657428292E746F';
wwv_flow_api.g_varchar2_table(193) := '70203D3D2072696768742E6F666673657428292E746F702020202020202626206C6566742E6F666673657428292E746F70203D3D2072616E6765732E6F666673657428292E746F700D0A2020202020202F2F706F64776F6A6E7920692077796C61637A6F';
wwv_flow_api.g_varchar2_table(194) := '6E652072616E6765730D0A2020202020207C7C20746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E646172203D3D2066616C736520202626206C6566742E6F666673657428292E746F70203D3D2072696768742E6F6666';
wwv_flow_api.g_varchar2_table(195) := '73657428292E746F70202020202020262620746869732E6F7074696F6E732E6461746572616E67657069636B65722E72616E676573203D3D20756E646566696E65640D0A2020202020202F2F706F64776F6A6E7920692072616E676573206A616B6F2070';
wwv_flow_api.g_varchar2_table(196) := '69657277737A650D0A2020202020207C7C20746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E646172203D3D2066616C73652020262620746869732E6F7074696F6E732E6461746572616E67657069636B65722E616C77';
wwv_flow_api.g_varchar2_table(197) := '61797353686F7743616C656E64617273203D3D2066616C736520262620216C6566742E697328273A76697369626C652729202626202172696768742E697328273A76697369626C6527290D0A20202020297B0D0A20202020202072657475726E20747275';
wwv_flow_api.g_varchar2_table(198) := '653B0D0A202020207D0D0A20202020656C7365207B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A20207D2C0D0A202066697843616C656E646172506F736974696F6E566572746963616C3A2066756E6374696F6E28297B0D';
wwv_flow_api.g_varchar2_table(199) := '0A202020202F2F706F6D6F636E69637A650D0A202020207661722066697865644E6176426172486569676874203D202428272E742D426F64792D636F6E74656E7427292E73697A652829203E2030203F207061727365496E74282428272E742D426F6479';
wwv_flow_api.g_varchar2_table(200) := '2D636F6E74656E7427292E63737328276D617267696E546F70272929203A20303B0D0A0D0A20202020766172206974656D203D20746869732E7069636B65722E656C656D656E743B0D0A202020202F2F61206F666673657420746F70206974656D200D0A';
wwv_flow_api.g_varchar2_table(201) := '20202020766172206974656D4F6666736574546F70203D206974656D2E6F666673657428292E746F70202D2066697865644E61764261724865696768743B0D0A202020202F2F6320696C65206A6573742070727A6577696E69657461207374726F6E610D';
wwv_flow_api.g_varchar2_table(202) := '0A202020207661722077696E646F775363726F6C6C486569676874203D20242877696E646F77292E7363726F6C6C546F7028293B2F2F242827626F647927292E7363726F6C6C546F7028293B0D0A202020202F2F64207779736F6B6F7363206F6B6E6120';
wwv_flow_api.g_varchar2_table(203) := '70727A65676C616461726B690D0A202020207661722077696E646F77486569676874203D20242877696E646F77292E6F7574657248656967687428293B0D0A202020202F2F65207779736F6B6F7363206974656D0D0A20202020766172206974656D4865';
wwv_flow_api.g_varchar2_table(204) := '69676874203D206974656D2E6F7574657248656967687428293B0D0A202020202F2F62203D2061202D2063202F2F20696C65207A6F7374616C6F206D69656A73636120706F6E6164206974656D0D0A2020202076617220737061636541626F7665497465';
wwv_flow_api.g_varchar2_table(205) := '6D203D206974656D4F6666736574546F70202D2077696E646F775363726F6C6C4865696768743B0D0A202020202F2F66203D20642D622D65202F2F696C65207A6F7374616C6F206D69656A73636120706F64206974656D0D0A2020202076617220737061';
wwv_flow_api.g_varchar2_table(206) := '636542656C6F77654974656D203D2077696E646F77486569676874202D20737061636541626F76654974656D202D206974656D4865696768743B0D0A202020202F2F67207779736F6B6F7363206B6F746E656E657261206B616C656E6461727A79202F2F';
wwv_flow_api.g_varchar2_table(207) := '6A65736C69200D0A202020207661722063616C656E646172486569676874203D20746869732E7069636B65722E636F6E7461696E65722E6F7574657248656967687428293B0D0A202020202F2F69206F666673657420746F70206B616C656E6461727A79';
wwv_flow_api.g_varchar2_table(208) := '0D0A202020207661722063616C656E6461724F6666736574546F70203D20746869732E7069636B65722E636F6E7461696E65722E6F666673657428292E746F703B0D0A202020202F2F68203D2069202D2063202F2F696C65207A6F7374616C6F206D6965';
wwv_flow_api.g_varchar2_table(209) := '6A736361206E6164206B616C656E6461727A656D0D0A2020202076617220737061636541626F636543616C656E646172203D2063616C656E6461724F6666736574546F70202D2077696E646F775363726F6C6C4865696768743B0D0A202020202F2F6A20';
wwv_flow_api.g_varchar2_table(210) := '6A65736C69207769656B737A79206F64207A65726120746F2077797374616A6520706F77797A656A0D0A202020207661722063616C656E6461724F766572666C6F7741626F7665486569676874203D2077696E646F775363726F6C6C486569676874202D';
wwv_flow_api.g_varchar2_table(211) := '2063616C656E6461724F6666736574546F703B200D0A202020202F2F6A65736C69207769656B737A79206F64207A65726120746F2077797374616A6520706F6E697A656A0D0A202020207661722063616C656E6461724F766572666C6F7742656C6F7748';
wwv_flow_api.g_varchar2_table(212) := '6569676874203D202863616C656E646172486569676874202B2063616C656E6461724F6666736574546F7029202D202877696E646F775363726F6C6C486569676874202B2077696E646F77486569676874293B200D0A0D0A20202020696620282063616C';
wwv_flow_api.g_varchar2_table(213) := '656E6461724F766572666C6F7741626F7665486569676874203E3D2030202029207B0D0A2020202020202F2F616C776179732064726F7020646F776E2069662063616C656E646172206973206375742066726F6D2061626F76650D0A2020202020207468';
wwv_flow_api.g_varchar2_table(214) := '69732E7069636B65722E636F6E7461696E65722E72656D6F7665436C617373282764726F70757027293B0D0A202020202020746869732E7069636B65722E64726F7073203D2027646F776E273B0D0A202020202020746869732E7069636B65722E6D6F76';
wwv_flow_api.g_varchar2_table(215) := '6528293B0D0A202020207D0D0A20202020656C736520696620282063616C656E6461724F766572666C6F7742656C6F77486569676874203E3D20302029207B0D0A2020202020202F2F6375742066726F6D20646F776E0D0A202020202020696620282073';
wwv_flow_api.g_varchar2_table(216) := '7061636541626F76654974656D203E3D2063616C656E6461724865696768742029207B0D0A2020202020202020746869732E7069636B65722E636F6E7461696E65722E616464436C617373282764726F70757027293B0D0A202020202020202074686973';
wwv_flow_api.g_varchar2_table(217) := '2E7069636B65722E64726F7073203D20277570273B0D0A2020202020202020746869732E7069636B65722E6D6F766528293B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020202F2F7468657265206973206E6F20737061';
wwv_flow_api.g_varchar2_table(218) := '63652061626F76652C207363726F6C6C207468652062726F737765720D0A20202020202020206E756C6C3B0D0A2020202020207D0D0A202020207D0D0A20207D2C0D0A202066697843616C656E646172506F736974696F6E486F72697A6F6E74616C3A20';
wwv_flow_api.g_varchar2_table(219) := '66756E6374696F6E28297B0D0A202020202F2F636F6E736F6C652E6C6F67282766697843616C656E646172506F736974696F6E486F72697A6F6E74616C27293B0D0A20202020766172200D0A2020202020206F70656E73203D20746869732E7069636B65';
wwv_flow_api.g_varchar2_table(220) := '722E6F70656E732C0D0A2020202020206F70656E65724F6666736574203D20746869732E7069636B65722E656C656D656E742E6F666673657428293B0D0A0D0A202020206966202820746869732E5F69734F6E654C696E652829203D3D2066616C736520';
wwv_flow_api.g_varchar2_table(221) := '26262021746869732E7069636B65722E636F6E7461696E65722E697328272E666F7263654F6E65436F6C756D6E272929207B0D0A2020202020202F2F7768656E2063616C656E6461727320616E642072616E67657320617265206E6F7420696E20746865';
wwv_flow_api.g_varchar2_table(222) := '2073616D65206C696E653B0D0A2020202020202F2F7269676874202D2D3E20206C6566742020202D2D3E2063656E746572202D2D3E20666F726365206F6E6520636F6C756D6E0D0A2020202020202F2F6C65667420202D2D3E2020726967687420202D2D';
wwv_flow_api.g_varchar2_table(223) := '3E2063656E746572202D2D3E20666F726365206F6E6520636F6C756D6E0D0A2020202020202F2F63656E746572202D2D3E20726967687420202D2D3E206C6566742020202D2D3E20666F726365206F6E6520636F6C756D6E0D0A0D0A2020202020206966';
wwv_flow_api.g_varchar2_table(224) := '202820746869732E6F7267696E616C2E6F70656E73203D3D20277269676874272029207B0D0A20202020202020202F2F7768656E20706F7075702073686F756C64206265206F70656E656420696E20726967687420706F736974696F6E0D0A2020202020';
wwv_flow_api.g_varchar2_table(225) := '20202069662028206F70656E73203D3D20277269676874272029207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276F70656E73726967687427292E616464436C61737328276F70';
wwv_flow_api.g_varchar2_table(226) := '656E736C65667427293B0D0A20202020202020202020746869732E7069636B65722E6F70656E73203D20276C656674273B0D0A20202020202020202020746869732E7069636B65722E6D6F766528293B0D0A20202020202020207D0D0A20202020202020';
wwv_flow_api.g_varchar2_table(227) := '20656C73652069662028206F70656E73203D3D20276C656674272029207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276F70656E736C65667427292E616464436C61737328276F';
wwv_flow_api.g_varchar2_table(228) := '70656E736C65667427293B0D0A20202020202020202020746869732E7069636B65722E6F70656E73203D202763656E746572273B0D0A20202020202020202020746869732E7069636B65722E6D6F766528293B0D0A20202020202020207D0D0A20202020';
wwv_flow_api.g_varchar2_table(229) := '20202020656C7365207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E616464436C6173732827666F7263654F6E65436F6C756D6E27290D0A20202020202020207D0D0A2020202020207D0D0A202020202020656C';
wwv_flow_api.g_varchar2_table(230) := '7365206966202820746869732E6F7267696E616C2E6F70656E73203D3D20276C656674272029207B0D0A20202020202020202F2F7768656E20706F7075702073686F756C64206265206F70656E656420696E206C65667420706F736974696F6E0D0A2020';
wwv_flow_api.g_varchar2_table(231) := '20202020202069662028206F70656E73203D3D20276C656674272029207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276F70656E736C65667427292E616464436C61737328276F';
wwv_flow_api.g_varchar2_table(232) := '70656E73726967687427293B0D0A20202020202020202020746869732E7069636B65722E6F70656E73203D20277269676874273B0D0A20202020202020202020746869732E7069636B65722E6D6F766528293B0D0A20202020202020207D0D0A20202020';
wwv_flow_api.g_varchar2_table(233) := '20202020656C73652069662028206F70656E73203D3D20277269676874272029207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276F70656E73726967687427292E616464436C61';
wwv_flow_api.g_varchar2_table(234) := '737328276F70656E7363656E74657227293B0D0A20202020202020202020746869732E7069636B65722E6F70656E73203D202763656E746572273B0D0A20202020202020202020746869732E7069636B65722E6D6F766528293B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(235) := '7D0D0A2020202020202020656C7365207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E616464436C6173732827666F7263654F6E65436F6C756D6E27290D0A20202020202020207D0D0A2020202020207D0D0A20';
wwv_flow_api.g_varchar2_table(236) := '2020202020656C7365207B0D0A20202020202020202F2F7768656E20706F7075702073686F756C64206265206F70656E656420696E2063656E74657220706F736974696F6E0D0A202020202020202069662028206F70656E73203D3D202763656E746572';
wwv_flow_api.g_varchar2_table(237) := '272029207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276F70656E7363656E74657227292E616464436C61737328276F70656E73726967687427293B0D0A202020202020202020';
wwv_flow_api.g_varchar2_table(238) := '20746869732E7069636B65722E6F70656E73203D20277269676874273B0D0A20202020202020202020746869732E7069636B65722E6D6F766528293B0D0A20202020202020207D0D0A2020202020202020656C73652069662028206F70656E73203D3D20';
wwv_flow_api.g_varchar2_table(239) := '277269676874272029207B0D0A20202020202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276F70656E73726967687427292E616464436C61737328276F70656E736C65667427293B0D0A2020202020';
wwv_flow_api.g_varchar2_table(240) := '2020202020746869732E7069636B65722E6F70656E73203D20276C656674273B0D0A20202020202020202020746869732E7069636B65722E6D6F766528293B0D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(241) := '2020746869732E7069636B65722E636F6E7461696E65722E616464436C6173732827666F7263654F6E65436F6C756D6E27290D0A20202020202020207D0D0A0D0A2020202020207D0D0A0D0A202020202020746869732E66697843616C656E646172506F';
wwv_flow_api.g_varchar2_table(242) := '736974696F6E486F72697A6F6E74616C28293B0D0A0D0A202020207D200D0A20202020656C7365207B0D0A2020202020202F2F657863657074696F6E20666F722072696768742F63656E74657220706F736974696F6E0D0A20202020202069662028200D';
wwv_flow_api.g_varchar2_table(243) := '0A2020202020202020746869732E6F7267696E616C2E6F70656E73203D3D2027726967687427202626207061727365496E742820746869732E7069636B65722E636F6E7461696E65722E6373732827726967687427292029203D3D2030200D0A20202020';
wwv_flow_api.g_varchar2_table(244) := '202020207C7C20746869732E6F7267696E616C2E6F70656E73203D3D202763656E74657227202626207061727365496E742820746869732E7069636B65722E636F6E7461696E65722E6373732827726967687427292029203D3D2030200D0A2020202020';
wwv_flow_api.g_varchar2_table(245) := '2029207B0D0A0D0A2020202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C61737328276F70656E737269676874206F70656E7363656E74657227292E616464436C61737328276F70656E736C65667427293B0D0A';
wwv_flow_api.g_varchar2_table(246) := '2020202020202020746869732E7069636B65722E6F70656E73203D20276C656674273B0D0A2020202020202020746869732E7069636B65722E6D6F766528293B0D0A2020202020202020746869732E66697843616C656E646172506F736974696F6E486F';
wwv_flow_api.g_varchar2_table(247) := '72697A6F6E74616C28293B0D0A202020202020202072657475726E3B0D0A2020202020207D0D0A0D0A202020202020746869732E7069636B65722E6D6F766528293B0D0A202020207D0D0A20200D0A20207D2C0D0A20205F636F6D6D6F6E486964653A20';
wwv_flow_api.g_varchar2_table(248) := '66756E6374696F6E282074726967676572696E67456C656D656E742029207B0D0A202020202F2F636F6E736F6C652E6C6F6728275F636F6D6D6F6E4869646527293B0D0A20202020746869732E7069636B65722E64726F7073203D20746869732E6F7267';
wwv_flow_api.g_varchar2_table(249) := '696E616C2E64726F70733B0D0A20202020746869732E7069636B65722E6F70656E73203D20746869732E6F7267696E616C2E6F70656E733B0D0A20202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C6173732827666F72';
wwv_flow_api.g_varchar2_table(250) := '63654F6E65436F6C756D6E27293B0D0A0D0A20207D2C0D0A20205F636F6D6D6F6E53686F773A2066756E6374696F6E282074726967676572696E67456C656D656E7420297B0D0A202020202F2F636F6E736F6C652E6C6F6728275F636F6D6D6F6E53686F';
wwv_flow_api.g_varchar2_table(251) := '7727293B0D0A20202020766172207269676874496E707574203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E6461722E7269676874202E6461746572616E67657069636B65725F696E70757427292E61646443';
wwv_flow_api.g_varchar2_table(252) := '6C617373282764617465546F27293B0D0A20202020766172206C656674496E707574203D20746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E6461722E6C656674202E6461746572616E67657069636B65725F696E70';
wwv_flow_api.g_varchar2_table(253) := '757427292E616464436C61737328276461746546726F6D27293B0D0A0D0A20202020746869732E5F6D6F766552616E67657328293B0D0A0D0A202020206966202820746869732E6F7074696F6E732E707265746975732E6F6E6C794F6E6543616C656E64';
wwv_flow_api.g_varchar2_table(254) := '61722029207B0D0A202020202020746869732E7069636B65722E636F6E7461696E65722E72656D6F7665436C617373282768696465526967687443616C656E6461722027292E616464436C61737328202768696465526967687443616C656E6461722720';
wwv_flow_api.g_varchar2_table(255) := '293B0D0A2020202020200D0A2020202020207269676874496E7075742E64657461636828293B0D0A2020202020207269676874496E7075742E696E73657274416674657228206C656674496E70757420293B0D0A2020202020200D0A202020207D200D0A';
wwv_flow_api.g_varchar2_table(256) := '0D0A202020206966202820746869732E6F7074696F6E732E6461746572616E67657069636B65722E6175746F4170706C792029207B0D0A202020202020746869732E7069636B65722E636F6E7461696E65722E616464436C61737328276861734175746F';
wwv_flow_api.g_varchar2_table(257) := '4170706C7927293B0D0A202020207D0D0A0D0A202020206966202820746869732E6F7074696F6E732E6461746572616E67657069636B65722E73686F775765656B4E756D626572732029207B0D0A202020202020746869732E7069636B65722E636F6E74';
wwv_flow_api.g_varchar2_table(258) := '61696E65722E616464436C617373282768617353686F775765656B4E756D6265727327293B0D0A202020207D0D0A0D0A202020206966202820746869732E6F7074696F6E732E6461746572616E67657069636B65722E72616E6765732029207B0D0A2020';
wwv_flow_api.g_varchar2_table(259) := '20202020746869732E7069636B65722E636F6E7461696E65722E616464436C617373282768617352616E67657327293B0D0A202020207D0D0A0D0A202020206966202820746869732E6F7074696F6E732E707265746975732E6869646543616C656E6461';
wwv_flow_api.g_varchar2_table(260) := '7244617465496E707574732029207B0D0A202020202020746869732E7069636B65722E636F6E7461696E65722E616464436C61737328276869646543616C656E64617244617465496E7075747327293B0D0A202020207D0D0A0D0A20202020746869732E';
wwv_flow_api.g_varchar2_table(261) := '66697843616C656E646172506F736974696F6E486F72697A6F6E74616C28293B0D0A20202020746869732E66697843616C656E646172506F736974696F6E566572746963616C28293B0D0A0D0A0D0A0D0A20207D2C0D0A0D0A20202F2F0D0A20202F2F2D';
wwv_flow_api.g_varchar2_table(262) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A2020';
wwv_flow_api.g_varchar2_table(263) := '2F2F0D0A20205F6F7665726C61795F73686F775069636B65724F6E427574746F6E436C69636B3A2066756E6374696F6E28297B0D0A202020206966202820746869732E64617465546F2E646174657069636B6572427574746F6E2E697328272E64697361';
wwv_flow_api.g_varchar2_table(264) := '626C656427292029207B0D0A20202020202072657475726E2066616C73653B0D0A202020207D0D0A0D0A202020202F2F636F6E736F6C652E6C6F672820275F6F7665726C61795F73686F775069636B65724F6E427574746F6E436C69636B2720293B0D0A';
wwv_flow_api.g_varchar2_table(265) := '20202020746869732E5F6F7665726C61795F666F6375734F6E44617465546F28293B0D0A20207D2C0D0A0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(266) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20205F6F7665726C61795F666F6375734F6E44617465546F3A2066756E6374696F6E28297B0D0A2020';
wwv_flow_api.g_varchar2_table(267) := '20202F2F636F6E736F6C652E6C6F672820275F6F7665726C61795F666F6375734F6E44617465546F2720293B0D0A0D0A20202020766172200D0A202020202020746172676574456E64446174652C0D0A2020202020207461726765745374617274446174';
wwv_flow_api.g_varchar2_table(268) := '653B0D0A0D0A202020202F2F6A65736C692064617461206F64206A6573742070757374610D0A202020206966202820746869732E656C656D656E742E76616C28292E7472696D28292E6C656E677468203D3D20302029207B0D0A2020202020202F2F7779';
wwv_flow_api.g_varchar2_table(269) := '6D757320706F6B617A616E6965206E616A70696572772064617479206F640D0A2020202020202F2F746869732E7069636B65722E73686F7728293B0D0A202020202020746869732E7069636B65722E737461727444617465203D206D6F6D656E7428292E';
wwv_flow_api.g_varchar2_table(270) := '73746172744F66282764617927293B0D0A202020202020746869732E617065782E6974656D2E666F63757328293B0D0A202020207D0D0A202020202F2F6A65736C692064617461206F64206E6965206A6573742070757374610D0A20202020656C736520';
wwv_flow_api.g_varchar2_table(271) := '7B0D0A202020202020746869732E7069636B65722E656C656D656E74203D20746869732E64617465546F2E6974656D3B0D0A202020202020746869732E7069636B65722E73686F7728293B0D0A0D0A202020202020746172676574537461727444617465';
wwv_flow_api.g_varchar2_table(272) := '203D20746869732E6765744D6F6D656E7446726F6D537472696E674C6F63616C65466F726D61742820746869732E656C656D656E742E76616C282920293B0D0A202020202020746172676574456E64446174652020203D20746869732E6765744D6F6D65';
wwv_flow_api.g_varchar2_table(273) := '6E7446726F6D537472696E674C6F63616C65466F726D61742820746869732E64617465546F2E6974656D2E76616C28292E7472696D28292E6C656E677468203D3D2030203F20746869732E656C656D656E742E76616C2829203A20746869732E64617465';
wwv_flow_api.g_varchar2_table(274) := '546F2E6974656D2E76616C282920293B0D0A0D0A202020202020746869732E7069636B65722E736574456E64446174652820746172676574456E644461746520290D0A0D0A202020202020746869732E5F75706461746543616C656E6461725669657728';
wwv_flow_api.g_varchar2_table(275) := '207461726765745374617274446174652C20746172676574456E644461746520293B0D0A0D0A202020207D0D0A20207D2C0D0A0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(276) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20205F75706461746543616C656E646172566965773A2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(277) := '20705461726765745374617274446174652C2070546172676574456E64446174652029207B0D0A202020202F2F636F6E736F6C652E6C6F6728275F75706461746543616C656E6461725669657727293B0D0A0D0A202020206966202820746869732E6F70';
wwv_flow_api.g_varchar2_table(278) := '74696F6E732E707265746975732E6F6E6C794F6E6543616C656E6461722029207B0D0A2020202020202F2F7768656E207573696E67206F6E6C79206F6E652063616C656E6461720D0A202020202020746869732E7069636B65722E6C65667443616C656E';
wwv_flow_api.g_varchar2_table(279) := '6461722E6D6F6E74682E73657428202779656172272C2070546172676574456E64446174652E79656172282920293B0D0A202020202020746869732E7069636B65722E6C65667443616C656E6461722E6D6F6E74682E7365742820276D6F6E7468272C20';
wwv_flow_api.g_varchar2_table(280) := '70546172676574456E64446174652E6D6F6E7468282920293B20200D0A202020207D0D0A20202020656C7365207B0D0A2020202020202F2F7768656E207573696E672074776F2063616C656E646172730D0A2020202020206966202820746869732E6F70';
wwv_flow_api.g_varchar2_table(281) := '74696F6E732E6461746572616E67657069636B65722E6C696E6B656443616C656E646172732029207B0D0A20202020202020202F2F7768656E2063616C656E6461727320617265206C696E6B65640D0A202020202020202069662028200D0A2020202020';
wwv_flow_api.g_varchar2_table(282) := '2020202020705461726765745374617274446174652E6D6F6E74682829203D3D2070546172676574456E64446174652E6D6F6E74682829200D0A20202020202020202020262620705461726765745374617274446174652E796561722829203D3D207054';
wwv_flow_api.g_varchar2_table(283) := '6172676574456E64446174652E796561722829200D0A202020202020202029207B0D0A202020202020202020202F2F7768656E20737461727420616E6420656E6420646174652061726520696E207468652073616D65206D6F6E74680D0A202020202020';
wwv_flow_api.g_varchar2_table(284) := '20202020746869732E7069636B65722E6C65667443616C656E6461722E6D6F6E74682E736574282779656172272C2070546172676574456E64446174652E636C6F6E6528292E79656172282920290D0A20202020202020202020746869732E7069636B65';
wwv_flow_api.g_varchar2_table(285) := '722E6C65667443616C656E6461722E6D6F6E74682E73657428276D6F6E7468272C2070546172676574456E64446174652E636C6F6E6528292E6D6F6E7468282920290D0A0D0A20202020202020202020746869732E7069636B65722E726967687443616C';
wwv_flow_api.g_varchar2_table(286) := '656E6461722E6D6F6E74682E736574282779656172272C2070546172676574456E64446174652E636C6F6E6528292E61646428312C20276D6F6E746827292E79656172282920290D0A20202020202020202020746869732E7069636B65722E7269676874';
wwv_flow_api.g_varchar2_table(287) := '43616C656E6461722E6D6F6E74682E73657428276D6F6E7468272C2070546172676574456E64446174652E636C6F6E6528292E61646428312C20276D6F6E746827292E6D6F6E7468282920290D0A0D0A20202020202020207D0D0A202020202020202065';
wwv_flow_api.g_varchar2_table(288) := '6C7365207B0D0A202020202020202020202F2F7768656E20737461727420616E6420616E6420646174652061726520696E20646966666572656E74206D6F6E7468730D0A20202020202020202020746869732E7069636B65722E6C65667443616C656E64';
wwv_flow_api.g_varchar2_table(289) := '61722E6D6F6E74682E736574282779656172272C2070546172676574456E64446174652E636C6F6E6528292E737562747261637428312C20276D6F6E746827292E79656172282920290D0A20202020202020202020746869732E7069636B65722E6C6566';
wwv_flow_api.g_varchar2_table(290) := '7443616C656E6461722E6D6F6E74682E73657428276D6F6E7468272C2070546172676574456E64446174652E636C6F6E6528292E737562747261637428312C20276D6F6E746827292E6D6F6E7468282920290D0A0D0A2020202020202020202074686973';
wwv_flow_api.g_varchar2_table(291) := '2E7069636B65722E726967687443616C656E6461722E6D6F6E74682E736574282779656172272C2070546172676574456E64446174652E79656172282920290D0A20202020202020202020746869732E7069636B65722E726967687443616C656E646172';
wwv_flow_api.g_varchar2_table(292) := '2E6D6F6E74682E73657428276D6F6E7468272C2070546172676574456E64446174652E6D6F6E7468282920290D0A20202020202020207D0D0A2020202020207D0D0A202020202020656C7365207B200D0A20202020202020202F2F7768656E2063616C65';
wwv_flow_api.g_varchar2_table(293) := '6E6461727320617265206E6F74206C696E6B65640D0A0D0A2020202020202020696620280D0A20202020202020202020705461726765745374617274446174652E6D6F6E74682829203D3D2070546172676574456E64446174652E6D6F6E74682829200D';
wwv_flow_api.g_varchar2_table(294) := '0A20202020202020202020262620705461726765745374617274446174652E796561722829203D3D2070546172676574456E64446174652E796561722829200D0A202020202020202029207B0D0A202020202020202020202F2F7768656E207374617274';
wwv_flow_api.g_varchar2_table(295) := '20616E6420656E6420646174652061726520696E207468652073616D65206D6F6E74680D0A20202020202020202020746869732E7069636B65722E6C65667443616C656E6461722E6D6F6E74682E736574282779656172272C2070546172676574456E64';
wwv_flow_api.g_varchar2_table(296) := '446174652E636C6F6E6528292E79656172282920290D0A20202020202020202020746869732E7069636B65722E6C65667443616C656E6461722E6D6F6E74682E73657428276D6F6E7468272C2070546172676574456E64446174652E636C6F6E6528292E';
wwv_flow_api.g_varchar2_table(297) := '6D6F6E7468282920290D0A0D0A20202020202020202020746869732E7069636B65722E726967687443616C656E6461722E6D6F6E74682E736574282779656172272C2070546172676574456E64446174652E636C6F6E6528292E61646428312C20276D6F';
wwv_flow_api.g_varchar2_table(298) := '6E746827292E79656172282920290D0A20202020202020202020746869732E7069636B65722E726967687443616C656E6461722E6D6F6E74682E73657428276D6F6E7468272C2070546172676574456E64446174652E636C6F6E6528292E61646428312C';
wwv_flow_api.g_varchar2_table(299) := '20276D6F6E746827292E6D6F6E7468282920290D0A0D0A20202020202020207D200D0A2020202020202020656C7365207B0D0A202020202020202020202F2F7768656E20737461727420616E6420616E6420646174652061726520696E20646966666572';
wwv_flow_api.g_varchar2_table(300) := '656E74206D6F6E7468730D0A20202020202020202020746869732E7069636B65722E6C65667443616C656E6461722E6D6F6E74682E736574282779656172272C20705461726765745374617274446174652E79656172282920290D0A2020202020202020';
wwv_flow_api.g_varchar2_table(301) := '2020746869732E7069636B65722E6C65667443616C656E6461722E6D6F6E74682E73657428276D6F6E7468272C20705461726765745374617274446174652E6D6F6E7468282920290D0A202020202020202020200D0A2020202020202020202074686973';
wwv_flow_api.g_varchar2_table(302) := '2E7069636B65722E726967687443616C656E6461722E6D6F6E74682E736574282779656172272C2070546172676574456E64446174652E79656172282920290D0A20202020202020202020746869732E7069636B65722E726967687443616C656E646172';
wwv_flow_api.g_varchar2_table(303) := '2E6D6F6E74682E73657428276D6F6E7468272C2070546172676574456E64446174652E6D6F6E7468282920290D0A0D0A20202020202020207D0D0A0D0A2020202020207D2020202020200D0A202020207D0D0A0D0A20202020746869732E7069636B6572';
wwv_flow_api.g_varchar2_table(304) := '2E72656E64657243616C656E64617228276C65667427293B0D0A20202020746869732E7069636B65722E72656E64657243616C656E6461722827726967687427293B0D0A0D0A20207D2C0D0A0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(305) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20205F6F766572';
wwv_flow_api.g_varchar2_table(306) := '6C61795F75706461746544617465546F5F696E7075743A2066756E6374696F6E2820652029207B0D0A202020202F2F636F6E736F6C652E6C6F6728275F6F7665726C61795F75706461746544617465546F5F696E70757427293B0D0A2020202076617220';
wwv_flow_api.g_varchar2_table(307) := '0D0A20202020202064617465203D20746869732E6765744461746546726F6D43616C656E64617228202428652E7461726765742920292C0D0A202020202020666F726D6174203D20746869732E6F7074696F6E732E6461746572616E67657069636B6572';
wwv_flow_api.g_varchar2_table(308) := '2E6C6F63616C652E666F726D61743B0D0A0D0A20202020746869732E7069636B65722E636F6E7461696E65722E66696E6428272E64617465546F203A696E70757427292E76616C2820646174652E666F726D61742820666F726D6174202920293B0D0A0D';
wwv_flow_api.g_varchar2_table(309) := '0A20202020652E70726576656E7444656661756C7428293B0D0A20202020652E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A0D0A20207D2C0D0A20205F6F7665726C61795F64617465546F53686F775F666F72636544617465';
wwv_flow_api.g_varchar2_table(310) := '546F53656C656374696F6E3A2066756E6374696F6E28206520297B0D0A202020202F2F636F6E736F6C652E6C6F6728275F6F7665726C61795F64617465546F53686F775F666F72636544617465546F53656C656374696F6E27293B0D0A0D0A2020202076';
wwv_flow_api.g_varchar2_table(311) := '6172200D0A202020202020746172676574537461727444617465203D20746869732E6765744D6F6D656E7446726F6D537472696E674C6F63616C65466F726D61742820746869732E656C656D656E742E76616C282920292C0D0A20202020202074617267';
wwv_flow_api.g_varchar2_table(312) := '6574456E6444617465203D20746869732E6765744461746546726F6D43616C656E64617228202428652E7461726765742920293B0D0A0D0A20202020652E70726576656E7444656661756C7428293B0D0A20202020652E73746F70496D6D656469617465';
wwv_flow_api.g_varchar2_table(313) := '50726F7061676174696F6E28293B0D0A0D0A202020206966202820746172676574456E64446174652E69734265666F7265282074617267657453746172744461746520292029207B0D0A2020202020202F2F776F726B61726F756E642061742074686520';
wwv_flow_api.g_varchar2_table(314) := '6D6F6D656E742E2053686F756C64206265206368616E67656420696E206E6578742076657273696F6E730D0A2020202020202428652E746172676574292E616464436C61737328276F64642064697361626C656427293B0D0A2020202020207265747572';
wwv_flow_api.g_varchar2_table(315) := '6E3B0D0A202020207D0D0A20202020656C7365207B0D0A2020202020202F2F636F6E736F6C652E6C6F6728202777796272616E612064617461206A65737420706F20616B7475616C6E656A2720293B200D0A202020207D0D0A0D0A20202020746869732E';
wwv_flow_api.g_varchar2_table(316) := '7069636B65722E736574537461727444617465282074617267657453746172744461746520293B0D0A20202020746869732E7069636B65722E736574456E64446174652820746172676574456E644461746520293B0D0A0D0A20202020746869732E5F75';
wwv_flow_api.g_varchar2_table(317) := '706461746543616C656E6461725669657728207461726765745374617274446174652C20746172676574456E644461746520293B0D0A0D0A20202020746869732E7069636B65722E72656E64657243616C656E64617228276C65667427293B0D0A202020';
wwv_flow_api.g_varchar2_table(318) := '20746869732E7069636B65722E72656E64657243616C656E6461722827726967687427293B0D0A0D0A20202020746869732E7069636B65722E636F6E7461696E65722E66696E6428272E63616C656E64617220746427290D0A2020202020202E62696E64';
wwv_flow_api.g_varchar2_table(319) := '2820276D6F757365646F776E2E7465737420636C69636B2E746573742720202C20242E70726F78792820746869732E5F6F7665726C61795F64617465546F53686F775F666F72636544617465546F53656C656374696F6E20202C2074686973202920290D';
wwv_flow_api.g_varchar2_table(320) := '0A2020202020202E62696E642820276D6F757365656E7465722E6461746572616E67657069636B657227202C20242E70726F78792820746869732E5F6F7665726C61795F75706461746544617465546F5F696E7075742020202020202020202020202020';
wwv_flow_api.g_varchar2_table(321) := '202C2074686973202920293B0D0A0D0A202020206966202820746869732E6F7074696F6E732E6461746572616E67657069636B65722E6175746F4170706C792029207B0D0A202020202020746869732E7069636B65722E63616C63756C61746543686F73';
wwv_flow_api.g_varchar2_table(322) := '656E4C6162656C28293B0D0A202020202020746869732E7069636B65722E636C69636B4170706C7928293B202020202020202020200D0A202020207D0D0A20207D2C0D0A0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(323) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20205F6F7665726C61794170706C79';
wwv_flow_api.g_varchar2_table(324) := '3A2066756E6374696F6E28704576656E7429207B0D0A202020202F2F636F6E736F6C652E6C6F672820275F6F7665726C61794170706C792720293B0D0A20202020766172200D0A202020202020666F726D6174203D20746869732E6F7074696F6E732E64';
wwv_flow_api.g_varchar2_table(325) := '61746572616E67657069636B65722E6C6F63616C652E666F726D61743B0D0A0D0A20202020746869732E656C656D656E742E76616C2820746869732E7069636B65722E7374617274446174652E666F726D61742820666F726D6174202920293B0D0A2020';
wwv_flow_api.g_varchar2_table(326) := '2020746869732E64617465546F2E6974656D2E76616C2820746869732E7069636B65722E656E64446174652E666F726D61742820666F726D6174202920293B0D0A0D0A202020200D0A20207D2C0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(327) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20205F6F7665';
wwv_flow_api.g_varchar2_table(328) := '726C617943616E63656C3A2066756E6374696F6E28704576656E7429207B0D0A202020202F2F0D0A20207D2C0D0A0D0A20202F2F0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(329) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202F2F0D0A20206765744D6F6D656E7446726F6D537472696E674C6F63616C65466F726D61743A206675';
wwv_flow_api.g_varchar2_table(330) := '6E6374696F6E2820737472696E6720297B0D0A2020202072657475726E206D6F6D656E742820737472696E67202C20746869732E6F7074696F6E732E6461746572616E67657069636B65722E6C6F63616C652E666F726D617420293B202020200D0A2020';
wwv_flow_api.g_varchar2_table(331) := '7D2C0D0A0D0A20206765744461746546726F6D43616C656E6461723A2066756E6374696F6E2820656C656D2C2063616C656E6461722029207B0D0A20202020766172200D0A2020202020207464436C69636B6564203D20656C656D2C0D0A202020202020';
wwv_flow_api.g_varchar2_table(332) := '7469746C65203D207464436C69636B65642E617474722827646174612D7469746C6527292C0D0A202020202020726F77203D207469746C652E73756273747228312C2031292C0D0A202020202020636F6C203D207469746C652E73756273747228332C20';
wwv_flow_api.g_varchar2_table(333) := '31292C0D0A20202020202063616C203D2063616C656E646172203D3D20756E646566696E6564203F207464436C69636B65642E706172656E747328272E63616C656E6461722729203A2063616C656E6461722C0D0A20202020202064617465203D206361';
wwv_flow_api.g_varchar2_table(334) := '6C2E686173436C61737328276C6566742729203F20746869732E7069636B65722E6C65667443616C656E6461722E63616C656E6461725B726F775D5B636F6C5D203A20746869732E7069636B65722E726967687443616C656E6461722E63616C656E6461';
wwv_flow_api.g_varchar2_table(335) := '725B726F775D5B636F6C5D3B0D0A0D0A2020202072657475726E20646174652E636C6F6E6528293B0D0A20207D2C0D0A0D0A20206765744D696E4D61784461746546726F6D537472696E673A2066756E6374696F6E2820737472696E67546F4461746520';
wwv_flow_api.g_varchar2_table(336) := '297B0D0A2020202076617220666F726D61746564446174653B0D0A0D0A202020206966202820737472696E67546F44617465203D3D2027746F646179272029207B0D0A202020202020666F726D6174656444617465203D206D6F6D656E7428293B0D0A20';
wwv_flow_api.g_varchar2_table(337) := '2020207D0D0A20202020656C73652069662028202F5C647B347D2D5C647B327D2D5C647B327D2F2E746573742820737472696E67546F4461746520292029207B0D0A202020202020666F726D6174656444617465203D206D6F6D656E742820737472696E';
wwv_flow_api.g_varchar2_table(338) := '67546F446174652C2027595959592D4D4D2D44442720293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020666F726D6174656444617465203D20746869732E63616C63756C6174654D6F6D656E7446726F6D5061747465726E282073';
wwv_flow_api.g_varchar2_table(339) := '7472696E67546F4461746520293B0D0A202020207D0D0A0D0A2020202072657475726E20666F726D61746564446174653B0D0A20207D2C0D0A0D0A202063616C63756C6174654D6F6D656E7446726F6D5061747465726E3A2066756E6374696F6E282073';
wwv_flow_api.g_varchar2_table(340) := '7472696E672C2072657475726E496E466F726D61742029207B0D0A20202020766172200D0A2020202020207265203D202F285B5C2B2D5D7B317D5C647B312C7D5B797C6D7C647C775D7B317D292F672C0D0A2020202020206D6174636865732C0D0A2020';
wwv_flow_api.g_varchar2_table(341) := '202020206D617463686564203D205B5D2C0D0A2020202020206465737444617465203D206D6F6D656E7428292E73746172744F66282764617927292C0D0A20202020202065787072657373696F6E2C0D0A2020202020206F7065726174696F6E2C0D0A20';
wwv_flow_api.g_varchar2_table(342) := '2020202020686F774D616E792C0D0A202020202020756E69743B0D0A0D0A202020207768696C652028286D617463686573203D2072652E6578656328737472696E67292920213D206E756C6C29207B0D0A2020202020206D6174636865642E7075736828';
wwv_flow_api.g_varchar2_table(343) := '6D6174636865735B315D293B0D0A202020207D0D0A0D0A20202020666F722028207661722069203D20303B2069203C206D6174636865642E6C656E6774683B20692B2B29207B0D0A20202020202065787072657373696F6E203D206D6174636865645B69';
wwv_flow_api.g_varchar2_table(344) := '5D3B0D0A2020202020206F7065726174696F6E203D2065787072657373696F6E2E73756273747228302C2031292C0D0A202020202020686F774D616E79203D207061727365496E74282065787072657373696F6E2E73756273747228312C206578707265';
wwv_flow_api.g_varchar2_table(345) := '7373696F6E2E6C656E6774682920292C0D0A202020202020756E6974203D2065787072657373696F6E2E737562737472282D312C2065787072657373696F6E2E6C656E677468293B0D0A0D0A2020202020206966202820756E6974203D3D20276D272029';
wwv_flow_api.g_varchar2_table(346) := '207B0D0A2020202020202020756E6974203D20274D273B0D0A2020202020207D0D0A0D0A20202020202069662028206F7065726174696F6E203D3D20272B272029207B0D0A202020202020202064657374446174652E6164642820686F774D616E792C20';
wwv_flow_api.g_varchar2_table(347) := '756E697420293B0D0A2020202020207D656C7365207B0D0A202020202020202064657374446174652E73756274726163742820686F774D616E792C20756E697420293B0D0A2020202020207D0D0A202020207D0D0A0D0A20202020696620282072657475';
wwv_flow_api.g_varchar2_table(348) := '726E496E466F726D6174203D3D2066616C7365207C7C2072657475726E496E466F726D6174203D3D20756E646566696E65642029207B0D0A20202020202072657475726E2064657374446174653B20200D0A202020207D0D0A20202020656C7365207B0D';
wwv_flow_api.g_varchar2_table(349) := '0A20202020202072657475726E2064657374446174652E666F726D61742820746869732E6F7074696F6E732E6461746572616E67657069636B65722E6C6F63616C652E666F726D617420290D0A202020207D0D0A202020200D0A20207D2C0D0A20202F2F';
wwv_flow_api.g_varchar2_table(350) := '0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D444F205554594C495A41434A490D0A20202F2F0D0A0D0A0D0A7D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(173819119754705446)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_file_name=>'pretiusapexdaterangepicker.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A2A0A2A204076657273696F6E3A20322E312E32340A2A2040617574686F723A2044616E2047726F73736D616E20687474703A2F2F7777772E64616E67726F73736D616E2E696E666F2F0A2A2040636F707972696768743A20436F7079726967687420';
wwv_flow_api.g_varchar2_table(2) := '28632920323031322D323031362044616E2047726F73736D616E2E20416C6C207269676874732072657365727665642E0A2A20406C6963656E73653A204C6963656E73656420756E64657220746865204D4954206C6963656E73652E2053656520687474';
wwv_flow_api.g_varchar2_table(3) := '703A2F2F7777772E6F70656E736F757263652E6F72672F6C6963656E7365732F6D69742D6C6963656E73652E7068700A2A2040776562736974653A2068747470733A2F2F7777772E696D70726F76656C792E636F6D2F0A2A2F0A2F2F20466F6C6C6F7720';
wwv_flow_api.g_varchar2_table(4) := '74686520554D442074656D706C6174652068747470733A2F2F6769746875622E636F6D2F756D646A732F756D642F626C6F622F6D61737465722F74656D706C617465732F72657475726E4578706F727473476C6F62616C2E6A730A2866756E6374696F6E';
wwv_flow_api.g_varchar2_table(5) := '2028726F6F742C20666163746F727929207B0A2020202069662028747970656F6620646566696E65203D3D3D202766756E6374696F6E2720262620646566696E652E616D6429207B0A20202020202020202F2F20414D442E204D616B6520676C6F62616C';
wwv_flow_api.g_varchar2_table(6) := '7920617661696C61626C652061732077656C6C0A2020202020202020646566696E65285B276D6F6D656E74272C20276A7175657279275D2C2066756E6374696F6E20286D6F6D656E742C206A717565727929207B0A202020202020202020202020726574';
wwv_flow_api.g_varchar2_table(7) := '75726E2028726F6F742E6461746572616E67657069636B6572203D20666163746F7279286D6F6D656E742C206A717565727929293B0A20202020202020207D293B0A202020207D20656C73652069662028747970656F66206D6F64756C65203D3D3D2027';
wwv_flow_api.g_varchar2_table(8) := '6F626A65637427202626206D6F64756C652E6578706F72747329207B0A20202020202020202F2F204E6F6465202F2042726F777365726966790A20202020202020202F2F69736F6D6F72706869632069737375650A2020202020202020766172206A5175';
wwv_flow_api.g_varchar2_table(9) := '657279203D2028747970656F662077696E646F7720213D2027756E646566696E65642729203F2077696E646F772E6A5175657279203A20756E646566696E65643B0A202020202020202069662028216A517565727929207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(10) := '206A5175657279203D207265717569726528276A717565727927293B0A20202020202020202020202069662028216A51756572792E666E29206A51756572792E666E203D207B7D3B0A20202020202020207D0A20202020202020206D6F64756C652E6578';
wwv_flow_api.g_varchar2_table(11) := '706F727473203D20666163746F7279287265717569726528276D6F6D656E7427292C206A5175657279293B0A202020207D20656C7365207B0A20202020202020202F2F2042726F7773657220676C6F62616C730A2020202020202020726F6F742E646174';
wwv_flow_api.g_varchar2_table(12) := '6572616E67657069636B6572203D20666163746F727928726F6F742E6D6F6D656E742C20726F6F742E6A5175657279293B0A202020207D0A7D28746869732C2066756E6374696F6E286D6F6D656E742C202429207B0A2020202076617220446174655261';
wwv_flow_api.g_varchar2_table(13) := '6E67655069636B6572203D2066756E6374696F6E28656C656D656E742C206F7074696F6E732C20636229207B0A0A20202020202020202F2F64656661756C742073657474696E677320666F72206F7074696F6E730A2020202020202020746869732E7061';
wwv_flow_api.g_varchar2_table(14) := '72656E74456C203D2027626F6479273B0A2020202020202020746869732E656C656D656E74203D202428656C656D656E74293B0A2020202020202020746869732E737461727444617465203D206D6F6D656E7428292E73746172744F6628276461792729';
wwv_flow_api.g_varchar2_table(15) := '3B0A2020202020202020746869732E656E6444617465203D206D6F6D656E7428292E656E644F66282764617927293B0A2020202020202020746869732E6D696E44617465203D2066616C73653B0A2020202020202020746869732E6D617844617465203D';
wwv_flow_api.g_varchar2_table(16) := '2066616C73653B0A2020202020202020746869732E646174654C696D6974203D2066616C73653B0A2020202020202020746869732E6175746F4170706C79203D2066616C73653B0A2020202020202020746869732E73696E676C65446174655069636B65';
wwv_flow_api.g_varchar2_table(17) := '72203D2066616C73653B0A2020202020202020746869732E73686F7744726F70646F776E73203D2066616C73653B0A2020202020202020746869732E73686F775765656B4E756D62657273203D2066616C73653B0A2020202020202020746869732E7368';
wwv_flow_api.g_varchar2_table(18) := '6F7749534F5765656B4E756D62657273203D2066616C73653B0A2020202020202020746869732E73686F77437573746F6D52616E67654C6162656C203D20747275653B0A2020202020202020746869732E74696D655069636B6572203D2066616C73653B';
wwv_flow_api.g_varchar2_table(19) := '0A2020202020202020746869732E74696D655069636B65723234486F7572203D2066616C73653B0A2020202020202020746869732E74696D655069636B6572496E6372656D656E74203D20313B0A2020202020202020746869732E74696D655069636B65';
wwv_flow_api.g_varchar2_table(20) := '725365636F6E6473203D2066616C73653B0A2020202020202020746869732E6C696E6B656443616C656E64617273203D20747275653B0A2020202020202020746869732E6175746F557064617465496E707574203D20747275653B0A2020202020202020';
wwv_flow_api.g_varchar2_table(21) := '746869732E616C7761797353686F7743616C656E64617273203D2066616C73653B0A2020202020202020746869732E72616E676573203D207B7D3B0A0A2020202020202020746869732E6F70656E73203D20277269676874273B0A202020202020202069';
wwv_flow_api.g_varchar2_table(22) := '662028746869732E656C656D656E742E686173436C617373282770756C6C2D72696768742729290A202020202020202020202020746869732E6F70656E73203D20276C656674273B0A0A2020202020202020746869732E64726F7073203D2027646F776E';
wwv_flow_api.g_varchar2_table(23) := '273B0A202020202020202069662028746869732E656C656D656E742E686173436C617373282764726F7075702729290A202020202020202020202020746869732E64726F7073203D20277570273B0A0A2020202020202020746869732E627574746F6E43';
wwv_flow_api.g_varchar2_table(24) := '6C6173736573203D202762746E2062746E2D736D273B0A2020202020202020746869732E6170706C79436C617373203D202762746E2D73756363657373273B0A2020202020202020746869732E63616E63656C436C617373203D202762746E2D64656661';
wwv_flow_api.g_varchar2_table(25) := '756C74273B0A0A2020202020202020746869732E6C6F63616C65203D207B0A202020202020202020202020646972656374696F6E3A20276C7472272C0A202020202020202020202020666F726D61743A20274D4D2F44442F59595959272C0A2020202020';
wwv_flow_api.g_varchar2_table(26) := '20202020202020736570617261746F723A2027202D20272C0A2020202020202020202020206170706C794C6162656C3A20274170706C79272C0A20202020202020202020202063616E63656C4C6162656C3A202743616E63656C272C0A20202020202020';
wwv_flow_api.g_varchar2_table(27) := '20202020207765656B4C6162656C3A202757272C0A202020202020202020202020637573746F6D52616E67654C6162656C3A2027437573746F6D2052616E6765272C0A202020202020202020202020646179734F665765656B3A206D6F6D656E742E7765';
wwv_flow_api.g_varchar2_table(28) := '656B646179734D696E28292C0A2020202020202020202020206D6F6E74684E616D65733A206D6F6D656E742E6D6F6E74687353686F727428292C0A20202020202020202020202066697273744461793A206D6F6D656E742E6C6F63616C65446174612829';
wwv_flow_api.g_varchar2_table(29) := '2E66697273744461794F665765656B28290A20202020202020207D3B0A0A2020202020202020746869732E63616C6C6261636B203D2066756E6374696F6E2829207B207D3B0A0A20202020202020202F2F736F6D6520737461746520696E666F726D6174';
wwv_flow_api.g_varchar2_table(30) := '696F6E0A2020202020202020746869732E697353686F77696E67203D2066616C73653B0A2020202020202020746869732E6C65667443616C656E646172203D207B7D3B0A2020202020202020746869732E726967687443616C656E646172203D207B7D3B';
wwv_flow_api.g_varchar2_table(31) := '0A0A20202020202020202F2F637573746F6D206F7074696F6E732066726F6D20757365720A202020202020202069662028747970656F66206F7074696F6E7320213D3D20276F626A65637427207C7C206F7074696F6E73203D3D3D206E756C6C290A2020';
wwv_flow_api.g_varchar2_table(32) := '202020202020202020206F7074696F6E73203D207B7D3B0A0A20202020202020202F2F616C6C6F772073657474696E67206F7074696F6E732077697468206461746120617474726962757465730A20202020202020202F2F646174612D617069206F7074';
wwv_flow_api.g_varchar2_table(33) := '696F6E732077696C6C206265206F7665727772697474656E207769746820637573746F6D206A617661736372697074206F7074696F6E730A20202020202020206F7074696F6E73203D20242E657874656E6428746869732E656C656D656E742E64617461';
wwv_flow_api.g_varchar2_table(34) := '28292C206F7074696F6E73293B0A0A20202020202020202F2F68746D6C2074656D706C61746520666F7220746865207069636B65722055490A202020202020202069662028747970656F66206F7074696F6E732E74656D706C61746520213D3D20277374';
wwv_flow_api.g_varchar2_table(35) := '72696E67272026262021286F7074696F6E732E74656D706C61746520696E7374616E63656F66202429290A2020202020202020202020206F7074696F6E732E74656D706C617465203D20273C64697620636C6173733D226461746572616E67657069636B';
wwv_flow_api.g_varchar2_table(36) := '65722064726F70646F776E2D6D656E75223E27202B0A20202020202020202020202020202020273C64697620636C6173733D2263616C656E646172206C656674223E27202B0A2020202020202020202020202020202020202020273C64697620636C6173';
wwv_flow_api.g_varchar2_table(37) := '733D226461746572616E67657069636B65725F696E707574223E27202B0A20202020202020202020202020202020202020202020273C696E70757420636C6173733D22696E7075742D6D696E6920666F726D2D636F6E74726F6C2220747970653D227465';
wwv_flow_api.g_varchar2_table(38) := '787422206E616D653D226461746572616E67657069636B65725F7374617274222076616C75653D2222202F3E27202B0A20202020202020202020202020202020202020202020273C6920636C6173733D2266612066612D63616C656E64617220676C7970';
wwv_flow_api.g_varchar2_table(39) := '6869636F6E20676C79706869636F6E2D63616C656E646172223E3C2F693E27202B0A20202020202020202020202020202020202020202020273C64697620636C6173733D2263616C656E6461722D74696D65223E27202B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '202020202020202020202020273C6469763E3C2F6469763E27202B0A202020202020202020202020202020202020202020202020273C6920636C6173733D2266612066612D636C6F636B2D6F20676C79706869636F6E20676C79706869636F6E2D74696D';
wwv_flow_api.g_varchar2_table(41) := '65223E3C2F693E27202B0A20202020202020202020202020202020202020202020273C2F6469763E27202B0A2020202020202020202020202020202020202020273C2F6469763E27202B0A2020202020202020202020202020202020202020273C646976';
wwv_flow_api.g_varchar2_table(42) := '20636C6173733D2263616C656E6461722D7461626C65223E3C2F6469763E27202B0A20202020202020202020202020202020273C2F6469763E27202B0A20202020202020202020202020202020273C64697620636C6173733D2263616C656E6461722072';
wwv_flow_api.g_varchar2_table(43) := '69676874223E27202B0A2020202020202020202020202020202020202020273C64697620636C6173733D226461746572616E67657069636B65725F696E707574223E27202B0A20202020202020202020202020202020202020202020273C696E70757420';
wwv_flow_api.g_varchar2_table(44) := '636C6173733D22696E7075742D6D696E6920666F726D2D636F6E74726F6C2220747970653D227465787422206E616D653D226461746572616E67657069636B65725F656E64222076616C75653D2222202F3E27202B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(45) := '2020202020202020273C6920636C6173733D2266612066612D63616C656E64617220676C79706869636F6E20676C79706869636F6E2D63616C656E646172223E3C2F693E27202B0A20202020202020202020202020202020202020202020273C64697620';
wwv_flow_api.g_varchar2_table(46) := '636C6173733D2263616C656E6461722D74696D65223E27202B0A202020202020202020202020202020202020202020202020273C6469763E3C2F6469763E27202B0A202020202020202020202020202020202020202020202020273C6920636C6173733D';
wwv_flow_api.g_varchar2_table(47) := '2266612066612D636C6F636B2D6F20676C79706869636F6E20676C79706869636F6E2D74696D65223E3C2F693E27202B0A20202020202020202020202020202020202020202020273C2F6469763E27202B0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(48) := '2020273C2F6469763E27202B0A2020202020202020202020202020202020202020273C64697620636C6173733D2263616C656E6461722D7461626C65223E3C2F6469763E27202B0A20202020202020202020202020202020273C2F6469763E27202B0A20';
wwv_flow_api.g_varchar2_table(49) := '202020202020202020202020202020273C64697620636C6173733D2272616E676573223E27202B0A2020202020202020202020202020202020202020273C64697620636C6173733D2272616E67655F696E70757473223E27202B0A202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '202020202020202020202020202020273C627574746F6E20636C6173733D226170706C7942746E222064697361626C65643D2264697361626C65642220747970653D22627574746F6E223E3C2F627574746F6E3E2027202B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '20202020202020202020202020273C627574746F6E20636C6173733D2263616E63656C42746E2220747970653D22627574746F6E223E3C2F627574746F6E3E27202B0A2020202020202020202020202020202020202020273C2F6469763E27202B0A2020';
wwv_flow_api.g_varchar2_table(52) := '2020202020202020202020202020273C2F6469763E27202B0A202020202020202020202020273C2F6469763E273B0A0A2020202020202020746869732E706172656E74456C203D20286F7074696F6E732E706172656E74456C2026262024286F7074696F';
wwv_flow_api.g_varchar2_table(53) := '6E732E706172656E74456C292E6C656E67746829203F2024286F7074696F6E732E706172656E74456C29203A202428746869732E706172656E74456C293B0A2020202020202020746869732E636F6E7461696E6572203D2024286F7074696F6E732E7465';
wwv_flow_api.g_varchar2_table(54) := '6D706C617465292E617070656E64546F28746869732E706172656E74456C293B0A0A20202020202020202F2F0A20202020202020202F2F2068616E646C6520616C6C2074686520706F737369626C65206F7074696F6E73206F766572726964696E672064';
wwv_flow_api.g_varchar2_table(55) := '656661756C74730A20202020202020202F2F0A0A202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C65203D3D3D20276F626A6563742729207B0A0A20202020202020202020202069662028747970656F66206F7074696F6E';
wwv_flow_api.g_varchar2_table(56) := '732E6C6F63616C652E646972656374696F6E203D3D3D2027737472696E6727290A20202020202020202020202020202020746869732E6C6F63616C652E646972656374696F6E203D206F7074696F6E732E6C6F63616C652E646972656374696F6E3B0A0A';
wwv_flow_api.g_varchar2_table(57) := '20202020202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C652E666F726D6174203D3D3D2027737472696E6727290A20202020202020202020202020202020746869732E6C6F63616C652E666F726D6174203D206F707469';
wwv_flow_api.g_varchar2_table(58) := '6F6E732E6C6F63616C652E666F726D61743B0A0A20202020202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C652E736570617261746F72203D3D3D2027737472696E6727290A202020202020202020202020202020207468';
wwv_flow_api.g_varchar2_table(59) := '69732E6C6F63616C652E736570617261746F72203D206F7074696F6E732E6C6F63616C652E736570617261746F723B0A0A20202020202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C652E646179734F665765656B203D3D';
wwv_flow_api.g_varchar2_table(60) := '3D20276F626A65637427290A20202020202020202020202020202020746869732E6C6F63616C652E646179734F665765656B203D206F7074696F6E732E6C6F63616C652E646179734F665765656B2E736C69636528293B0A0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(61) := '2069662028747970656F66206F7074696F6E732E6C6F63616C652E6D6F6E74684E616D6573203D3D3D20276F626A65637427290A2020202020202020202020202020746869732E6C6F63616C652E6D6F6E74684E616D6573203D206F7074696F6E732E6C';
wwv_flow_api.g_varchar2_table(62) := '6F63616C652E6D6F6E74684E616D65732E736C69636528293B0A0A20202020202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C652E6669727374446179203D3D3D20276E756D62657227290A202020202020202020202020';
wwv_flow_api.g_varchar2_table(63) := '2020746869732E6C6F63616C652E6669727374446179203D206F7074696F6E732E6C6F63616C652E66697273744461793B0A0A20202020202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C652E6170706C794C6162656C20';
wwv_flow_api.g_varchar2_table(64) := '3D3D3D2027737472696E6727290A2020202020202020202020202020746869732E6C6F63616C652E6170706C794C6162656C203D206F7074696F6E732E6C6F63616C652E6170706C794C6162656C3B0A0A20202020202020202020202069662028747970';
wwv_flow_api.g_varchar2_table(65) := '656F66206F7074696F6E732E6C6F63616C652E63616E63656C4C6162656C203D3D3D2027737472696E6727290A2020202020202020202020202020746869732E6C6F63616C652E63616E63656C4C6162656C203D206F7074696F6E732E6C6F63616C652E';
wwv_flow_api.g_varchar2_table(66) := '63616E63656C4C6162656C3B0A0A20202020202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C652E7765656B4C6162656C203D3D3D2027737472696E6727290A2020202020202020202020202020746869732E6C6F63616C';
wwv_flow_api.g_varchar2_table(67) := '652E7765656B4C6162656C203D206F7074696F6E732E6C6F63616C652E7765656B4C6162656C3B0A0A20202020202020202020202069662028747970656F66206F7074696F6E732E6C6F63616C652E637573746F6D52616E67654C6162656C203D3D3D20';
wwv_flow_api.g_varchar2_table(68) := '27737472696E6727290A2020202020202020202020202020746869732E6C6F63616C652E637573746F6D52616E67654C6162656C203D206F7074696F6E732E6C6F63616C652E637573746F6D52616E67654C6162656C3B0A0A20202020202020207D0A20';
wwv_flow_api.g_varchar2_table(69) := '20202020202020746869732E636F6E7461696E65722E616464436C61737328746869732E6C6F63616C652E646972656374696F6E293B0A0A202020202020202069662028747970656F66206F7074696F6E732E737461727444617465203D3D3D20277374';
wwv_flow_api.g_varchar2_table(70) := '72696E6727290A202020202020202020202020746869732E737461727444617465203D206D6F6D656E74286F7074696F6E732E7374617274446174652C20746869732E6C6F63616C652E666F726D6174293B0A0A20202020202020206966202874797065';
wwv_flow_api.g_varchar2_table(71) := '6F66206F7074696F6E732E656E6444617465203D3D3D2027737472696E6727290A202020202020202020202020746869732E656E6444617465203D206D6F6D656E74286F7074696F6E732E656E64446174652C20746869732E6C6F63616C652E666F726D';
wwv_flow_api.g_varchar2_table(72) := '6174293B0A0A202020202020202069662028747970656F66206F7074696F6E732E6D696E44617465203D3D3D2027737472696E6727290A202020202020202020202020746869732E6D696E44617465203D206D6F6D656E74286F7074696F6E732E6D696E';
wwv_flow_api.g_varchar2_table(73) := '446174652C20746869732E6C6F63616C652E666F726D6174293B0A0A202020202020202069662028747970656F66206F7074696F6E732E6D617844617465203D3D3D2027737472696E6727290A202020202020202020202020746869732E6D6178446174';
wwv_flow_api.g_varchar2_table(74) := '65203D206D6F6D656E74286F7074696F6E732E6D6178446174652C20746869732E6C6F63616C652E666F726D6174293B0A0A202020202020202069662028747970656F66206F7074696F6E732E737461727444617465203D3D3D20276F626A6563742729';
wwv_flow_api.g_varchar2_table(75) := '0A202020202020202020202020746869732E737461727444617465203D206D6F6D656E74286F7074696F6E732E737461727444617465293B0A0A202020202020202069662028747970656F66206F7074696F6E732E656E6444617465203D3D3D20276F62';
wwv_flow_api.g_varchar2_table(76) := '6A65637427290A202020202020202020202020746869732E656E6444617465203D206D6F6D656E74286F7074696F6E732E656E6444617465293B0A0A202020202020202069662028747970656F66206F7074696F6E732E6D696E44617465203D3D3D2027';
wwv_flow_api.g_varchar2_table(77) := '6F626A65637427290A202020202020202020202020746869732E6D696E44617465203D206D6F6D656E74286F7074696F6E732E6D696E44617465293B0A0A202020202020202069662028747970656F66206F7074696F6E732E6D617844617465203D3D3D';
wwv_flow_api.g_varchar2_table(78) := '20276F626A65637427290A202020202020202020202020746869732E6D617844617465203D206D6F6D656E74286F7074696F6E732E6D617844617465293B0A0A20202020202020202F2F2073616E69747920636865636B20666F7220626164206F707469';
wwv_flow_api.g_varchar2_table(79) := '6F6E730A202020202020202069662028746869732E6D696E4461746520262620746869732E7374617274446174652E69734265666F726528746869732E6D696E4461746529290A202020202020202020202020746869732E737461727444617465203D20';
wwv_flow_api.g_varchar2_table(80) := '746869732E6D696E446174652E636C6F6E6528293B0A0A20202020202020202F2F2073616E69747920636865636B20666F7220626164206F7074696F6E730A202020202020202069662028746869732E6D61784461746520262620746869732E656E6444';
wwv_flow_api.g_varchar2_table(81) := '6174652E6973416674657228746869732E6D61784461746529290A202020202020202020202020746869732E656E6444617465203D20746869732E6D6178446174652E636C6F6E6528293B0A0A202020202020202069662028747970656F66206F707469';
wwv_flow_api.g_varchar2_table(82) := '6F6E732E6170706C79436C617373203D3D3D2027737472696E6727290A202020202020202020202020746869732E6170706C79436C617373203D206F7074696F6E732E6170706C79436C6173733B0A0A202020202020202069662028747970656F66206F';
wwv_flow_api.g_varchar2_table(83) := '7074696F6E732E63616E63656C436C617373203D3D3D2027737472696E6727290A202020202020202020202020746869732E63616E63656C436C617373203D206F7074696F6E732E63616E63656C436C6173733B0A0A2020202020202020696620287479';
wwv_flow_api.g_varchar2_table(84) := '70656F66206F7074696F6E732E646174654C696D6974203D3D3D20276F626A65637427290A202020202020202020202020746869732E646174654C696D6974203D206F7074696F6E732E646174654C696D69743B0A0A2020202020202020696620287479';
wwv_flow_api.g_varchar2_table(85) := '70656F66206F7074696F6E732E6F70656E73203D3D3D2027737472696E6727290A202020202020202020202020746869732E6F70656E73203D206F7074696F6E732E6F70656E733B0A0A202020202020202069662028747970656F66206F7074696F6E73';
wwv_flow_api.g_varchar2_table(86) := '2E64726F7073203D3D3D2027737472696E6727290A202020202020202020202020746869732E64726F7073203D206F7074696F6E732E64726F70733B0A0A202020202020202069662028747970656F66206F7074696F6E732E73686F775765656B4E756D';
wwv_flow_api.g_varchar2_table(87) := '62657273203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E73686F775765656B4E756D62657273203D206F7074696F6E732E73686F775765656B4E756D626572733B0A0A202020202020202069662028747970656F6620';
wwv_flow_api.g_varchar2_table(88) := '6F7074696F6E732E73686F7749534F5765656B4E756D62657273203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E73686F7749534F5765656B4E756D62657273203D206F7074696F6E732E73686F7749534F5765656B4E';
wwv_flow_api.g_varchar2_table(89) := '756D626572733B0A0A202020202020202069662028747970656F66206F7074696F6E732E627574746F6E436C6173736573203D3D3D2027737472696E6727290A202020202020202020202020746869732E627574746F6E436C6173736573203D206F7074';
wwv_flow_api.g_varchar2_table(90) := '696F6E732E627574746F6E436C61737365733B0A0A202020202020202069662028747970656F66206F7074696F6E732E627574746F6E436C6173736573203D3D3D20276F626A65637427290A202020202020202020202020746869732E627574746F6E43';
wwv_flow_api.g_varchar2_table(91) := '6C6173736573203D206F7074696F6E732E627574746F6E436C61737365732E6A6F696E28272027293B0A0A202020202020202069662028747970656F66206F7074696F6E732E73686F7744726F70646F776E73203D3D3D2027626F6F6C65616E27290A20';
wwv_flow_api.g_varchar2_table(92) := '2020202020202020202020746869732E73686F7744726F70646F776E73203D206F7074696F6E732E73686F7744726F70646F776E733B0A0A202020202020202069662028747970656F66206F7074696F6E732E73686F77437573746F6D52616E67654C61';
wwv_flow_api.g_varchar2_table(93) := '62656C203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E73686F77437573746F6D52616E67654C6162656C203D206F7074696F6E732E73686F77437573746F6D52616E67654C6162656C3B0A0A20202020202020206966';
wwv_flow_api.g_varchar2_table(94) := '2028747970656F66206F7074696F6E732E73696E676C65446174655069636B6572203D3D3D2027626F6F6C65616E2729207B0A202020202020202020202020746869732E73696E676C65446174655069636B6572203D206F7074696F6E732E73696E676C';
wwv_flow_api.g_varchar2_table(95) := '65446174655069636B65723B0A20202020202020202020202069662028746869732E73696E676C65446174655069636B6572290A20202020202020202020202020202020746869732E656E6444617465203D20746869732E7374617274446174652E636C';
wwv_flow_api.g_varchar2_table(96) := '6F6E6528293B0A20202020202020207D0A0A202020202020202069662028747970656F66206F7074696F6E732E74696D655069636B6572203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E74696D655069636B6572203D';
wwv_flow_api.g_varchar2_table(97) := '206F7074696F6E732E74696D655069636B65723B0A0A202020202020202069662028747970656F66206F7074696F6E732E74696D655069636B65725365636F6E6473203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E74';
wwv_flow_api.g_varchar2_table(98) := '696D655069636B65725365636F6E6473203D206F7074696F6E732E74696D655069636B65725365636F6E64733B0A0A202020202020202069662028747970656F66206F7074696F6E732E74696D655069636B6572496E6372656D656E74203D3D3D20276E';
wwv_flow_api.g_varchar2_table(99) := '756D62657227290A202020202020202020202020746869732E74696D655069636B6572496E6372656D656E74203D206F7074696F6E732E74696D655069636B6572496E6372656D656E743B0A0A202020202020202069662028747970656F66206F707469';
wwv_flow_api.g_varchar2_table(100) := '6F6E732E74696D655069636B65723234486F7572203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E74696D655069636B65723234486F7572203D206F7074696F6E732E74696D655069636B65723234486F75723B0A0A20';
wwv_flow_api.g_varchar2_table(101) := '2020202020202069662028747970656F66206F7074696F6E732E6175746F4170706C79203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E6175746F4170706C79203D206F7074696F6E732E6175746F4170706C793B0A0A';
wwv_flow_api.g_varchar2_table(102) := '202020202020202069662028747970656F66206F7074696F6E732E6175746F557064617465496E707574203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E6175746F557064617465496E707574203D206F7074696F6E73';
wwv_flow_api.g_varchar2_table(103) := '2E6175746F557064617465496E7075743B0A0A202020202020202069662028747970656F66206F7074696F6E732E6C696E6B656443616C656E64617273203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E6C696E6B6564';
wwv_flow_api.g_varchar2_table(104) := '43616C656E64617273203D206F7074696F6E732E6C696E6B656443616C656E646172733B0A0A202020202020202069662028747970656F66206F7074696F6E732E6973496E76616C696444617465203D3D3D202766756E6374696F6E27290A2020202020';
wwv_flow_api.g_varchar2_table(105) := '20202020202020746869732E6973496E76616C696444617465203D206F7074696F6E732E6973496E76616C6964446174653B0A0A202020202020202069662028747970656F66206F7074696F6E732E6973437573746F6D44617465203D3D3D202766756E';
wwv_flow_api.g_varchar2_table(106) := '6374696F6E27290A202020202020202020202020746869732E6973437573746F6D44617465203D206F7074696F6E732E6973437573746F6D446174653B0A0A202020202020202069662028747970656F66206F7074696F6E732E616C7761797353686F77';
wwv_flow_api.g_varchar2_table(107) := '43616C656E64617273203D3D3D2027626F6F6C65616E27290A202020202020202020202020746869732E616C7761797353686F7743616C656E64617273203D206F7074696F6E732E616C7761797353686F7743616C656E646172733B0A0A202020202020';
wwv_flow_api.g_varchar2_table(108) := '20202F2F2075706461746520646179206E616D6573206F7264657220746F2066697273744461790A202020202020202069662028746869732E6C6F63616C652E666972737444617920213D203029207B0A20202020202020202020202076617220697465';
wwv_flow_api.g_varchar2_table(109) := '7261746F72203D20746869732E6C6F63616C652E66697273744461793B0A2020202020202020202020207768696C6520286974657261746F72203E203029207B0A20202020202020202020202020202020746869732E6C6F63616C652E646179734F6657';
wwv_flow_api.g_varchar2_table(110) := '65656B2E7075736828746869732E6C6F63616C652E646179734F665765656B2E73686966742829293B0A202020202020202020202020202020206974657261746F722D2D3B0A2020202020202020202020207D0A20202020202020207D0A0A2020202020';
wwv_flow_api.g_varchar2_table(111) := '2020207661722073746172742C20656E642C2072616E67653B0A0A20202020202020202F2F6966206E6F2073746172742F656E64206461746573207365742C20636865636B20696620616E20696E70757420656C656D656E7420636F6E7461696E732069';
wwv_flow_api.g_varchar2_table(112) := '6E697469616C2076616C7565730A202020202020202069662028747970656F66206F7074696F6E732E737461727444617465203D3D3D2027756E646566696E65642720262620747970656F66206F7074696F6E732E656E6444617465203D3D3D2027756E';
wwv_flow_api.g_varchar2_table(113) := '646566696E65642729207B0A202020202020202020202020696620282428746869732E656C656D656E74292E69732827696E7075745B747970653D746578745D272929207B0A202020202020202020202020202020207661722076616C203D2024287468';
wwv_flow_api.g_varchar2_table(114) := '69732E656C656D656E74292E76616C28292C0A202020202020202020202020202020202020202073706C6974203D2076616C2E73706C697428746869732E6C6F63616C652E736570617261746F72293B0A0A202020202020202020202020202020207374';
wwv_flow_api.g_varchar2_table(115) := '617274203D20656E64203D206E756C6C3B0A0A202020202020202020202020202020206966202873706C69742E6C656E677468203D3D203229207B0A20202020202020202020202020202020202020207374617274203D206D6F6D656E742873706C6974';
wwv_flow_api.g_varchar2_table(116) := '5B305D2C20746869732E6C6F63616C652E666F726D6174293B0A2020202020202020202020202020202020202020656E64203D206D6F6D656E742873706C69745B315D2C20746869732E6C6F63616C652E666F726D6174293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(117) := '2020202020207D20656C73652069662028746869732E73696E676C65446174655069636B65722026262076616C20213D3D20222229207B0A20202020202020202020202020202020202020207374617274203D206D6F6D656E742876616C2C2074686973';
wwv_flow_api.g_varchar2_table(118) := '2E6C6F63616C652E666F726D6174293B0A2020202020202020202020202020202020202020656E64203D206D6F6D656E742876616C2C20746869732E6C6F63616C652E666F726D6174293B0A202020202020202020202020202020207D0A202020202020';
wwv_flow_api.g_varchar2_table(119) := '2020202020202020202069662028737461727420213D3D206E756C6C20262620656E6420213D3D206E756C6C29207B0A2020202020202020202020202020202020202020746869732E736574537461727444617465287374617274293B0A202020202020';
wwv_flow_api.g_varchar2_table(120) := '2020202020202020202020202020746869732E736574456E644461746528656E64293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A0A202020202020202069662028747970656F66206F70';
wwv_flow_api.g_varchar2_table(121) := '74696F6E732E72616E676573203D3D3D20276F626A6563742729207B0A202020202020202020202020666F72202872616E676520696E206F7074696F6E732E72616E67657329207B0A0A2020202020202020202020202020202069662028747970656F66';
wwv_flow_api.g_varchar2_table(122) := '206F7074696F6E732E72616E6765735B72616E67655D5B305D203D3D3D2027737472696E6727290A20202020202020202020202020202020202020207374617274203D206D6F6D656E74286F7074696F6E732E72616E6765735B72616E67655D5B305D2C';
wwv_flow_api.g_varchar2_table(123) := '20746869732E6C6F63616C652E666F726D6174293B0A20202020202020202020202020202020656C73650A20202020202020202020202020202020202020207374617274203D206D6F6D656E74286F7074696F6E732E72616E6765735B72616E67655D5B';
wwv_flow_api.g_varchar2_table(124) := '305D293B0A0A2020202020202020202020202020202069662028747970656F66206F7074696F6E732E72616E6765735B72616E67655D5B315D203D3D3D2027737472696E6727290A2020202020202020202020202020202020202020656E64203D206D6F';
wwv_flow_api.g_varchar2_table(125) := '6D656E74286F7074696F6E732E72616E6765735B72616E67655D5B315D2C20746869732E6C6F63616C652E666F726D6174293B0A20202020202020202020202020202020656C73650A2020202020202020202020202020202020202020656E64203D206D';
wwv_flow_api.g_varchar2_table(126) := '6F6D656E74286F7074696F6E732E72616E6765735B72616E67655D5B315D293B0A0A202020202020202020202020202020202F2F20496620746865207374617274206F7220656E642064617465206578636565642074686F736520616C6C6F7765642062';
wwv_flow_api.g_varchar2_table(127) := '7920746865206D696E44617465206F7220646174654C696D69740A202020202020202020202020202020202F2F206F7074696F6E732C2073686F7274656E207468652072616E676520746F2074686520616C6C6F7761626C6520706572696F642E0A2020';
wwv_flow_api.g_varchar2_table(128) := '202020202020202020202020202069662028746869732E6D696E446174652026262073746172742E69734265666F726528746869732E6D696E4461746529290A20202020202020202020202020202020202020207374617274203D20746869732E6D696E';
wwv_flow_api.g_varchar2_table(129) := '446174652E636C6F6E6528293B0A0A20202020202020202020202020202020766172206D617844617465203D20746869732E6D6178446174653B0A2020202020202020202020202020202069662028746869732E646174654C696D6974202626206D6178';
wwv_flow_api.g_varchar2_table(130) := '446174652026262073746172742E636C6F6E6528292E61646428746869732E646174654C696D6974292E69734166746572286D61784461746529290A20202020202020202020202020202020202020206D617844617465203D2073746172742E636C6F6E';
wwv_flow_api.g_varchar2_table(131) := '6528292E61646428746869732E646174654C696D6974293B0A20202020202020202020202020202020696620286D61784461746520262620656E642E69734166746572286D61784461746529290A2020202020202020202020202020202020202020656E';
wwv_flow_api.g_varchar2_table(132) := '64203D206D6178446174652E636C6F6E6528293B0A0A202020202020202020202020202020202F2F2049662074686520656E64206F66207468652072616E6765206973206265666F726520746865206D696E696D756D206F722074686520737461727420';
wwv_flow_api.g_varchar2_table(133) := '6F66207468652072616E67652069730A202020202020202020202020202020202F2F20616674657220746865206D6178696D756D2C20646F6E277420646973706C617920746869732072616E6765206F7074696F6E20617420616C6C2E0A202020202020';
wwv_flow_api.g_varchar2_table(134) := '202020202020202020206966202828746869732E6D696E4461746520262620656E642E69734265666F726528746869732E6D696E446174652C20746869732E74696D657069636B6572203F20276D696E75746527203A2027646179272929200A20202020';
wwv_flow_api.g_varchar2_table(135) := '20202020202020202020202020207C7C20286D6178446174652026262073746172742E69734166746572286D6178446174652C20746869732E74696D657069636B6572203F20276D696E75746527203A2027646179272929290A20202020202020202020';
wwv_flow_api.g_varchar2_table(136) := '20202020202020202020636F6E74696E75653B0A0A202020202020202020202020202020202F2F537570706F727420756E69636F646520636861727320696E207468652072616E6765206E616D65732E0A20202020202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(137) := '20656C656D203D20646F63756D656E742E637265617465456C656D656E742827746578746172656127293B0A20202020202020202020202020202020656C656D2E696E6E657248544D4C203D2072616E67653B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(138) := '7661722072616E676548746D6C203D20656C656D2E76616C75653B0A0A20202020202020202020202020202020746869732E72616E6765735B72616E676548746D6C5D203D205B73746172742C20656E645D3B0A2020202020202020202020207D0A0A20';
wwv_flow_api.g_varchar2_table(139) := '2020202020202020202020766172206C697374203D20273C756C3E273B0A202020202020202020202020666F72202872616E676520696E20746869732E72616E67657329207B0A202020202020202020202020202020206C697374202B3D20273C6C6920';
wwv_flow_api.g_varchar2_table(140) := '646174612D72616E67652D6B65793D2227202B2072616E6765202B2027223E27202B2072616E6765202B20273C2F6C693E273B0A2020202020202020202020207D0A20202020202020202020202069662028746869732E73686F77437573746F6D52616E';
wwv_flow_api.g_varchar2_table(141) := '67654C6162656C29207B0A202020202020202020202020202020206C697374202B3D20273C6C6920646174612D72616E67652D6B65793D2227202B20746869732E6C6F63616C652E637573746F6D52616E67654C6162656C202B2027223E27202B207468';
wwv_flow_api.g_varchar2_table(142) := '69732E6C6F63616C652E637573746F6D52616E67654C6162656C202B20273C2F6C693E273B0A2020202020202020202020207D0A2020202020202020202020206C697374202B3D20273C2F756C3E273B0A202020202020202020202020746869732E636F';
wwv_flow_api.g_varchar2_table(143) := '6E7461696E65722E66696E6428272E72616E67657327292E70726570656E64286C697374293B0A20202020202020207D0A0A202020202020202069662028747970656F66206362203D3D3D202766756E6374696F6E2729207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(144) := '2020746869732E63616C6C6261636B203D2063623B0A20202020202020207D0A0A20202020202020206966202821746869732E74696D655069636B657229207B0A202020202020202020202020746869732E737461727444617465203D20746869732E73';
wwv_flow_api.g_varchar2_table(145) := '74617274446174652E73746172744F66282764617927293B0A202020202020202020202020746869732E656E6444617465203D20746869732E656E64446174652E656E644F66282764617927293B0A202020202020202020202020746869732E636F6E74';
wwv_flow_api.g_varchar2_table(146) := '61696E65722E66696E6428272E63616C656E6461722D74696D6527292E6869646528293B0A20202020202020207D0A0A20202020202020202F2F63616E2774206265207573656420746F67657468657220666F72206E6F770A2020202020202020696620';
wwv_flow_api.g_varchar2_table(147) := '28746869732E74696D655069636B657220262620746869732E6175746F4170706C79290A202020202020202020202020746869732E6175746F4170706C79203D2066616C73653B0A0A202020202020202069662028746869732E6175746F4170706C7920';
wwv_flow_api.g_varchar2_table(148) := '262620747970656F66206F7074696F6E732E72616E67657320213D3D20276F626A6563742729207B0A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E72616E67657327292E6869646528293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(149) := '7D20656C73652069662028746869732E6175746F4170706C7929207B0A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E6170706C7942746E2C202E63616E63656C42746E27292E616464436C617373282768696465';
wwv_flow_api.g_varchar2_table(150) := '27293B0A20202020202020207D0A0A202020202020202069662028746869732E73696E676C65446174655069636B657229207B0A202020202020202020202020746869732E636F6E7461696E65722E616464436C617373282773696E676C6527293B0A20';
wwv_flow_api.g_varchar2_table(151) := '2020202020202020202020746869732E636F6E7461696E65722E66696E6428272E63616C656E6461722E6C65667427292E616464436C617373282773696E676C6527293B0A202020202020202020202020746869732E636F6E7461696E65722E66696E64';
wwv_flow_api.g_varchar2_table(152) := '28272E63616C656E6461722E6C65667427292E73686F7728293B0A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E63616C656E6461722E726967687427292E6869646528293B0A2020202020202020202020207468';
wwv_flow_api.g_varchar2_table(153) := '69732E636F6E7461696E65722E66696E6428272E6461746572616E67657069636B65725F696E70757420696E7075742C202E6461746572616E67657069636B65725F696E707574203E206927292E6869646528293B0A2020202020202020202020206966';
wwv_flow_api.g_varchar2_table(154) := '2028746869732E74696D655069636B657229207B0A20202020202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E72616E67657320756C27292E6869646528293B0A2020202020202020202020207D20656C7365207B0A';
wwv_flow_api.g_varchar2_table(155) := '20202020202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E72616E67657327292E6869646528293B0A2020202020202020202020207D0A20202020202020207D0A0A20202020202020206966202828747970656F6620';
wwv_flow_api.g_varchar2_table(156) := '6F7074696F6E732E72616E676573203D3D3D2027756E646566696E6564272026262021746869732E73696E676C65446174655069636B657229207C7C20746869732E616C7761797353686F7743616C656E6461727329207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(157) := '20746869732E636F6E7461696E65722E616464436C617373282773686F772D63616C656E64617227293B0A20202020202020207D0A0A2020202020202020746869732E636F6E7461696E65722E616464436C61737328276F70656E7327202B2074686973';
wwv_flow_api.g_varchar2_table(158) := '2E6F70656E73293B0A0A20202020202020202F2F737761702074686520706F736974696F6E206F662074686520707265646566696E65642072616E676573206966206F70656E732072696768740A202020202020202069662028747970656F66206F7074';
wwv_flow_api.g_varchar2_table(159) := '696F6E732E72616E67657320213D3D2027756E646566696E65642720262620746869732E6F70656E73203D3D202772696768742729207B0A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E72616E67657327292E70';
wwv_flow_api.g_varchar2_table(160) := '726570656E64546F2820746869732E636F6E7461696E65722E66696E6428272E63616C656E6461722E6C65667427292E706172656E74282920293B0A20202020202020207D0A0A20202020202020202F2F6170706C792043535320636C61737365732061';
wwv_flow_api.g_varchar2_table(161) := '6E64206C6162656C7320746F20627574746F6E730A2020202020202020746869732E636F6E7461696E65722E66696E6428272E6170706C7942746E2C202E63616E63656C42746E27292E616464436C61737328746869732E627574746F6E436C61737365';
wwv_flow_api.g_varchar2_table(162) := '73293B0A202020202020202069662028746869732E6170706C79436C6173732E6C656E677468290A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E6170706C7942746E27292E616464436C61737328746869732E61';
wwv_flow_api.g_varchar2_table(163) := '70706C79436C617373293B0A202020202020202069662028746869732E63616E63656C436C6173732E6C656E677468290A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E63616E63656C42746E27292E616464436C';
wwv_flow_api.g_varchar2_table(164) := '61737328746869732E63616E63656C436C617373293B0A2020202020202020746869732E636F6E7461696E65722E66696E6428272E6170706C7942746E27292E68746D6C28746869732E6C6F63616C652E6170706C794C6162656C293B0A202020202020';
wwv_flow_api.g_varchar2_table(165) := '2020746869732E636F6E7461696E65722E66696E6428272E63616E63656C42746E27292E68746D6C28746869732E6C6F63616C652E63616E63656C4C6162656C293B0A0A20202020202020202F2F0A20202020202020202F2F206576656E74206C697374';
wwv_flow_api.g_varchar2_table(166) := '656E6572730A20202020202020202F2F0A0A2020202020202020746869732E636F6E7461696E65722E66696E6428272E63616C656E64617227290A2020202020202020202020202E6F6E2827636C69636B2E6461746572616E67657069636B6572272C20';
wwv_flow_api.g_varchar2_table(167) := '272E70726576272C20242E70726F787928746869732E636C69636B507265762C207468697329290A2020202020202020202020202E6F6E2827636C69636B2E6461746572616E67657069636B6572272C20272E6E657874272C20242E70726F7879287468';
wwv_flow_api.g_varchar2_table(168) := '69732E636C69636B4E6578742C207468697329290A2020202020202020202020202E6F6E28276D6F757365646F776E2E6461746572616E67657069636B6572272C202774642E617661696C61626C65272C20242E70726F787928746869732E636C69636B';
wwv_flow_api.g_varchar2_table(169) := '446174652C207468697329290A2020202020202020202020202E6F6E28276D6F757365656E7465722E6461746572616E67657069636B6572272C202774642E617661696C61626C65272C20242E70726F787928746869732E686F766572446174652C2074';
wwv_flow_api.g_varchar2_table(170) := '68697329290A2020202020202020202020202E6F6E28276D6F7573656C656176652E6461746572616E67657069636B6572272C202774642E617661696C61626C65272C20242E70726F787928746869732E757064617465466F726D496E707574732C2074';
wwv_flow_api.g_varchar2_table(171) := '68697329290A2020202020202020202020202E6F6E28276368616E67652E6461746572616E67657069636B6572272C202773656C6563742E7965617273656C656374272C20242E70726F787928746869732E6D6F6E74684F72596561724368616E676564';
wwv_flow_api.g_varchar2_table(172) := '2C207468697329290A2020202020202020202020202E6F6E28276368616E67652E6461746572616E67657069636B6572272C202773656C6563742E6D6F6E746873656C656374272C20242E70726F787928746869732E6D6F6E74684F7259656172436861';
wwv_flow_api.g_varchar2_table(173) := '6E6765642C207468697329290A2020202020202020202020202E6F6E28276368616E67652E6461746572616E67657069636B6572272C202773656C6563742E686F757273656C6563742C73656C6563742E6D696E75746573656C6563742C73656C656374';
wwv_flow_api.g_varchar2_table(174) := '2E7365636F6E6473656C6563742C73656C6563742E616D706D73656C656374272C20242E70726F787928746869732E74696D654368616E6765642C207468697329290A2020202020202020202020202E6F6E2827636C69636B2E6461746572616E676570';
wwv_flow_api.g_varchar2_table(175) := '69636B6572272C20272E6461746572616E67657069636B65725F696E70757420696E707574272C20242E70726F787928746869732E73686F7743616C656E646172732C207468697329290A2020202020202020202020202E6F6E2827666F6375732E6461';
wwv_flow_api.g_varchar2_table(176) := '746572616E67657069636B6572272C20272E6461746572616E67657069636B65725F696E70757420696E707574272C20242E70726F787928746869732E666F726D496E70757473466F63757365642C207468697329290A2020202020202020202020202E';
wwv_flow_api.g_varchar2_table(177) := '6F6E2827626C75722E6461746572616E67657069636B6572272C20272E6461746572616E67657069636B65725F696E70757420696E707574272C20242E70726F787928746869732E666F726D496E70757473426C75727265642C207468697329290A2020';
wwv_flow_api.g_varchar2_table(178) := '202020202020202020202E6F6E28276368616E67652E6461746572616E67657069636B6572272C20272E6461746572616E67657069636B65725F696E70757420696E707574272C20242E70726F787928746869732E666F726D496E707574734368616E67';
wwv_flow_api.g_varchar2_table(179) := '65642C207468697329293B0A0A2020202020202020746869732E636F6E7461696E65722E66696E6428272E72616E67657327290A2020202020202020202020202E6F6E2827636C69636B2E6461746572616E67657069636B6572272C2027627574746F6E';
wwv_flow_api.g_varchar2_table(180) := '2E6170706C7942746E272C20242E70726F787928746869732E636C69636B4170706C792C207468697329290A2020202020202020202020202E6F6E2827636C69636B2E6461746572616E67657069636B6572272C2027627574746F6E2E63616E63656C42';
wwv_flow_api.g_varchar2_table(181) := '746E272C20242E70726F787928746869732E636C69636B43616E63656C2C207468697329290A2020202020202020202020202E6F6E2827636C69636B2E6461746572616E67657069636B6572272C20276C69272C20242E70726F787928746869732E636C';
wwv_flow_api.g_varchar2_table(182) := '69636B52616E67652C207468697329290A2020202020202020202020202E6F6E28276D6F757365656E7465722E6461746572616E67657069636B6572272C20276C69272C20242E70726F787928746869732E686F76657252616E67652C20746869732929';
wwv_flow_api.g_varchar2_table(183) := '0A2020202020202020202020202E6F6E28276D6F7573656C656176652E6461746572616E67657069636B6572272C20276C69272C20242E70726F787928746869732E757064617465466F726D496E707574732C207468697329293B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(184) := '2069662028746869732E656C656D656E742E69732827696E7075742729207C7C20746869732E656C656D656E742E69732827627574746F6E272929207B0A202020202020202020202020746869732E656C656D656E742E6F6E287B0A2020202020202020';
wwv_flow_api.g_varchar2_table(185) := '202020202020202027636C69636B2E6461746572616E67657069636B6572273A20242E70726F787928746869732E73686F772C2074686973292C0A2020202020202020202020202020202027666F6375732E6461746572616E67657069636B6572273A20';
wwv_flow_api.g_varchar2_table(186) := '242E70726F787928746869732E73686F772C2074686973292C0A20202020202020202020202020202020276B657975702E6461746572616E67657069636B6572273A20242E70726F787928746869732E656C656D656E744368616E6765642C2074686973';
wwv_flow_api.g_varchar2_table(187) := '292C0A20202020202020202020202020202020276B6579646F776E2E6461746572616E67657069636B6572273A20242E70726F787928746869732E6B6579646F776E2C2074686973290A2020202020202020202020207D293B0A20202020202020207D20';
wwv_flow_api.g_varchar2_table(188) := '656C7365207B0A202020202020202020202020746869732E656C656D656E742E6F6E2827636C69636B2E6461746572616E67657069636B6572272C20242E70726F787928746869732E746F67676C652C207468697329293B0A20202020202020207D0A0A';
wwv_flow_api.g_varchar2_table(189) := '20202020202020202F2F0A20202020202020202F2F20696620617474616368656420746F2061207465787420696E7075742C207365742074686520696E697469616C2076616C75650A20202020202020202F2F0A0A202020202020202069662028746869';
wwv_flow_api.g_varchar2_table(190) := '732E656C656D656E742E69732827696E70757427292026262021746869732E73696E676C65446174655069636B657220262620746869732E6175746F557064617465496E70757429207B0A202020202020202020202020746869732E656C656D656E742E';
wwv_flow_api.g_varchar2_table(191) := '76616C28746869732E7374617274446174652E666F726D617428746869732E6C6F63616C652E666F726D617429202B20746869732E6C6F63616C652E736570617261746F72202B20746869732E656E64446174652E666F726D617428746869732E6C6F63';
wwv_flow_api.g_varchar2_table(192) := '616C652E666F726D617429293B0A202020202020202020202020746869732E656C656D656E742E7472696767657228276368616E676527293B0A20202020202020207D20656C73652069662028746869732E656C656D656E742E69732827696E70757427';
wwv_flow_api.g_varchar2_table(193) := '2920262620746869732E6175746F557064617465496E70757429207B0A202020202020202020202020746869732E656C656D656E742E76616C28746869732E7374617274446174652E666F726D617428746869732E6C6F63616C652E666F726D61742929';
wwv_flow_api.g_varchar2_table(194) := '3B0A202020202020202020202020746869732E656C656D656E742E7472696767657228276368616E676527293B0A20202020202020207D0A0A202020207D3B0A0A202020204461746552616E67655069636B65722E70726F746F74797065203D207B0A0A';
wwv_flow_api.g_varchar2_table(195) := '2020202020202020636F6E7374727563746F723A204461746552616E67655069636B65722C0A0A20202020202020207365745374617274446174653A2066756E6374696F6E2873746172744461746529207B0A2020202020202020202020206966202874';
wwv_flow_api.g_varchar2_table(196) := '7970656F6620737461727444617465203D3D3D2027737472696E6727290A20202020202020202020202020202020746869732E737461727444617465203D206D6F6D656E74287374617274446174652C20746869732E6C6F63616C652E666F726D617429';
wwv_flow_api.g_varchar2_table(197) := '3B0A0A20202020202020202020202069662028747970656F6620737461727444617465203D3D3D20276F626A65637427290A20202020202020202020202020202020746869732E737461727444617465203D206D6F6D656E742873746172744461746529';
wwv_flow_api.g_varchar2_table(198) := '3B0A0A2020202020202020202020206966202821746869732E74696D655069636B6572290A20202020202020202020202020202020746869732E737461727444617465203D20746869732E7374617274446174652E73746172744F66282764617927293B';
wwv_flow_api.g_varchar2_table(199) := '0A0A20202020202020202020202069662028746869732E74696D655069636B657220262620746869732E74696D655069636B6572496E6372656D656E74290A20202020202020202020202020202020746869732E7374617274446174652E6D696E757465';
wwv_flow_api.g_varchar2_table(200) := '284D6174682E726F756E6428746869732E7374617274446174652E6D696E7574652829202F20746869732E74696D655069636B6572496E6372656D656E7429202A20746869732E74696D655069636B6572496E6372656D656E74293B0A0A202020202020';
wwv_flow_api.g_varchar2_table(201) := '20202020202069662028746869732E6D696E4461746520262620746869732E7374617274446174652E69734265666F726528746869732E6D696E446174652929207B0A20202020202020202020202020202020746869732E737461727444617465203D20';
wwv_flow_api.g_varchar2_table(202) := '746869732E6D696E446174653B0A2020202020202020202020202020202069662028746869732E74696D655069636B657220262620746869732E74696D655069636B6572496E6372656D656E74290A202020202020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(203) := '6869732E7374617274446174652E6D696E757465284D6174682E726F756E6428746869732E7374617274446174652E6D696E7574652829202F20746869732E74696D655069636B6572496E6372656D656E7429202A20746869732E74696D655069636B65';
wwv_flow_api.g_varchar2_table(204) := '72496E6372656D656E74293B0A2020202020202020202020207D0A0A20202020202020202020202069662028746869732E6D61784461746520262620746869732E7374617274446174652E6973416674657228746869732E6D6178446174652929207B0A';
wwv_flow_api.g_varchar2_table(205) := '20202020202020202020202020202020746869732E737461727444617465203D20746869732E6D6178446174653B0A2020202020202020202020202020202069662028746869732E74696D655069636B657220262620746869732E74696D655069636B65';
wwv_flow_api.g_varchar2_table(206) := '72496E6372656D656E74290A2020202020202020202020202020202020202020746869732E7374617274446174652E6D696E757465284D6174682E666C6F6F7228746869732E7374617274446174652E6D696E7574652829202F20746869732E74696D65';
wwv_flow_api.g_varchar2_table(207) := '5069636B6572496E6372656D656E7429202A20746869732E74696D655069636B6572496E6372656D656E74293B0A2020202020202020202020207D0A0A2020202020202020202020206966202821746869732E697353686F77696E67290A202020202020';
wwv_flow_api.g_varchar2_table(208) := '20202020202020202020746869732E757064617465456C656D656E7428293B0A0A202020202020202020202020746869732E7570646174654D6F6E746873496E5669657728293B0A20202020202020207D2C0A0A2020202020202020736574456E644461';
wwv_flow_api.g_varchar2_table(209) := '74653A2066756E6374696F6E28656E644461746529207B0A20202020202020202020202069662028747970656F6620656E6444617465203D3D3D2027737472696E6727290A20202020202020202020202020202020746869732E656E6444617465203D20';
wwv_flow_api.g_varchar2_table(210) := '6D6F6D656E7428656E64446174652C20746869732E6C6F63616C652E666F726D6174293B0A0A20202020202020202020202069662028747970656F6620656E6444617465203D3D3D20276F626A65637427290A2020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(211) := '6869732E656E6444617465203D206D6F6D656E7428656E6444617465293B0A0A2020202020202020202020206966202821746869732E74696D655069636B6572290A20202020202020202020202020202020746869732E656E6444617465203D20746869';
wwv_flow_api.g_varchar2_table(212) := '732E656E64446174652E656E644F66282764617927293B0A0A20202020202020202020202069662028746869732E74696D655069636B657220262620746869732E74696D655069636B6572496E6372656D656E74290A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(213) := '2020746869732E656E64446174652E6D696E757465284D6174682E726F756E6428746869732E656E64446174652E6D696E7574652829202F20746869732E74696D655069636B6572496E6372656D656E7429202A20746869732E74696D655069636B6572';
wwv_flow_api.g_varchar2_table(214) := '496E6372656D656E74293B0A0A20202020202020202020202069662028746869732E656E64446174652E69734265666F726528746869732E73746172744461746529290A20202020202020202020202020202020746869732E656E6444617465203D2074';
wwv_flow_api.g_varchar2_table(215) := '6869732E7374617274446174652E636C6F6E6528293B0A0A20202020202020202020202069662028746869732E6D61784461746520262620746869732E656E64446174652E6973416674657228746869732E6D61784461746529290A2020202020202020';
wwv_flow_api.g_varchar2_table(216) := '2020202020202020746869732E656E6444617465203D20746869732E6D6178446174653B0A0A20202020202020202020202069662028746869732E646174654C696D697420262620746869732E7374617274446174652E636C6F6E6528292E6164642874';
wwv_flow_api.g_varchar2_table(217) := '6869732E646174654C696D6974292E69734265666F726528746869732E656E644461746529290A20202020202020202020202020202020746869732E656E6444617465203D20746869732E7374617274446174652E636C6F6E6528292E61646428746869';
wwv_flow_api.g_varchar2_table(218) := '732E646174654C696D6974293B0A0A202020202020202020202020746869732E70726576696F7573526967687454696D65203D20746869732E656E64446174652E636C6F6E6528293B0A0A2020202020202020202020206966202821746869732E697353';
wwv_flow_api.g_varchar2_table(219) := '686F77696E67290A20202020202020202020202020202020746869732E757064617465456C656D656E7428293B0A0A202020202020202020202020746869732E7570646174654D6F6E746873496E5669657728293B0A20202020202020207D2C0A0A2020';
wwv_flow_api.g_varchar2_table(220) := '2020202020206973496E76616C6964446174653A2066756E6374696F6E2829207B0A20202020202020202020202072657475726E2066616C73653B0A20202020202020207D2C0A0A20202020202020206973437573746F6D446174653A2066756E637469';
wwv_flow_api.g_varchar2_table(221) := '6F6E2829207B0A20202020202020202020202072657475726E2066616C73653B0A20202020202020207D2C0A0A2020202020202020757064617465566965773A2066756E6374696F6E2829207B0A20202020202020202020202069662028746869732E74';
wwv_flow_api.g_varchar2_table(222) := '696D655069636B657229207B0A20202020202020202020202020202020746869732E72656E64657254696D655069636B657228276C65667427293B0A20202020202020202020202020202020746869732E72656E64657254696D655069636B6572282772';
wwv_flow_api.g_varchar2_table(223) := '6967687427293B0A202020202020202020202020202020206966202821746869732E656E644461746529207B0A2020202020202020202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E7269676874202E63616C656E64';
wwv_flow_api.g_varchar2_table(224) := '61722D74696D652073656C65637427292E61747472282764697361626C6564272C202764697361626C656427292E616464436C617373282764697361626C656427293B0A202020202020202020202020202020207D20656C7365207B0A20202020202020';
wwv_flow_api.g_varchar2_table(225) := '20202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E7269676874202E63616C656E6461722D74696D652073656C65637427292E72656D6F766541747472282764697361626C656427292E72656D6F7665436C61737328';
wwv_flow_api.g_varchar2_table(226) := '2764697361626C656427293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020202020202069662028746869732E656E644461746529207B0A20202020202020202020202020202020746869732E636F';
wwv_flow_api.g_varchar2_table(227) := '6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F656E64225D27292E72656D6F7665436C617373282761637469766527293B0A20202020202020202020202020202020746869732E636F6E746169';
wwv_flow_api.g_varchar2_table(228) := '6E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F7374617274225D27292E616464436C617373282761637469766527293B0A2020202020202020202020207D20656C7365207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(229) := '2020202020746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F656E64225D27292E616464436C617373282761637469766527293B0A202020202020202020202020202020207468';
wwv_flow_api.g_varchar2_table(230) := '69732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F7374617274225D27292E72656D6F7665436C617373282761637469766527293B0A2020202020202020202020207D0A202020202020';
wwv_flow_api.g_varchar2_table(231) := '202020202020746869732E7570646174654D6F6E746873496E5669657728293B0A202020202020202020202020746869732E75706461746543616C656E6461727328293B0A202020202020202020202020746869732E757064617465466F726D496E7075';
wwv_flow_api.g_varchar2_table(232) := '747328293B0A0A0A20202020202020207D2C0A0A20202020202020207570646174654D6F6E746873496E566965773A2066756E6374696F6E2829207B0A20202020202020202020202069662028746869732E656E644461746529207B0A0A202020202020';
wwv_flow_api.g_varchar2_table(233) := '202020202020202020202F2F696620626F7468206461746573206172652076697369626C6520616C72656164792C20646F206E6F7468696E670A202020202020202020202020202020206966202821746869732E73696E676C65446174655069636B6572';
wwv_flow_api.g_varchar2_table(234) := '20262620746869732E6C65667443616C656E6461722E6D6F6E746820262620746869732E726967687443616C656E6461722E6D6F6E74682026260A202020202020202020202020202020202020202028746869732E7374617274446174652E666F726D61';
wwv_flow_api.g_varchar2_table(235) := '742827595959592D4D4D2729203D3D20746869732E6C65667443616C656E6461722E6D6F6E74682E666F726D61742827595959592D4D4D2729207C7C20746869732E7374617274446174652E666F726D61742827595959592D4D4D2729203D3D20746869';
wwv_flow_api.g_varchar2_table(236) := '732E726967687443616C656E6461722E6D6F6E74682E666F726D61742827595959592D4D4D2729290A202020202020202020202020202020202020202026260A202020202020202020202020202020202020202028746869732E656E64446174652E666F';
wwv_flow_api.g_varchar2_table(237) := '726D61742827595959592D4D4D2729203D3D20746869732E6C65667443616C656E6461722E6D6F6E74682E666F726D61742827595959592D4D4D2729207C7C20746869732E656E64446174652E666F726D61742827595959592D4D4D2729203D3D207468';
wwv_flow_api.g_varchar2_table(238) := '69732E726967687443616C656E6461722E6D6F6E74682E666F726D61742827595959592D4D4D2729290A202020202020202020202020202020202020202029207B0A202020202020202020202020202020202020202072657475726E3B0A202020202020';
wwv_flow_api.g_varchar2_table(239) := '202020202020202020207D0A0A20202020202020202020202020202020746869732E6C65667443616C656E6461722E6D6F6E7468203D20746869732E7374617274446174652E636C6F6E6528292E646174652832293B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(240) := '2020206966202821746869732E6C696E6B656443616C656E646172732026262028746869732E656E64446174652E6D6F6E7468282920213D20746869732E7374617274446174652E6D6F6E74682829207C7C20746869732E656E64446174652E79656172';
wwv_flow_api.g_varchar2_table(241) := '282920213D20746869732E7374617274446174652E7965617228292929207B0A2020202020202020202020202020202020202020746869732E726967687443616C656E6461722E6D6F6E7468203D20746869732E656E64446174652E636C6F6E6528292E';
wwv_flow_api.g_varchar2_table(242) := '646174652832293B0A202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020746869732E726967687443616C656E6461722E6D6F6E7468203D20746869732E7374617274446174652E636C6F6E';
wwv_flow_api.g_varchar2_table(243) := '6528292E646174652832292E61646428312C20276D6F6E746827293B0A202020202020202020202020202020207D0A0A2020202020202020202020207D20656C7365207B0A2020202020202020202020202020202069662028746869732E6C6566744361';
wwv_flow_api.g_varchar2_table(244) := '6C656E6461722E6D6F6E74682E666F726D61742827595959592D4D4D272920213D20746869732E7374617274446174652E666F726D61742827595959592D4D4D272920262620746869732E726967687443616C656E6461722E6D6F6E74682E666F726D61';
wwv_flow_api.g_varchar2_table(245) := '742827595959592D4D4D272920213D20746869732E7374617274446174652E666F726D61742827595959592D4D4D272929207B0A2020202020202020202020202020202020202020746869732E6C65667443616C656E6461722E6D6F6E7468203D207468';
wwv_flow_api.g_varchar2_table(246) := '69732E7374617274446174652E636C6F6E6528292E646174652832293B0A2020202020202020202020202020202020202020746869732E726967687443616C656E6461722E6D6F6E7468203D20746869732E7374617274446174652E636C6F6E6528292E';
wwv_flow_api.g_varchar2_table(247) := '646174652832292E61646428312C20276D6F6E746827293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020202020202069662028746869732E6D61784461746520262620746869732E6C696E6B6564';
wwv_flow_api.g_varchar2_table(248) := '43616C656E646172732026262021746869732E73696E676C65446174655069636B657220262620746869732E726967687443616C656E6461722E6D6F6E7468203E20746869732E6D61784461746529207B0A202020202020202020202020202074686973';
wwv_flow_api.g_varchar2_table(249) := '2E726967687443616C656E6461722E6D6F6E7468203D20746869732E6D6178446174652E636C6F6E6528292E646174652832293B0A2020202020202020202020202020746869732E6C65667443616C656E6461722E6D6F6E7468203D20746869732E6D61';
wwv_flow_api.g_varchar2_table(250) := '78446174652E636C6F6E6528292E646174652832292E737562747261637428312C20276D6F6E746827293B0A2020202020202020202020207D0A20202020202020207D2C0A0A202020202020202075706461746543616C656E646172733A2066756E6374';
wwv_flow_api.g_varchar2_table(251) := '696F6E2829207B0A0A20202020202020202020202069662028746869732E74696D655069636B657229207B0A2020202020202020202020202020202076617220686F75722C206D696E7574652C207365636F6E643B0A2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(252) := '202069662028746869732E656E644461746529207B0A2020202020202020202020202020202020202020686F7572203D207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E6C656674202E686F757273656C65637427292E76';
wwv_flow_api.g_varchar2_table(253) := '616C28292C203130293B0A20202020202020202020202020202020202020206D696E757465203D207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E6C656674202E6D696E75746573656C65637427292E76616C28292C2031';
wwv_flow_api.g_varchar2_table(254) := '30293B0A20202020202020202020202020202020202020207365636F6E64203D20746869732E74696D655069636B65725365636F6E6473203F207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E6C656674202E7365636F6E';
wwv_flow_api.g_varchar2_table(255) := '6473656C65637427292E76616C28292C20313029203A20303B0A20202020202020202020202020202020202020206966202821746869732E74696D655069636B65723234486F757229207B0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(256) := '76617220616D706D203D20746869732E636F6E7461696E65722E66696E6428272E6C656674202E616D706D73656C65637427292E76616C28293B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027504D27';
wwv_flow_api.g_varchar2_table(257) := '20262620686F7572203C203132290A20202020202020202020202020202020202020202020202020202020686F7572202B3D2031323B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027414D2720262620';
wwv_flow_api.g_varchar2_table(258) := '686F7572203D3D3D203132290A20202020202020202020202020202020202020202020202020202020686F7572203D20303B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D20656C7365207B0A2020';
wwv_flow_api.g_varchar2_table(259) := '202020202020202020202020202020202020686F7572203D207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E7269676874202E686F757273656C65637427292E76616C28292C203130293B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(260) := '20202020202020206D696E757465203D207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E7269676874202E6D696E75746573656C65637427292E76616C28292C203130293B0A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(261) := '20207365636F6E64203D20746869732E74696D655069636B65725365636F6E6473203F207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E7269676874202E7365636F6E6473656C65637427292E76616C28292C2031302920';
wwv_flow_api.g_varchar2_table(262) := '3A20303B0A20202020202020202020202020202020202020206966202821746869732E74696D655069636B65723234486F757229207B0A20202020202020202020202020202020202020202020202076617220616D706D203D20746869732E636F6E7461';
wwv_flow_api.g_varchar2_table(263) := '696E65722E66696E6428272E7269676874202E616D706D73656C65637427292E76616C28293B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027504D2720262620686F7572203C203132290A2020202020';
wwv_flow_api.g_varchar2_table(264) := '2020202020202020202020202020202020202020202020686F7572202B3D2031323B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027414D2720262620686F7572203D3D3D203132290A20202020202020';
wwv_flow_api.g_varchar2_table(265) := '202020202020202020202020202020202020202020686F7572203D20303B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A20202020202020202020202020202020746869732E6C65667443616C65';
wwv_flow_api.g_varchar2_table(266) := '6E6461722E6D6F6E74682E686F757228686F7572292E6D696E757465286D696E757465292E7365636F6E64287365636F6E64293B0A20202020202020202020202020202020746869732E726967687443616C656E6461722E6D6F6E74682E686F75722868';
wwv_flow_api.g_varchar2_table(267) := '6F7572292E6D696E757465286D696E757465292E7365636F6E64287365636F6E64293B0A2020202020202020202020207D0A0A202020202020202020202020746869732E72656E64657243616C656E64617228276C65667427293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(268) := '20202020746869732E72656E64657243616C656E6461722827726967687427293B0A0A2020202020202020202020202F2F686967686C6967687420616E7920707265646566696E65642072616E6765206D61746368696E67207468652063757272656E74';
wwv_flow_api.g_varchar2_table(269) := '20737461727420616E6420656E642064617465730A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E72616E676573206C6927292E72656D6F7665436C617373282761637469766527293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(270) := '202069662028746869732E656E6444617465203D3D206E756C6C292072657475726E3B0A0A202020202020202020202020746869732E63616C63756C61746543686F73656E4C6162656C28293B0A20202020202020207D2C0A0A20202020202020207265';
wwv_flow_api.g_varchar2_table(271) := '6E64657243616C656E6461723A2066756E6374696F6E287369646529207B0A0A2020202020202020202020202F2F0A2020202020202020202020202F2F204275696C6420746865206D6174726978206F6620646174657320746861742077696C6C20706F';
wwv_flow_api.g_varchar2_table(272) := '70756C617465207468652063616C656E6461720A2020202020202020202020202F2F0A0A2020202020202020202020207661722063616C656E646172203D2073696465203D3D20276C65667427203F20746869732E6C65667443616C656E646172203A20';
wwv_flow_api.g_varchar2_table(273) := '746869732E726967687443616C656E6461723B0A202020202020202020202020766172206D6F6E7468203D2063616C656E6461722E6D6F6E74682E6D6F6E746828293B0A2020202020202020202020207661722079656172203D2063616C656E6461722E';
wwv_flow_api.g_varchar2_table(274) := '6D6F6E74682E7965617228293B0A20202020202020202020202076617220686F7572203D2063616C656E6461722E6D6F6E74682E686F757228293B0A202020202020202020202020766172206D696E757465203D2063616C656E6461722E6D6F6E74682E';
wwv_flow_api.g_varchar2_table(275) := '6D696E75746528293B0A202020202020202020202020766172207365636F6E64203D2063616C656E6461722E6D6F6E74682E7365636F6E6428293B0A2020202020202020202020207661722064617973496E4D6F6E7468203D206D6F6D656E74285B7965';
wwv_flow_api.g_varchar2_table(276) := '61722C206D6F6E74685D292E64617973496E4D6F6E746828293B0A202020202020202020202020766172206669727374446179203D206D6F6D656E74285B796561722C206D6F6E74682C20315D293B0A202020202020202020202020766172206C617374';
wwv_flow_api.g_varchar2_table(277) := '446179203D206D6F6D656E74285B796561722C206D6F6E74682C2064617973496E4D6F6E74685D293B0A202020202020202020202020766172206C6173744D6F6E7468203D206D6F6D656E74286669727374446179292E737562747261637428312C2027';
wwv_flow_api.g_varchar2_table(278) := '6D6F6E746827292E6D6F6E746828293B0A202020202020202020202020766172206C61737459656172203D206D6F6D656E74286669727374446179292E737562747261637428312C20276D6F6E746827292E7965617228293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(279) := '20207661722064617973496E4C6173744D6F6E7468203D206D6F6D656E74285B6C617374596561722C206C6173744D6F6E74685D292E64617973496E4D6F6E746828293B0A202020202020202020202020766172206461794F665765656B203D20666972';
wwv_flow_api.g_varchar2_table(280) := '73744461792E64617928293B0A0A2020202020202020202020202F2F696E697469616C697A652061203620726F77732078203720636F6C756D6E7320617272617920666F72207468652063616C656E6461720A2020202020202020202020207661722063';
wwv_flow_api.g_varchar2_table(281) := '616C656E646172203D205B5D3B0A20202020202020202020202063616C656E6461722E6669727374446179203D2066697273744461793B0A20202020202020202020202063616C656E6461722E6C617374446179203D206C6173744461793B0A0A202020';
wwv_flow_api.g_varchar2_table(282) := '202020202020202020666F7220287661722069203D20303B2069203C20363B20692B2B29207B0A2020202020202020202020202020202063616C656E6461725B695D203D205B5D3B0A2020202020202020202020207D0A0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(283) := '2F2F706F70756C617465207468652063616C656E64617220776974682064617465206F626A656374730A202020202020202020202020766172207374617274446179203D2064617973496E4C6173744D6F6E7468202D206461794F665765656B202B2074';
wwv_flow_api.g_varchar2_table(284) := '6869732E6C6F63616C652E6669727374446179202B20313B0A202020202020202020202020696620287374617274446179203E2064617973496E4C6173744D6F6E7468290A202020202020202020202020202020207374617274446179202D3D20373B0A';
wwv_flow_api.g_varchar2_table(285) := '0A202020202020202020202020696620286461794F665765656B203D3D20746869732E6C6F63616C652E6669727374446179290A202020202020202020202020202020207374617274446179203D2064617973496E4C6173744D6F6E7468202D20363B0A';
wwv_flow_api.g_varchar2_table(286) := '0A2020202020202020202020207661722063757244617465203D206D6F6D656E74285B6C617374596561722C206C6173744D6F6E74682C2073746172744461792C2031322C206D696E7574652C207365636F6E645D293B0A0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(287) := '2076617220636F6C2C20726F773B0A202020202020202020202020666F7220287661722069203D20302C20636F6C203D20302C20726F77203D20303B2069203C2034323B20692B2B2C20636F6C2B2B2C2063757244617465203D206D6F6D656E74286375';
wwv_flow_api.g_varchar2_table(288) := '7244617465292E6164642832342C2027686F7572272929207B0A202020202020202020202020202020206966202869203E203020262620636F6C20252037203D3D3D203029207B0A2020202020202020202020202020202020202020636F6C203D20303B';
wwv_flow_api.g_varchar2_table(289) := '0A2020202020202020202020202020202020202020726F772B2B3B0A202020202020202020202020202020207D0A2020202020202020202020202020202063616C656E6461725B726F775D5B636F6C5D203D20637572446174652E636C6F6E6528292E68';
wwv_flow_api.g_varchar2_table(290) := '6F757228686F7572292E6D696E757465286D696E757465292E7365636F6E64287365636F6E64293B0A20202020202020202020202020202020637572446174652E686F7572283132293B0A0A202020202020202020202020202020206966202874686973';
wwv_flow_api.g_varchar2_table(291) := '2E6D696E446174652026262063616C656E6461725B726F775D5B636F6C5D2E666F726D61742827595959592D4D4D2D44442729203D3D20746869732E6D696E446174652E666F726D61742827595959592D4D4D2D444427292026262063616C656E646172';
wwv_flow_api.g_varchar2_table(292) := '5B726F775D5B636F6C5D2E69734265666F726528746869732E6D696E44617465292026262073696465203D3D20276C6566742729207B0A202020202020202020202020202020202020202063616C656E6461725B726F775D5B636F6C5D203D2074686973';
wwv_flow_api.g_varchar2_table(293) := '2E6D696E446174652E636C6F6E6528293B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202069662028746869732E6D6178446174652026262063616C656E6461725B726F775D5B636F6C5D2E666F726D61742827';
wwv_flow_api.g_varchar2_table(294) := '595959592D4D4D2D44442729203D3D20746869732E6D6178446174652E666F726D61742827595959592D4D4D2D444427292026262063616C656E6461725B726F775D5B636F6C5D2E6973416674657228746869732E6D6178446174652920262620736964';
wwv_flow_api.g_varchar2_table(295) := '65203D3D202772696768742729207B0A202020202020202020202020202020202020202063616C656E6461725B726F775D5B636F6C5D203D20746869732E6D6178446174652E636C6F6E6528293B0A202020202020202020202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(296) := '202020202020202020207D0A0A2020202020202020202020202F2F6D616B65207468652063616C656E646172206F626A65637420617661696C61626C6520746F20686F766572446174652F636C69636B446174650A202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(297) := '2873696465203D3D20276C6566742729207B0A20202020202020202020202020202020746869732E6C65667443616C656E6461722E63616C656E646172203D2063616C656E6461723B0A2020202020202020202020207D20656C7365207B0A2020202020';
wwv_flow_api.g_varchar2_table(298) := '2020202020202020202020746869732E726967687443616C656E6461722E63616C656E646172203D2063616C656E6461723B0A2020202020202020202020207D0A0A2020202020202020202020202F2F0A2020202020202020202020202F2F2044697370';
wwv_flow_api.g_varchar2_table(299) := '6C6179207468652063616C656E6461720A2020202020202020202020202F2F0A0A202020202020202020202020766172206D696E44617465203D2073696465203D3D20276C65667427203F20746869732E6D696E44617465203A20746869732E73746172';
wwv_flow_api.g_varchar2_table(300) := '74446174653B0A202020202020202020202020766172206D617844617465203D20746869732E6D6178446174653B0A2020202020202020202020207661722073656C6563746564203D2073696465203D3D20276C65667427203F20746869732E73746172';
wwv_flow_api.g_varchar2_table(301) := '7444617465203A20746869732E656E64446174653B0A202020202020202020202020766172206172726F77203D20746869732E6C6F63616C652E646972656374696F6E203D3D20276C747227203F207B6C6566743A202763686576726F6E2D6C65667427';
wwv_flow_api.g_varchar2_table(302) := '2C2072696768743A202763686576726F6E2D7269676874277D203A207B6C6566743A202763686576726F6E2D7269676874272C2072696768743A202763686576726F6E2D6C656674277D3B0A0A2020202020202020202020207661722068746D6C203D20';
wwv_flow_api.g_varchar2_table(303) := '273C7461626C6520636C6173733D227461626C652D636F6E64656E736564223E273B0A20202020202020202020202068746D6C202B3D20273C74686561643E273B0A20202020202020202020202068746D6C202B3D20273C74723E273B0A0A2020202020';
wwv_flow_api.g_varchar2_table(304) := '202020202020202F2F2061646420656D7074792063656C6C20666F72207765656B206E756D6265720A20202020202020202020202069662028746869732E73686F775765656B4E756D62657273207C7C20746869732E73686F7749534F5765656B4E756D';
wwv_flow_api.g_varchar2_table(305) := '62657273290A2020202020202020202020202020202068746D6C202B3D20273C74683E3C2F74683E273B0A0A2020202020202020202020206966202828216D696E44617465207C7C206D696E446174652E69734265666F72652863616C656E6461722E66';
wwv_flow_api.g_varchar2_table(306) := '697273744461792929202626202821746869732E6C696E6B656443616C656E64617273207C7C2073696465203D3D20276C656674272929207B0A2020202020202020202020202020202068746D6C202B3D20273C746820636C6173733D22707265762061';
wwv_flow_api.g_varchar2_table(307) := '7661696C61626C65223E3C6920636C6173733D2266612066612D27202B206172726F772E6C656674202B202720676C79706869636F6E20676C79706869636F6E2D27202B206172726F772E6C656674202B2027223E3C2F693E3C2F74683E273B0A202020';
wwv_flow_api.g_varchar2_table(308) := '2020202020202020207D20656C7365207B0A2020202020202020202020202020202068746D6C202B3D20273C74683E3C2F74683E273B0A2020202020202020202020207D0A0A202020202020202020202020766172206461746548746D6C203D20746869';
wwv_flow_api.g_varchar2_table(309) := '732E6C6F63616C652E6D6F6E74684E616D65735B63616C656E6461725B315D5B315D2E6D6F6E746828295D202B2063616C656E6461725B315D5B315D2E666F726D61742822205959595922293B0A0A20202020202020202020202069662028746869732E';
wwv_flow_api.g_varchar2_table(310) := '73686F7744726F70646F776E7329207B0A202020202020202020202020202020207661722063757272656E744D6F6E7468203D2063616C656E6461725B315D5B315D2E6D6F6E746828293B0A202020202020202020202020202020207661722063757272';
wwv_flow_api.g_varchar2_table(311) := '656E7459656172203D2063616C656E6461725B315D5B315D2E7965617228293B0A20202020202020202020202020202020766172206D617859656172203D20286D617844617465202626206D6178446174652E79656172282929207C7C20286375727265';
wwv_flow_api.g_varchar2_table(312) := '6E7459656172202B2035293B0A20202020202020202020202020202020766172206D696E59656172203D20286D696E44617465202626206D696E446174652E79656172282929207C7C202863757272656E7459656172202D203530293B0A202020202020';
wwv_flow_api.g_varchar2_table(313) := '2020202020202020202076617220696E4D696E59656172203D2063757272656E7459656172203D3D206D696E596561723B0A2020202020202020202020202020202076617220696E4D617859656172203D2063757272656E7459656172203D3D206D6178';
wwv_flow_api.g_varchar2_table(314) := '596561723B0A0A20202020202020202020202020202020766172206D6F6E746848746D6C203D20273C73656C65637420636C6173733D226D6F6E746873656C656374223E273B0A20202020202020202020202020202020666F722028766172206D203D20';
wwv_flow_api.g_varchar2_table(315) := '303B206D203C2031323B206D2B2B29207B0A2020202020202020202020202020202020202020696620282821696E4D696E59656172207C7C206D203E3D206D696E446174652E6D6F6E7468282929202626202821696E4D617859656172207C7C206D203C';
wwv_flow_api.g_varchar2_table(316) := '3D206D6178446174652E6D6F6E746828292929207B0A2020202020202020202020202020202020202020202020206D6F6E746848746D6C202B3D20223C6F7074696F6E2076616C75653D2722202B206D202B20222722202B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(317) := '2020202020202020202020202020202020286D203D3D3D2063757272656E744D6F6E7468203F20222073656C65637465643D2773656C65637465642722203A20222229202B0A20202020202020202020202020202020202020202020202020202020223E';
wwv_flow_api.g_varchar2_table(318) := '22202B20746869732E6C6F63616C652E6D6F6E74684E616D65735B6D5D202B20223C2F6F7074696F6E3E223B0A20202020202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020202020206D6F';
wwv_flow_api.g_varchar2_table(319) := '6E746848746D6C202B3D20223C6F7074696F6E2076616C75653D2722202B206D202B20222722202B0A20202020202020202020202020202020202020202020202020202020286D203D3D3D2063757272656E744D6F6E7468203F20222073656C65637465';
wwv_flow_api.g_varchar2_table(320) := '643D2773656C65637465642722203A20222229202B0A20202020202020202020202020202020202020202020202020202020222064697361626C65643D2764697361626C6564273E22202B20746869732E6C6F63616C652E6D6F6E74684E616D65735B6D';
wwv_flow_api.g_varchar2_table(321) := '5D202B20223C2F6F7074696F6E3E223B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A202020202020202020202020202020206D6F6E746848746D6C202B3D20223C2F73656C6563743E223B0A0A';
wwv_flow_api.g_varchar2_table(322) := '20202020202020202020202020202020766172207965617248746D6C203D20273C73656C65637420636C6173733D227965617273656C656374223E273B0A20202020202020202020202020202020666F7220287661722079203D206D696E596561723B20';
wwv_flow_api.g_varchar2_table(323) := '79203C3D206D6178596561723B20792B2B29207B0A20202020202020202020202020202020202020207965617248746D6C202B3D20273C6F7074696F6E2076616C75653D2227202B2079202B20272227202B0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(324) := '202020202020202879203D3D3D2063757272656E7459656172203F20272073656C65637465643D2273656C65637465642227203A20272729202B0A202020202020202020202020202020202020202020202020273E27202B2079202B20273C2F6F707469';
wwv_flow_api.g_varchar2_table(325) := '6F6E3E273B0A202020202020202020202020202020207D0A202020202020202020202020202020207965617248746D6C202B3D20273C2F73656C6563743E273B0A0A202020202020202020202020202020206461746548746D6C203D206D6F6E74684874';
wwv_flow_api.g_varchar2_table(326) := '6D6C202B207965617248746D6C3B0A2020202020202020202020207D0A0A20202020202020202020202068746D6C202B3D20273C746820636F6C7370616E3D22352220636C6173733D226D6F6E7468223E27202B206461746548746D6C202B20273C2F74';
wwv_flow_api.g_varchar2_table(327) := '683E273B0A2020202020202020202020206966202828216D617844617465207C7C206D6178446174652E697341667465722863616C656E6461722E6C6173744461792929202626202821746869732E6C696E6B656443616C656E64617273207C7C207369';
wwv_flow_api.g_varchar2_table(328) := '6465203D3D2027726967687427207C7C20746869732E73696E676C65446174655069636B65722929207B0A2020202020202020202020202020202068746D6C202B3D20273C746820636C6173733D226E65787420617661696C61626C65223E3C6920636C';
wwv_flow_api.g_varchar2_table(329) := '6173733D2266612066612D27202B206172726F772E7269676874202B202720676C79706869636F6E20676C79706869636F6E2D27202B206172726F772E7269676874202B2027223E3C2F693E3C2F74683E273B0A2020202020202020202020207D20656C';
wwv_flow_api.g_varchar2_table(330) := '7365207B0A2020202020202020202020202020202068746D6C202B3D20273C74683E3C2F74683E273B0A2020202020202020202020207D0A0A20202020202020202020202068746D6C202B3D20273C2F74723E273B0A2020202020202020202020206874';
wwv_flow_api.g_varchar2_table(331) := '6D6C202B3D20273C74723E273B0A0A2020202020202020202020202F2F20616464207765656B206E756D626572206C6162656C0A20202020202020202020202069662028746869732E73686F775765656B4E756D62657273207C7C20746869732E73686F';
wwv_flow_api.g_varchar2_table(332) := '7749534F5765656B4E756D62657273290A2020202020202020202020202020202068746D6C202B3D20273C746820636C6173733D227765656B223E27202B20746869732E6C6F63616C652E7765656B4C6162656C202B20273C2F74683E273B0A0A202020';
wwv_flow_api.g_varchar2_table(333) := '202020202020202020242E6561636828746869732E6C6F63616C652E646179734F665765656B2C2066756E6374696F6E28696E6465782C206461794F665765656B29207B0A2020202020202020202020202020202068746D6C202B3D20273C74683E2720';
wwv_flow_api.g_varchar2_table(334) := '2B206461794F665765656B202B20273C2F74683E273B0A2020202020202020202020207D293B0A0A20202020202020202020202068746D6C202B3D20273C2F74723E273B0A20202020202020202020202068746D6C202B3D20273C2F74686561643E273B';
wwv_flow_api.g_varchar2_table(335) := '0A20202020202020202020202068746D6C202B3D20273C74626F64793E273B0A0A2020202020202020202020202F2F61646A757374206D61784461746520746F207265666C6563742074686520646174654C696D69742073657474696E6720696E206F72';
wwv_flow_api.g_varchar2_table(336) := '64657220746F0A2020202020202020202020202F2F67726579206F757420656E64206461746573206265796F6E642074686520646174654C696D69740A20202020202020202020202069662028746869732E656E6444617465203D3D206E756C6C202626';
wwv_flow_api.g_varchar2_table(337) := '20746869732E646174654C696D697429207B0A20202020202020202020202020202020766172206D61784C696D6974203D20746869732E7374617274446174652E636C6F6E6528292E61646428746869732E646174654C696D6974292E656E644F662827';
wwv_flow_api.g_varchar2_table(338) := '64617927293B0A2020202020202020202020202020202069662028216D617844617465207C7C206D61784C696D69742E69734265666F7265286D6178446174652929207B0A20202020202020202020202020202020202020206D617844617465203D206D';
wwv_flow_api.g_varchar2_table(339) := '61784C696D69743B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A202020202020202020202020666F72202876617220726F77203D20303B20726F77203C20363B20726F772B2B29207B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(340) := '20202020202068746D6C202B3D20273C74723E273B0A0A202020202020202020202020202020202F2F20616464207765656B206E756D6265720A2020202020202020202020202020202069662028746869732E73686F775765656B4E756D62657273290A';
wwv_flow_api.g_varchar2_table(341) := '202020202020202020202020202020202020202068746D6C202B3D20273C746420636C6173733D227765656B223E27202B2063616C656E6461725B726F775D5B305D2E7765656B2829202B20273C2F74643E273B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(342) := '20656C73652069662028746869732E73686F7749534F5765656B4E756D62657273290A202020202020202020202020202020202020202068746D6C202B3D20273C746420636C6173733D227765656B223E27202B2063616C656E6461725B726F775D5B30';
wwv_flow_api.g_varchar2_table(343) := '5D2E69736F5765656B2829202B20273C2F74643E273B0A0A20202020202020202020202020202020666F72202876617220636F6C203D20303B20636F6C203C20373B20636F6C2B2B29207B0A0A2020202020202020202020202020202020202020766172';
wwv_flow_api.g_varchar2_table(344) := '20636C6173736573203D205B5D3B0A0A20202020202020202020202020202020202020202F2F686967686C6967687420746F646179277320646174650A20202020202020202020202020202020202020206966202863616C656E6461725B726F775D5B63';
wwv_flow_api.g_varchar2_table(345) := '6F6C5D2E697353616D65286E6577204461746528292C20226461792229290A202020202020202020202020202020202020202020202020636C61737365732E707573682827746F64617927293B0A0A20202020202020202020202020202020202020202F';
wwv_flow_api.g_varchar2_table(346) := '2F686967686C69676874207765656B656E64730A20202020202020202020202020202020202020206966202863616C656E6461725B726F775D5B636F6C5D2E69736F5765656B6461792829203E2035290A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(347) := '2020202020636C61737365732E7075736828277765656B656E6427293B0A0A20202020202020202020202020202020202020202F2F67726579206F75742074686520646174657320696E206F74686572206D6F6E74687320646973706C61796564206174';
wwv_flow_api.g_varchar2_table(348) := '20626567696E6E696E6720616E6420656E64206F6620746869732063616C656E6461720A20202020202020202020202020202020202020206966202863616C656E6461725B726F775D5B636F6C5D2E6D6F6E7468282920213D2063616C656E6461725B31';
wwv_flow_api.g_varchar2_table(349) := '5D5B315D2E6D6F6E74682829290A202020202020202020202020202020202020202020202020636C61737365732E7075736828276F666627293B0A0A20202020202020202020202020202020202020202F2F646F6E277420616C6C6F772073656C656374';
wwv_flow_api.g_varchar2_table(350) := '696F6E206F66206461746573206265666F726520746865206D696E696D756D20646174650A202020202020202020202020202020202020202069662028746869732E6D696E446174652026262063616C656E6461725B726F775D5B636F6C5D2E69734265';
wwv_flow_api.g_varchar2_table(351) := '666F726528746869732E6D696E446174652C20276461792729290A202020202020202020202020202020202020202020202020636C61737365732E7075736828276F6666272C202764697361626C656427293B0A0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(352) := '20202020202F2F646F6E277420616C6C6F772073656C656374696F6E206F6620646174657320616674657220746865206D6178696D756D20646174650A2020202020202020202020202020202020202020696620286D6178446174652026262063616C65';
wwv_flow_api.g_varchar2_table(353) := '6E6461725B726F775D5B636F6C5D2E69734166746572286D6178446174652C20276461792729290A202020202020202020202020202020202020202020202020636C61737365732E7075736828276F6666272C202764697361626C656427293B0A0A2020';
wwv_flow_api.g_varchar2_table(354) := '2020202020202020202020202020202020202F2F646F6E277420616C6C6F772073656C656374696F6E206F662064617465206966206120637573746F6D2066756E6374696F6E2064656369646573206974277320696E76616C69640A2020202020202020';
wwv_flow_api.g_varchar2_table(355) := '20202020202020202020202069662028746869732E6973496E76616C6964446174652863616C656E6461725B726F775D5B636F6C5D29290A202020202020202020202020202020202020202020202020636C61737365732E7075736828276F6666272C20';
wwv_flow_api.g_varchar2_table(356) := '2764697361626C656427293B0A0A20202020202020202020202020202020202020202F2F686967686C69676874207468652063757272656E746C792073656C656374656420737461727420646174650A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(357) := '6966202863616C656E6461725B726F775D5B636F6C5D2E666F726D61742827595959592D4D4D2D44442729203D3D20746869732E7374617274446174652E666F726D61742827595959592D4D4D2D44442729290A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(358) := '2020202020202020636C61737365732E707573682827616374697665272C202773746172742D6461746527293B0A0A20202020202020202020202020202020202020202F2F686967686C69676874207468652063757272656E746C792073656C65637465';
wwv_flow_api.g_varchar2_table(359) := '6420656E6420646174650A202020202020202020202020202020202020202069662028746869732E656E644461746520213D206E756C6C2026262063616C656E6461725B726F775D5B636F6C5D2E666F726D61742827595959592D4D4D2D44442729203D';
wwv_flow_api.g_varchar2_table(360) := '3D20746869732E656E64446174652E666F726D61742827595959592D4D4D2D44442729290A202020202020202020202020202020202020202020202020636C61737365732E707573682827616374697665272C2027656E642D6461746527293B0A0A2020';
wwv_flow_api.g_varchar2_table(361) := '2020202020202020202020202020202020202F2F686967686C6967687420646174657320696E2D6265747765656E207468652073656C65637465642064617465730A202020202020202020202020202020202020202069662028746869732E656E644461';
wwv_flow_api.g_varchar2_table(362) := '746520213D206E756C6C2026262063616C656E6461725B726F775D5B636F6C5D203E20746869732E7374617274446174652026262063616C656E6461725B726F775D5B636F6C5D203C20746869732E656E6444617465290A202020202020202020202020';
wwv_flow_api.g_varchar2_table(363) := '202020202020202020202020636C61737365732E707573682827696E2D72616E676527293B0A0A20202020202020202020202020202020202020202F2F6170706C7920637573746F6D20636C617373657320666F72207468697320646174650A20202020';
wwv_flow_api.g_varchar2_table(364) := '20202020202020202020202020202020766172206973437573746F6D203D20746869732E6973437573746F6D446174652863616C656E6461725B726F775D5B636F6C5D293B0A202020202020202020202020202020202020202069662028697343757374';
wwv_flow_api.g_varchar2_table(365) := '6F6D20213D3D2066616C736529207B0A20202020202020202020202020202020202020202020202069662028747970656F66206973437573746F6D203D3D3D2027737472696E6727290A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(366) := '2020636C61737365732E70757368286973437573746F6D293B0A202020202020202020202020202020202020202020202020656C73650A2020202020202020202020202020202020202020202020202020202041727261792E70726F746F747970652E70';
wwv_flow_api.g_varchar2_table(367) := '7573682E6170706C7928636C61737365732C206973437573746F6D293B0A20202020202020202020202020202020202020207D0A0A202020202020202020202020202020202020202076617220636E616D65203D2027272C2064697361626C6564203D20';
wwv_flow_api.g_varchar2_table(368) := '66616C73653B0A2020202020202020202020202020202020202020666F7220287661722069203D20303B2069203C20636C61737365732E6C656E6774683B20692B2B29207B0A202020202020202020202020202020202020202020202020636E616D6520';
wwv_flow_api.g_varchar2_table(369) := '2B3D20636C61737365735B695D202B202720273B0A20202020202020202020202020202020202020202020202069662028636C61737365735B695D203D3D202764697361626C656427290A20202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(370) := '20202064697361626C6564203D20747275653B0A20202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020696620282164697361626C6564290A2020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(371) := '20636E616D65202B3D2027617661696C61626C65273B0A0A202020202020202020202020202020202020202068746D6C202B3D20273C746420636C6173733D2227202B20636E616D652E7265706C616365282F5E5C732B7C5C732B242F672C2027272920';
wwv_flow_api.g_varchar2_table(372) := '2B20272220646174612D7469746C653D2227202B20277227202B20726F77202B20276327202B20636F6C202B2027223E27202B2063616C656E6461725B726F775D5B636F6C5D2E646174652829202B20273C2F74643E273B0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(373) := '2020202020207D0A2020202020202020202020202020202068746D6C202B3D20273C2F74723E273B0A2020202020202020202020207D0A0A20202020202020202020202068746D6C202B3D20273C2F74626F64793E273B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(374) := '68746D6C202B3D20273C2F7461626C653E273B0A0A202020202020202020202020746869732E636F6E7461696E65722E66696E6428272E63616C656E6461722E27202B2073696465202B2027202E63616C656E6461722D7461626C6527292E68746D6C28';
wwv_flow_api.g_varchar2_table(375) := '68746D6C293B0A202020202020202020202020746869732E656C656D656E742E74726967676572282763616C656E646172557064617465642E61706578272C2074686973293B0A20202020202020207D2C0A0A202020202020202072656E64657254696D';
wwv_flow_api.g_varchar2_table(376) := '655069636B65723A2066756E6374696F6E287369646529207B0A0A2020202020202020202020202F2F20446F6E277420626F74686572207570646174696E67207468652074696D65207069636B657220696620697427732063757272656E746C79206469';
wwv_flow_api.g_varchar2_table(377) := '7361626C65640A2020202020202020202020202F2F206265636175736520616E20656E642064617465206861736E2774206265656E20636C69636B6564207965740A2020202020202020202020206966202873696465203D3D2027726967687427202626';
wwv_flow_api.g_varchar2_table(378) := '2021746869732E656E6444617465292072657475726E3B0A0A2020202020202020202020207661722068746D6C2C2073656C65637465642C206D696E446174652C206D617844617465203D20746869732E6D6178446174653B0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(379) := '20202069662028746869732E646174654C696D6974202626202821746869732E6D617844617465207C7C20746869732E7374617274446174652E636C6F6E6528292E61646428746869732E646174654C696D6974292E6973416674657228746869732E6D';
wwv_flow_api.g_varchar2_table(380) := '6178446174652929290A202020202020202020202020202020206D617844617465203D20746869732E7374617274446174652E636C6F6E6528292E61646428746869732E646174654C696D6974293B0A0A20202020202020202020202069662028736964';
wwv_flow_api.g_varchar2_table(381) := '65203D3D20276C6566742729207B0A2020202020202020202020202020202073656C6563746564203D20746869732E7374617274446174652E636C6F6E6528293B0A202020202020202020202020202020206D696E44617465203D20746869732E6D696E';
wwv_flow_api.g_varchar2_table(382) := '446174653B0A2020202020202020202020207D20656C7365206966202873696465203D3D202772696768742729207B0A2020202020202020202020202020202073656C6563746564203D20746869732E656E64446174652E636C6F6E6528293B0A202020';
wwv_flow_api.g_varchar2_table(383) := '202020202020202020202020206D696E44617465203D20746869732E7374617274446174653B0A0A202020202020202020202020202020202F2F5072657365727665207468652074696D6520616C72656164792073656C65637465640A20202020202020';
wwv_flow_api.g_varchar2_table(384) := '2020202020202020207661722074696D6553656C6563746F72203D20746869732E636F6E7461696E65722E66696E6428272E63616C656E6461722E7269676874202E63616C656E6461722D74696D652064697627293B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(385) := '2020206966202821746869732E656E64446174652026262074696D6553656C6563746F722E68746D6C282920213D20272729207B0A0A202020202020202020202020202020202020202073656C65637465642E686F75722874696D6553656C6563746F72';
wwv_flow_api.g_varchar2_table(386) := '2E66696E6428272E686F757273656C656374206F7074696F6E3A73656C656374656427292E76616C2829207C7C2073656C65637465642E686F75722829293B0A202020202020202020202020202020202020202073656C65637465642E6D696E75746528';
wwv_flow_api.g_varchar2_table(387) := '74696D6553656C6563746F722E66696E6428272E6D696E75746573656C656374206F7074696F6E3A73656C656374656427292E76616C2829207C7C2073656C65637465642E6D696E7574652829293B0A2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(388) := '73656C65637465642E7365636F6E642874696D6553656C6563746F722E66696E6428272E7365636F6E6473656C656374206F7074696F6E3A73656C656374656427292E76616C2829207C7C2073656C65637465642E7365636F6E642829293B0A0A202020';
wwv_flow_api.g_varchar2_table(389) := '20202020202020202020202020202020206966202821746869732E74696D655069636B65723234486F757229207B0A20202020202020202020202020202020202020202020202076617220616D706D203D2074696D6553656C6563746F722E66696E6428';
wwv_flow_api.g_varchar2_table(390) := '272E616D706D73656C656374206F7074696F6E3A73656C656374656427292E76616C28293B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027504D272026262073656C65637465642E686F75722829203C';
wwv_flow_api.g_varchar2_table(391) := '203132290A2020202020202020202020202020202020202020202020202020202073656C65637465642E686F75722873656C65637465642E686F75722829202B203132293B0A20202020202020202020202020202020202020202020202069662028616D';
wwv_flow_api.g_varchar2_table(392) := '706D203D3D3D2027414D272026262073656C65637465642E686F75722829203D3D3D203132290A2020202020202020202020202020202020202020202020202020202073656C65637465642E686F75722830293B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(393) := '20202020207D0A0A202020202020202020202020202020207D0A0A202020202020202020202020202020206966202873656C65637465642E69734265666F726528746869732E73746172744461746529290A202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(394) := '202073656C6563746564203D20746869732E7374617274446174652E636C6F6E6528293B0A0A20202020202020202020202020202020696620286D6178446174652026262073656C65637465642E69734166746572286D61784461746529290A20202020';
wwv_flow_api.g_varchar2_table(395) := '2020202020202020202020202020202073656C6563746564203D206D6178446174652E636C6F6E6528293B0A0A2020202020202020202020207D0A0A2020202020202020202020202F2F0A2020202020202020202020202F2F20686F7572730A20202020';
wwv_flow_api.g_varchar2_table(396) := '20202020202020202F2F0A0A20202020202020202020202068746D6C203D20273C73656C65637420636C6173733D22686F757273656C656374223E273B0A0A202020202020202020202020766172207374617274203D20746869732E74696D655069636B';
wwv_flow_api.g_varchar2_table(397) := '65723234486F7572203F2030203A20313B0A20202020202020202020202076617220656E64203D20746869732E74696D655069636B65723234486F7572203F203233203A2031323B0A0A202020202020202020202020666F7220287661722069203D2073';
wwv_flow_api.g_varchar2_table(398) := '746172743B2069203C3D20656E643B20692B2B29207B0A2020202020202020202020202020202076617220695F696E5F3234203D20693B0A202020202020202020202020202020206966202821746869732E74696D655069636B65723234486F7572290A';
wwv_flow_api.g_varchar2_table(399) := '2020202020202020202020202020202020202020695F696E5F3234203D2073656C65637465642E686F75722829203E3D203132203F202869203D3D203132203F203132203A2069202B20313229203A202869203D3D203132203F2030203A2069293B0A0A';
wwv_flow_api.g_varchar2_table(400) := '202020202020202020202020202020207661722074696D65203D2073656C65637465642E636C6F6E6528292E686F757228695F696E5F3234293B0A202020202020202020202020202020207661722064697361626C6564203D2066616C73653B0A202020';
wwv_flow_api.g_varchar2_table(401) := '20202020202020202020202020696620286D696E446174652026262074696D652E6D696E757465283539292E69734265666F7265286D696E4461746529290A202020202020202020202020202020202020202064697361626C6564203D20747275653B0A';
wwv_flow_api.g_varchar2_table(402) := '20202020202020202020202020202020696620286D6178446174652026262074696D652E6D696E7574652830292E69734166746572286D61784461746529290A202020202020202020202020202020202020202064697361626C6564203D20747275653B';
wwv_flow_api.g_varchar2_table(403) := '0A0A2020202020202020202020202020202069662028695F696E5F3234203D3D2073656C65637465642E686F75722829202626202164697361626C656429207B0A202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F';
wwv_flow_api.g_varchar2_table(404) := '6E2076616C75653D2227202B2069202B2027222073656C65637465643D2273656C6563746564223E27202B2069202B20273C2F6F7074696F6E3E273B0A202020202020202020202020202020207D20656C7365206966202864697361626C656429207B0A';
wwv_flow_api.g_varchar2_table(405) := '202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F6E2076616C75653D2227202B2069202B2027222064697361626C65643D2264697361626C65642220636C6173733D2264697361626C6564223E27202B2069202B20';
wwv_flow_api.g_varchar2_table(406) := '273C2F6F7074696F6E3E273B0A202020202020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F6E2076616C75653D2227202B2069202B2027223E27202B2069202B';
wwv_flow_api.g_varchar2_table(407) := '20273C2F6F7074696F6E3E273B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020202020202068746D6C202B3D20273C2F73656C6563743E20273B0A0A2020202020202020202020202F2F0A202020';
wwv_flow_api.g_varchar2_table(408) := '2020202020202020202F2F206D696E757465730A2020202020202020202020202F2F0A0A20202020202020202020202068746D6C202B3D20273A203C73656C65637420636C6173733D226D696E75746573656C656374223E273B0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(409) := '20202020666F7220287661722069203D20303B2069203C2036303B2069202B3D20746869732E74696D655069636B6572496E6372656D656E7429207B0A2020202020202020202020202020202076617220706164646564203D2069203C203130203F2027';
wwv_flow_api.g_varchar2_table(410) := '3027202B2069203A20693B0A202020202020202020202020202020207661722074696D65203D2073656C65637465642E636C6F6E6528292E6D696E7574652869293B0A0A202020202020202020202020202020207661722064697361626C6564203D2066';
wwv_flow_api.g_varchar2_table(411) := '616C73653B0A20202020202020202020202020202020696620286D696E446174652026262074696D652E7365636F6E64283539292E69734265666F7265286D696E4461746529290A202020202020202020202020202020202020202064697361626C6564';
wwv_flow_api.g_varchar2_table(412) := '203D20747275653B0A20202020202020202020202020202020696620286D6178446174652026262074696D652E7365636F6E642830292E69734166746572286D61784461746529290A202020202020202020202020202020202020202064697361626C65';
wwv_flow_api.g_varchar2_table(413) := '64203D20747275653B0A0A202020202020202020202020202020206966202873656C65637465642E6D696E7574652829203D3D2069202626202164697361626C656429207B0A202020202020202020202020202020202020202068746D6C202B3D20273C';
wwv_flow_api.g_varchar2_table(414) := '6F7074696F6E2076616C75653D2227202B2069202B2027222073656C65637465643D2273656C6563746564223E27202B20706164646564202B20273C2F6F7074696F6E3E273B0A202020202020202020202020202020207D20656C736520696620286469';
wwv_flow_api.g_varchar2_table(415) := '7361626C656429207B0A202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F6E2076616C75653D2227202B2069202B2027222064697361626C65643D2264697361626C65642220636C6173733D2264697361626C6564';
wwv_flow_api.g_varchar2_table(416) := '223E27202B20706164646564202B20273C2F6F7074696F6E3E273B0A202020202020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F6E2076616C75653D2227202B';
wwv_flow_api.g_varchar2_table(417) := '2069202B2027223E27202B20706164646564202B20273C2F6F7074696F6E3E273B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020202020202068746D6C202B3D20273C2F73656C6563743E20273B';
wwv_flow_api.g_varchar2_table(418) := '0A0A2020202020202020202020202F2F0A2020202020202020202020202F2F207365636F6E64730A2020202020202020202020202F2F0A0A20202020202020202020202069662028746869732E74696D655069636B65725365636F6E647329207B0A2020';
wwv_flow_api.g_varchar2_table(419) := '202020202020202020202020202068746D6C202B3D20273A203C73656C65637420636C6173733D227365636F6E6473656C656374223E273B0A0A20202020202020202020202020202020666F7220287661722069203D20303B2069203C2036303B20692B';
wwv_flow_api.g_varchar2_table(420) := '2B29207B0A202020202020202020202020202020202020202076617220706164646564203D2069203C203130203F20273027202B2069203A20693B0A20202020202020202020202020202020202020207661722074696D65203D2073656C65637465642E';
wwv_flow_api.g_varchar2_table(421) := '636C6F6E6528292E7365636F6E642869293B0A0A20202020202020202020202020202020202020207661722064697361626C6564203D2066616C73653B0A2020202020202020202020202020202020202020696620286D696E446174652026262074696D';
wwv_flow_api.g_varchar2_table(422) := '652E69734265666F7265286D696E4461746529290A20202020202020202020202020202020202020202020202064697361626C6564203D20747275653B0A2020202020202020202020202020202020202020696620286D6178446174652026262074696D';
wwv_flow_api.g_varchar2_table(423) := '652E69734166746572286D61784461746529290A20202020202020202020202020202020202020202020202064697361626C6564203D20747275653B0A0A20202020202020202020202020202020202020206966202873656C65637465642E7365636F6E';
wwv_flow_api.g_varchar2_table(424) := '642829203D3D2069202626202164697361626C656429207B0A20202020202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F6E2076616C75653D2227202B2069202B2027222073656C65637465643D2273656C656374';
wwv_flow_api.g_varchar2_table(425) := '6564223E27202B20706164646564202B20273C2F6F7074696F6E3E273B0A20202020202020202020202020202020202020207D20656C7365206966202864697361626C656429207B0A20202020202020202020202020202020202020202020202068746D';
wwv_flow_api.g_varchar2_table(426) := '6C202B3D20273C6F7074696F6E2076616C75653D2227202B2069202B2027222064697361626C65643D2264697361626C65642220636C6173733D2264697361626C6564223E27202B20706164646564202B20273C2F6F7074696F6E3E273B0A2020202020';
wwv_flow_api.g_varchar2_table(427) := '2020202020202020202020202020207D20656C7365207B0A20202020202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F6E2076616C75653D2227202B2069202B2027223E27202B20706164646564202B20273C2F6F';
wwv_flow_api.g_varchar2_table(428) := '7074696F6E3E273B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A2020202020202020202020202020202068746D6C202B3D20273C2F73656C6563743E20273B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(429) := '7D0A0A2020202020202020202020202F2F0A2020202020202020202020202F2F20414D2F504D0A2020202020202020202020202F2F0A0A2020202020202020202020206966202821746869732E74696D655069636B65723234486F757229207B0A202020';
wwv_flow_api.g_varchar2_table(430) := '2020202020202020202020202068746D6C202B3D20273C73656C65637420636C6173733D22616D706D73656C656374223E273B0A0A2020202020202020202020202020202076617220616D5F68746D6C203D2027273B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(431) := '20202076617220706D5F68746D6C203D2027273B0A0A20202020202020202020202020202020696620286D696E446174652026262073656C65637465642E636C6F6E6528292E686F7572283132292E6D696E7574652830292E7365636F6E642830292E69';
wwv_flow_api.g_varchar2_table(432) := '734265666F7265286D696E4461746529290A2020202020202020202020202020202020202020616D5F68746D6C203D20272064697361626C65643D2264697361626C65642220636C6173733D2264697361626C656422273B0A0A20202020202020202020';
wwv_flow_api.g_varchar2_table(433) := '202020202020696620286D6178446174652026262073656C65637465642E636C6F6E6528292E686F75722830292E6D696E7574652830292E7365636F6E642830292E69734166746572286D61784461746529290A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(434) := '20202020706D5F68746D6C203D20272064697361626C65643D2264697361626C65642220636C6173733D2264697361626C656422273B0A0A202020202020202020202020202020206966202873656C65637465642E686F75722829203E3D20313229207B';
wwv_flow_api.g_varchar2_table(435) := '0A202020202020202020202020202020202020202068746D6C202B3D20273C6F7074696F6E2076616C75653D22414D2227202B20616D5F68746D6C202B20273E414D3C2F6F7074696F6E3E3C6F7074696F6E2076616C75653D22504D222073656C656374';
wwv_flow_api.g_varchar2_table(436) := '65643D2273656C65637465642227202B20706D5F68746D6C202B20273E504D3C2F6F7074696F6E3E273B0A202020202020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202068746D6C202B3D20273C6F70';
wwv_flow_api.g_varchar2_table(437) := '74696F6E2076616C75653D22414D222073656C65637465643D2273656C65637465642227202B20616D5F68746D6C202B20273E414D3C2F6F7074696F6E3E3C6F7074696F6E2076616C75653D22504D2227202B20706D5F68746D6C202B20273E504D3C2F';
wwv_flow_api.g_varchar2_table(438) := '6F7074696F6E3E273B0A202020202020202020202020202020207D0A0A2020202020202020202020202020202068746D6C202B3D20273C2F73656C6563743E273B0A2020202020202020202020207D0A0A202020202020202020202020746869732E636F';
wwv_flow_api.g_varchar2_table(439) := '6E7461696E65722E66696E6428272E63616C656E6461722E27202B2073696465202B2027202E63616C656E6461722D74696D652064697627292E68746D6C2868746D6C293B0A0A20202020202020207D2C0A0A2020202020202020757064617465466F72';
wwv_flow_api.g_varchar2_table(440) := '6D496E707574733A2066756E6374696F6E2829207B0A0A2020202020202020202020202F2F69676E6F7265206D6F757365206D6F76656D656E7473207768696C6520616E2061626F76652D63616C656E646172207465787420696E707574206861732066';
wwv_flow_api.g_varchar2_table(441) := '6F6375730A20202020202020202020202069662028746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F73746172745D27292E697328223A666F6375732229207C7C20746869732E63';
wwv_flow_api.g_varchar2_table(442) := '6F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F656E645D27292E697328223A666F6375732229290A2020202020202020202020202020202072657475726E3B0A0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(443) := '746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F73746172745D27292E76616C28746869732E7374617274446174652E666F726D617428746869732E6C6F63616C652E666F726D61';
wwv_flow_api.g_varchar2_table(444) := '7429293B0A20202020202020202020202069662028746869732E656E6444617465290A20202020202020202020202020202020746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F65';
wwv_flow_api.g_varchar2_table(445) := '6E645D27292E76616C28746869732E656E64446174652E666F726D617428746869732E6C6F63616C652E666F726D617429293B0A0A20202020202020202020202069662028746869732E73696E676C65446174655069636B6572207C7C2028746869732E';
wwv_flow_api.g_varchar2_table(446) := '656E64446174652026262028746869732E7374617274446174652E69734265666F726528746869732E656E644461746529207C7C20746869732E7374617274446174652E697353616D6528746869732E656E644461746529292929207B0A202020202020';
wwv_flow_api.g_varchar2_table(447) := '20202020202020202020746869732E636F6E7461696E65722E66696E642827627574746F6E2E6170706C7942746E27292E72656D6F766541747472282764697361626C656427293B0A2020202020202020202020207D20656C7365207B0A202020202020';
wwv_flow_api.g_varchar2_table(448) := '20202020202020202020746869732E636F6E7461696E65722E66696E642827627574746F6E2E6170706C7942746E27292E61747472282764697361626C6564272C202764697361626C656427293B0A2020202020202020202020207D0A0A202020202020';
wwv_flow_api.g_varchar2_table(449) := '20207D2C0A0A20202020202020206D6F76653A2066756E6374696F6E2829207B0A20202020202020202020202076617220706172656E744F6666736574203D207B20746F703A20302C206C6566743A2030207D2C0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(450) := '20636F6E7461696E6572546F703B0A20202020202020202020202076617220706172656E74526967687445646765203D20242877696E646F77292E776964746828293B0A2020202020202020202020206966202821746869732E706172656E74456C2E69';
wwv_flow_api.g_varchar2_table(451) := '732827626F6479272929207B0A20202020202020202020202020202020706172656E744F6666736574203D207B0A2020202020202020202020202020202020202020746F703A20746869732E706172656E74456C2E6F666673657428292E746F70202D20';
wwv_flow_api.g_varchar2_table(452) := '746869732E706172656E74456C2E7363726F6C6C546F7028292C0A20202020202020202020202020202020202020206C6566743A20746869732E706172656E74456C2E6F666673657428292E6C656674202D20746869732E706172656E74456C2E736372';
wwv_flow_api.g_varchar2_table(453) := '6F6C6C4C65667428290A202020202020202020202020202020207D3B0A20202020202020202020202020202020706172656E74526967687445646765203D20746869732E706172656E74456C5B305D2E636C69656E745769647468202B20746869732E70';
wwv_flow_api.g_varchar2_table(454) := '6172656E74456C2E6F666673657428292E6C6566743B0A2020202020202020202020207D0A0A20202020202020202020202069662028746869732E64726F7073203D3D2027757027290A20202020202020202020202020202020636F6E7461696E657254';
wwv_flow_api.g_varchar2_table(455) := '6F70203D20746869732E656C656D656E742E6F666673657428292E746F70202D20746869732E636F6E7461696E65722E6F757465724865696768742829202D20706172656E744F66667365742E746F703B0A202020202020202020202020656C73650A20';
wwv_flow_api.g_varchar2_table(456) := '202020202020202020202020202020636F6E7461696E6572546F70203D20746869732E656C656D656E742E6F666673657428292E746F70202B20746869732E656C656D656E742E6F757465724865696768742829202D20706172656E744F66667365742E';
wwv_flow_api.g_varchar2_table(457) := '746F703B0A202020202020202020202020746869732E636F6E7461696E65725B746869732E64726F7073203D3D2027757027203F2027616464436C61737327203A202772656D6F7665436C617373275D282764726F70757027293B0A0A20202020202020';
wwv_flow_api.g_varchar2_table(458) := '202020202069662028746869732E6F70656E73203D3D20276C6566742729207B0A20202020202020202020202020202020746869732E636F6E7461696E65722E637373287B0A2020202020202020202020202020202020202020746F703A20636F6E7461';
wwv_flow_api.g_varchar2_table(459) := '696E6572546F702C0A202020202020202020202020202020202020202072696768743A20706172656E74526967687445646765202D20746869732E656C656D656E742E6F666673657428292E6C656674202D20746869732E656C656D656E742E6F757465';
wwv_flow_api.g_varchar2_table(460) := '72576964746828292C0A20202020202020202020202020202020202020206C6566743A20276175746F270A202020202020202020202020202020207D293B0A2020202020202020202020202020202069662028746869732E636F6E7461696E65722E6F66';
wwv_flow_api.g_varchar2_table(461) := '6673657428292E6C656674203C203029207B0A2020202020202020202020202020202020202020746869732E636F6E7461696E65722E637373287B0A20202020202020202020202020202020202020202020202072696768743A20276175746F272C0A20';
wwv_flow_api.g_varchar2_table(462) := '20202020202020202020202020202020202020202020206C6566743A20390A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D0A2020202020202020202020207D20656C7365206966202874686973';
wwv_flow_api.g_varchar2_table(463) := '2E6F70656E73203D3D202763656E7465722729207B0A20202020202020202020202020202020746869732E636F6E7461696E65722E637373287B0A2020202020202020202020202020202020202020746F703A20636F6E7461696E6572546F702C0A2020';
wwv_flow_api.g_varchar2_table(464) := '2020202020202020202020202020202020206C6566743A20746869732E656C656D656E742E6F666673657428292E6C656674202D20706172656E744F66667365742E6C656674202B20746869732E656C656D656E742E6F7574657257696474682829202F';
wwv_flow_api.g_varchar2_table(465) := '20320A202020202020202020202020202020202020202020202020202020202D20746869732E636F6E7461696E65722E6F7574657257696474682829202F20322C0A202020202020202020202020202020202020202072696768743A20276175746F270A';
wwv_flow_api.g_varchar2_table(466) := '202020202020202020202020202020207D293B0A2020202020202020202020202020202069662028746869732E636F6E7461696E65722E6F666673657428292E6C656674203C203029207B0A202020202020202020202020202020202020202074686973';
wwv_flow_api.g_varchar2_table(467) := '2E636F6E7461696E65722E637373287B0A20202020202020202020202020202020202020202020202072696768743A20276175746F272C0A2020202020202020202020202020202020202020202020206C6566743A20390A202020202020202020202020';
wwv_flow_api.g_varchar2_table(468) := '20202020202020207D293B0A202020202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020746869732E636F6E7461696E65722E637373287B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(469) := '2020202020202020746F703A20636F6E7461696E6572546F702C0A20202020202020202020202020202020202020206C6566743A20746869732E656C656D656E742E6F666673657428292E6C656674202D20706172656E744F66667365742E6C6566742C';
wwv_flow_api.g_varchar2_table(470) := '0A202020202020202020202020202020202020202072696768743A20276175746F270A202020202020202020202020202020207D293B0A2020202020202020202020202020202069662028746869732E636F6E7461696E65722E6F666673657428292E6C';
wwv_flow_api.g_varchar2_table(471) := '656674202B20746869732E636F6E7461696E65722E6F7574657257696474682829203E20242877696E646F77292E7769647468282929207B0A2020202020202020202020202020202020202020746869732E636F6E7461696E65722E637373287B0A2020';
wwv_flow_api.g_varchar2_table(472) := '202020202020202020202020202020202020202020206C6566743A20276175746F272C0A20202020202020202020202020202020202020202020202072696768743A20300A20202020202020202020202020202020202020207D293B0A20202020202020';
wwv_flow_api.g_varchar2_table(473) := '2020202020202020207D0A2020202020202020202020207D0A20202020202020207D2C0A0A202020202020202073686F773A2066756E6374696F6E286529207B0A20202020202020202020202069662028746869732E697353686F77696E672920726574';
wwv_flow_api.g_varchar2_table(474) := '75726E3B0A0A2020202020202020202020202F2F20437265617465206120636C69636B2070726F78792074686174206973207072697661746520746F207468697320696E7374616E6365206F6620646174657069636B65722C20666F7220756E62696E64';
wwv_flow_api.g_varchar2_table(475) := '696E670A202020202020202020202020746869732E5F6F757473696465436C69636B50726F7879203D20242E70726F78792866756E6374696F6E286529207B20746869732E6F757473696465436C69636B2865293B207D2C2074686973293B0A0A202020';
wwv_flow_api.g_varchar2_table(476) := '2020202020202020202F2F2042696E6420676C6F62616C20646174657069636B6572206D6F757365646F776E20666F7220686964696E6720616E640A2020202020202020202020202428646F63756D656E74290A20202020202020202020202020202E6F';
wwv_flow_api.g_varchar2_table(477) := '6E28276D6F757365646F776E2E6461746572616E67657069636B6572272C20746869732E5F6F757473696465436C69636B50726F7879290A20202020202020202020202020202F2F20616C736F20737570706F7274206D6F62696C652064657669636573';
wwv_flow_api.g_varchar2_table(478) := '0A20202020202020202020202020202E6F6E2827746F756368656E642E6461746572616E67657069636B6572272C20746869732E5F6F757473696465436C69636B50726F7879290A20202020202020202020202020202F2F20616C736F206578706C6963';
wwv_flow_api.g_varchar2_table(479) := '69746C7920706C6179206E696365207769746820426F6F7473747261702064726F70646F776E732C2077686963682073746F7050726F7061676174696F6E207768656E20636C69636B696E67207468656D0A20202020202020202020202020202E6F6E28';
wwv_flow_api.g_varchar2_table(480) := '27636C69636B2E6461746572616E67657069636B6572272C20275B646174612D746F67676C653D64726F70646F776E5D272C20746869732E5F6F757473696465436C69636B50726F7879290A20202020202020202020202020202F2F20616E6420616C73';
wwv_flow_api.g_varchar2_table(481) := '6F20636C6F7365207768656E20666F637573206368616E67657320746F206F75747369646520746865207069636B6572202865672E2074616262696E67206265747765656E20636F6E74726F6C73290A20202020202020202020202020202E6F6E282766';
wwv_flow_api.g_varchar2_table(482) := '6F637573696E2E6461746572616E67657069636B6572272C20746869732E5F6F757473696465436C69636B50726F7879293B0A0A2020202020202020202020202F2F205265706F736974696F6E20746865207069636B6572206966207468652077696E64';
wwv_flow_api.g_varchar2_table(483) := '6F7720697320726573697A6564207768696C652069742773206F70656E0A202020202020202020202020242877696E646F77292E6F6E2827726573697A652E6461746572616E67657069636B6572272C20242E70726F78792866756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(484) := '207B20746869732E6D6F76652865293B207D2C207468697329293B0A0A202020202020202020202020746869732E6F6C64537461727444617465203D20746869732E7374617274446174652E636C6F6E6528293B0A202020202020202020202020746869';
wwv_flow_api.g_varchar2_table(485) := '732E6F6C64456E6444617465203D20746869732E656E64446174652E636C6F6E6528293B0A202020202020202020202020746869732E70726576696F7573526967687454696D65203D20746869732E656E64446174652E636C6F6E6528293B0A0A202020';
wwv_flow_api.g_varchar2_table(486) := '202020202020202020746869732E7570646174655669657728293B0A202020202020202020202020746869732E636F6E7461696E65722E73686F7728293B0A202020202020202020202020746869732E6D6F766528293B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(487) := '746869732E656C656D656E742E74726967676572282773686F772E6461746572616E67657069636B6572272C2074686973293B0A202020202020202020202020746869732E697353686F77696E67203D20747275653B0A20202020202020207D2C0A0A20';
wwv_flow_api.g_varchar2_table(488) := '20202020202020686964653A2066756E6374696F6E286529207B0A2020202020202020202020206966202821746869732E697353686F77696E67292072657475726E3B0A0A2020202020202020202020202F2F696E636F6D706C65746520646174652073';
wwv_flow_api.g_varchar2_table(489) := '656C656374696F6E2C2072657665727420746F206C6173742076616C7565730A2020202020202020202020206966202821746869732E656E644461746529207B0A20202020202020202020202020202020746869732E737461727444617465203D207468';
wwv_flow_api.g_varchar2_table(490) := '69732E6F6C645374617274446174652E636C6F6E6528293B0A20202020202020202020202020202020746869732E656E6444617465203D20746869732E6F6C64456E64446174652E636C6F6E6528293B0A2020202020202020202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(491) := '20202020202020202F2F69662061206E657720646174652072616E6765207761732073656C65637465642C20696E766F6B652074686520757365722063616C6C6261636B2066756E6374696F6E0A2020202020202020202020206966202821746869732E';
wwv_flow_api.g_varchar2_table(492) := '7374617274446174652E697353616D6528746869732E6F6C6453746172744461746529207C7C2021746869732E656E64446174652E697353616D6528746869732E6F6C64456E644461746529290A20202020202020202020202020202020746869732E63';
wwv_flow_api.g_varchar2_table(493) := '616C6C6261636B28746869732E7374617274446174652C20746869732E656E64446174652C20746869732E63686F73656E4C6162656C293B0A0A2020202020202020202020202F2F6966207069636B657220697320617474616368656420746F20612074';
wwv_flow_api.g_varchar2_table(494) := '65787420696E7075742C207570646174652069740A202020202020202020202020746869732E757064617465456C656D656E7428293B0A0A2020202020202020202020202428646F63756D656E74292E6F666628272E6461746572616E67657069636B65';
wwv_flow_api.g_varchar2_table(495) := '7227293B0A202020202020202020202020242877696E646F77292E6F666628272E6461746572616E67657069636B657227293B0A202020202020202020202020746869732E636F6E7461696E65722E6869646528293B0A20202020202020202020202074';
wwv_flow_api.g_varchar2_table(496) := '6869732E656C656D656E742E747269676765722827686964652E6461746572616E67657069636B6572272C2074686973293B0A202020202020202020202020746869732E697353686F77696E67203D2066616C73653B0A20202020202020207D2C0A0A20';
wwv_flow_api.g_varchar2_table(497) := '20202020202020746F67676C653A2066756E6374696F6E286529207B0A20202020202020202020202069662028746869732E697353686F77696E6729207B0A20202020202020202020202020202020746869732E6869646528293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(498) := '202020207D20656C7365207B0A20202020202020202020202020202020746869732E73686F7728293B0A2020202020202020202020207D0A20202020202020207D2C0A0A20202020202020206F757473696465436C69636B3A2066756E6374696F6E2865';
wwv_flow_api.g_varchar2_table(499) := '29207B0A20202020202020202020202076617220746172676574203D202428652E746172676574293B0A2020202020202020202020202F2F20696620746865207061676520697320636C69636B656420616E797768657265206578636570742077697468';
wwv_flow_api.g_varchar2_table(500) := '696E20746865206461746572616E6765727069636B65722F627574746F6E0A2020202020202020202020202F2F20697473656C66207468656E2063616C6C20746869732E6869646528290A202020202020202020202020696620280A2020202020202020';
wwv_flow_api.g_varchar2_table(501) := '20202020202020202F2F206965206D6F64616C206469616C6F67206669780A20202020202020202020202020202020652E74797065203D3D2022666F637573696E22207C7C0A202020202020202020202020202020207461726765742E636C6F73657374';
wwv_flow_api.g_varchar2_table(502) := '28746869732E656C656D656E74292E6C656E677468207C7C0A202020202020202020202020202020207461726765742E636C6F7365737428746869732E636F6E7461696E6572292E6C656E677468207C7C0A202020202020202020202020202020207461';
wwv_flow_api.g_varchar2_table(503) := '726765742E636C6F7365737428272E63616C656E6461722D7461626C6527292E6C656E6774680A20202020202020202020202020202020292072657475726E3B0A202020202020202020202020746869732E6869646528293B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(504) := '2020746869732E656C656D656E742E7472696767657228276F757473696465436C69636B2E6461746572616E67657069636B6572272C2074686973293B0A20202020202020207D2C0A0A202020202020202073686F7743616C656E646172733A2066756E';
wwv_flow_api.g_varchar2_table(505) := '6374696F6E2829207B0A202020202020202020202020746869732E636F6E7461696E65722E616464436C617373282773686F772D63616C656E64617227293B0A202020202020202020202020746869732E6D6F766528293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(506) := '20746869732E656C656D656E742E74726967676572282773686F7743616C656E6461722E6461746572616E67657069636B6572272C2074686973293B0A20202020202020207D2C0A0A20202020202020206869646543616C656E646172733A2066756E63';
wwv_flow_api.g_varchar2_table(507) := '74696F6E2829207B0A202020202020202020202020746869732E636F6E7461696E65722E72656D6F7665436C617373282773686F772D63616C656E64617227293B0A202020202020202020202020746869732E656C656D656E742E747269676765722827';
wwv_flow_api.g_varchar2_table(508) := '6869646543616C656E6461722E6461746572616E67657069636B6572272C2074686973293B0A20202020202020207D2C0A0A2020202020202020686F76657252616E67653A2066756E6374696F6E286529207B0A0A2020202020202020202020202F2F69';
wwv_flow_api.g_varchar2_table(509) := '676E6F7265206D6F757365206D6F76656D656E7473207768696C6520616E2061626F76652D63616C656E646172207465787420696E7075742068617320666F6375730A20202020202020202020202069662028746869732E636F6E7461696E65722E6669';
wwv_flow_api.g_varchar2_table(510) := '6E642827696E7075745B6E616D653D6461746572616E67657069636B65725F73746172745D27292E697328223A666F6375732229207C7C20746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E6765706963';
wwv_flow_api.g_varchar2_table(511) := '6B65725F656E645D27292E697328223A666F6375732229290A2020202020202020202020202020202072657475726E3B0A0A202020202020202020202020766172206C6162656C203D20652E7461726765742E6765744174747269627574652827646174';
wwv_flow_api.g_varchar2_table(512) := '612D72616E67652D6B657927293B0A0A202020202020202020202020696620286C6162656C203D3D20746869732E6C6F63616C652E637573746F6D52616E67654C6162656C29207B0A20202020202020202020202020202020746869732E757064617465';
wwv_flow_api.g_varchar2_table(513) := '5669657728293B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020766172206461746573203D20746869732E72616E6765735B6C6162656C5D3B0A20202020202020202020202020202020746869732E636F';
wwv_flow_api.g_varchar2_table(514) := '6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F73746172745D27292E76616C2864617465735B305D2E666F726D617428746869732E6C6F63616C652E666F726D617429293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(515) := '2020202020202020746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F656E645D27292E76616C2864617465735B315D2E666F726D617428746869732E6C6F63616C652E666F726D61';
wwv_flow_api.g_varchar2_table(516) := '7429293B0A2020202020202020202020207D0A0A20202020202020207D2C0A0A2020202020202020636C69636B52616E67653A2066756E6374696F6E286529207B0A202020202020202020202020766172206C6162656C203D20652E7461726765742E67';
wwv_flow_api.g_varchar2_table(517) := '65744174747269627574652827646174612D72616E67652D6B657927293B0A202020202020202020202020746869732E63686F73656E4C6162656C203D206C6162656C3B0A202020202020202020202020696620286C6162656C203D3D20746869732E6C';
wwv_flow_api.g_varchar2_table(518) := '6F63616C652E637573746F6D52616E67654C6162656C29207B0A20202020202020202020202020202020746869732E73686F7743616C656E6461727328293B0A2020202020202020202020207D20656C7365207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(519) := '20766172206461746573203D20746869732E72616E6765735B6C6162656C5D3B0A20202020202020202020202020202020746869732E737461727444617465203D2064617465735B305D3B0A20202020202020202020202020202020746869732E656E64';
wwv_flow_api.g_varchar2_table(520) := '44617465203D2064617465735B315D3B0A0A202020202020202020202020202020206966202821746869732E74696D655069636B657229207B0A2020202020202020202020202020202020202020746869732E7374617274446174652E73746172744F66';
wwv_flow_api.g_varchar2_table(521) := '282764617927293B0A2020202020202020202020202020202020202020746869732E656E64446174652E656E644F66282764617927293B0A202020202020202020202020202020207D0A0A20202020202020202020202020202020696620282174686973';
wwv_flow_api.g_varchar2_table(522) := '2E616C7761797353686F7743616C656E64617273290A2020202020202020202020202020202020202020746869732E6869646543616C656E6461727328293B0A20202020202020202020202020202020746869732E636C69636B4170706C7928293B0A20';
wwv_flow_api.g_varchar2_table(523) := '20202020202020202020207D0A20202020202020207D2C0A0A2020202020202020636C69636B507265763A2066756E6374696F6E286529207B0A2020202020202020202020207661722063616C203D202428652E746172676574292E706172656E747328';
wwv_flow_api.g_varchar2_table(524) := '272E63616C656E64617227293B0A2020202020202020202020206966202863616C2E686173436C61737328276C656674272929207B0A20202020202020202020202020202020746869732E6C65667443616C656E6461722E6D6F6E74682E737562747261';
wwv_flow_api.g_varchar2_table(525) := '637428312C20276D6F6E746827293B0A2020202020202020202020202020202069662028746869732E6C696E6B656443616C656E64617273290A2020202020202020202020202020202020202020746869732E726967687443616C656E6461722E6D6F6E';
wwv_flow_api.g_varchar2_table(526) := '74682E737562747261637428312C20276D6F6E746827293B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020746869732E726967687443616C656E6461722E6D6F6E74682E737562747261637428312C2027';
wwv_flow_api.g_varchar2_table(527) := '6D6F6E746827293B0A2020202020202020202020207D0A202020202020202020202020746869732E75706461746543616C656E6461727328293B0A20202020202020207D2C0A0A2020202020202020636C69636B4E6578743A2066756E6374696F6E2865';
wwv_flow_api.g_varchar2_table(528) := '29207B0A2020202020202020202020207661722063616C203D202428652E746172676574292E706172656E747328272E63616C656E64617227293B0A2020202020202020202020206966202863616C2E686173436C61737328276C656674272929207B0A';
wwv_flow_api.g_varchar2_table(529) := '20202020202020202020202020202020746869732E6C65667443616C656E6461722E6D6F6E74682E61646428312C20276D6F6E746827293B0A2020202020202020202020207D20656C7365207B0A20202020202020202020202020202020746869732E72';
wwv_flow_api.g_varchar2_table(530) := '6967687443616C656E6461722E6D6F6E74682E61646428312C20276D6F6E746827293B0A2020202020202020202020202020202069662028746869732E6C696E6B656443616C656E64617273290A20202020202020202020202020202020202020207468';
wwv_flow_api.g_varchar2_table(531) := '69732E6C65667443616C656E6461722E6D6F6E74682E61646428312C20276D6F6E746827293B0A2020202020202020202020207D0A202020202020202020202020746869732E75706461746543616C656E6461727328293B0A20202020202020207D2C0A';
wwv_flow_api.g_varchar2_table(532) := '0A2020202020202020686F766572446174653A2066756E6374696F6E286529207B0A0A2020202020202020202020202F2F69676E6F7265206D6F757365206D6F76656D656E7473207768696C6520616E2061626F76652D63616C656E6461722074657874';
wwv_flow_api.g_varchar2_table(533) := '20696E7075742068617320666F6375730A2020202020202020202020202F2F69662028746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F73746172745D27292E697328223A666F63';
wwv_flow_api.g_varchar2_table(534) := '75732229207C7C20746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F656E645D27292E697328223A666F6375732229290A2020202020202020202020202F2F202020207265747572';
wwv_flow_api.g_varchar2_table(535) := '6E3B0A0A2020202020202020202020202F2F69676E6F726520646174657320746861742063616E27742062652073656C65637465640A20202020202020202020202069662028212428652E746172676574292E686173436C6173732827617661696C6162';
wwv_flow_api.g_varchar2_table(536) := '6C652729292072657475726E3B0A0A2020202020202020202020202F2F6861766520746865207465787420696E707574732061626F76652063616C656E64617273207265666C656374207468652064617465206265696E6720686F7665726564206F7665';
wwv_flow_api.g_varchar2_table(537) := '720A202020202020202020202020766172207469746C65203D202428652E746172676574292E617474722827646174612D7469746C6527293B0A20202020202020202020202076617220726F77203D207469746C652E73756273747228312C2031293B0A';
wwv_flow_api.g_varchar2_table(538) := '20202020202020202020202076617220636F6C203D207469746C652E73756273747228332C2031293B0A2020202020202020202020207661722063616C203D202428652E746172676574292E706172656E747328272E63616C656E64617227293B0A2020';
wwv_flow_api.g_varchar2_table(539) := '202020202020202020207661722064617465203D2063616C2E686173436C61737328276C6566742729203F20746869732E6C65667443616C656E6461722E63616C656E6461725B726F775D5B636F6C5D203A20746869732E726967687443616C656E6461';
wwv_flow_api.g_varchar2_table(540) := '722E63616C656E6461725B726F775D5B636F6C5D3B0A0A20202020202020202020202069662028746869732E656E64446174652026262021746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E6765706963';
wwv_flow_api.g_varchar2_table(541) := '6B65725F73746172745D27292E697328223A666F637573222929207B0A20202020202020202020202020202020746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D6461746572616E67657069636B65725F73746172745D27';
wwv_flow_api.g_varchar2_table(542) := '292E76616C28646174652E666F726D617428746869732E6C6F63616C652E666F726D617429293B0A2020202020202020202020207D20656C7365206966202821746869732E656E64446174652026262021746869732E636F6E7461696E65722E66696E64';
wwv_flow_api.g_varchar2_table(543) := '2827696E7075745B6E616D653D6461746572616E67657069636B65725F656E645D27292E697328223A666F637573222929207B0A20202020202020202020202020202020746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D';
wwv_flow_api.g_varchar2_table(544) := '6461746572616E67657069636B65725F656E645D27292E76616C28646174652E666F726D617428746869732E6C6F63616C652E666F726D617429293B0A2020202020202020202020207D0A0A2020202020202020202020202F2F686967686C6967687420';
wwv_flow_api.g_varchar2_table(545) := '746865206461746573206265747765656E20746865207374617274206461746520616E64207468652064617465206265696E6720686F7665726564206173206120706F74656E7469616C20656E6420646174650A20202020202020202020202076617220';
wwv_flow_api.g_varchar2_table(546) := '6C65667443616C656E646172203D20746869732E6C65667443616C656E6461723B0A20202020202020202020202076617220726967687443616C656E646172203D20746869732E726967687443616C656E6461723B0A2020202020202020202020207661';
wwv_flow_api.g_varchar2_table(547) := '7220737461727444617465203D20746869732E7374617274446174653B0A2020202020202020202020206966202821746869732E656E644461746529207B0A20202020202020202020202020202020746869732E636F6E7461696E65722E66696E642827';
wwv_flow_api.g_varchar2_table(548) := '2E63616C656E64617220746427292E656163682866756E6374696F6E28696E6465782C20656C29207B0A0A20202020202020202020202020202020202020202F2F736B6970207765656B206E756D626572732C206F6E6C79206C6F6F6B20617420646174';
wwv_flow_api.g_varchar2_table(549) := '65730A2020202020202020202020202020202020202020696620282428656C292E686173436C61737328277765656B2729292072657475726E3B0A0A2020202020202020202020202020202020202020766172207469746C65203D202428656C292E6174';
wwv_flow_api.g_varchar2_table(550) := '74722827646174612D7469746C6527293B0A202020202020202020202020202020202020202076617220726F77203D207469746C652E73756273747228312C2031293B0A202020202020202020202020202020202020202076617220636F6C203D207469';
wwv_flow_api.g_varchar2_table(551) := '746C652E73756273747228332C2031293B0A20202020202020202020202020202020202020207661722063616C203D202428656C292E706172656E747328272E63616C656E64617227293B0A202020202020202020202020202020202020202076617220';
wwv_flow_api.g_varchar2_table(552) := '6474203D2063616C2E686173436C61737328276C6566742729203F206C65667443616C656E6461722E63616C656E6461725B726F775D5B636F6C5D203A20726967687443616C656E6461722E63616C656E6461725B726F775D5B636F6C5D3B0A0A202020';
wwv_flow_api.g_varchar2_table(553) := '2020202020202020202020202020202020696620282864742E6973416674657228737461727444617465292026262064742E69734265666F726528646174652929207C7C2064742E697353616D6528646174652C2027646179272929207B0A2020202020';
wwv_flow_api.g_varchar2_table(554) := '202020202020202020202020202020202020202428656C292E616464436C6173732827696E2D72616E676527293B0A20202020202020202020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(555) := '2428656C292E72656D6F7665436C6173732827696E2D72616E676527293B0A20202020202020202020202020202020202020207D0A0A202020202020202020202020202020207D293B0A2020202020202020202020207D0A0A20202020202020207D2C0A';
wwv_flow_api.g_varchar2_table(556) := '0A2020202020202020636C69636B446174653A2066756E6374696F6E286529207B0A0A20202020202020202020202069662028212428652E746172676574292E686173436C6173732827617661696C61626C652729292072657475726E3B0A0A20202020';
wwv_flow_api.g_varchar2_table(557) := '2020202020202020766172207469746C65203D202428652E746172676574292E617474722827646174612D7469746C6527293B0A20202020202020202020202076617220726F77203D207469746C652E73756273747228312C2031293B0A202020202020';
wwv_flow_api.g_varchar2_table(558) := '20202020202076617220636F6C203D207469746C652E73756273747228332C2031293B0A2020202020202020202020207661722063616C203D202428652E746172676574292E706172656E747328272E63616C656E64617227293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(559) := '202020207661722064617465203D2063616C2E686173436C61737328276C6566742729203F20746869732E6C65667443616C656E6461722E63616C656E6461725B726F775D5B636F6C5D203A20746869732E726967687443616C656E6461722E63616C65';
wwv_flow_api.g_varchar2_table(560) := '6E6461725B726F775D5B636F6C5D3B0A0A2020202020202020202020202F2F0A2020202020202020202020202F2F20746869732066756E6374696F6E206E6565647320746F20646F206120666577207468696E67733A0A2020202020202020202020202F';
wwv_flow_api.g_varchar2_table(561) := '2F202A20616C7465726E617465206265747765656E2073656C656374696E67206120737461727420616E6420656E64206461746520666F72207468652072616E67652C0A2020202020202020202020202F2F202A206966207468652074696D6520706963';
wwv_flow_api.g_varchar2_table(562) := '6B657220697320656E61626C65642C206170706C792074686520686F75722F6D696E7574652F7365636F6E642066726F6D207468652073656C65637420626F78657320746F2074686520636C69636B656420646174650A2020202020202020202020202F';
wwv_flow_api.g_varchar2_table(563) := '2F202A206966206175746F6170706C7920697320656E61626C65642C20616E6420616E20656E642064617465207761732063686F73656E2C206170706C79207468652073656C656374696F6E0A2020202020202020202020202F2F202A2069662073696E';
wwv_flow_api.g_varchar2_table(564) := '676C652064617465207069636B6572206D6F64652C20616E642074696D65207069636B65722069736E277420656E61626C65642C206170706C79207468652073656C656374696F6E20696D6D6564696174656C790A2020202020202020202020202F2F20';
wwv_flow_api.g_varchar2_table(565) := '2A206966206F6E65206F662074686520696E707574732061626F7665207468652063616C656E646172732077617320666F63757365642C2063616E63656C2074686174206D616E75616C20696E7075740A2020202020202020202020202F2F0A0A202020';
wwv_flow_api.g_varchar2_table(566) := '20202020202020202069662028746869732E656E6444617465207C7C20646174652E69734265666F726528746869732E7374617274446174652C2027646179272929207B202F2F7069636B696E672073746172740A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(567) := '2069662028746869732E74696D655069636B657229207B0A202020202020202020202020202020202020202076617220686F7572203D207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E6C656674202E686F757273656C65';
wwv_flow_api.g_varchar2_table(568) := '637427292E76616C28292C203130293B0A20202020202020202020202020202020202020206966202821746869732E74696D655069636B65723234486F757229207B0A20202020202020202020202020202020202020202020202076617220616D706D20';
wwv_flow_api.g_varchar2_table(569) := '3D20746869732E636F6E7461696E65722E66696E6428272E6C656674202E616D706D73656C65637427292E76616C28293B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027504D2720262620686F757220';
wwv_flow_api.g_varchar2_table(570) := '3C203132290A20202020202020202020202020202020202020202020202020202020686F7572202B3D2031323B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027414D2720262620686F7572203D3D3D20';
wwv_flow_api.g_varchar2_table(571) := '3132290A20202020202020202020202020202020202020202020202020202020686F7572203D20303B0A20202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020766172206D696E757465203D20706172';
wwv_flow_api.g_varchar2_table(572) := '7365496E7428746869732E636F6E7461696E65722E66696E6428272E6C656674202E6D696E75746573656C65637427292E76616C28292C203130293B0A2020202020202020202020202020202020202020766172207365636F6E64203D20746869732E74';
wwv_flow_api.g_varchar2_table(573) := '696D655069636B65725365636F6E6473203F207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E6C656674202E7365636F6E6473656C65637427292E76616C28292C20313029203A20303B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(574) := '2020202020202064617465203D20646174652E636C6F6E6528292E686F757228686F7572292E6D696E757465286D696E757465292E7365636F6E64287365636F6E64293B0A202020202020202020202020202020207D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(575) := '202020746869732E656E6444617465203D206E756C6C3B0A20202020202020202020202020202020746869732E73657453746172744461746528646174652E636C6F6E652829293B0A2020202020202020202020207D20656C7365206966202821746869';
wwv_flow_api.g_varchar2_table(576) := '732E656E644461746520262620646174652E69734265666F726528746869732E7374617274446174652929207B0A202020202020202020202020202020202F2F7370656369616C20636173653A20636C69636B696E67207468652073616D652064617465';
wwv_flow_api.g_varchar2_table(577) := '20666F722073746172742F656E642C0A202020202020202020202020202020202F2F627574207468652074696D65206F662074686520656E642064617465206973206265666F72652074686520737461727420646174650A202020202020202020202020';
wwv_flow_api.g_varchar2_table(578) := '20202020746869732E736574456E644461746528746869732E7374617274446174652E636C6F6E652829293B0A2020202020202020202020207D20656C7365207B202F2F207069636B696E6720656E640A20202020202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(579) := '28746869732E74696D655069636B657229207B0A202020202020202020202020202020202020202076617220686F7572203D207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E7269676874202E686F757273656C65637427';
wwv_flow_api.g_varchar2_table(580) := '292E76616C28292C203130293B0A20202020202020202020202020202020202020206966202821746869732E74696D655069636B65723234486F757229207B0A20202020202020202020202020202020202020202020202076617220616D706D203D2074';
wwv_flow_api.g_varchar2_table(581) := '6869732E636F6E7461696E65722E66696E6428272E7269676874202E616D706D73656C65637427292E76616C28293B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027504D2720262620686F7572203C20';
wwv_flow_api.g_varchar2_table(582) := '3132290A20202020202020202020202020202020202020202020202020202020686F7572202B3D2031323B0A20202020202020202020202020202020202020202020202069662028616D706D203D3D3D2027414D2720262620686F7572203D3D3D203132';
wwv_flow_api.g_varchar2_table(583) := '290A20202020202020202020202020202020202020202020202020202020686F7572203D20303B0A20202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020766172206D696E757465203D207061727365';
wwv_flow_api.g_varchar2_table(584) := '496E7428746869732E636F6E7461696E65722E66696E6428272E7269676874202E6D696E75746573656C65637427292E76616C28292C203130293B0A2020202020202020202020202020202020202020766172207365636F6E64203D20746869732E7469';
wwv_flow_api.g_varchar2_table(585) := '6D655069636B65725365636F6E6473203F207061727365496E7428746869732E636F6E7461696E65722E66696E6428272E7269676874202E7365636F6E6473656C65637427292E76616C28292C20313029203A20303B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(586) := '2020202020202064617465203D20646174652E636C6F6E6528292E686F757228686F7572292E6D696E757465286D696E757465292E7365636F6E64287365636F6E64293B0A202020202020202020202020202020207D0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(587) := '202020746869732E736574456E644461746528646174652E636C6F6E652829293B0A2020202020202020202020202020202069662028746869732E6175746F4170706C7929207B0A202020202020202020202020202020202020746869732E63616C6375';
wwv_flow_api.g_varchar2_table(588) := '6C61746543686F73656E4C6162656C28293B0A202020202020202020202020202020202020746869732E636C69636B4170706C7928293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(589) := '2069662028746869732E73696E676C65446174655069636B657229207B0A20202020202020202020202020202020746869732E736574456E644461746528746869732E737461727444617465293B0A202020202020202020202020202020206966202821';
wwv_flow_api.g_varchar2_table(590) := '746869732E74696D655069636B6572290A2020202020202020202020202020202020202020746869732E636C69636B4170706C7928293B0A2020202020202020202020207D0A0A202020202020202020202020746869732E757064617465566965772829';
wwv_flow_api.g_varchar2_table(591) := '3B0A0A2020202020202020202020202F2F5468697320697320746F2063616E63656C2074686520626C7572206576656E742068616E646C657220696620746865206D6F7573652077617320696E206F6E65206F662074686520696E707574730A20202020';
wwv_flow_api.g_varchar2_table(592) := '2020202020202020652E73746F7050726F7061676174696F6E28293B0A0A20202020202020207D2C0A0A202020202020202063616C63756C61746543686F73656E4C6162656C3A2066756E6374696F6E2829207B0A202020202020202020207661722063';
wwv_flow_api.g_varchar2_table(593) := '7573746F6D52616E6765203D20747275653B0A202020202020202020207661722069203D20303B0A20202020202020202020666F7220287661722072616E676520696E20746869732E72616E67657329207B0A2020202020202020202020202020696620';
wwv_flow_api.g_varchar2_table(594) := '28746869732E74696D655069636B657229207B0A20202020202020202020202020202020202069662028746869732E7374617274446174652E697353616D6528746869732E72616E6765735B72616E67655D5B305D2920262620746869732E656E644461';
wwv_flow_api.g_varchar2_table(595) := '74652E697353616D6528746869732E72616E6765735B72616E67655D5B315D2929207B0A20202020202020202020202020202020202020202020637573746F6D52616E6765203D2066616C73653B0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(596) := '20746869732E63686F73656E4C6162656C203D20746869732E636F6E7461696E65722E66696E6428272E72616E676573206C693A65712827202B2069202B20272927292E616464436C617373282761637469766527292E68746D6C28293B0A2020202020';
wwv_flow_api.g_varchar2_table(597) := '2020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202020207D0A20202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202F2F69676E6F72652074696D657320';
wwv_flow_api.g_varchar2_table(598) := '7768656E20636F6D706172696E672064617465732069662074696D65207069636B6572206973206E6F7420656E61626C65640A20202020202020202020202020202020202069662028746869732E7374617274446174652E666F726D6174282759595959';
wwv_flow_api.g_varchar2_table(599) := '2D4D4D2D44442729203D3D20746869732E72616E6765735B72616E67655D5B305D2E666F726D61742827595959592D4D4D2D4444272920262620746869732E656E64446174652E666F726D61742827595959592D4D4D2D44442729203D3D20746869732E';
wwv_flow_api.g_varchar2_table(600) := '72616E6765735B72616E67655D5B315D2E666F726D61742827595959592D4D4D2D4444272929207B0A20202020202020202020202020202020202020202020637573746F6D52616E6765203D2066616C73653B0A20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(601) := '202020202020746869732E63686F73656E4C6162656C203D20746869732E636F6E7461696E65722E66696E6428272E72616E676573206C693A65712827202B2069202B20272927292E616464436C617373282761637469766527292E68746D6C28293B0A';
wwv_flow_api.g_varchar2_table(602) := '20202020202020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202020207D0A20202020202020202020202020207D0A2020202020202020202020202020692B2B3B0A202020202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(603) := '20202020202069662028637573746F6D52616E676520262620746869732E73686F77437573746F6D52616E67654C6162656C29207B0A2020202020202020202020202020746869732E63686F73656E4C6162656C203D20746869732E636F6E7461696E65';
wwv_flow_api.g_varchar2_table(604) := '722E66696E6428272E72616E676573206C693A6C61737427292E616464436C617373282761637469766527292E68746D6C28293B0A2020202020202020202020202020746869732E73686F7743616C656E6461727328293B0A202020202020202020207D';
wwv_flow_api.g_varchar2_table(605) := '0A20202020202020207D2C0A0A2020202020202020636C69636B4170706C793A2066756E6374696F6E286529207B0A202020202020202020202020746869732E6869646528293B0A202020202020202020202020746869732E656C656D656E742E747269';
wwv_flow_api.g_varchar2_table(606) := '6767657228276170706C792E6461746572616E67657069636B6572272C2074686973293B0A20202020202020207D2C0A0A2020202020202020636C69636B43616E63656C3A2066756E6374696F6E286529207B0A20202020202020202020202074686973';
wwv_flow_api.g_varchar2_table(607) := '2E737461727444617465203D20746869732E6F6C645374617274446174653B0A202020202020202020202020746869732E656E6444617465203D20746869732E6F6C64456E64446174653B0A202020202020202020202020746869732E6869646528293B';
wwv_flow_api.g_varchar2_table(608) := '0A202020202020202020202020746869732E656C656D656E742E74726967676572282763616E63656C2E6461746572616E67657069636B6572272C2074686973293B0A20202020202020207D2C0A0A20202020202020206D6F6E74684F72596561724368';
wwv_flow_api.g_varchar2_table(609) := '616E6765643A2066756E6374696F6E286529207B0A2020202020202020202020207661722069734C656674203D202428652E746172676574292E636C6F7365737428272E63616C656E64617227292E686173436C61737328276C65667427292C0A202020';
wwv_flow_api.g_varchar2_table(610) := '202020202020202020202020206C6566744F725269676874203D2069734C656674203F20276C65667427203A20277269676874272C0A2020202020202020202020202020202063616C203D20746869732E636F6E7461696E65722E66696E6428272E6361';
wwv_flow_api.g_varchar2_table(611) := '6C656E6461722E272B6C6566744F725269676874293B0A0A2020202020202020202020202F2F204D6F6E7468206D757374206265204E756D62657220666F72206E6577206D6F6D656E742076657273696F6E730A20202020202020202020202076617220';
wwv_flow_api.g_varchar2_table(612) := '6D6F6E7468203D207061727365496E742863616C2E66696E6428272E6D6F6E746873656C65637427292E76616C28292C203130293B0A2020202020202020202020207661722079656172203D2063616C2E66696E6428272E7965617273656C6563742729';
wwv_flow_api.g_varchar2_table(613) := '2E76616C28293B0A0A202020202020202020202020696620282169734C65667429207B0A202020202020202020202020202020206966202879656172203C20746869732E7374617274446174652E796561722829207C7C202879656172203D3D20746869';
wwv_flow_api.g_varchar2_table(614) := '732E7374617274446174652E796561722829202626206D6F6E7468203C20746869732E7374617274446174652E6D6F6E746828292929207B0A20202020202020202020202020202020202020206D6F6E7468203D20746869732E7374617274446174652E';
wwv_flow_api.g_varchar2_table(615) := '6D6F6E746828293B0A202020202020202020202020202020202020202079656172203D20746869732E7374617274446174652E7965617228293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A2020202020202020';
wwv_flow_api.g_varchar2_table(616) := '2020202069662028746869732E6D696E4461746529207B0A202020202020202020202020202020206966202879656172203C20746869732E6D696E446174652E796561722829207C7C202879656172203D3D20746869732E6D696E446174652E79656172';
wwv_flow_api.g_varchar2_table(617) := '2829202626206D6F6E7468203C20746869732E6D696E446174652E6D6F6E746828292929207B0A20202020202020202020202020202020202020206D6F6E7468203D20746869732E6D696E446174652E6D6F6E746828293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(618) := '20202020202020202079656172203D20746869732E6D696E446174652E7965617228293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A20202020202020202020202069662028746869732E6D6178446174652920';
wwv_flow_api.g_varchar2_table(619) := '7B0A202020202020202020202020202020206966202879656172203E20746869732E6D6178446174652E796561722829207C7C202879656172203D3D20746869732E6D6178446174652E796561722829202626206D6F6E7468203E20746869732E6D6178';
wwv_flow_api.g_varchar2_table(620) := '446174652E6D6F6E746828292929207B0A20202020202020202020202020202020202020206D6F6E7468203D20746869732E6D6178446174652E6D6F6E746828293B0A202020202020202020202020202020202020202079656172203D20746869732E6D';
wwv_flow_api.g_varchar2_table(621) := '6178446174652E7965617228293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A0A2020202020202020202020206966202869734C65667429207B0A20202020202020202020202020202020746869732E6C65667443';
wwv_flow_api.g_varchar2_table(622) := '616C656E6461722E6D6F6E74682E6D6F6E7468286D6F6E7468292E796561722879656172293B0A2020202020202020202020202020202069662028746869732E6C696E6B656443616C656E64617273290A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(623) := '20746869732E726967687443616C656E6461722E6D6F6E7468203D20746869732E6C65667443616C656E6461722E6D6F6E74682E636C6F6E6528292E61646428312C20276D6F6E746827293B0A2020202020202020202020207D20656C7365207B0A2020';
wwv_flow_api.g_varchar2_table(624) := '2020202020202020202020202020746869732E726967687443616C656E6461722E6D6F6E74682E6D6F6E7468286D6F6E7468292E796561722879656172293B0A2020202020202020202020202020202069662028746869732E6C696E6B656443616C656E';
wwv_flow_api.g_varchar2_table(625) := '64617273290A2020202020202020202020202020202020202020746869732E6C65667443616C656E6461722E6D6F6E7468203D20746869732E726967687443616C656E6461722E6D6F6E74682E636C6F6E6528292E737562747261637428312C20276D6F';
wwv_flow_api.g_varchar2_table(626) := '6E746827293B0A2020202020202020202020207D0A202020202020202020202020746869732E75706461746543616C656E6461727328293B0A20202020202020207D2C0A0A202020202020202074696D654368616E6765643A2066756E6374696F6E2865';
wwv_flow_api.g_varchar2_table(627) := '29207B0A0A2020202020202020202020207661722063616C203D202428652E746172676574292E636C6F7365737428272E63616C656E64617227292C0A2020202020202020202020202020202069734C656674203D2063616C2E686173436C6173732827';
wwv_flow_api.g_varchar2_table(628) := '6C65667427293B0A0A20202020202020202020202076617220686F7572203D207061727365496E742863616C2E66696E6428272E686F757273656C65637427292E76616C28292C203130293B0A202020202020202020202020766172206D696E75746520';
wwv_flow_api.g_varchar2_table(629) := '3D207061727365496E742863616C2E66696E6428272E6D696E75746573656C65637427292E76616C28292C203130293B0A202020202020202020202020766172207365636F6E64203D20746869732E74696D655069636B65725365636F6E6473203F2070';
wwv_flow_api.g_varchar2_table(630) := '61727365496E742863616C2E66696E6428272E7365636F6E6473656C65637427292E76616C28292C20313029203A20303B0A0A2020202020202020202020206966202821746869732E74696D655069636B65723234486F757229207B0A20202020202020';
wwv_flow_api.g_varchar2_table(631) := '20202020202020202076617220616D706D203D2063616C2E66696E6428272E616D706D73656C65637427292E76616C28293B0A2020202020202020202020202020202069662028616D706D203D3D3D2027504D2720262620686F7572203C203132290A20';
wwv_flow_api.g_varchar2_table(632) := '20202020202020202020202020202020202020686F7572202B3D2031323B0A2020202020202020202020202020202069662028616D706D203D3D3D2027414D2720262620686F7572203D3D3D203132290A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(633) := '20686F7572203D20303B0A2020202020202020202020207D0A0A2020202020202020202020206966202869734C65667429207B0A20202020202020202020202020202020766172207374617274203D20746869732E7374617274446174652E636C6F6E65';
wwv_flow_api.g_varchar2_table(634) := '28293B0A2020202020202020202020202020202073746172742E686F757228686F7572293B0A2020202020202020202020202020202073746172742E6D696E757465286D696E757465293B0A2020202020202020202020202020202073746172742E7365';
wwv_flow_api.g_varchar2_table(635) := '636F6E64287365636F6E64293B0A20202020202020202020202020202020746869732E736574537461727444617465287374617274293B0A2020202020202020202020202020202069662028746869732E73696E676C65446174655069636B657229207B';
wwv_flow_api.g_varchar2_table(636) := '0A2020202020202020202020202020202020202020746869732E656E6444617465203D20746869732E7374617274446174652E636C6F6E6528293B0A202020202020202020202020202020207D20656C73652069662028746869732E656E644461746520';
wwv_flow_api.g_varchar2_table(637) := '262620746869732E656E64446174652E666F726D61742827595959592D4D4D2D44442729203D3D2073746172742E666F726D61742827595959592D4D4D2D4444272920262620746869732E656E64446174652E69734265666F7265287374617274292920';
wwv_flow_api.g_varchar2_table(638) := '7B0A2020202020202020202020202020202020202020746869732E736574456E64446174652873746172742E636C6F6E652829293B0A202020202020202020202020202020207D0A2020202020202020202020207D20656C73652069662028746869732E';
wwv_flow_api.g_varchar2_table(639) := '656E644461746529207B0A2020202020202020202020202020202076617220656E64203D20746869732E656E64446174652E636C6F6E6528293B0A20202020202020202020202020202020656E642E686F757228686F7572293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(640) := '20202020202020656E642E6D696E757465286D696E757465293B0A20202020202020202020202020202020656E642E7365636F6E64287365636F6E64293B0A20202020202020202020202020202020746869732E736574456E644461746528656E64293B';
wwv_flow_api.g_varchar2_table(641) := '0A2020202020202020202020207D0A0A2020202020202020202020202F2F757064617465207468652063616C656E6461727320736F20616C6C20636C69636B61626C65206461746573207265666C65637420746865206E65772074696D6520636F6D706F';
wwv_flow_api.g_varchar2_table(642) := '6E656E740A202020202020202020202020746869732E75706461746543616C656E6461727328293B0A0A2020202020202020202020202F2F7570646174652074686520666F726D20696E707574732061626F7665207468652063616C656E646172732077';
wwv_flow_api.g_varchar2_table(643) := '69746820746865206E65772074696D650A202020202020202020202020746869732E757064617465466F726D496E7075747328293B0A0A2020202020202020202020202F2F72652D72656E646572207468652074696D65207069636B6572732062656361';
wwv_flow_api.g_varchar2_table(644) := '757365206368616E67696E67206F6E652073656C656374696F6E2063616E206166666563742077686174277320656E61626C656420696E20616E6F746865720A202020202020202020202020746869732E72656E64657254696D655069636B657228276C';
wwv_flow_api.g_varchar2_table(645) := '65667427293B0A202020202020202020202020746869732E72656E64657254696D655069636B65722827726967687427293B0A0A20202020202020207D2C0A0A2020202020202020666F726D496E707574734368616E6765643A2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(646) := '6529207B0A2020202020202020202020207661722069735269676874203D202428652E746172676574292E636C6F7365737428272E63616C656E64617227292E686173436C6173732827726967687427293B0A2020202020202020202020207661722073';
wwv_flow_api.g_varchar2_table(647) := '74617274203D206D6F6D656E7428746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F7374617274225D27292E76616C28292C20746869732E6C6F63616C652E666F726D6174293B';
wwv_flow_api.g_varchar2_table(648) := '0A20202020202020202020202076617220656E64203D206D6F6D656E7428746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F656E64225D27292E76616C28292C20746869732E6C';
wwv_flow_api.g_varchar2_table(649) := '6F63616C652E666F726D6174293B0A0A2020202020202020202020206966202873746172742E697356616C6964282920262620656E642E697356616C6964282929207B0A0A20202020202020202020202020202020696620286973526967687420262620';
wwv_flow_api.g_varchar2_table(650) := '656E642E69734265666F726528737461727429290A20202020202020202020202020202020202020207374617274203D20656E642E636C6F6E6528293B0A0A20202020202020202020202020202020746869732E73657453746172744461746528737461';
wwv_flow_api.g_varchar2_table(651) := '7274293B0A20202020202020202020202020202020746869732E736574456E644461746528656E64293B0A0A20202020202020202020202020202020696620286973526967687429207B0A2020202020202020202020202020202020202020746869732E';
wwv_flow_api.g_varchar2_table(652) := '636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F7374617274225D27292E76616C28746869732E7374617274446174652E666F726D617428746869732E6C6F63616C652E666F726D61742929';
wwv_flow_api.g_varchar2_table(653) := '3B0A202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F656E6422';
wwv_flow_api.g_varchar2_table(654) := '5D27292E76616C28746869732E656E64446174652E666F726D617428746869732E6C6F63616C652E666F726D617429293B0A202020202020202020202020202020207D0A0A2020202020202020202020207D0A0A20202020202020202020202074686973';
wwv_flow_api.g_varchar2_table(655) := '2E7570646174655669657728293B0A20202020202020207D2C0A0A2020202020202020666F726D496E70757473466F63757365643A2066756E6374696F6E286529207B0A0A2020202020202020202020202F2F20486967686C696768742074686520666F';
wwv_flow_api.g_varchar2_table(656) := '637573656420696E7075740A202020202020202020202020746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F7374617274225D2C20696E7075745B6E616D653D22646174657261';
wwv_flow_api.g_varchar2_table(657) := '6E67657069636B65725F656E64225D27292E72656D6F7665436C617373282761637469766527293B0A2020202020202020202020202428652E746172676574292E616464436C617373282761637469766527293B0A0A2020202020202020202020202F2F';
wwv_flow_api.g_varchar2_table(658) := '20536574207468652073746174652073756368207468617420696620746865207573657220676F6573206261636B20746F207573696E672061206D6F7573652C200A2020202020202020202020202F2F207468652063616C656E64617273206172652061';
wwv_flow_api.g_varchar2_table(659) := '776172652077652772652073656C656374696E672074686520656E64206F66207468652072616E67652C206E6F740A2020202020202020202020202F2F207468652073746172742E205468697320616C6C6F777320736F6D656F6E6520746F2065646974';
wwv_flow_api.g_varchar2_table(660) := '2074686520656E64206F66206120646174652072616E676520776974686F75740A2020202020202020202020202F2F2072652D73656C656374696E672074686520626567696E6E696E672C20627920636C69636B696E67206F6E2074686520656E642064';
wwv_flow_api.g_varchar2_table(661) := '61746520696E707574207468656E0A2020202020202020202020202F2F207573696E67207468652063616C656E6461722E0A2020202020202020202020207661722069735269676874203D202428652E746172676574292E636C6F7365737428272E6361';
wwv_flow_api.g_varchar2_table(662) := '6C656E64617227292E686173436C6173732827726967687427293B0A202020202020202020202020696620286973526967687429207B0A20202020202020202020202020202020746869732E656E6444617465203D206E756C6C3B0A2020202020202020';
wwv_flow_api.g_varchar2_table(663) := '2020202020202020746869732E73657453746172744461746528746869732E7374617274446174652E636C6F6E652829293B0A20202020202020202020202020202020746869732E7570646174655669657728293B0A2020202020202020202020207D0A';
wwv_flow_api.g_varchar2_table(664) := '0A20202020202020207D2C0A0A2020202020202020666F726D496E70757473426C75727265643A2066756E6374696F6E286529207B0A0A2020202020202020202020202F2F20746869732066756E6374696F6E20686173206F6E6520707572706F736520';
wwv_flow_api.g_varchar2_table(665) := '7269676874206E6F773A20696620796F75207461622066726F6D207468652066697273740A2020202020202020202020202F2F207465787420696E70757420746F20746865207365636F6E6420696E207468652055492C2074686520656E644461746520';
wwv_flow_api.g_varchar2_table(666) := '6973206E756C6C656420736F20746861740A2020202020202020202020202F2F20796F752063616E20636C69636B20616E6F746865722C2062757420696620796F7520746162206F757420776974686F757420636C69636B696E6720616E797468696E67';
wwv_flow_api.g_varchar2_table(667) := '0A2020202020202020202020202F2F206F72206368616E67696E672074686520696E7075742076616C75652C20746865206F6C6420656E64446174652073686F756C642062652072657461696E65640A0A20202020202020202020202069662028217468';
wwv_flow_api.g_varchar2_table(668) := '69732E656E644461746529207B0A202020202020202020202020202020207661722076616C203D20746869732E636F6E7461696E65722E66696E642827696E7075745B6E616D653D226461746572616E67657069636B65725F656E64225D27292E76616C';
wwv_flow_api.g_varchar2_table(669) := '28293B0A2020202020202020202020202020202076617220656E64203D206D6F6D656E742876616C2C20746869732E6C6F63616C652E666F726D6174293B0A2020202020202020202020202020202069662028656E642E697356616C6964282929207B0A';
wwv_flow_api.g_varchar2_table(670) := '2020202020202020202020202020202020202020746869732E736574456E644461746528656E64293B0A2020202020202020202020202020202020202020746869732E7570646174655669657728293B0A202020202020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(671) := '20202020202020202020207D0A0A20202020202020207D2C0A0A2020202020202020656C656D656E744368616E6765643A2066756E6374696F6E2829207B0A2020202020202020202020206966202821746869732E656C656D656E742E69732827696E70';
wwv_flow_api.g_varchar2_table(672) := '75742729292072657475726E3B0A2020202020202020202020206966202821746869732E656C656D656E742E76616C28292E6C656E677468292072657475726E3B0A20202020202020202020202069662028746869732E656C656D656E742E76616C2829';
wwv_flow_api.g_varchar2_table(673) := '2E6C656E677468203C20746869732E6C6F63616C652E666F726D61742E6C656E677468292072657475726E3B0A0A2020202020202020202020207661722064617465537472696E67203D20746869732E656C656D656E742E76616C28292E73706C697428';
wwv_flow_api.g_varchar2_table(674) := '746869732E6C6F63616C652E736570617261746F72292C0A202020202020202020202020202020207374617274203D206E756C6C2C0A20202020202020202020202020202020656E64203D206E756C6C3B0A0A2020202020202020202020206966202864';
wwv_flow_api.g_varchar2_table(675) := '617465537472696E672E6C656E677468203D3D3D203229207B0A202020202020202020202020202020207374617274203D206D6F6D656E742864617465537472696E675B305D2C20746869732E6C6F63616C652E666F726D6174293B0A20202020202020';
wwv_flow_api.g_varchar2_table(676) := '202020202020202020656E64203D206D6F6D656E742864617465537472696E675B315D2C20746869732E6C6F63616C652E666F726D6174293B0A2020202020202020202020207D0A0A20202020202020202020202069662028746869732E73696E676C65';
wwv_flow_api.g_varchar2_table(677) := '446174655069636B6572207C7C207374617274203D3D3D206E756C6C207C7C20656E64203D3D3D206E756C6C29207B0A202020202020202020202020202020207374617274203D206D6F6D656E7428746869732E656C656D656E742E76616C28292C2074';
wwv_flow_api.g_varchar2_table(678) := '6869732E6C6F63616C652E666F726D6174293B0A20202020202020202020202020202020656E64203D2073746172743B0A2020202020202020202020207D0A0A202020202020202020202020696620282173746172742E697356616C69642829207C7C20';
wwv_flow_api.g_varchar2_table(679) := '21656E642E697356616C69642829292072657475726E3B0A0A202020202020202020202020746869732E736574537461727444617465287374617274293B0A202020202020202020202020746869732E736574456E644461746528656E64293B0A202020';
wwv_flow_api.g_varchar2_table(680) := '202020202020202020746869732E7570646174655669657728293B0A20202020202020207D2C0A0A20202020202020206B6579646F776E3A2066756E6374696F6E286529207B0A2020202020202020202020202F2F68696465206F6E20746162206F7220';
wwv_flow_api.g_varchar2_table(681) := '656E7465720A2020202020202020202020206966202828652E6B6579436F6465203D3D3D203929207C7C2028652E6B6579436F6465203D3D3D2031332929207B0A20202020202020202020202020202020746869732E6869646528293B0A202020202020';
wwv_flow_api.g_varchar2_table(682) := '2020202020207D0A20202020202020207D2C0A0A2020202020202020757064617465456C656D656E743A2066756E6374696F6E2829207B0A20202020202020202020202069662028746869732E656C656D656E742E69732827696E707574272920262620';
wwv_flow_api.g_varchar2_table(683) := '21746869732E73696E676C65446174655069636B657220262620746869732E6175746F557064617465496E70757429207B0A20202020202020202020202020202020746869732E656C656D656E742E76616C28746869732E7374617274446174652E666F';
wwv_flow_api.g_varchar2_table(684) := '726D617428746869732E6C6F63616C652E666F726D617429202B20746869732E6C6F63616C652E736570617261746F72202B20746869732E656E64446174652E666F726D617428746869732E6C6F63616C652E666F726D617429293B0A20202020202020';
wwv_flow_api.g_varchar2_table(685) := '202020202020202020746869732E656C656D656E742E7472696767657228276368616E676527293B0A2020202020202020202020207D20656C73652069662028746869732E656C656D656E742E69732827696E707574272920262620746869732E617574';
wwv_flow_api.g_varchar2_table(686) := '6F557064617465496E70757429207B0A20202020202020202020202020202020746869732E656C656D656E742E76616C28746869732E7374617274446174652E666F726D617428746869732E6C6F63616C652E666F726D617429293B0A20202020202020';
wwv_flow_api.g_varchar2_table(687) := '202020202020202020746869732E656C656D656E742E7472696767657228276368616E676527293B0A2020202020202020202020207D0A20202020202020207D2C0A0A202020202020202072656D6F76653A2066756E6374696F6E2829207B0A20202020';
wwv_flow_api.g_varchar2_table(688) := '2020202020202020746869732E636F6E7461696E65722E72656D6F766528293B0A202020202020202020202020746869732E656C656D656E742E6F666628272E6461746572616E67657069636B657227293B0A202020202020202020202020746869732E';
wwv_flow_api.g_varchar2_table(689) := '656C656D656E742E72656D6F76654461746128293B0A20202020202020207D0A0A202020207D3B0A0A20202020242E666E2E6461746572616E67657069636B6572203D2066756E6374696F6E286F7074696F6E732C2063616C6C6261636B29207B0A2020';
wwv_flow_api.g_varchar2_table(690) := '202020202020746869732E656163682866756E6374696F6E2829207B0A20202020202020202020202076617220656C203D20242874686973293B0A20202020202020202020202069662028656C2E6461746128276461746572616E67657069636B657227';
wwv_flow_api.g_varchar2_table(691) := '29290A20202020202020202020202020202020656C2E6461746128276461746572616E67657069636B657227292E72656D6F766528293B0A202020202020202020202020656C2E6461746128276461746572616E67657069636B6572272C206E65772044';
wwv_flow_api.g_varchar2_table(692) := '61746552616E67655069636B657228656C2C206F7074696F6E732C2063616C6C6261636B29293B0A20202020202020207D293B0A202020202020202072657475726E20746869733B0A202020207D3B0A0A2020202072657475726E204461746552616E67';
wwv_flow_api.g_varchar2_table(693) := '655069636B65723B0A0A7D29293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(1891052784196876109)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_file_name=>'daterangepicker.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2F21206D6F6D656E742E6A730A2F2F212076657273696F6E203A20322E31332E300A2F2F2120617574686F7273203A2054696D20576F6F642C2049736B72656E20436865726E65762C204D6F6D656E742E6A7320636F6E7472696275746F72730A2F2F';
wwv_flow_api.g_varchar2_table(2) := '21206C6963656E7365203A204D49540A2F2F21206D6F6D656E746A732E636F6D0A2166756E6374696F6E28612C62297B226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C65';
wwv_flow_api.g_varchar2_table(3) := '3F6D6F64756C652E6578706F7274733D6228293A2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E652862293A612E6D6F6D656E743D6228297D28746869732C66756E6374696F6E28297B2275';
wwv_flow_api.g_varchar2_table(4) := '736520737472696374223B66756E6374696F6E206128297B72657475726E2066642E6170706C79286E756C6C2C617267756D656E7473297D66756E6374696F6E20622861297B66643D617D66756E6374696F6E20632861297B72657475726E206120696E';
wwv_flow_api.g_varchar2_table(5) := '7374616E63656F662041727261797C7C225B6F626A6563742041727261795D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C2861297D66756E6374696F6E20642861297B72657475726E206120696E7374616E6365';
wwv_flow_api.g_varchar2_table(6) := '6F6620446174657C7C225B6F626A65637420446174655D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C2861297D66756E6374696F6E206528612C62297B76617220632C643D5B5D3B666F7228633D303B633C612E';
wwv_flow_api.g_varchar2_table(7) := '6C656E6774683B2B2B6329642E70757368286228615B635D2C6329293B72657475726E20647D66756E6374696F6E206628612C62297B72657475726E204F626A6563742E70726F746F747970652E6861734F776E50726F70657274792E63616C6C28612C';
wwv_flow_api.g_varchar2_table(8) := '62297D66756E6374696F6E206728612C62297B666F7228766172206320696E2062296628622C6329262628615B635D3D625B635D293B72657475726E206628622C22746F537472696E672229262628612E746F537472696E673D622E746F537472696E67';
wwv_flow_api.g_varchar2_table(9) := '292C6628622C2276616C75654F662229262628612E76616C75654F663D622E76616C75654F66292C617D66756E6374696F6E206828612C622C632C64297B72657475726E204A6128612C622C632C642C2130292E75746328297D66756E6374696F6E2069';
wwv_flow_api.g_varchar2_table(10) := '28297B72657475726E7B656D7074793A21312C756E75736564546F6B656E733A5B5D2C756E75736564496E7075743A5B5D2C6F766572666C6F773A2D322C63686172734C6566744F7665723A302C6E756C6C496E7075743A21312C696E76616C69644D6F';
wwv_flow_api.g_varchar2_table(11) := '6E74683A6E756C6C2C696E76616C6964466F726D61743A21312C75736572496E76616C6964617465643A21312C69736F3A21312C7061727365644461746550617274733A5B5D2C6D6572696469656D3A6E756C6C7D7D66756E6374696F6E206A2861297B';
wwv_flow_api.g_varchar2_table(12) := '72657475726E206E756C6C3D3D612E5F7066262628612E5F70663D692829292C612E5F70667D66756E6374696F6E206B2861297B6966286E756C6C3D3D612E5F697356616C6964297B76617220623D6A2861292C633D67642E63616C6C28622E70617273';
wwv_flow_api.g_varchar2_table(13) := '65644461746550617274732C66756E6374696F6E2861297B72657475726E206E756C6C213D617D293B612E5F697356616C69643D2169734E614E28612E5F642E67657454696D652829292626622E6F766572666C6F773C30262621622E656D7074792626';
wwv_flow_api.g_varchar2_table(14) := '21622E696E76616C69644D6F6E7468262621622E696E76616C69645765656B646179262621622E6E756C6C496E707574262621622E696E76616C6964466F726D6174262621622E75736572496E76616C69646174656426262821622E6D6572696469656D';
wwv_flow_api.g_varchar2_table(15) := '7C7C622E6D6572696469656D262663292C612E5F737472696374262628612E5F697356616C69643D612E5F697356616C69642626303D3D3D622E63686172734C6566744F7665722626303D3D3D622E756E75736564546F6B656E732E6C656E6774682626';
wwv_flow_api.g_varchar2_table(16) := '766F696420303D3D3D622E626967486F7572297D72657475726E20612E5F697356616C69647D66756E6374696F6E206C2861297B76617220623D68284E614E293B72657475726E206E756C6C213D613F67286A2862292C61293A6A2862292E7573657249';
wwv_flow_api.g_varchar2_table(17) := '6E76616C6964617465643D21302C627D66756E6374696F6E206D2861297B72657475726E20766F696420303D3D3D617D66756E6374696F6E206E28612C62297B76617220632C642C653B6966286D28622E5F6973414D6F6D656E744F626A656374297C7C';
wwv_flow_api.g_varchar2_table(18) := '28612E5F6973414D6F6D656E744F626A6563743D622E5F6973414D6F6D656E744F626A656374292C6D28622E5F69297C7C28612E5F693D622E5F69292C6D28622E5F66297C7C28612E5F663D622E5F66292C6D28622E5F6C297C7C28612E5F6C3D622E5F';
wwv_flow_api.g_varchar2_table(19) := '6C292C6D28622E5F737472696374297C7C28612E5F7374726963743D622E5F737472696374292C6D28622E5F747A6D297C7C28612E5F747A6D3D622E5F747A6D292C6D28622E5F6973555443297C7C28612E5F69735554433D622E5F6973555443292C6D';
wwv_flow_api.g_varchar2_table(20) := '28622E5F6F6666736574297C7C28612E5F6F66667365743D622E5F6F6666736574292C6D28622E5F7066297C7C28612E5F70663D6A286229292C6D28622E5F6C6F63616C65297C7C28612E5F6C6F63616C653D622E5F6C6F63616C65292C68642E6C656E';
wwv_flow_api.g_varchar2_table(21) := '6774683E3029666F72286320696E20686429643D68645B635D2C653D625B645D2C6D2865297C7C28615B645D3D65293B72657475726E20617D66756E6374696F6E206F2862297B6E28746869732C62292C746869732E5F643D6E65772044617465286E75';
wwv_flow_api.g_varchar2_table(22) := '6C6C213D622E5F643F622E5F642E67657454696D6528293A4E614E292C69643D3D3D213126262869643D21302C612E7570646174654F66667365742874686973292C69643D2131297D66756E6374696F6E20702861297B72657475726E206120696E7374';
wwv_flow_api.g_varchar2_table(23) := '616E63656F66206F7C7C6E756C6C213D6126266E756C6C213D612E5F6973414D6F6D656E744F626A6563747D66756E6374696F6E20712861297B72657475726E20303E613F4D6174682E6365696C2861293A4D6174682E666C6F6F722861297D66756E63';
wwv_flow_api.g_varchar2_table(24) := '74696F6E20722861297B76617220623D2B612C633D303B72657475726E2030213D3D622626697346696E697465286229262628633D71286229292C637D66756E6374696F6E207328612C622C63297B76617220642C653D4D6174682E6D696E28612E6C65';
wwv_flow_api.g_varchar2_table(25) := '6E6774682C622E6C656E677468292C663D4D6174682E61627328612E6C656E6774682D622E6C656E677468292C673D303B666F7228643D303B653E643B642B2B2928632626615B645D213D3D625B645D7C7C216326267228615B645D29213D3D7228625B';
wwv_flow_api.g_varchar2_table(26) := '645D29292626672B2B3B72657475726E20672B667D66756E6374696F6E20742862297B612E73757070726573734465707265636174696F6E5761726E696E67733D3D3D2131262622756E646566696E656422213D747970656F6620636F6E736F6C652626';
wwv_flow_api.g_varchar2_table(27) := '636F6E736F6C652E7761726E2626636F6E736F6C652E7761726E28224465707265636174696F6E207761726E696E673A20222B62297D66756E6374696F6E207528622C63297B76617220643D21303B72657475726E20672866756E6374696F6E28297B72';
wwv_flow_api.g_varchar2_table(28) := '657475726E206E756C6C213D612E6465707265636174696F6E48616E646C65722626612E6465707265636174696F6E48616E646C6572286E756C6C2C62292C642626287428622B225C6E417267756D656E74733A20222B41727261792E70726F746F7479';
wwv_flow_api.g_varchar2_table(29) := '70652E736C6963652E63616C6C28617267756D656E7473292E6A6F696E28222C2022292B225C6E222B286E6577204572726F72292E737461636B292C643D2131292C632E6170706C7928746869732C617267756D656E7473297D2C63297D66756E637469';
wwv_flow_api.g_varchar2_table(30) := '6F6E207628622C63297B6E756C6C213D612E6465707265636174696F6E48616E646C65722626612E6465707265636174696F6E48616E646C657228622C63292C6A645B625D7C7C28742863292C6A645B625D3D2130297D66756E6374696F6E2077286129';
wwv_flow_api.g_varchar2_table(31) := '7B72657475726E206120696E7374616E63656F662046756E6374696F6E7C7C225B6F626A6563742046756E6374696F6E5D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C2861297D66756E6374696F6E2078286129';
wwv_flow_api.g_varchar2_table(32) := '7B72657475726E225B6F626A656374204F626A6563745D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C2861297D66756E6374696F6E20792861297B76617220622C633B666F72286320696E206129623D615B635D';
wwv_flow_api.g_varchar2_table(33) := '2C772862293F746869735B635D3D623A746869735B225F222B635D3D623B746869732E5F636F6E6669673D612C746869732E5F6F7264696E616C50617273654C656E69656E743D6E65772052656745787028746869732E5F6F7264696E616C5061727365';
wwv_flow_api.g_varchar2_table(34) := '2E736F757263652B227C222B2F5C647B312C327D2F2E736F75726365297D66756E6374696F6E207A28612C62297B76617220632C643D67287B7D2C61293B666F72286320696E2062296628622C63292626287828615B635D2926267828625B635D293F28';
wwv_flow_api.g_varchar2_table(35) := '645B635D3D7B7D2C6728645B635D2C615B635D292C6728645B635D2C625B635D29293A6E756C6C213D625B635D3F645B635D3D625B635D3A64656C65746520645B635D293B72657475726E20647D66756E6374696F6E20412861297B6E756C6C213D6126';
wwv_flow_api.g_varchar2_table(36) := '26746869732E7365742861297D66756E6374696F6E20422861297B72657475726E20613F612E746F4C6F7765724361736528292E7265706C61636528225F222C222D22293A617D66756E6374696F6E20432861297B666F722876617220622C632C642C65';
wwv_flow_api.g_varchar2_table(37) := '2C663D303B663C612E6C656E6774683B297B666F7228653D4228615B665D292E73706C697428222D22292C623D652E6C656E6774682C633D4228615B662B315D292C633D633F632E73706C697428222D22293A6E756C6C3B623E303B297B696628643D44';
wwv_flow_api.g_varchar2_table(38) := '28652E736C69636528302C62292E6A6F696E28222D2229292972657475726E20643B696628632626632E6C656E6774683E3D6226267328652C632C2130293E3D622D3129627265616B3B622D2D7D662B2B7D72657475726E206E756C6C7D66756E637469';
wwv_flow_api.g_varchar2_table(39) := '6F6E20442861297B76617220623D6E756C6C3B696628216E645B615D262622756E646566696E656422213D747970656F66206D6F64756C6526266D6F64756C6526266D6F64756C652E6578706F727473297472797B623D6C642E5F616262722C72657175';
wwv_flow_api.g_varchar2_table(40) := '69726528222E2F6C6F63616C652F222B61292C452862297D63617463682863297B7D72657475726E206E645B615D7D66756E6374696F6E204528612C62297B76617220633B72657475726E2061262628633D6D2862293F482861293A4628612C62292C63';
wwv_flow_api.g_varchar2_table(41) := '2626286C643D6329292C6C642E5F616262727D66756E6374696F6E204628612C62297B72657475726E206E756C6C213D3D623F28622E616262723D612C6E756C6C213D6E645B615D3F28762822646566696E654C6F63616C654F76657272696465222C22';
wwv_flow_api.g_varchar2_table(42) := '757365206D6F6D656E742E7570646174654C6F63616C65286C6F63616C654E616D652C20636F6E6669672920746F206368616E676520616E206578697374696E67206C6F63616C652E206D6F6D656E742E646566696E654C6F63616C65286C6F63616C65';
wwv_flow_api.g_varchar2_table(43) := '4E616D652C20636F6E666967292073686F756C64206F6E6C79206265207573656420666F72206372656174696E672061206E6577206C6F63616C6522292C623D7A286E645B615D2E5F636F6E6669672C6229293A6E756C6C213D622E706172656E744C6F';
wwv_flow_api.g_varchar2_table(44) := '63616C652626286E756C6C213D6E645B622E706172656E744C6F63616C655D3F623D7A286E645B622E706172656E744C6F63616C655D2E5F636F6E6669672C62293A762822706172656E744C6F63616C65556E646566696E6564222C2273706563696669';
wwv_flow_api.g_varchar2_table(45) := '656420706172656E744C6F63616C65206973206E6F7420646566696E6564207965742229292C6E645B615D3D6E657720412862292C452861292C6E645B615D293A2864656C657465206E645B615D2C6E756C6C297D66756E6374696F6E204728612C6229';
wwv_flow_api.g_varchar2_table(46) := '7B6966286E756C6C213D62297B76617220633B6E756C6C213D6E645B615D262628623D7A286E645B615D2E5F636F6E6669672C6229292C633D6E657720412862292C632E706172656E744C6F63616C653D6E645B615D2C6E645B615D3D632C452861297D';
wwv_flow_api.g_varchar2_table(47) := '656C7365206E756C6C213D6E645B615D2626286E756C6C213D6E645B615D2E706172656E744C6F63616C653F6E645B615D3D6E645B615D2E706172656E744C6F63616C653A6E756C6C213D6E645B615D262664656C657465206E645B615D293B72657475';
wwv_flow_api.g_varchar2_table(48) := '726E206E645B615D7D66756E6374696F6E20482861297B76617220623B696628612626612E5F6C6F63616C652626612E5F6C6F63616C652E5F61626272262628613D612E5F6C6F63616C652E5F61626272292C21612972657475726E206C643B69662821';
wwv_flow_api.g_varchar2_table(49) := '63286129297B696628623D442861292972657475726E20623B613D5B615D7D72657475726E20432861297D66756E6374696F6E204928297B72657475726E206B64286E64297D66756E6374696F6E204A28612C62297B76617220633D612E746F4C6F7765';
wwv_flow_api.g_varchar2_table(50) := '724361736528293B6F645B635D3D6F645B632B2273225D3D6F645B625D3D617D66756E6374696F6E204B2861297B72657475726E22737472696E67223D3D747970656F6620613F6F645B615D7C7C6F645B612E746F4C6F7765724361736528295D3A766F';
wwv_flow_api.g_varchar2_table(51) := '696420307D66756E6374696F6E204C2861297B76617220622C632C643D7B7D3B666F72286320696E2061296628612C6329262628623D4B2863292C62262628645B625D3D615B635D29293B72657475726E20647D66756E6374696F6E204D28622C63297B';
wwv_flow_api.g_varchar2_table(52) := '72657475726E2066756E6374696F6E2864297B72657475726E206E756C6C213D643F284F28746869732C622C64292C612E7570646174654F666673657428746869732C63292C74686973293A4E28746869732C62297D7D66756E6374696F6E204E28612C';
wwv_flow_api.g_varchar2_table(53) := '62297B72657475726E20612E697356616C696428293F612E5F645B22676574222B28612E5F69735554433F22555443223A2222292B625D28293A4E614E7D66756E6374696F6E204F28612C622C63297B612E697356616C696428292626612E5F645B2273';
wwv_flow_api.g_varchar2_table(54) := '6574222B28612E5F69735554433F22555443223A2222292B625D2863297D66756E6374696F6E205028612C62297B76617220633B696628226F626A656374223D3D747970656F66206129666F72286320696E206129746869732E73657428632C615B635D';
wwv_flow_api.g_varchar2_table(55) := '293B656C736520696628613D4B2861292C7728746869735B615D292972657475726E20746869735B615D2862293B72657475726E20746869737D66756E6374696F6E205128612C622C63297B76617220643D22222B4D6174682E6162732861292C653D62';
wwv_flow_api.g_varchar2_table(56) := '2D642E6C656E6774682C663D613E3D303B72657475726E28663F633F222B223A22223A222D22292B4D6174682E706F772831302C4D6174682E6D617828302C6529292E746F537472696E6728292E7375627374722831292B647D66756E6374696F6E2052';
wwv_flow_api.g_varchar2_table(57) := '28612C622C632C64297B76617220653D643B22737472696E67223D3D747970656F662064262628653D66756E6374696F6E28297B72657475726E20746869735B645D28297D292C6126262873645B615D3D65292C6226262873645B625B305D5D3D66756E';
wwv_flow_api.g_varchar2_table(58) := '6374696F6E28297B72657475726E205128652E6170706C7928746869732C617267756D656E7473292C625B315D2C625B325D297D292C6326262873645B635D3D66756E6374696F6E28297B72657475726E20746869732E6C6F63616C654461746128292E';
wwv_flow_api.g_varchar2_table(59) := '6F7264696E616C28652E6170706C7928746869732C617267756D656E7473292C61297D297D66756E6374696F6E20532861297B72657475726E20612E6D61746368282F5C5B5B5C735C535D2F293F612E7265706C616365282F5E5C5B7C5C5D242F672C22';
wwv_flow_api.g_varchar2_table(60) := '22293A612E7265706C616365282F5C5C2F672C2222297D66756E6374696F6E20542861297B76617220622C632C643D612E6D61746368287064293B666F7228623D302C633D642E6C656E6774683B633E623B622B2B2973645B645B625D5D3F645B625D3D';
wwv_flow_api.g_varchar2_table(61) := '73645B645B625D5D3A645B625D3D5328645B625D293B72657475726E2066756E6374696F6E2862297B76617220652C663D22223B666F7228653D303B633E653B652B2B29662B3D645B655D696E7374616E63656F662046756E6374696F6E3F645B655D2E';
wwv_flow_api.g_varchar2_table(62) := '63616C6C28622C61293A645B655D3B72657475726E20667D7D66756E6374696F6E205528612C62297B72657475726E20612E697356616C696428293F28623D5628622C612E6C6F63616C65446174612829292C72645B625D3D72645B625D7C7C54286229';
wwv_flow_api.g_varchar2_table(63) := '2C72645B625D286129293A612E6C6F63616C654461746128292E696E76616C69644461746528297D66756E6374696F6E205628612C62297B66756E6374696F6E20632861297B72657475726E20622E6C6F6E6744617465466F726D61742861297C7C617D';
wwv_flow_api.g_varchar2_table(64) := '76617220643D353B666F722871642E6C617374496E6465783D303B643E3D30262671642E746573742861293B29613D612E7265706C6163652871642C63292C71642E6C617374496E6465783D302C642D3D313B72657475726E20617D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(65) := '205728612C622C63297B4B645B615D3D772862293F623A66756E6374696F6E28612C64297B72657475726E20612626633F633A627D7D66756E6374696F6E205828612C62297B72657475726E2066284B642C61293F4B645B615D28622E5F737472696374';
wwv_flow_api.g_varchar2_table(66) := '2C622E5F6C6F63616C65293A6E6577205265674578702859286129297D66756E6374696F6E20592861297B72657475726E205A28612E7265706C61636528225C5C222C2222292E7265706C616365282F5C5C285C5B297C5C5C285C5D297C5C5B285B5E5C';
wwv_flow_api.g_varchar2_table(67) := '5D5C5B5D2A295C5D7C5C5C282E292F672C66756E6374696F6E28612C622C632C642C65297B72657475726E20627C7C637C7C647C7C657D29297D66756E6374696F6E205A2861297B72657475726E20612E7265706C616365282F5B2D5C2F5C5C5E242A2B';
wwv_flow_api.g_varchar2_table(68) := '3F2E28297C5B5C5D7B7D5D2F672C225C5C242622297D66756E6374696F6E202428612C62297B76617220632C643D623B666F722822737472696E67223D3D747970656F662061262628613D5B615D292C226E756D626572223D3D747970656F6620622626';
wwv_flow_api.g_varchar2_table(69) := '28643D66756E6374696F6E28612C63297B635B625D3D722861297D292C633D303B633C612E6C656E6774683B632B2B294C645B615B635D5D3D647D66756E6374696F6E205F28612C62297B2428612C66756E6374696F6E28612C632C642C65297B642E5F';
wwv_flow_api.g_varchar2_table(70) := '773D642E5F777C7C7B7D2C6228612C642E5F772C642C65297D297D66756E6374696F6E20616128612C622C63297B6E756C6C213D62262666284C642C612926264C645B615D28622C632E5F612C632C61297D66756E6374696F6E20626128612C62297B72';
wwv_flow_api.g_varchar2_table(71) := '657475726E206E6577204461746528446174652E55544328612C622B312C3029292E6765745554434461746528297D66756E6374696F6E20636128612C62297B72657475726E206328746869732E5F6D6F6E746873293F746869732E5F6D6F6E7468735B';
wwv_flow_api.g_varchar2_table(72) := '612E6D6F6E746828295D3A746869732E5F6D6F6E7468735B56642E746573742862293F22666F726D6174223A227374616E64616C6F6E65225D5B612E6D6F6E746828295D7D66756E6374696F6E20646128612C62297B72657475726E206328746869732E';
wwv_flow_api.g_varchar2_table(73) := '5F6D6F6E74687353686F7274293F746869732E5F6D6F6E74687353686F72745B612E6D6F6E746828295D3A746869732E5F6D6F6E74687353686F72745B56642E746573742862293F22666F726D6174223A227374616E64616C6F6E65225D5B612E6D6F6E';
wwv_flow_api.g_varchar2_table(74) := '746828295D7D66756E6374696F6E20656128612C622C63297B76617220642C652C662C673D612E746F4C6F63616C654C6F7765724361736528293B69662821746869732E5F6D6F6E746873506172736529666F7228746869732E5F6D6F6E746873506172';
wwv_flow_api.g_varchar2_table(75) := '73653D5B5D2C746869732E5F6C6F6E674D6F6E74687350617273653D5B5D2C746869732E5F73686F72744D6F6E74687350617273653D5B5D2C643D303B31323E643B2B2B6429663D68285B3265332C645D292C746869732E5F73686F72744D6F6E746873';
wwv_flow_api.g_varchar2_table(76) := '50617273655B645D3D746869732E6D6F6E74687353686F727428662C2222292E746F4C6F63616C654C6F7765724361736528292C746869732E5F6C6F6E674D6F6E74687350617273655B645D3D746869732E6D6F6E74687328662C2222292E746F4C6F63';
wwv_flow_api.g_varchar2_table(77) := '616C654C6F7765724361736528293B72657475726E20633F224D4D4D223D3D3D623F28653D6D642E63616C6C28746869732E5F73686F72744D6F6E74687350617273652C67292C2D31213D3D653F653A6E756C6C293A28653D6D642E63616C6C28746869';
wwv_flow_api.g_varchar2_table(78) := '732E5F6C6F6E674D6F6E74687350617273652C67292C2D31213D3D653F653A6E756C6C293A224D4D4D223D3D3D623F28653D6D642E63616C6C28746869732E5F73686F72744D6F6E74687350617273652C67292C2D31213D3D653F653A28653D6D642E63';
wwv_flow_api.g_varchar2_table(79) := '616C6C28746869732E5F6C6F6E674D6F6E74687350617273652C67292C2D31213D3D653F653A6E756C6C29293A28653D6D642E63616C6C28746869732E5F6C6F6E674D6F6E74687350617273652C67292C2D31213D3D653F653A28653D6D642E63616C6C';
wwv_flow_api.g_varchar2_table(80) := '28746869732E5F73686F72744D6F6E74687350617273652C67292C2D31213D3D653F653A6E756C6C29297D66756E6374696F6E20666128612C622C63297B76617220642C652C663B696628746869732E5F6D6F6E74687350617273654578616374297265';
wwv_flow_api.g_varchar2_table(81) := '7475726E2065612E63616C6C28746869732C612C622C63293B666F7228746869732E5F6D6F6E74687350617273657C7C28746869732E5F6D6F6E74687350617273653D5B5D2C746869732E5F6C6F6E674D6F6E74687350617273653D5B5D2C746869732E';
wwv_flow_api.g_varchar2_table(82) := '5F73686F72744D6F6E74687350617273653D5B5D292C643D303B31323E643B642B2B297B696628653D68285B3265332C645D292C63262621746869732E5F6C6F6E674D6F6E74687350617273655B645D262628746869732E5F6C6F6E674D6F6E74687350';
wwv_flow_api.g_varchar2_table(83) := '617273655B645D3D6E65772052656745787028225E222B746869732E6D6F6E74687328652C2222292E7265706C61636528222E222C2222292B2224222C226922292C746869732E5F73686F72744D6F6E74687350617273655B645D3D6E65772052656745';
wwv_flow_api.g_varchar2_table(84) := '787028225E222B746869732E6D6F6E74687353686F727428652C2222292E7265706C61636528222E222C2222292B2224222C22692229292C637C7C746869732E5F6D6F6E74687350617273655B645D7C7C28663D225E222B746869732E6D6F6E74687328';
wwv_flow_api.g_varchar2_table(85) := '652C2222292B227C5E222B746869732E6D6F6E74687353686F727428652C2222292C746869732E5F6D6F6E74687350617273655B645D3D6E65772052656745787028662E7265706C61636528222E222C2222292C22692229292C632626224D4D4D4D223D';
wwv_flow_api.g_varchar2_table(86) := '3D3D622626746869732E5F6C6F6E674D6F6E74687350617273655B645D2E746573742861292972657475726E20643B696628632626224D4D4D223D3D3D622626746869732E5F73686F72744D6F6E74687350617273655B645D2E74657374286129297265';
wwv_flow_api.g_varchar2_table(87) := '7475726E20643B69662821632626746869732E5F6D6F6E74687350617273655B645D2E746573742861292972657475726E20647D7D66756E6374696F6E20676128612C62297B76617220633B69662821612E697356616C696428292972657475726E2061';
wwv_flow_api.g_varchar2_table(88) := '3B69662822737472696E67223D3D747970656F662062296966282F5E5C642B242F2E7465737428622929623D722862293B656C736520696628623D612E6C6F63616C654461746128292E6D6F6E74687350617273652862292C226E756D62657222213D74';
wwv_flow_api.g_varchar2_table(89) := '7970656F6620622972657475726E20613B72657475726E20633D4D6174682E6D696E28612E6461746528292C626128612E7965617228292C6229292C612E5F645B22736574222B28612E5F69735554433F22555443223A2222292B224D6F6E7468225D28';
wwv_flow_api.g_varchar2_table(90) := '622C63292C617D66756E6374696F6E2068612862297B72657475726E206E756C6C213D623F28676128746869732C62292C612E7570646174654F666673657428746869732C2130292C74686973293A4E28746869732C224D6F6E746822297D66756E6374';
wwv_flow_api.g_varchar2_table(91) := '696F6E20696128297B72657475726E20626128746869732E7965617228292C746869732E6D6F6E74682829297D66756E6374696F6E206A612861297B72657475726E20746869732E5F6D6F6E746873506172736545786163743F286628746869732C225F';
wwv_flow_api.g_varchar2_table(92) := '6D6F6E746873526567657822297C7C6C612E63616C6C2874686973292C613F746869732E5F6D6F6E74687353686F727453747269637452656765783A746869732E5F6D6F6E74687353686F72745265676578293A746869732E5F6D6F6E74687353686F72';
wwv_flow_api.g_varchar2_table(93) := '7453747269637452656765782626613F746869732E5F6D6F6E74687353686F727453747269637452656765783A746869732E5F6D6F6E74687353686F727452656765787D66756E6374696F6E206B612861297B72657475726E20746869732E5F6D6F6E74';
wwv_flow_api.g_varchar2_table(94) := '6873506172736545786163743F286628746869732C225F6D6F6E746873526567657822297C7C6C612E63616C6C2874686973292C613F746869732E5F6D6F6E74687353747269637452656765783A746869732E5F6D6F6E7468735265676578293A746869';
wwv_flow_api.g_varchar2_table(95) := '732E5F6D6F6E74687353747269637452656765782626613F746869732E5F6D6F6E74687353747269637452656765783A746869732E5F6D6F6E74687352656765787D66756E6374696F6E206C6128297B66756E6374696F6E206128612C62297B72657475';
wwv_flow_api.g_varchar2_table(96) := '726E20622E6C656E6774682D612E6C656E6774687D76617220622C632C643D5B5D2C653D5B5D2C663D5B5D3B666F7228623D303B31323E623B622B2B29633D68285B3265332C625D292C642E7075736828746869732E6D6F6E74687353686F727428632C';
wwv_flow_api.g_varchar2_table(97) := '222229292C652E7075736828746869732E6D6F6E74687328632C222229292C662E7075736828746869732E6D6F6E74687328632C222229292C662E7075736828746869732E6D6F6E74687353686F727428632C222229293B666F7228642E736F72742861';
wwv_flow_api.g_varchar2_table(98) := '292C652E736F72742861292C662E736F72742861292C623D303B31323E623B622B2B29645B625D3D5A28645B625D292C655B625D3D5A28655B625D292C665B625D3D5A28665B625D293B746869732E5F6D6F6E74687352656765783D6E65772052656745';
wwv_flow_api.g_varchar2_table(99) := '787028225E28222B662E6A6F696E28227C22292B2229222C226922292C746869732E5F6D6F6E74687353686F727452656765783D746869732E5F6D6F6E74687352656765782C746869732E5F6D6F6E74687353747269637452656765783D6E6577205265';
wwv_flow_api.g_varchar2_table(100) := '6745787028225E28222B652E6A6F696E28227C22292B2229222C226922292C746869732E5F6D6F6E74687353686F727453747269637452656765783D6E65772052656745787028225E28222B642E6A6F696E28227C22292B2229222C226922297D66756E';
wwv_flow_api.g_varchar2_table(101) := '6374696F6E206D612861297B76617220622C633D612E5F613B72657475726E206326262D323D3D3D6A2861292E6F766572666C6F77262628623D635B4E645D3C307C7C635B4E645D3E31313F4E643A635B4F645D3C317C7C635B4F645D3E626128635B4D';
wwv_flow_api.g_varchar2_table(102) := '645D2C635B4E645D293F4F643A635B50645D3C307C7C635B50645D3E32347C7C32343D3D3D635B50645D26262830213D3D635B51645D7C7C30213D3D635B52645D7C7C30213D3D635B53645D293F50643A635B51645D3C307C7C635B51645D3E35393F51';
wwv_flow_api.g_varchar2_table(103) := '643A635B52645D3C307C7C635B52645D3E35393F52643A635B53645D3C307C7C635B53645D3E3939393F53643A2D312C6A2861292E5F6F766572666C6F774461794F66596561722626284D643E627C7C623E4F6429262628623D4F64292C6A2861292E5F';
wwv_flow_api.g_varchar2_table(104) := '6F766572666C6F775765656B7326262D313D3D3D62262628623D5464292C6A2861292E5F6F766572666C6F775765656B64617926262D313D3D3D62262628623D5564292C6A2861292E6F766572666C6F773D62292C617D66756E6374696F6E206E612861';
wwv_flow_api.g_varchar2_table(105) := '297B76617220622C632C642C652C662C672C683D612E5F692C693D24642E657865632868297C7C5F642E657865632868293B69662869297B666F72286A2861292E69736F3D21302C623D302C633D62652E6C656E6774683B633E623B622B2B2969662862';
wwv_flow_api.g_varchar2_table(106) := '655B625D5B315D2E6578656328695B315D29297B653D62655B625D5B305D2C643D62655B625D5B325D213D3D21313B627265616B7D6966286E756C6C3D3D652972657475726E20766F696428612E5F697356616C69643D2131293B696628695B335D297B';
wwv_flow_api.g_varchar2_table(107) := '666F7228623D302C633D63652E6C656E6774683B633E623B622B2B2969662863655B625D5B315D2E6578656328695B335D29297B663D28695B325D7C7C222022292B63655B625D5B305D3B627265616B7D6966286E756C6C3D3D662972657475726E2076';
wwv_flow_api.g_varchar2_table(108) := '6F696428612E5F697356616C69643D2131297D696628216426266E756C6C213D662972657475726E20766F696428612E5F697356616C69643D2131293B696628695B345D297B6966282161652E6578656328695B345D292972657475726E20766F696428';
wwv_flow_api.g_varchar2_table(109) := '612E5F697356616C69643D2131293B673D225A227D612E5F663D652B28667C7C2222292B28677C7C2222292C43612861297D656C736520612E5F697356616C69643D21317D66756E6374696F6E206F612862297B76617220633D64652E6578656328622E';
wwv_flow_api.g_varchar2_table(110) := '5F69293B72657475726E206E756C6C213D3D633F766F696428622E5F643D6E65772044617465282B635B315D29293A286E612862292C766F696428622E5F697356616C69643D3D3D213126262864656C65746520622E5F697356616C69642C612E637265';
wwv_flow_api.g_varchar2_table(111) := '61746546726F6D496E70757446616C6C6261636B2862292929297D66756E6374696F6E20706128612C622C632C642C652C662C67297B76617220683D6E6577204461746528612C622C632C642C652C662C67293B72657475726E203130303E612626613E';
wwv_flow_api.g_varchar2_table(112) := '3D302626697346696E69746528682E67657446756C6C596561722829292626682E73657446756C6C596561722861292C687D66756E6374696F6E2071612861297B76617220623D6E6577204461746528446174652E5554432E6170706C79286E756C6C2C';
wwv_flow_api.g_varchar2_table(113) := '617267756D656E747329293B72657475726E203130303E612626613E3D302626697346696E69746528622E67657455544346756C6C596561722829292626622E73657455544346756C6C596561722861292C627D66756E6374696F6E2072612861297B72';
wwv_flow_api.g_varchar2_table(114) := '657475726E2073612861293F3336363A3336357D66756E6374696F6E2073612861297B72657475726E206125343D3D3D3026266125313030213D3D307C7C61253430303D3D3D307D66756E6374696F6E20746128297B72657475726E2073612874686973';
wwv_flow_api.g_varchar2_table(115) := '2E796561722829297D66756E6374696F6E20756128612C622C63297B76617220643D372B622D632C653D28372B716128612C302C64292E67657455544344617928292D622925373B72657475726E2D652B642D317D66756E6374696F6E20766128612C62';
wwv_flow_api.g_varchar2_table(116) := '2C632C642C65297B76617220662C672C683D28372B632D642925372C693D756128612C642C65292C6A3D312B372A28622D31292B682B693B72657475726E20303E3D6A3F28663D612D312C673D72612866292B6A293A6A3E72612861293F28663D612B31';
wwv_flow_api.g_varchar2_table(117) := '2C673D6A2D7261286129293A28663D612C673D6A292C7B796561723A662C6461794F66596561723A677D7D66756E6374696F6E20776128612C622C63297B76617220642C652C663D756128612E7965617228292C622C63292C673D4D6174682E666C6F6F';
wwv_flow_api.g_varchar2_table(118) := '722828612E6461794F665965617228292D662D31292F37292B313B72657475726E20313E673F28653D612E7965617228292D312C643D672B786128652C622C6329293A673E786128612E7965617228292C622C63293F28643D672D786128612E79656172';
wwv_flow_api.g_varchar2_table(119) := '28292C622C63292C653D612E7965617228292B31293A28653D612E7965617228292C643D67292C7B7765656B3A642C796561723A657D7D66756E6374696F6E20786128612C622C63297B76617220643D756128612C622C63292C653D756128612B312C62';
wwv_flow_api.g_varchar2_table(120) := '2C63293B72657475726E2872612861292D642B65292F377D66756E6374696F6E20796128612C622C63297B72657475726E206E756C6C213D613F613A6E756C6C213D623F623A637D66756E6374696F6E207A612862297B76617220633D6E657720446174';
wwv_flow_api.g_varchar2_table(121) := '6528612E6E6F772829293B72657475726E20622E5F7573655554433F5B632E67657455544346756C6C5965617228292C632E6765745554434D6F6E746828292C632E6765745554434461746528295D3A5B632E67657446756C6C5965617228292C632E67';
wwv_flow_api.g_varchar2_table(122) := '65744D6F6E746828292C632E6765744461746528295D7D66756E6374696F6E2041612861297B76617220622C632C642C652C663D5B5D3B69662821612E5F64297B666F7228643D7A612861292C612E5F7726266E756C6C3D3D612E5F615B4F645D26266E';
wwv_flow_api.g_varchar2_table(123) := '756C6C3D3D612E5F615B4E645D262642612861292C612E5F6461794F6659656172262628653D796128612E5F615B4D645D2C645B4D645D292C612E5F6461794F66596561723E72612865292626286A2861292E5F6F766572666C6F774461794F66596561';
wwv_flow_api.g_varchar2_table(124) := '723D2130292C633D716128652C302C612E5F6461794F6659656172292C612E5F615B4E645D3D632E6765745554434D6F6E746828292C612E5F615B4F645D3D632E676574555443446174652829292C623D303B333E6226266E756C6C3D3D612E5F615B62';
wwv_flow_api.g_varchar2_table(125) := '5D3B2B2B6229612E5F615B625D3D665B625D3D645B625D3B666F72283B373E623B622B2B29612E5F615B625D3D665B625D3D6E756C6C3D3D612E5F615B625D3F323D3D3D623F313A303A612E5F615B625D3B32343D3D3D612E5F615B50645D2626303D3D';
wwv_flow_api.g_varchar2_table(126) := '3D612E5F615B51645D2626303D3D3D612E5F615B52645D2626303D3D3D612E5F615B53645D262628612E5F6E6578744461793D21302C612E5F615B50645D3D30292C612E5F643D28612E5F7573655554433F71613A7061292E6170706C79286E756C6C2C';
wwv_flow_api.g_varchar2_table(127) := '66292C6E756C6C213D612E5F747A6D2626612E5F642E7365745554434D696E7574657328612E5F642E6765745554434D696E7574657328292D612E5F747A6D292C612E5F6E657874446179262628612E5F615B50645D3D3234297D7D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(128) := '2042612861297B76617220622C632C642C652C662C672C682C693B623D612E5F772C6E756C6C213D622E47477C7C6E756C6C213D622E577C7C6E756C6C213D622E453F28663D312C673D342C633D796128622E47472C612E5F615B4D645D2C7761284B61';
wwv_flow_api.g_varchar2_table(129) := '28292C312C34292E79656172292C643D796128622E572C31292C653D796128622E452C31292C28313E657C7C653E3729262628693D213029293A28663D612E5F6C6F63616C652E5F7765656B2E646F772C673D612E5F6C6F63616C652E5F7765656B2E64';
wwv_flow_api.g_varchar2_table(130) := '6F792C633D796128622E67672C612E5F615B4D645D2C7761284B6128292C662C67292E79656172292C643D796128622E772C31292C6E756C6C213D622E643F28653D622E642C28303E657C7C653E3629262628693D213029293A6E756C6C213D622E653F';
wwv_flow_api.g_varchar2_table(131) := '28653D622E652B662C28622E653C307C7C622E653E3629262628693D213029293A653D66292C313E647C7C643E786128632C662C67293F6A2861292E5F6F766572666C6F775765656B733D21303A6E756C6C213D693F6A2861292E5F6F766572666C6F77';
wwv_flow_api.g_varchar2_table(132) := '5765656B6461793D21303A28683D766128632C642C652C662C67292C612E5F615B4D645D3D682E796561722C612E5F6461794F66596561723D682E6461794F6659656172297D66756E6374696F6E2043612862297B696628622E5F663D3D3D612E49534F';
wwv_flow_api.g_varchar2_table(133) := '5F383630312972657475726E20766F6964206E612862293B622E5F613D5B5D2C6A2862292E656D7074793D21303B76617220632C642C652C662C672C683D22222B622E5F692C693D682E6C656E6774682C6B3D303B666F7228653D5628622E5F662C622E';
wwv_flow_api.g_varchar2_table(134) := '5F6C6F63616C65292E6D61746368287064297C7C5B5D2C633D303B633C652E6C656E6774683B632B2B29663D655B635D2C643D28682E6D61746368285828662C6229297C7C5B5D295B305D2C64262628673D682E73756273747228302C682E696E646578';
wwv_flow_api.g_varchar2_table(135) := '4F66286429292C672E6C656E6774683E3026266A2862292E756E75736564496E7075742E707573682867292C683D682E736C69636528682E696E6465784F662864292B642E6C656E677468292C6B2B3D642E6C656E677468292C73645B665D3F28643F6A';
wwv_flow_api.g_varchar2_table(136) := '2862292E656D7074793D21313A6A2862292E756E75736564546F6B656E732E707573682866292C616128662C642C6229293A622E5F7374726963742626216426266A2862292E756E75736564546F6B656E732E707573682866293B6A2862292E63686172';
wwv_flow_api.g_varchar2_table(137) := '734C6566744F7665723D692D6B2C682E6C656E6774683E3026266A2862292E756E75736564496E7075742E707573682868292C6A2862292E626967486F75723D3D3D21302626622E5F615B50645D3C3D31322626622E5F615B50645D3E302626286A2862';
wwv_flow_api.g_varchar2_table(138) := '292E626967486F75723D766F69642030292C6A2862292E7061727365644461746550617274733D622E5F612E736C6963652830292C6A2862292E6D6572696469656D3D622E5F6D6572696469656D2C622E5F615B50645D3D446128622E5F6C6F63616C65';
wwv_flow_api.g_varchar2_table(139) := '2C622E5F615B50645D2C622E5F6D6572696469656D292C41612862292C6D612862297D66756E6374696F6E20446128612C622C63297B76617220643B72657475726E206E756C6C3D3D633F623A6E756C6C213D612E6D6572696469656D486F75723F612E';
wwv_flow_api.g_varchar2_table(140) := '6D6572696469656D486F757228622C63293A6E756C6C213D612E6973504D3F28643D612E6973504D2863292C64262631323E62262628622B3D3132292C647C7C3132213D3D627C7C28623D30292C62293A627D66756E6374696F6E2045612861297B7661';
wwv_flow_api.g_varchar2_table(141) := '7220622C632C642C652C663B696628303D3D3D612E5F662E6C656E6774682972657475726E206A2861292E696E76616C6964466F726D61743D21302C766F696428612E5F643D6E65772044617465284E614E29293B666F7228653D303B653C612E5F662E';
wwv_flow_api.g_varchar2_table(142) := '6C656E6774683B652B2B29663D302C623D6E287B7D2C61292C6E756C6C213D612E5F757365555443262628622E5F7573655554433D612E5F757365555443292C622E5F663D612E5F665B655D2C43612862292C6B286229262628662B3D6A2862292E6368';
wwv_flow_api.g_varchar2_table(143) := '6172734C6566744F7665722C662B3D31302A6A2862292E756E75736564546F6B656E732E6C656E6774682C6A2862292E73636F72653D662C286E756C6C3D3D647C7C643E6629262628643D662C633D6229293B6728612C637C7C62297D66756E6374696F';
wwv_flow_api.g_varchar2_table(144) := '6E2046612861297B69662821612E5F64297B76617220623D4C28612E5F69293B612E5F613D65285B622E796561722C622E6D6F6E74682C622E6461797C7C622E646174652C622E686F75722C622E6D696E7574652C622E7365636F6E642C622E6D696C6C';
wwv_flow_api.g_varchar2_table(145) := '697365636F6E645D2C66756E6374696F6E2861297B72657475726E206126267061727365496E7428612C3130297D292C41612861297D7D66756E6374696F6E2047612861297B76617220623D6E6577206F286D6128486128612929293B72657475726E20';
wwv_flow_api.g_varchar2_table(146) := '622E5F6E657874446179262628622E61646428312C226422292C622E5F6E6578744461793D766F69642030292C627D66756E6374696F6E2048612861297B76617220623D612E5F692C653D612E5F663B72657475726E20612E5F6C6F63616C653D612E5F';
wwv_flow_api.g_varchar2_table(147) := '6C6F63616C657C7C4828612E5F6C292C6E756C6C3D3D3D627C7C766F696420303D3D3D65262622223D3D3D623F6C287B6E756C6C496E7075743A21307D293A2822737472696E67223D3D747970656F662062262628612E5F693D623D612E5F6C6F63616C';
wwv_flow_api.g_varchar2_table(148) := '652E7072657061727365286229292C702862293F6E6577206F286D61286229293A28632865293F45612861293A653F43612861293A642862293F612E5F643D623A49612861292C6B2861297C7C28612E5F643D6E756C6C292C6129297D66756E6374696F';
wwv_flow_api.g_varchar2_table(149) := '6E2049612862297B76617220663D622E5F693B766F696420303D3D3D663F622E5F643D6E6577204461746528612E6E6F772829293A642866293F622E5F643D6E6577204461746528662E76616C75654F662829293A22737472696E67223D3D747970656F';
wwv_flow_api.g_varchar2_table(150) := '6620663F6F612862293A632866293F28622E5F613D6528662E736C6963652830292C66756E6374696F6E2861297B72657475726E207061727365496E7428612C3130297D292C4161286229293A226F626A656374223D3D747970656F6620663F46612862';
wwv_flow_api.g_varchar2_table(151) := '293A226E756D626572223D3D747970656F6620663F622E5F643D6E657720446174652866293A612E63726561746546726F6D496E70757446616C6C6261636B2862297D66756E6374696F6E204A6128612C622C632C642C65297B76617220663D7B7D3B72';
wwv_flow_api.g_varchar2_table(152) := '657475726E22626F6F6C65616E223D3D747970656F662063262628643D632C633D766F69642030292C662E5F6973414D6F6D656E744F626A6563743D21302C662E5F7573655554433D662E5F69735554433D652C662E5F6C3D632C662E5F693D612C662E';
wwv_flow_api.g_varchar2_table(153) := '5F663D622C662E5F7374726963743D642C47612866297D66756E6374696F6E204B6128612C622C632C64297B72657475726E204A6128612C622C632C642C2131297D66756E6374696F6E204C6128612C62297B76617220642C653B696628313D3D3D622E';
wwv_flow_api.g_varchar2_table(154) := '6C656E67746826266328625B305D29262628623D625B305D292C21622E6C656E6774682972657475726E204B6128293B666F7228643D625B305D2C653D313B653C622E6C656E6774683B2B2B65292821625B655D2E697356616C696428297C7C625B655D';
wwv_flow_api.g_varchar2_table(155) := '5B615D28642929262628643D625B655D293B72657475726E20647D66756E6374696F6E204D6128297B76617220613D5B5D2E736C6963652E63616C6C28617267756D656E74732C30293B72657475726E204C61282269734265666F7265222C61297D6675';
wwv_flow_api.g_varchar2_table(156) := '6E6374696F6E204E6128297B76617220613D5B5D2E736C6963652E63616C6C28617267756D656E74732C30293B72657475726E204C61282269734166746572222C61297D66756E6374696F6E204F612861297B76617220623D4C2861292C633D622E7965';
wwv_flow_api.g_varchar2_table(157) := '61727C7C302C643D622E717561727465727C7C302C653D622E6D6F6E74687C7C302C663D622E7765656B7C7C302C673D622E6461797C7C302C683D622E686F75727C7C302C693D622E6D696E7574657C7C302C6A3D622E7365636F6E647C7C302C6B3D62';
wwv_flow_api.g_varchar2_table(158) := '2E6D696C6C697365636F6E647C7C303B746869732E5F6D696C6C697365636F6E64733D2B6B2B3165332A6A2B3665342A692B3165332A682A36302A36302C746869732E5F646179733D2B672B372A662C746869732E5F6D6F6E7468733D2B652B332A642B';
wwv_flow_api.g_varchar2_table(159) := '31322A632C746869732E5F646174613D7B7D2C746869732E5F6C6F63616C653D4828292C746869732E5F627562626C6528297D66756E6374696F6E2050612861297B72657475726E206120696E7374616E63656F66204F617D66756E6374696F6E205161';
wwv_flow_api.g_varchar2_table(160) := '28612C62297B5228612C302C302C66756E6374696F6E28297B76617220613D746869732E7574634F666673657428292C633D222B223B72657475726E20303E61262628613D2D612C633D222D22292C632B51287E7E28612F3630292C32292B622B51287E';
wwv_flow_api.g_varchar2_table(161) := '7E612536302C32297D297D66756E6374696F6E20526128612C62297B76617220633D28627C7C2222292E6D617463682861297C7C5B5D2C643D635B632E6C656E6774682D315D7C7C5B5D2C653D28642B2222292E6D61746368286965297C7C5B222D222C';
wwv_flow_api.g_varchar2_table(162) := '302C305D2C663D2B2836302A655B315D292B7228655B325D293B72657475726E222B223D3D3D655B305D3F663A2D667D66756E6374696F6E20536128622C63297B76617220652C663B72657475726E20632E5F69735554433F28653D632E636C6F6E6528';
wwv_flow_api.g_varchar2_table(163) := '292C663D28702862297C7C642862293F622E76616C75654F6628293A4B612862292E76616C75654F662829292D652E76616C75654F6628292C652E5F642E73657454696D6528652E5F642E76616C75654F6628292B66292C612E7570646174654F666673';
wwv_flow_api.g_varchar2_table(164) := '657428652C2131292C65293A4B612862292E6C6F63616C28297D66756E6374696F6E2054612861297B72657475726E2031352A2D4D6174682E726F756E6428612E5F642E67657454696D657A6F6E654F666673657428292F3135297D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(165) := '20556128622C63297B76617220642C653D746869732E5F6F66667365747C7C303B72657475726E20746869732E697356616C696428293F6E756C6C213D623F2822737472696E67223D3D747970656F6620623F623D52612848642C62293A4D6174682E61';
wwv_flow_api.g_varchar2_table(166) := '62732862293C3136262628623D36302A62292C21746869732E5F6973555443262663262628643D5461287468697329292C746869732E5F6F66667365743D622C746869732E5F69735554433D21302C6E756C6C213D642626746869732E61646428642C22';
wwv_flow_api.g_varchar2_table(167) := '6D22292C65213D3D6226262821637C7C746869732E5F6368616E6765496E50726F67726573733F6A6228746869732C646228622D652C226D22292C312C2131293A746869732E5F6368616E6765496E50726F67726573737C7C28746869732E5F6368616E';
wwv_flow_api.g_varchar2_table(168) := '6765496E50726F67726573733D21302C612E7570646174654F666673657428746869732C2130292C746869732E5F6368616E6765496E50726F67726573733D6E756C6C29292C74686973293A746869732E5F69735554433F653A54612874686973293A6E';
wwv_flow_api.g_varchar2_table(169) := '756C6C213D623F746869733A4E614E7D66756E6374696F6E20566128612C62297B72657475726E206E756C6C213D613F2822737472696E6722213D747970656F662061262628613D2D61292C746869732E7574634F666673657428612C62292C74686973';
wwv_flow_api.g_varchar2_table(170) := '293A2D746869732E7574634F666673657428297D66756E6374696F6E2057612861297B72657475726E20746869732E7574634F666673657428302C61297D66756E6374696F6E2058612861297B72657475726E20746869732E5F69735554432626287468';
wwv_flow_api.g_varchar2_table(171) := '69732E7574634F666673657428302C61292C746869732E5F69735554433D21312C612626746869732E73756274726163742854612874686973292C226D2229292C746869737D66756E6374696F6E20596128297B72657475726E20746869732E5F747A6D';
wwv_flow_api.g_varchar2_table(172) := '3F746869732E7574634F666673657428746869732E5F747A6D293A22737472696E67223D3D747970656F6620746869732E5F692626746869732E7574634F66667365742852612847642C746869732E5F6929292C746869737D66756E6374696F6E205A61';
wwv_flow_api.g_varchar2_table(173) := '2861297B72657475726E20746869732E697356616C696428293F28613D613F4B612861292E7574634F666673657428293A302C28746869732E7574634F666673657428292D61292536303D3D3D30293A21317D66756E6374696F6E20246128297B726574';
wwv_flow_api.g_varchar2_table(174) := '75726E20746869732E7574634F666673657428293E746869732E636C6F6E6528292E6D6F6E74682830292E7574634F666673657428297C7C746869732E7574634F666673657428293E746869732E636C6F6E6528292E6D6F6E74682835292E7574634F66';
wwv_flow_api.g_varchar2_table(175) := '6673657428297D66756E6374696F6E205F6128297B696628216D28746869732E5F697344535453686966746564292972657475726E20746869732E5F6973445354536869667465643B76617220613D7B7D3B6966286E28612C74686973292C613D486128';
wwv_flow_api.g_varchar2_table(176) := '61292C612E5F61297B76617220623D612E5F69735554433F6828612E5F61293A4B6128612E5F61293B746869732E5F6973445354536869667465643D746869732E697356616C6964282926267328612E5F612C622E746F41727261792829293E307D656C';
wwv_flow_api.g_varchar2_table(177) := '736520746869732E5F6973445354536869667465643D21313B72657475726E20746869732E5F6973445354536869667465647D66756E6374696F6E20616228297B72657475726E20746869732E697356616C696428293F21746869732E5F69735554433A';
wwv_flow_api.g_varchar2_table(178) := '21317D66756E6374696F6E20626228297B72657475726E20746869732E697356616C696428293F746869732E5F69735554433A21317D66756E6374696F6E20636228297B72657475726E20746869732E697356616C696428293F746869732E5F69735554';
wwv_flow_api.g_varchar2_table(179) := '432626303D3D3D746869732E5F6F66667365743A21317D66756E6374696F6E20646228612C62297B76617220632C642C652C673D612C683D6E756C6C3B72657475726E2050612861293F673D7B6D733A612E5F6D696C6C697365636F6E64732C643A612E';
wwv_flow_api.g_varchar2_table(180) := '5F646179732C4D3A612E5F6D6F6E7468737D3A226E756D626572223D3D747970656F6620613F28673D7B7D2C623F675B625D3D613A672E6D696C6C697365636F6E64733D61293A28683D6A652E65786563286129293F28633D222D223D3D3D685B315D3F';
wwv_flow_api.g_varchar2_table(181) := '2D313A312C673D7B793A302C643A7228685B4F645D292A632C683A7228685B50645D292A632C6D3A7228685B51645D292A632C733A7228685B52645D292A632C6D733A7228685B53645D292A637D293A28683D6B652E65786563286129293F28633D222D';
wwv_flow_api.g_varchar2_table(182) := '223D3D3D685B315D3F2D313A312C673D7B793A656228685B325D2C63292C4D3A656228685B335D2C63292C773A656228685B345D2C63292C643A656228685B355D2C63292C683A656228685B365D2C63292C6D3A656228685B375D2C63292C733A656228';
wwv_flow_api.g_varchar2_table(183) := '685B385D2C63297D293A6E756C6C3D3D673F673D7B7D3A226F626A656374223D3D747970656F6620672626282266726F6D22696E20677C7C22746F22696E206729262628653D6762284B6128672E66726F6D292C4B6128672E746F29292C673D7B7D2C67';
wwv_flow_api.g_varchar2_table(184) := '2E6D733D652E6D696C6C697365636F6E64732C672E4D3D652E6D6F6E746873292C643D6E6577204F612867292C506128612926266628612C225F6C6F63616C652229262628642E5F6C6F63616C653D612E5F6C6F63616C65292C647D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(185) := '20656228612C62297B76617220633D6126267061727365466C6F617428612E7265706C61636528222C222C222E2229293B72657475726E2869734E614E2863293F303A63292A627D66756E6374696F6E20666228612C62297B76617220633D7B6D696C6C';
wwv_flow_api.g_varchar2_table(186) := '697365636F6E64733A302C6D6F6E7468733A307D3B72657475726E20632E6D6F6E7468733D622E6D6F6E746828292D612E6D6F6E746828292B31322A28622E7965617228292D612E796561722829292C612E636C6F6E6528292E61646428632E6D6F6E74';
wwv_flow_api.g_varchar2_table(187) := '68732C224D22292E6973416674657228622926262D2D632E6D6F6E7468732C632E6D696C6C697365636F6E64733D2B622D2B612E636C6F6E6528292E61646428632E6D6F6E7468732C224D22292C637D66756E6374696F6E20676228612C62297B766172';
wwv_flow_api.g_varchar2_table(188) := '20633B72657475726E20612E697356616C696428292626622E697356616C696428293F28623D536128622C61292C612E69734265666F72652862293F633D666228612C62293A28633D666228622C61292C632E6D696C6C697365636F6E64733D2D632E6D';
wwv_flow_api.g_varchar2_table(189) := '696C6C697365636F6E64732C632E6D6F6E7468733D2D632E6D6F6E746873292C63293A7B6D696C6C697365636F6E64733A302C6D6F6E7468733A307D7D66756E6374696F6E2068622861297B72657475726E20303E613F2D312A4D6174682E726F756E64';
wwv_flow_api.g_varchar2_table(190) := '282D312A61293A4D6174682E726F756E642861297D66756E6374696F6E20696228612C62297B72657475726E2066756E6374696F6E28632C64297B76617220652C663B72657475726E206E756C6C3D3D3D647C7C69734E614E282B64297C7C287628622C';
wwv_flow_api.g_varchar2_table(191) := '226D6F6D656E7428292E222B622B2228706572696F642C206E756D6265722920697320646570726563617465642E20506C6561736520757365206D6F6D656E7428292E222B622B22286E756D6265722C20706572696F64292E22292C663D632C633D642C';
wwv_flow_api.g_varchar2_table(192) := '643D66292C633D22737472696E67223D3D747970656F6620633F2B633A632C653D646228632C64292C6A6228746869732C652C61292C746869737D7D66756E6374696F6E206A6228622C632C642C65297B76617220663D632E5F6D696C6C697365636F6E';
wwv_flow_api.g_varchar2_table(193) := '64732C673D686228632E5F64617973292C683D686228632E5F6D6F6E746873293B622E697356616C69642829262628653D6E756C6C3D3D653F21303A652C662626622E5F642E73657454696D6528622E5F642E76616C75654F6628292B662A64292C6726';
wwv_flow_api.g_varchar2_table(194) := '264F28622C2244617465222C4E28622C224461746522292B672A64292C682626676128622C4E28622C224D6F6E746822292B682A64292C652626612E7570646174654F666673657428622C677C7C6829297D66756E6374696F6E206B6228612C62297B76';
wwv_flow_api.g_varchar2_table(195) := '617220633D617C7C4B6128292C643D536128632C74686973292E73746172744F66282264617922292C653D746869732E6469666628642C2264617973222C2130292C663D2D363E653F2273616D65456C7365223A2D313E653F226C6173745765656B223A';
wwv_flow_api.g_varchar2_table(196) := '303E653F226C617374446179223A313E653F2273616D65446179223A323E653F226E657874446179223A373E653F226E6578745765656B223A2273616D65456C7365222C673D622626287728625B665D293F625B665D28293A625B665D293B7265747572';
wwv_flow_api.g_varchar2_table(197) := '6E20746869732E666F726D617428677C7C746869732E6C6F63616C654461746128292E63616C656E64617228662C746869732C4B6128632929297D66756E6374696F6E206C6228297B72657475726E206E6577206F2874686973297D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(198) := '206D6228612C62297B76617220633D702861293F613A4B612861293B72657475726E20746869732E697356616C696428292626632E697356616C696428293F28623D4B286D2862293F226D696C6C697365636F6E64223A62292C226D696C6C697365636F';
wwv_flow_api.g_varchar2_table(199) := '6E64223D3D3D623F746869732E76616C75654F6628293E632E76616C75654F6628293A632E76616C75654F6628293C746869732E636C6F6E6528292E73746172744F662862292E76616C75654F662829293A21317D66756E6374696F6E206E6228612C62';
wwv_flow_api.g_varchar2_table(200) := '297B76617220633D702861293F613A4B612861293B72657475726E20746869732E697356616C696428292626632E697356616C696428293F28623D4B286D2862293F226D696C6C697365636F6E64223A62292C226D696C6C697365636F6E64223D3D3D62';
wwv_flow_api.g_varchar2_table(201) := '3F746869732E76616C75654F6628293C632E76616C75654F6628293A746869732E636C6F6E6528292E656E644F662862292E76616C75654F6628293C632E76616C75654F662829293A21317D66756E6374696F6E206F6228612C622C632C64297B726574';
wwv_flow_api.g_varchar2_table(202) := '75726E20643D647C7C222829222C282228223D3D3D645B305D3F746869732E6973416674657228612C63293A21746869732E69734265666F726528612C6329292626282229223D3D3D645B315D3F746869732E69734265666F726528622C63293A217468';
wwv_flow_api.g_varchar2_table(203) := '69732E6973416674657228622C6329297D66756E6374696F6E20706228612C62297B76617220632C643D702861293F613A4B612861293B72657475726E20746869732E697356616C696428292626642E697356616C696428293F28623D4B28627C7C226D';
wwv_flow_api.g_varchar2_table(204) := '696C6C697365636F6E6422292C226D696C6C697365636F6E64223D3D3D623F746869732E76616C75654F6628293D3D3D642E76616C75654F6628293A28633D642E76616C75654F6628292C746869732E636C6F6E6528292E73746172744F662862292E76';
wwv_flow_api.g_varchar2_table(205) := '616C75654F6628293C3D632626633C3D746869732E636C6F6E6528292E656E644F662862292E76616C75654F66282929293A21317D66756E6374696F6E20716228612C62297B72657475726E20746869732E697353616D6528612C62297C7C746869732E';
wwv_flow_api.g_varchar2_table(206) := '6973416674657228612C62297D66756E6374696F6E20726228612C62297B72657475726E20746869732E697353616D6528612C62297C7C746869732E69734265666F726528612C62297D66756E6374696F6E20736228612C622C63297B76617220642C65';
wwv_flow_api.g_varchar2_table(207) := '2C662C673B72657475726E20746869732E697356616C696428293F28643D536128612C74686973292C642E697356616C696428293F28653D3665342A28642E7574634F666673657428292D746869732E7574634F66667365742829292C623D4B2862292C';
wwv_flow_api.g_varchar2_table(208) := '2279656172223D3D3D627C7C226D6F6E7468223D3D3D627C7C2271756172746572223D3D3D623F28673D746228746869732C64292C2271756172746572223D3D3D623F672F3D333A2279656172223D3D3D62262628672F3D313229293A28663D74686973';
wwv_flow_api.g_varchar2_table(209) := '2D642C673D227365636F6E64223D3D3D623F662F3165333A226D696E757465223D3D3D623F662F3665343A22686F7572223D3D3D623F662F333665353A22646179223D3D3D623F28662D65292F38363465353A227765656B223D3D3D623F28662D65292F';
wwv_flow_api.g_varchar2_table(210) := '3630343865353A66292C633F673A71286729293A4E614E293A4E614E7D66756E6374696F6E20746228612C62297B76617220632C642C653D31322A28622E7965617228292D612E796561722829292B28622E6D6F6E746828292D612E6D6F6E7468282929';
wwv_flow_api.g_varchar2_table(211) := '2C663D612E636C6F6E6528292E61646428652C226D6F6E74687322293B72657475726E20303E622D663F28633D612E636C6F6E6528292E61646428652D312C226D6F6E74687322292C643D28622D66292F28662D6329293A28633D612E636C6F6E652829';
wwv_flow_api.g_varchar2_table(212) := '2E61646428652B312C226D6F6E74687322292C643D28622D66292F28632D6629292C2D28652B64297C7C307D66756E6374696F6E20756228297B72657475726E20746869732E636C6F6E6528292E6C6F63616C652822656E22292E666F726D6174282264';
wwv_flow_api.g_varchar2_table(213) := '6464204D4D4D20444420595959592048483A6D6D3A7373205B474D545D5A5A22297D66756E6374696F6E20766228297B76617220613D746869732E636C6F6E6528292E75746328293B72657475726E20303C612E7965617228292626612E796561722829';
wwv_flow_api.g_varchar2_table(214) := '3C3D393939393F7728446174652E70726F746F747970652E746F49534F537472696E67293F746869732E746F4461746528292E746F49534F537472696E6728293A5528612C22595959592D4D4D2D44445B545D48483A6D6D3A73732E5353535B5A5D2229';
wwv_flow_api.g_varchar2_table(215) := '3A5528612C225959595959592D4D4D2D44445B545D48483A6D6D3A73732E5353535B5A5D22297D66756E6374696F6E2077622862297B627C7C28623D746869732E697355746328293F612E64656661756C74466F726D61745574633A612E64656661756C';
wwv_flow_api.g_varchar2_table(216) := '74466F726D6174293B76617220633D5528746869732C62293B72657475726E20746869732E6C6F63616C654461746128292E706F7374666F726D61742863297D66756E6374696F6E20786228612C62297B72657475726E20746869732E697356616C6964';
wwv_flow_api.g_varchar2_table(217) := '2829262628702861292626612E697356616C696428297C7C4B612861292E697356616C69642829293F6462287B746F3A746869732C66726F6D3A617D292E6C6F63616C6528746869732E6C6F63616C652829292E68756D616E697A65282162293A746869';
wwv_flow_api.g_varchar2_table(218) := '732E6C6F63616C654461746128292E696E76616C69644461746528297D66756E6374696F6E2079622861297B72657475726E20746869732E66726F6D284B6128292C61297D66756E6374696F6E207A6228612C62297B72657475726E20746869732E6973';
wwv_flow_api.g_varchar2_table(219) := '56616C69642829262628702861292626612E697356616C696428297C7C4B612861292E697356616C69642829293F6462287B66726F6D3A746869732C746F3A617D292E6C6F63616C6528746869732E6C6F63616C652829292E68756D616E697A65282162';
wwv_flow_api.g_varchar2_table(220) := '293A746869732E6C6F63616C654461746128292E696E76616C69644461746528297D66756E6374696F6E2041622861297B72657475726E20746869732E746F284B6128292C61297D66756E6374696F6E2042622861297B76617220623B72657475726E20';
wwv_flow_api.g_varchar2_table(221) := '766F696420303D3D3D613F746869732E5F6C6F63616C652E5F616262723A28623D482861292C6E756C6C213D62262628746869732E5F6C6F63616C653D62292C74686973297D66756E6374696F6E20436228297B72657475726E20746869732E5F6C6F63';
wwv_flow_api.g_varchar2_table(222) := '616C657D66756E6374696F6E2044622861297B73776974636828613D4B286129297B636173652279656172223A746869732E6D6F6E74682830293B636173652271756172746572223A63617365226D6F6E7468223A746869732E646174652831293B6361';
wwv_flow_api.g_varchar2_table(223) := '7365227765656B223A636173652269736F5765656B223A6361736522646179223A636173652264617465223A746869732E686F7572732830293B6361736522686F7572223A746869732E6D696E757465732830293B63617365226D696E757465223A7468';
wwv_flow_api.g_varchar2_table(224) := '69732E7365636F6E64732830293B63617365227365636F6E64223A746869732E6D696C6C697365636F6E64732830297D72657475726E227765656B223D3D3D612626746869732E7765656B6461792830292C2269736F5765656B223D3D3D612626746869';
wwv_flow_api.g_varchar2_table(225) := '732E69736F5765656B6461792831292C2271756172746572223D3D3D612626746869732E6D6F6E746828332A4D6174682E666C6F6F7228746869732E6D6F6E746828292F3329292C746869737D66756E6374696F6E2045622861297B72657475726E2061';
wwv_flow_api.g_varchar2_table(226) := '3D4B2861292C766F696420303D3D3D617C7C226D696C6C697365636F6E64223D3D3D613F746869733A282264617465223D3D3D61262628613D2264617922292C746869732E73746172744F662861292E61646428312C2269736F5765656B223D3D3D613F';
wwv_flow_api.g_varchar2_table(227) := '227765656B223A61292E737562747261637428312C226D732229297D66756E6374696F6E20466228297B72657475726E20746869732E5F642E76616C75654F6628292D3665342A28746869732E5F6F66667365747C7C30297D66756E6374696F6E204762';
wwv_flow_api.g_varchar2_table(228) := '28297B72657475726E204D6174682E666C6F6F7228746869732E76616C75654F6628292F316533297D66756E6374696F6E20486228297B72657475726E20746869732E5F6F66667365743F6E6577204461746528746869732E76616C75654F662829293A';
wwv_flow_api.g_varchar2_table(229) := '746869732E5F647D66756E6374696F6E20496228297B76617220613D746869733B72657475726E5B612E7965617228292C612E6D6F6E746828292C612E6461746528292C612E686F757228292C612E6D696E75746528292C612E7365636F6E6428292C61';
wwv_flow_api.g_varchar2_table(230) := '2E6D696C6C697365636F6E6428295D7D66756E6374696F6E204A6228297B76617220613D746869733B72657475726E7B79656172733A612E7965617228292C6D6F6E7468733A612E6D6F6E746828292C646174653A612E6461746528292C686F7572733A';
wwv_flow_api.g_varchar2_table(231) := '612E686F75727328292C6D696E757465733A612E6D696E7574657328292C7365636F6E64733A612E7365636F6E647328292C6D696C6C697365636F6E64733A612E6D696C6C697365636F6E647328297D7D66756E6374696F6E204B6228297B7265747572';
wwv_flow_api.g_varchar2_table(232) := '6E20746869732E697356616C696428293F746869732E746F49534F537472696E6728293A6E756C6C7D66756E6374696F6E204C6228297B72657475726E206B2874686973297D66756E6374696F6E204D6228297B72657475726E2067287B7D2C6A287468';
wwv_flow_api.g_varchar2_table(233) := '697329297D66756E6374696F6E204E6228297B72657475726E206A2874686973292E6F766572666C6F777D66756E6374696F6E204F6228297B72657475726E7B696E7075743A746869732E5F692C666F726D61743A746869732E5F662C6C6F63616C653A';
wwv_flow_api.g_varchar2_table(234) := '746869732E5F6C6F63616C652C69735554433A746869732E5F69735554432C7374726963743A746869732E5F7374726963747D7D66756E6374696F6E20506228612C62297B5228302C5B612C612E6C656E6774685D2C302C62297D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(235) := '51622861297B72657475726E2055622E63616C6C28746869732C612C746869732E7765656B28292C746869732E7765656B64617928292C746869732E6C6F63616C654461746128292E5F7765656B2E646F772C746869732E6C6F63616C65446174612829';
wwv_flow_api.g_varchar2_table(236) := '2E5F7765656B2E646F79297D66756E6374696F6E2052622861297B72657475726E2055622E63616C6C28746869732C612C746869732E69736F5765656B28292C746869732E69736F5765656B64617928292C312C34297D66756E6374696F6E2053622829';
wwv_flow_api.g_varchar2_table(237) := '7B72657475726E20786128746869732E7965617228292C312C34297D66756E6374696F6E20546228297B76617220613D746869732E6C6F63616C654461746128292E5F7765656B3B72657475726E20786128746869732E7965617228292C612E646F772C';
wwv_flow_api.g_varchar2_table(238) := '612E646F79297D66756E6374696F6E20556228612C622C632C642C65297B76617220663B72657475726E206E756C6C3D3D613F776128746869732C642C65292E796561723A28663D786128612C642C65292C623E66262628623D66292C56622E63616C6C';
wwv_flow_api.g_varchar2_table(239) := '28746869732C612C622C632C642C6529297D66756E6374696F6E20566228612C622C632C642C65297B76617220663D766128612C622C632C642C65292C673D716128662E796561722C302C662E6461794F6659656172293B72657475726E20746869732E';
wwv_flow_api.g_varchar2_table(240) := '7965617228672E67657455544346756C6C596561722829292C746869732E6D6F6E746828672E6765745554434D6F6E74682829292C746869732E6461746528672E676574555443446174652829292C746869737D66756E6374696F6E2057622861297B72';
wwv_flow_api.g_varchar2_table(241) := '657475726E206E756C6C3D3D613F4D6174682E6365696C2828746869732E6D6F6E746828292B31292F33293A746869732E6D6F6E746828332A28612D31292B746869732E6D6F6E746828292533297D66756E6374696F6E2058622861297B72657475726E';
wwv_flow_api.g_varchar2_table(242) := '20776128612C746869732E5F7765656B2E646F772C746869732E5F7765656B2E646F79292E7765656B7D66756E6374696F6E20596228297B72657475726E20746869732E5F7765656B2E646F777D66756E6374696F6E205A6228297B72657475726E2074';
wwv_flow_api.g_varchar2_table(243) := '6869732E5F7765656B2E646F797D66756E6374696F6E2024622861297B76617220623D746869732E6C6F63616C654461746128292E7765656B2874686973293B72657475726E206E756C6C3D3D613F623A746869732E61646428372A28612D62292C2264';
wwv_flow_api.g_varchar2_table(244) := '22297D66756E6374696F6E205F622861297B76617220623D776128746869732C312C34292E7765656B3B72657475726E206E756C6C3D3D613F623A746869732E61646428372A28612D62292C226422297D66756E6374696F6E20616328612C62297B7265';
wwv_flow_api.g_varchar2_table(245) := '7475726E22737472696E6722213D747970656F6620613F613A69734E614E2861293F28613D622E7765656B6461797350617273652861292C226E756D626572223D3D747970656F6620613F613A6E756C6C293A7061727365496E7428612C3130297D6675';
wwv_flow_api.g_varchar2_table(246) := '6E6374696F6E20626328612C62297B72657475726E206328746869732E5F7765656B64617973293F746869732E5F7765656B646179735B612E64617928295D3A746869732E5F7765656B646179735B746869732E5F7765656B646179732E6973466F726D';
wwv_flow_api.g_varchar2_table(247) := '61742E746573742862293F22666F726D6174223A227374616E64616C6F6E65225D5B612E64617928295D7D66756E6374696F6E2063632861297B72657475726E20746869732E5F7765656B6461797353686F72745B612E64617928295D7D66756E637469';
wwv_flow_api.g_varchar2_table(248) := '6F6E2064632861297B72657475726E20746869732E5F7765656B646179734D696E5B612E64617928295D7D66756E6374696F6E20656328612C622C63297B76617220642C652C662C673D612E746F4C6F63616C654C6F7765724361736528293B69662821';
wwv_flow_api.g_varchar2_table(249) := '746869732E5F7765656B64617973506172736529666F7228746869732E5F7765656B6461797350617273653D5B5D2C746869732E5F73686F72745765656B6461797350617273653D5B5D2C746869732E5F6D696E5765656B6461797350617273653D5B5D';
wwv_flow_api.g_varchar2_table(250) := '2C643D303B373E643B2B2B6429663D68285B3265332C315D292E6461792864292C746869732E5F6D696E5765656B6461797350617273655B645D3D746869732E7765656B646179734D696E28662C2222292E746F4C6F63616C654C6F7765724361736528';
wwv_flow_api.g_varchar2_table(251) := '292C746869732E5F73686F72745765656B6461797350617273655B645D3D746869732E7765656B6461797353686F727428662C2222292E746F4C6F63616C654C6F7765724361736528292C746869732E5F7765656B6461797350617273655B645D3D7468';
wwv_flow_api.g_varchar2_table(252) := '69732E7765656B6461797328662C2222292E746F4C6F63616C654C6F7765724361736528293B72657475726E20633F2264646464223D3D3D623F28653D6D642E63616C6C28746869732E5F7765656B6461797350617273652C67292C2D31213D3D653F65';
wwv_flow_api.g_varchar2_table(253) := '3A6E756C6C293A22646464223D3D3D623F28653D6D642E63616C6C28746869732E5F73686F72745765656B6461797350617273652C67292C2D31213D3D653F653A6E756C6C293A28653D6D642E63616C6C28746869732E5F6D696E5765656B6461797350';
wwv_flow_api.g_varchar2_table(254) := '617273652C67292C2D31213D3D653F653A6E756C6C293A2264646464223D3D3D623F28653D6D642E63616C6C28746869732E5F7765656B6461797350617273652C67292C2D31213D3D653F653A28653D6D642E63616C6C28746869732E5F73686F727457';
wwv_flow_api.g_varchar2_table(255) := '65656B6461797350617273652C67292C2D31213D3D653F653A28653D6D642E63616C6C28746869732E5F6D696E5765656B6461797350617273652C67292C2D31213D3D653F653A6E756C6C2929293A22646464223D3D3D623F28653D6D642E63616C6C28';
wwv_flow_api.g_varchar2_table(256) := '746869732E5F73686F72745765656B6461797350617273652C67292C2D31213D3D653F653A28653D6D642E63616C6C28746869732E5F7765656B6461797350617273652C67292C2D31213D3D653F653A28653D6D642E63616C6C28746869732E5F6D696E';
wwv_flow_api.g_varchar2_table(257) := '5765656B6461797350617273652C67292C2D31213D3D653F653A6E756C6C2929293A28653D6D642E63616C6C28746869732E5F6D696E5765656B6461797350617273652C67292C2D31213D3D653F653A28653D6D642E63616C6C28746869732E5F776565';
wwv_flow_api.g_varchar2_table(258) := '6B6461797350617273652C67292C2D31213D3D653F653A28653D6D642E63616C6C28746869732E5F73686F72745765656B6461797350617273652C67292C2D31213D3D653F653A6E756C6C2929297D66756E6374696F6E20666328612C622C63297B7661';
wwv_flow_api.g_varchar2_table(259) := '7220642C652C663B696628746869732E5F7765656B64617973506172736545786163742972657475726E2065632E63616C6C28746869732C612C622C63293B666F7228746869732E5F7765656B6461797350617273657C7C28746869732E5F7765656B64';
wwv_flow_api.g_varchar2_table(260) := '61797350617273653D5B5D2C746869732E5F6D696E5765656B6461797350617273653D5B5D2C746869732E5F73686F72745765656B6461797350617273653D5B5D2C746869732E5F66756C6C5765656B6461797350617273653D5B5D292C643D303B373E';
wwv_flow_api.g_varchar2_table(261) := '643B642B2B297B696628653D68285B3265332C315D292E6461792864292C63262621746869732E5F66756C6C5765656B6461797350617273655B645D262628746869732E5F66756C6C5765656B6461797350617273655B645D3D6E657720526567457870';
wwv_flow_api.g_varchar2_table(262) := '28225E222B746869732E7765656B6461797328652C2222292E7265706C61636528222E222C222E3F22292B2224222C226922292C746869732E5F73686F72745765656B6461797350617273655B645D3D6E65772052656745787028225E222B746869732E';
wwv_flow_api.g_varchar2_table(263) := '7765656B6461797353686F727428652C2222292E7265706C61636528222E222C222E3F22292B2224222C226922292C746869732E5F6D696E5765656B6461797350617273655B645D3D6E65772052656745787028225E222B746869732E7765656B646179';
wwv_flow_api.g_varchar2_table(264) := '734D696E28652C2222292E7265706C61636528222E222C222E3F22292B2224222C22692229292C746869732E5F7765656B6461797350617273655B645D7C7C28663D225E222B746869732E7765656B6461797328652C2222292B227C5E222B746869732E';
wwv_flow_api.g_varchar2_table(265) := '7765656B6461797353686F727428652C2222292B227C5E222B746869732E7765656B646179734D696E28652C2222292C746869732E5F7765656B6461797350617273655B645D3D6E65772052656745787028662E7265706C61636528222E222C2222292C';
wwv_flow_api.g_varchar2_table(266) := '22692229292C6326262264646464223D3D3D622626746869732E5F66756C6C5765656B6461797350617273655B645D2E746573742861292972657475726E20643B69662863262622646464223D3D3D622626746869732E5F73686F72745765656B646179';
wwv_flow_api.g_varchar2_table(267) := '7350617273655B645D2E746573742861292972657475726E20643B696628632626226464223D3D3D622626746869732E5F6D696E5765656B6461797350617273655B645D2E746573742861292972657475726E20643B69662821632626746869732E5F77';
wwv_flow_api.g_varchar2_table(268) := '65656B6461797350617273655B645D2E746573742861292972657475726E20647D7D66756E6374696F6E2067632861297B69662821746869732E697356616C696428292972657475726E206E756C6C213D613F746869733A4E614E3B76617220623D7468';
wwv_flow_api.g_varchar2_table(269) := '69732E5F69735554433F746869732E5F642E67657455544344617928293A746869732E5F642E67657444617928293B72657475726E206E756C6C213D613F28613D616328612C746869732E6C6F63616C65446174612829292C746869732E61646428612D';
wwv_flow_api.g_varchar2_table(270) := '622C22642229293A627D66756E6374696F6E2068632861297B69662821746869732E697356616C696428292972657475726E206E756C6C213D613F746869733A4E614E3B76617220623D28746869732E64617928292B372D746869732E6C6F63616C6544';
wwv_flow_api.g_varchar2_table(271) := '61746128292E5F7765656B2E646F772925373B72657475726E206E756C6C3D3D613F623A746869732E61646428612D622C226422297D66756E6374696F6E2069632861297B72657475726E20746869732E697356616C696428293F6E756C6C3D3D613F74';
wwv_flow_api.g_varchar2_table(272) := '6869732E64617928297C7C373A746869732E64617928746869732E646179282925373F613A612D37293A6E756C6C213D613F746869733A4E614E7D66756E6374696F6E206A632861297B72657475726E20746869732E5F7765656B646179735061727365';
wwv_flow_api.g_varchar2_table(273) := '45786163743F286628746869732C225F7765656B64617973526567657822297C7C6D632E63616C6C2874686973292C613F746869732E5F7765656B6461797353747269637452656765783A746869732E5F7765656B646179735265676578293A74686973';
wwv_flow_api.g_varchar2_table(274) := '2E5F7765656B6461797353747269637452656765782626613F746869732E5F7765656B6461797353747269637452656765783A746869732E5F7765656B6461797352656765787D66756E6374696F6E206B632861297B72657475726E20746869732E5F77';
wwv_flow_api.g_varchar2_table(275) := '65656B64617973506172736545786163743F286628746869732C225F7765656B64617973526567657822297C7C6D632E63616C6C2874686973292C613F746869732E5F7765656B6461797353686F727453747269637452656765783A746869732E5F7765';
wwv_flow_api.g_varchar2_table(276) := '656B6461797353686F72745265676578293A746869732E5F7765656B6461797353686F727453747269637452656765782626613F746869732E5F7765656B6461797353686F727453747269637452656765783A746869732E5F7765656B6461797353686F';
wwv_flow_api.g_varchar2_table(277) := '727452656765787D66756E6374696F6E206C632861297B72657475726E20746869732E5F7765656B64617973506172736545786163743F286628746869732C225F7765656B64617973526567657822297C7C6D632E63616C6C2874686973292C613F7468';
wwv_flow_api.g_varchar2_table(278) := '69732E5F7765656B646179734D696E53747269637452656765783A746869732E5F7765656B646179734D696E5265676578293A746869732E5F7765656B646179734D696E53747269637452656765782626613F746869732E5F7765656B646179734D696E';
wwv_flow_api.g_varchar2_table(279) := '53747269637452656765783A746869732E5F7765656B646179734D696E52656765787D66756E6374696F6E206D6328297B66756E6374696F6E206128612C62297B72657475726E20622E6C656E6774682D612E6C656E6774687D76617220622C632C642C';
wwv_flow_api.g_varchar2_table(280) := '652C662C673D5B5D2C693D5B5D2C6A3D5B5D2C6B3D5B5D3B666F7228623D303B373E623B622B2B29633D68285B3265332C315D292E6461792862292C643D746869732E7765656B646179734D696E28632C2222292C653D746869732E7765656B64617973';
wwv_flow_api.g_varchar2_table(281) := '53686F727428632C2222292C663D746869732E7765656B6461797328632C2222292C672E707573682864292C692E707573682865292C6A2E707573682866292C6B2E707573682864292C6B2E707573682865292C6B2E707573682866293B666F7228672E';
wwv_flow_api.g_varchar2_table(282) := '736F72742861292C692E736F72742861292C6A2E736F72742861292C6B2E736F72742861292C623D303B373E623B622B2B29695B625D3D5A28695B625D292C6A5B625D3D5A286A5B625D292C6B5B625D3D5A286B5B625D293B746869732E5F7765656B64';
wwv_flow_api.g_varchar2_table(283) := '61797352656765783D6E65772052656745787028225E28222B6B2E6A6F696E28227C22292B2229222C226922292C746869732E5F7765656B6461797353686F727452656765783D746869732E5F7765656B6461797352656765782C746869732E5F776565';
wwv_flow_api.g_varchar2_table(284) := '6B646179734D696E52656765783D746869732E5F7765656B6461797352656765782C746869732E5F7765656B6461797353747269637452656765783D6E65772052656745787028225E28222B6A2E6A6F696E28227C22292B2229222C226922292C746869';
wwv_flow_api.g_varchar2_table(285) := '732E5F7765656B6461797353686F727453747269637452656765783D6E65772052656745787028225E28222B692E6A6F696E28227C22292B2229222C226922292C746869732E5F7765656B646179734D696E53747269637452656765783D6E6577205265';
wwv_flow_api.g_varchar2_table(286) := '6745787028225E28222B672E6A6F696E28227C22292B2229222C226922297D66756E6374696F6E206E632861297B76617220623D4D6174682E726F756E642828746869732E636C6F6E6528292E73746172744F66282264617922292D746869732E636C6F';
wwv_flow_api.g_varchar2_table(287) := '6E6528292E73746172744F662822796561722229292F3836346535292B313B72657475726E206E756C6C3D3D613F623A746869732E61646428612D622C226422297D66756E6374696F6E206F6328297B72657475726E20746869732E686F757273282925';
wwv_flow_api.g_varchar2_table(288) := '31327C7C31327D66756E6374696F6E20706328297B72657475726E20746869732E686F75727328297C7C32347D66756E6374696F6E20716328612C62297B5228612C302C302C66756E6374696F6E28297B72657475726E20746869732E6C6F63616C6544';
wwv_flow_api.g_varchar2_table(289) := '61746128292E6D6572696469656D28746869732E686F75727328292C746869732E6D696E7574657328292C62297D297D66756E6374696F6E20726328612C62297B72657475726E20622E5F6D6572696469656D50617273657D66756E6374696F6E207363';
wwv_flow_api.g_varchar2_table(290) := '2861297B72657475726E2270223D3D3D28612B2222292E746F4C6F7765724361736528292E6368617241742830297D66756E6374696F6E20746328612C622C63297B72657475726E20613E31313F633F22706D223A22504D223A633F22616D223A22414D';
wwv_flow_api.g_varchar2_table(291) := '227D66756E6374696F6E20756328612C62297B625B53645D3D72283165332A2822302E222B6129297D66756E6374696F6E20766328297B72657475726E20746869732E5F69735554433F22555443223A22227D66756E6374696F6E20776328297B726574';
wwv_flow_api.g_varchar2_table(292) := '75726E20746869732E5F69735554433F22436F6F7264696E6174656420556E6976657273616C2054696D65223A22227D66756E6374696F6E2078632861297B72657475726E204B61283165332A61297D66756E6374696F6E20796328297B72657475726E';
wwv_flow_api.g_varchar2_table(293) := '204B612E6170706C79286E756C6C2C617267756D656E7473292E70617273655A6F6E6528297D66756E6374696F6E207A6328612C622C63297B76617220643D746869732E5F63616C656E6461725B615D3B72657475726E20772864293F642E63616C6C28';
wwv_flow_api.g_varchar2_table(294) := '622C63293A647D66756E6374696F6E2041632861297B76617220623D746869732E5F6C6F6E6744617465466F726D61745B615D2C633D746869732E5F6C6F6E6744617465466F726D61745B612E746F55707065724361736528295D3B72657475726E2062';
wwv_flow_api.g_varchar2_table(295) := '7C7C21633F623A28746869732E5F6C6F6E6744617465466F726D61745B615D3D632E7265706C616365282F4D4D4D4D7C4D4D7C44447C646464642F672C66756E6374696F6E2861297B72657475726E20612E736C6963652831297D292C746869732E5F6C';
wwv_flow_api.g_varchar2_table(296) := '6F6E6744617465466F726D61745B615D297D66756E6374696F6E20426328297B72657475726E20746869732E5F696E76616C6964446174657D66756E6374696F6E2043632861297B72657475726E20746869732E5F6F7264696E616C2E7265706C616365';
wwv_flow_api.g_varchar2_table(297) := '28222564222C61297D66756E6374696F6E2044632861297B72657475726E20617D66756E6374696F6E20456328612C622C632C64297B76617220653D746869732E5F72656C617469766554696D655B635D3B72657475726E20772865293F6528612C622C';
wwv_flow_api.g_varchar2_table(298) := '632C64293A652E7265706C616365282F25642F692C61297D66756E6374696F6E20466328612C62297B76617220633D746869732E5F72656C617469766554696D655B613E303F22667574757265223A2270617374225D3B72657475726E20772863293F63';
wwv_flow_api.g_varchar2_table(299) := '2862293A632E7265706C616365282F25732F692C62297D66756E6374696F6E20476328612C622C632C64297B76617220653D4828292C663D6828292E73657428642C62293B72657475726E20655B635D28662C61297D66756E6374696F6E20486328612C';
wwv_flow_api.g_varchar2_table(300) := '622C63297B696628226E756D626572223D3D747970656F662061262628623D612C613D766F69642030292C613D617C7C22222C6E756C6C213D622972657475726E20476328612C622C632C226D6F6E746822293B76617220642C653D5B5D3B666F722864';
wwv_flow_api.g_varchar2_table(301) := '3D303B31323E643B642B2B29655B645D3D476328612C642C632C226D6F6E746822293B72657475726E20657D66756E6374696F6E20496328612C622C632C64297B22626F6F6C65616E223D3D747970656F6620613F28226E756D626572223D3D74797065';
wwv_flow_api.g_varchar2_table(302) := '6F662062262628633D622C623D766F69642030292C623D627C7C2222293A28623D612C633D622C613D21312C226E756D626572223D3D747970656F662062262628633D622C623D766F69642030292C623D627C7C2222293B76617220653D4828292C663D';
wwv_flow_api.g_varchar2_table(303) := '613F652E5F7765656B2E646F773A303B6966286E756C6C213D632972657475726E20476328622C28632B662925372C642C2264617922293B76617220672C683D5B5D3B666F7228673D303B373E673B672B2B29685B675D3D476328622C28672B66292537';
wwv_flow_api.g_varchar2_table(304) := '2C642C2264617922293B72657475726E20687D66756E6374696F6E204A6328612C62297B72657475726E20486328612C622C226D6F6E74687322297D66756E6374696F6E204B6328612C62297B72657475726E20486328612C622C226D6F6E7468735368';
wwv_flow_api.g_varchar2_table(305) := '6F727422297D66756E6374696F6E204C6328612C622C63297B72657475726E20496328612C622C632C227765656B6461797322297D66756E6374696F6E204D6328612C622C63297B72657475726E20496328612C622C632C227765656B6461797353686F';
wwv_flow_api.g_varchar2_table(306) := '727422297D66756E6374696F6E204E6328612C622C63297B72657475726E20496328612C622C632C227765656B646179734D696E22297D66756E6374696F6E204F6328297B76617220613D746869732E5F646174613B72657475726E20746869732E5F6D';
wwv_flow_api.g_varchar2_table(307) := '696C6C697365636F6E64733D4C6528746869732E5F6D696C6C697365636F6E6473292C746869732E5F646179733D4C6528746869732E5F64617973292C746869732E5F6D6F6E7468733D4C6528746869732E5F6D6F6E746873292C612E6D696C6C697365';
wwv_flow_api.g_varchar2_table(308) := '636F6E64733D4C6528612E6D696C6C697365636F6E6473292C612E7365636F6E64733D4C6528612E7365636F6E6473292C612E6D696E757465733D4C6528612E6D696E75746573292C612E686F7572733D4C6528612E686F757273292C612E6D6F6E7468';
wwv_flow_api.g_varchar2_table(309) := '733D4C6528612E6D6F6E746873292C612E79656172733D4C6528612E7965617273292C746869737D66756E6374696F6E20506328612C622C632C64297B76617220653D646228622C63293B72657475726E20612E5F6D696C6C697365636F6E64732B3D64';
wwv_flow_api.g_varchar2_table(310) := '2A652E5F6D696C6C697365636F6E64732C612E5F646179732B3D642A652E5F646179732C612E5F6D6F6E7468732B3D642A652E5F6D6F6E7468732C612E5F627562626C6528297D66756E6374696F6E20516328612C62297B72657475726E205063287468';
wwv_flow_api.g_varchar2_table(311) := '69732C612C622C31297D66756E6374696F6E20526328612C62297B72657475726E20506328746869732C612C622C2D31297D66756E6374696F6E2053632861297B72657475726E20303E613F4D6174682E666C6F6F722861293A4D6174682E6365696C28';
wwv_flow_api.g_varchar2_table(312) := '61297D66756E6374696F6E20546328297B76617220612C622C632C642C652C663D746869732E5F6D696C6C697365636F6E64732C673D746869732E5F646179732C683D746869732E5F6D6F6E7468732C693D746869732E5F646174613B72657475726E20';
wwv_flow_api.g_varchar2_table(313) := '663E3D302626673E3D302626683E3D307C7C303E3D662626303E3D672626303E3D687C7C28662B3D38363465352A53632856632868292B67292C673D302C683D30292C692E6D696C6C697365636F6E64733D66253165332C613D7128662F316533292C69';
wwv_flow_api.g_varchar2_table(314) := '2E7365636F6E64733D612536302C623D7128612F3630292C692E6D696E757465733D622536302C633D7128622F3630292C692E686F7572733D632532342C672B3D7128632F3234292C653D71285563286729292C682B3D652C672D3D5363285663286529';
wwv_flow_api.g_varchar2_table(315) := '292C643D7128682F3132292C68253D31322C692E646179733D672C692E6D6F6E7468733D682C692E79656172733D642C746869737D66756E6374696F6E2055632861297B72657475726E20343830302A612F3134363039377D66756E6374696F6E205663';
wwv_flow_api.g_varchar2_table(316) := '2861297B72657475726E203134363039372A612F343830307D66756E6374696F6E2057632861297B76617220622C632C643D746869732E5F6D696C6C697365636F6E64733B696628613D4B2861292C226D6F6E7468223D3D3D617C7C2279656172223D3D';
wwv_flow_api.g_varchar2_table(317) := '3D612972657475726E20623D746869732E5F646179732B642F38363465352C633D746869732E5F6D6F6E7468732B55632862292C226D6F6E7468223D3D3D613F633A632F31323B73776974636828623D746869732E5F646179732B4D6174682E726F756E';
wwv_flow_api.g_varchar2_table(318) := '6428566328746869732E5F6D6F6E74687329292C61297B63617365227765656B223A72657475726E20622F372B642F3630343865353B6361736522646179223A72657475726E20622B642F38363465353B6361736522686F7572223A72657475726E2032';
wwv_flow_api.g_varchar2_table(319) := '342A622B642F333665353B63617365226D696E757465223A72657475726E20313434302A622B642F3665343B63617365227365636F6E64223A72657475726E2038363430302A622B642F3165333B63617365226D696C6C697365636F6E64223A72657475';
wwv_flow_api.g_varchar2_table(320) := '726E204D6174682E666C6F6F722838363465352A62292B643B64656661756C743A7468726F77206E6577204572726F722822556E6B6E6F776E20756E697420222B61297D7D66756E6374696F6E20586328297B72657475726E20746869732E5F6D696C6C';
wwv_flow_api.g_varchar2_table(321) := '697365636F6E64732B38363465352A746869732E5F646179732B746869732E5F6D6F6E7468732531322A3235393265362B333135333665362A7228746869732E5F6D6F6E7468732F3132297D66756E6374696F6E2059632861297B72657475726E206675';
wwv_flow_api.g_varchar2_table(322) := '6E6374696F6E28297B72657475726E20746869732E61732861297D7D66756E6374696F6E205A632861297B0A72657475726E20613D4B2861292C746869735B612B2273225D28297D66756E6374696F6E2024632861297B72657475726E2066756E637469';
wwv_flow_api.g_varchar2_table(323) := '6F6E28297B72657475726E20746869732E5F646174615B615D7D7D66756E6374696F6E205F6328297B72657475726E207128746869732E6461797328292F37297D66756E6374696F6E20616428612C622C632C642C65297B72657475726E20652E72656C';
wwv_flow_api.g_varchar2_table(324) := '617469766554696D6528627C7C312C2121632C612C64297D66756E6374696F6E20626428612C622C63297B76617220643D64622861292E61627328292C653D5F6528642E61732822732229292C663D5F6528642E617328226D2229292C673D5F6528642E';
wwv_flow_api.g_varchar2_table(325) := '61732822682229292C683D5F6528642E61732822642229292C693D5F6528642E617328224D2229292C6A3D5F6528642E61732822792229292C6B3D653C61662E7326265B2273222C655D7C7C313E3D6626265B226D225D7C7C663C61662E6D26265B226D';
wwv_flow_api.g_varchar2_table(326) := '6D222C665D7C7C313E3D6726265B2268225D7C7C673C61662E6826265B226868222C675D7C7C313E3D6826265B2264225D7C7C683C61662E6426265B226464222C685D7C7C313E3D6926265B224D225D7C7C693C61662E4D26265B224D4D222C695D7C7C';
wwv_flow_api.g_varchar2_table(327) := '313E3D6A26265B2279225D7C7C5B227979222C6A5D3B72657475726E206B5B325D3D622C6B5B335D3D2B613E302C6B5B345D3D632C61642E6170706C79286E756C6C2C6B297D66756E6374696F6E20636428612C62297B72657475726E20766F69642030';
wwv_flow_api.g_varchar2_table(328) := '3D3D3D61665B615D3F21313A766F696420303D3D3D623F61665B615D3A2861665B615D3D622C2130297D66756E6374696F6E2064642861297B76617220623D746869732E6C6F63616C654461746128292C633D626428746869732C21612C62293B726574';
wwv_flow_api.g_varchar2_table(329) := '75726E2061262628633D622E70617374467574757265282B746869732C6329292C622E706F7374666F726D61742863297D66756E6374696F6E20656428297B76617220612C622C632C643D626628746869732E5F6D696C6C697365636F6E6473292F3165';
wwv_flow_api.g_varchar2_table(330) := '332C653D626628746869732E5F64617973292C663D626628746869732E5F6D6F6E746873293B613D7128642F3630292C623D7128612F3630292C64253D36302C61253D36302C633D7128662F3132292C66253D31323B76617220673D632C683D662C693D';
wwv_flow_api.g_varchar2_table(331) := '652C6A3D622C6B3D612C6C3D642C6D3D746869732E61735365636F6E647328293B72657475726E206D3F28303E6D3F222D223A2222292B2250222B28673F672B2259223A2222292B28683F682B224D223A2222292B28693F692B2244223A2222292B286A';
wwv_flow_api.g_varchar2_table(332) := '7C7C6B7C7C6C3F2254223A2222292B286A3F6A2B2248223A2222292B286B3F6B2B224D223A2222292B286C3F6C2B2253223A2222293A22503044227D7661722066642C67643B67643D41727261792E70726F746F747970652E736F6D653F41727261792E';
wwv_flow_api.g_varchar2_table(333) := '70726F746F747970652E736F6D653A66756E6374696F6E2861297B666F722876617220623D4F626A6563742874686973292C633D622E6C656E6774683E3E3E302C643D303B633E643B642B2B296966286420696E20622626612E63616C6C28746869732C';
wwv_flow_api.g_varchar2_table(334) := '625B645D2C642C62292972657475726E21303B72657475726E21317D3B7661722068643D612E6D6F6D656E7450726F706572746965733D5B5D2C69643D21312C6A643D7B7D3B612E73757070726573734465707265636174696F6E5761726E696E67733D';
wwv_flow_api.g_varchar2_table(335) := '21312C612E6465707265636174696F6E48616E646C65723D6E756C6C3B766172206B643B6B643D4F626A6563742E6B6579733F4F626A6563742E6B6579733A66756E6374696F6E2861297B76617220622C633D5B5D3B666F72286220696E206129662861';
wwv_flow_api.g_varchar2_table(336) := '2C62292626632E707573682862293B72657475726E20637D3B766172206C642C6D642C6E643D7B7D2C6F643D7B7D2C70643D2F285C5B5B5E5C5B5D2A5C5D297C285C5C293F285B48685D6D6D287373293F7C4D6F7C4D4D3F4D3F4D3F7C446F7C4444446F';
wwv_flow_api.g_varchar2_table(337) := '7C44443F443F443F7C6464643F643F7C646F3F7C775B6F7C775D3F7C575B6F7C575D3F7C516F3F7C5959595959597C59595959597C595959597C59597C6767286767673F293F7C4747284747473F293F7C657C457C617C417C68683F7C48483F7C6B6B3F';
wwv_flow_api.g_varchar2_table(338) := '7C6D6D3F7C73733F7C537B312C397D7C787C587C7A7A3F7C5A5A3F7C2E292F672C71643D2F285C5B5B5E5C5B5D2A5C5D297C285C5C293F284C54537C4C547C4C4C3F4C3F4C3F7C6C7B312C347D292F672C72643D7B7D2C73643D7B7D2C74643D2F5C642F';
wwv_flow_api.g_varchar2_table(339) := '2C75643D2F5C645C642F2C76643D2F5C647B337D2F2C77643D2F5C647B347D2F2C78643D2F5B2B2D5D3F5C647B367D2F2C79643D2F5C645C643F2F2C7A643D2F5C645C645C645C643F2F2C41643D2F5C645C645C645C645C645C643F2F2C42643D2F5C64';
wwv_flow_api.g_varchar2_table(340) := '7B312C337D2F2C43643D2F5C647B312C347D2F2C44643D2F5B2B2D5D3F5C647B312C367D2F2C45643D2F5C642B2F2C46643D2F5B2B2D5D3F5C642B2F2C47643D2F5A7C5B2B2D5D5C645C643A3F5C645C642F67692C48643D2F5A7C5B2B2D5D5C645C6428';
wwv_flow_api.g_varchar2_table(341) := '3F3A3A3F5C645C64293F2F67692C49643D2F5B2B2D5D3F5C642B285C2E5C647B312C337D293F2F2C4A643D2F5B302D395D2A5B27612D7A5C75303041302D5C75303546465C75303730302D5C75443746465C75463930302D5C75464443465C7546444630';
wwv_flow_api.g_varchar2_table(342) := '2D5C75464645465D2B7C5B5C75303630302D5C75303646465C2F5D2B285C732A3F5B5C75303630302D5C75303646465D2B297B312C327D2F692C4B643D7B7D2C4C643D7B7D2C4D643D302C4E643D312C4F643D322C50643D332C51643D342C52643D352C';
wwv_flow_api.g_varchar2_table(343) := '53643D362C54643D372C55643D383B6D643D41727261792E70726F746F747970652E696E6465784F663F41727261792E70726F746F747970652E696E6465784F663A66756E6374696F6E2861297B76617220623B666F7228623D303B623C746869732E6C';
wwv_flow_api.g_varchar2_table(344) := '656E6774683B2B2B6229696628746869735B625D3D3D3D612972657475726E20623B72657475726E2D317D2C5228224D222C5B224D4D222C325D2C224D6F222C66756E6374696F6E28297B72657475726E20746869732E6D6F6E746828292B317D292C52';
wwv_flow_api.g_varchar2_table(345) := '28224D4D4D222C302C302C66756E6374696F6E2861297B72657475726E20746869732E6C6F63616C654461746128292E6D6F6E74687353686F727428746869732C61297D292C5228224D4D4D4D222C302C302C66756E6374696F6E2861297B7265747572';
wwv_flow_api.g_varchar2_table(346) := '6E20746869732E6C6F63616C654461746128292E6D6F6E74687328746869732C61297D292C4A28226D6F6E7468222C224D22292C5728224D222C7964292C5728224D4D222C79642C7564292C5728224D4D4D222C66756E6374696F6E28612C62297B7265';
wwv_flow_api.g_varchar2_table(347) := '7475726E20622E6D6F6E74687353686F727452656765782861297D292C5728224D4D4D4D222C66756E6374696F6E28612C62297B72657475726E20622E6D6F6E74687352656765782861297D292C24285B224D222C224D4D225D2C66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(348) := '612C62297B625B4E645D3D722861292D317D292C24285B224D4D4D222C224D4D4D4D225D2C66756E6374696F6E28612C622C632C64297B76617220653D632E5F6C6F63616C652E6D6F6E746873506172736528612C642C632E5F737472696374293B6E75';
wwv_flow_api.g_varchar2_table(349) := '6C6C213D653F625B4E645D3D653A6A2863292E696E76616C69644D6F6E74683D617D293B7661722056643D2F445B6F445D3F285C5B5B5E5C5B5C5D5D2A5C5D7C5C732B292B4D4D4D4D3F2F2C57643D224A616E756172795F46656272756172795F4D6172';
wwv_flow_api.g_varchar2_table(350) := '63685F417072696C5F4D61795F4A756E655F4A756C795F4175677573745F53657074656D6265725F4F63746F6265725F4E6F76656D6265725F446563656D626572222E73706C697428225F22292C58643D224A616E5F4665625F4D61725F4170725F4D61';
wwv_flow_api.g_varchar2_table(351) := '795F4A756E5F4A756C5F4175675F5365705F4F63745F4E6F765F446563222E73706C697428225F22292C59643D4A642C5A643D4A642C24643D2F5E5C732A28283F3A5B2B2D5D5C647B367D7C5C647B347D292D283F3A5C645C642D5C645C647C575C645C';
wwv_flow_api.g_varchar2_table(352) := '642D5C647C575C645C647C5C645C645C647C5C645C642929283F3A28547C2029285C645C64283F3A3A5C645C64283F3A3A5C645C64283F3A5B2E2C5D5C642B293F293F293F29285B5C2B5C2D5D5C645C64283F3A3A3F5C645C64293F7C5C732A5A293F29';
wwv_flow_api.g_varchar2_table(353) := '3F2F2C5F643D2F5E5C732A28283F3A5B2B2D5D5C647B367D7C5C647B347D29283F3A5C645C645C645C647C575C645C645C647C575C645C647C5C645C645C647C5C645C642929283F3A28547C2029285C645C64283F3A5C645C64283F3A5C645C64283F3A';
wwv_flow_api.g_varchar2_table(354) := '5B2E2C5D5C642B293F293F293F29285B5C2B5C2D5D5C645C64283F3A3A3F5C645C64293F7C5C732A5A293F293F2F2C61653D2F5A7C5B2B2D5D5C645C64283F3A3A3F5C645C64293F2F2C62653D5B5B225959595959592D4D4D2D4444222C2F5B2B2D5D5C';
wwv_flow_api.g_varchar2_table(355) := '647B367D2D5C645C642D5C645C642F5D2C5B22595959592D4D4D2D4444222C2F5C647B347D2D5C645C642D5C645C642F5D2C5B22474747472D5B575D57572D45222C2F5C647B347D2D575C645C642D5C642F5D2C5B22474747472D5B575D5757222C2F5C';
wwv_flow_api.g_varchar2_table(356) := '647B347D2D575C645C642F2C21315D2C5B22595959592D444444222C2F5C647B347D2D5C647B337D2F5D2C5B22595959592D4D4D222C2F5C647B347D2D5C645C642F2C21315D2C5B225959595959594D4D4444222C2F5B2B2D5D5C647B31307D2F5D2C5B';
wwv_flow_api.g_varchar2_table(357) := '22595959594D4D4444222C2F5C647B387D2F5D2C5B22474747475B575D575745222C2F5C647B347D575C647B337D2F5D2C5B22474747475B575D5757222C2F5C647B347D575C647B327D2F2C21315D2C5B2259595959444444222C2F5C647B377D2F5D5D';
wwv_flow_api.g_varchar2_table(358) := '2C63653D5B5B2248483A6D6D3A73732E53535353222C2F5C645C643A5C645C643A5C645C645C2E5C642B2F5D2C5B2248483A6D6D3A73732C53535353222C2F5C645C643A5C645C643A5C645C642C5C642B2F5D2C5B2248483A6D6D3A7373222C2F5C645C';
wwv_flow_api.g_varchar2_table(359) := '643A5C645C643A5C645C642F5D2C5B2248483A6D6D222C2F5C645C643A5C645C642F5D2C5B2248486D6D73732E53535353222C2F5C645C645C645C645C645C645C2E5C642B2F5D2C5B2248486D6D73732C53535353222C2F5C645C645C645C645C645C64';
wwv_flow_api.g_varchar2_table(360) := '2C5C642B2F5D2C5B2248486D6D7373222C2F5C645C645C645C645C645C642F5D2C5B2248486D6D222C2F5C645C645C645C642F5D2C5B224848222C2F5C645C642F5D5D2C64653D2F5E5C2F3F446174655C28285C2D3F5C642B292F693B612E6372656174';
wwv_flow_api.g_varchar2_table(361) := '6546726F6D496E70757446616C6C6261636B3D7528226D6F6D656E7420636F6E737472756374696F6E2066616C6C73206261636B20746F206A7320446174652E205468697320697320646973636F75726167656420616E642077696C6C2062652072656D';
wwv_flow_api.g_varchar2_table(362) := '6F76656420696E207570636F6D696E67206D616A6F722072656C656173652E20506C6561736520726566657220746F2068747470733A2F2F6769746875622E636F6D2F6D6F6D656E742F6D6F6D656E742F6973737565732F3134303720666F72206D6F72';
wwv_flow_api.g_varchar2_table(363) := '6520696E666F2E222C66756E6374696F6E2861297B612E5F643D6E6577204461746528612E5F692B28612E5F7573655554433F2220555443223A222229297D292C52282259222C302C302C66756E6374696F6E28297B76617220613D746869732E796561';
wwv_flow_api.g_varchar2_table(364) := '7228293B72657475726E20393939393E3D613F22222B613A222B222B617D292C5228302C5B225959222C325D2C302C66756E6374696F6E28297B72657475726E20746869732E796561722829253130307D292C5228302C5B2259595959222C345D2C302C';
wwv_flow_api.g_varchar2_table(365) := '227965617222292C5228302C5B225959595959222C355D2C302C227965617222292C5228302C5B22595959595959222C362C21305D2C302C227965617222292C4A282279656172222C227922292C57282259222C4664292C5728225959222C79642C7564';
wwv_flow_api.g_varchar2_table(366) := '292C57282259595959222C43642C7764292C5728225959595959222C44642C7864292C572822595959595959222C44642C7864292C24285B225959595959222C22595959595959225D2C4D64292C24282259595959222C66756E6374696F6E28622C6329';
wwv_flow_api.g_varchar2_table(367) := '7B635B4D645D3D323D3D3D622E6C656E6774683F612E706172736554776F4469676974596561722862293A722862297D292C2428225959222C66756E6374696F6E28622C63297B635B4D645D3D612E706172736554776F4469676974596561722862297D';
wwv_flow_api.g_varchar2_table(368) := '292C24282259222C66756E6374696F6E28612C62297B625B4D645D3D7061727365496E7428612C3130297D292C612E706172736554776F4469676974596561723D66756E6374696F6E2861297B72657475726E20722861292B28722861293E36383F3139';
wwv_flow_api.g_varchar2_table(369) := '30303A326533297D3B7661722065653D4D282246756C6C59656172222C2130293B612E49534F5F383630313D66756E6374696F6E28297B7D3B7661722066653D7528226D6F6D656E7428292E6D696E20697320646570726563617465642C20757365206D';
wwv_flow_api.g_varchar2_table(370) := '6F6D656E742E6D617820696E73746561642E2068747470733A2F2F6769746875622E636F6D2F6D6F6D656E742F6D6F6D656E742F6973737565732F31353438222C66756E6374696F6E28297B76617220613D4B612E6170706C79286E756C6C2C61726775';
wwv_flow_api.g_varchar2_table(371) := '6D656E7473293B72657475726E20746869732E697356616C696428292626612E697356616C696428293F746869733E613F746869733A613A6C28297D292C67653D7528226D6F6D656E7428292E6D617820697320646570726563617465642C2075736520';
wwv_flow_api.g_varchar2_table(372) := '6D6F6D656E742E6D696E20696E73746561642E2068747470733A2F2F6769746875622E636F6D2F6D6F6D656E742F6D6F6D656E742F6973737565732F31353438222C66756E6374696F6E28297B76617220613D4B612E6170706C79286E756C6C2C617267';
wwv_flow_api.g_varchar2_table(373) := '756D656E7473293B72657475726E20746869732E697356616C696428292626612E697356616C696428293F613E746869733F746869733A613A6C28297D292C68653D66756E6374696F6E28297B72657475726E20446174652E6E6F773F446174652E6E6F';
wwv_flow_api.g_varchar2_table(374) := '7728293A2B6E657720446174657D3B516128225A222C223A22292C516128225A5A222C2222292C5728225A222C4864292C5728225A5A222C4864292C24285B225A222C225A5A225D2C66756E6374696F6E28612C622C63297B632E5F7573655554433D21';
wwv_flow_api.g_varchar2_table(375) := '302C632E5F747A6D3D52612848642C61297D293B7661722069653D2F285B5C2B5C2D5D7C5C645C64292F67693B612E7570646174654F66667365743D66756E6374696F6E28297B7D3B766172206A653D2F5E285C2D293F283F3A285C642A295B2E205D29';
wwv_flow_api.g_varchar2_table(376) := '3F285C642B295C3A285C642B29283F3A5C3A285C642B295C2E3F285C647B337D293F5C642A293F242F2C6B653D2F5E282D293F50283F3A282D3F5B302D392C2E5D2A2959293F283F3A282D3F5B302D392C2E5D2A294D293F283F3A282D3F5B302D392C2E';
wwv_flow_api.g_varchar2_table(377) := '5D2A2957293F283F3A282D3F5B302D392C2E5D2A2944293F283F3A54283F3A282D3F5B302D392C2E5D2A2948293F283F3A282D3F5B302D392C2E5D2A294D293F283F3A282D3F5B302D392C2E5D2A2953293F293F242F3B64622E666E3D4F612E70726F74';
wwv_flow_api.g_varchar2_table(378) := '6F747970653B766172206C653D696228312C2261646422292C6D653D6962282D312C22737562747261637422293B612E64656661756C74466F726D61743D22595959592D4D4D2D44445448483A6D6D3A73735A222C612E64656661756C74466F726D6174';
wwv_flow_api.g_varchar2_table(379) := '5574633D22595959592D4D4D2D44445448483A6D6D3A73735B5A5D223B766172206E653D7528226D6F6D656E7428292E6C616E67282920697320646570726563617465642E20496E73746561642C20757365206D6F6D656E7428292E6C6F63616C654461';
wwv_flow_api.g_varchar2_table(380) := '7461282920746F2067657420746865206C616E677561676520636F6E66696775726174696F6E2E20557365206D6F6D656E7428292E6C6F63616C65282920746F206368616E6765206C616E6775616765732E222C66756E6374696F6E2861297B72657475';
wwv_flow_api.g_varchar2_table(381) := '726E20766F696420303D3D3D613F746869732E6C6F63616C654461746128293A746869732E6C6F63616C652861297D293B5228302C5B226767222C325D2C302C66756E6374696F6E28297B72657475726E20746869732E7765656B596561722829253130';
wwv_flow_api.g_varchar2_table(382) := '307D292C5228302C5B224747222C325D2C302C66756E6374696F6E28297B72657475726E20746869732E69736F5765656B596561722829253130307D292C5062282267676767222C227765656B5965617222292C506228226767676767222C227765656B';
wwv_flow_api.g_varchar2_table(383) := '5965617222292C5062282247474747222C2269736F5765656B5965617222292C506228224747474747222C2269736F5765656B5965617222292C4A28227765656B59656172222C22676722292C4A282269736F5765656B59656172222C22474722292C57';
wwv_flow_api.g_varchar2_table(384) := '282247222C4664292C57282267222C4664292C5728224747222C79642C7564292C5728226767222C79642C7564292C57282247474747222C43642C7764292C57282267676767222C43642C7764292C5728224747474747222C44642C7864292C57282267';
wwv_flow_api.g_varchar2_table(385) := '67676767222C44642C7864292C5F285B2267676767222C226767676767222C2247474747222C224747474747225D2C66756E6374696F6E28612C622C632C64297B625B642E73756273747228302C32295D3D722861297D292C5F285B226767222C224747';
wwv_flow_api.g_varchar2_table(386) := '225D2C66756E6374696F6E28622C632C642C65297B635B655D3D612E706172736554776F4469676974596561722862297D292C52282251222C302C22516F222C227175617274657222292C4A282271756172746572222C225122292C57282251222C7464';
wwv_flow_api.g_varchar2_table(387) := '292C24282251222C66756E6374696F6E28612C62297B625B4E645D3D332A28722861292D31297D292C52282277222C5B227777222C325D2C22776F222C227765656B22292C52282257222C5B225757222C325D2C22576F222C2269736F5765656B22292C';
wwv_flow_api.g_varchar2_table(388) := '4A28227765656B222C227722292C4A282269736F5765656B222C225722292C57282277222C7964292C5728227777222C79642C7564292C57282257222C7964292C5728225757222C79642C7564292C5F285B2277222C227777222C2257222C225757225D';
wwv_flow_api.g_varchar2_table(389) := '2C66756E6374696F6E28612C622C632C64297B625B642E73756273747228302C31295D3D722861297D293B766172206F653D7B646F773A302C646F793A367D3B52282244222C5B224444222C325D2C22446F222C226461746522292C4A28226461746522';
wwv_flow_api.g_varchar2_table(390) := '2C224422292C57282244222C7964292C5728224444222C79642C7564292C572822446F222C66756E6374696F6E28612C62297B72657475726E20613F622E5F6F7264696E616C50617273653A622E5F6F7264696E616C50617273654C656E69656E747D29';
wwv_flow_api.g_varchar2_table(391) := '2C24285B2244222C224444225D2C4F64292C242822446F222C66756E6374696F6E28612C62297B625B4F645D3D7228612E6D61746368287964295B305D2C3130297D293B7661722070653D4D282244617465222C2130293B52282264222C302C22646F22';
wwv_flow_api.g_varchar2_table(392) := '2C2264617922292C5228226464222C302C302C66756E6374696F6E2861297B72657475726E20746869732E6C6F63616C654461746128292E7765656B646179734D696E28746869732C61297D292C522822646464222C302C302C66756E6374696F6E2861';
wwv_flow_api.g_varchar2_table(393) := '297B72657475726E20746869732E6C6F63616C654461746128292E7765656B6461797353686F727428746869732C61297D292C52282264646464222C302C302C66756E6374696F6E2861297B72657475726E20746869732E6C6F63616C65446174612829';
wwv_flow_api.g_varchar2_table(394) := '2E7765656B6461797328746869732C61297D292C52282265222C302C302C227765656B64617922292C52282245222C302C302C2269736F5765656B64617922292C4A2822646179222C226422292C4A28227765656B646179222C226522292C4A28226973';
wwv_flow_api.g_varchar2_table(395) := '6F5765656B646179222C224522292C57282264222C7964292C57282265222C7964292C57282245222C7964292C5728226464222C66756E6374696F6E28612C62297B72657475726E20622E7765656B646179734D696E52656765782861297D292C572822';
wwv_flow_api.g_varchar2_table(396) := '646464222C66756E6374696F6E28612C62297B72657475726E20622E7765656B6461797353686F727452656765782861297D292C57282264646464222C66756E6374696F6E28612C62297B72657475726E20622E7765656B646179735265676578286129';
wwv_flow_api.g_varchar2_table(397) := '7D292C5F285B226464222C22646464222C2264646464225D2C66756E6374696F6E28612C622C632C64297B76617220653D632E5F6C6F63616C652E7765656B64617973506172736528612C642C632E5F737472696374293B6E756C6C213D653F622E643D';
wwv_flow_api.g_varchar2_table(398) := '653A6A2863292E696E76616C69645765656B6461793D617D292C5F285B2264222C2265222C2245225D2C66756E6374696F6E28612C622C632C64297B625B645D3D722861297D293B7661722071653D2253756E6461795F4D6F6E6461795F547565736461';
wwv_flow_api.g_varchar2_table(399) := '795F5765646E65736461795F54687572736461795F4672696461795F5361747572646179222E73706C697428225F22292C72653D2253756E5F4D6F6E5F5475655F5765645F5468755F4672695F536174222E73706C697428225F22292C73653D2253755F';
wwv_flow_api.g_varchar2_table(400) := '4D6F5F54755F57655F54685F46725F5361222E73706C697428225F22292C74653D4A642C75653D4A642C76653D4A643B522822444444222C5B2244444444222C335D2C224444446F222C226461794F665965617222292C4A28226461794F665965617222';
wwv_flow_api.g_varchar2_table(401) := '2C2244444422292C572822444444222C4264292C57282244444444222C7664292C24285B22444444222C2244444444225D2C66756E6374696F6E28612C622C63297B632E5F6461794F66596561723D722861297D292C52282248222C5B224848222C325D';
wwv_flow_api.g_varchar2_table(402) := '2C302C22686F757222292C52282268222C5B226868222C325D2C302C6F63292C5228226B222C5B226B6B222C325D2C302C7063292C522822686D6D222C302C302C66756E6374696F6E28297B72657475726E22222B6F632E6170706C792874686973292B';
wwv_flow_api.g_varchar2_table(403) := '5128746869732E6D696E7574657328292C32297D292C522822686D6D7373222C302C302C66756E6374696F6E28297B72657475726E22222B6F632E6170706C792874686973292B5128746869732E6D696E7574657328292C32292B5128746869732E7365';
wwv_flow_api.g_varchar2_table(404) := '636F6E647328292C32297D292C522822486D6D222C302C302C66756E6374696F6E28297B72657475726E22222B746869732E686F75727328292B5128746869732E6D696E7574657328292C32297D292C522822486D6D7373222C302C302C66756E637469';
wwv_flow_api.g_varchar2_table(405) := '6F6E28297B72657475726E22222B746869732E686F75727328292B5128746869732E6D696E7574657328292C32292B5128746869732E7365636F6E647328292C32297D292C7163282261222C2130292C7163282241222C2131292C4A2822686F7572222C';
wwv_flow_api.g_varchar2_table(406) := '226822292C57282261222C7263292C57282241222C7263292C57282248222C7964292C57282268222C7964292C5728224848222C79642C7564292C5728226868222C79642C7564292C572822686D6D222C7A64292C572822686D6D7373222C4164292C57';
wwv_flow_api.g_varchar2_table(407) := '2822486D6D222C7A64292C572822486D6D7373222C4164292C24285B2248222C224848225D2C5064292C24285B2261222C2241225D2C66756E6374696F6E28612C622C63297B632E5F6973506D3D632E5F6C6F63616C652E6973504D2861292C632E5F6D';
wwv_flow_api.g_varchar2_table(408) := '6572696469656D3D617D292C24285B2268222C226868225D2C66756E6374696F6E28612C622C63297B625B50645D3D722861292C6A2863292E626967486F75723D21307D292C242822686D6D222C66756E6374696F6E28612C622C63297B76617220643D';
wwv_flow_api.g_varchar2_table(409) := '612E6C656E6774682D323B625B50645D3D7228612E73756273747228302C6429292C625B51645D3D7228612E737562737472286429292C6A2863292E626967486F75723D21307D292C242822686D6D7373222C66756E6374696F6E28612C622C63297B76';
wwv_flow_api.g_varchar2_table(410) := '617220643D612E6C656E6774682D342C653D612E6C656E6774682D323B625B50645D3D7228612E73756273747228302C6429292C625B51645D3D7228612E73756273747228642C3229292C625B52645D3D7228612E737562737472286529292C6A286329';
wwv_flow_api.g_varchar2_table(411) := '2E626967486F75723D21307D292C242822486D6D222C66756E6374696F6E28612C622C63297B76617220643D612E6C656E6774682D323B625B50645D3D7228612E73756273747228302C6429292C625B51645D3D7228612E737562737472286429297D29';
wwv_flow_api.g_varchar2_table(412) := '2C242822486D6D7373222C66756E6374696F6E28612C622C63297B76617220643D612E6C656E6774682D342C653D612E6C656E6774682D323B625B50645D3D7228612E73756273747228302C6429292C625B51645D3D7228612E73756273747228642C32';
wwv_flow_api.g_varchar2_table(413) := '29292C625B52645D3D7228612E737562737472286529297D293B7661722077653D2F5B61705D5C2E3F6D3F5C2E3F2F692C78653D4D2822486F757273222C2130293B5228226D222C5B226D6D222C325D2C302C226D696E75746522292C4A28226D696E75';
wwv_flow_api.g_varchar2_table(414) := '7465222C226D22292C5728226D222C7964292C5728226D6D222C79642C7564292C24285B226D222C226D6D225D2C5164293B7661722079653D4D28224D696E75746573222C2131293B52282273222C5B227373222C325D2C302C227365636F6E6422292C';
wwv_flow_api.g_varchar2_table(415) := '4A28227365636F6E64222C227322292C57282273222C7964292C5728227373222C79642C7564292C24285B2273222C227373225D2C5264293B766172207A653D4D28225365636F6E6473222C2131293B52282253222C302C302C66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(416) := '7B72657475726E7E7E28746869732E6D696C6C697365636F6E6428292F313030297D292C5228302C5B225353222C325D2C302C66756E6374696F6E28297B72657475726E7E7E28746869732E6D696C6C697365636F6E6428292F3130297D292C5228302C';
wwv_flow_api.g_varchar2_table(417) := '5B22535353222C335D2C302C226D696C6C697365636F6E6422292C5228302C5B2253535353222C345D2C302C66756E6374696F6E28297B72657475726E2031302A746869732E6D696C6C697365636F6E6428297D292C5228302C5B225353535353222C35';
wwv_flow_api.g_varchar2_table(418) := '5D2C302C66756E6374696F6E28297B72657475726E203130302A746869732E6D696C6C697365636F6E6428297D292C5228302C5B22535353535353222C365D2C302C66756E6374696F6E28297B72657475726E203165332A746869732E6D696C6C697365';
wwv_flow_api.g_varchar2_table(419) := '636F6E6428297D292C5228302C5B2253535353535353222C375D2C302C66756E6374696F6E28297B72657475726E203165342A746869732E6D696C6C697365636F6E6428297D292C5228302C5B225353535353535353222C385D2C302C66756E6374696F';
wwv_flow_api.g_varchar2_table(420) := '6E28297B72657475726E203165352A746869732E6D696C6C697365636F6E6428297D292C5228302C5B22535353535353535353222C395D2C302C66756E6374696F6E28297B72657475726E203165362A746869732E6D696C6C697365636F6E6428297D29';
wwv_flow_api.g_varchar2_table(421) := '2C4A28226D696C6C697365636F6E64222C226D7322292C57282253222C42642C7464292C5728225353222C42642C7564292C572822535353222C42642C7664293B7661722041653B666F722841653D2253535353223B41652E6C656E6774683C3D393B41';
wwv_flow_api.g_varchar2_table(422) := '652B3D22532229572841652C4564293B666F722841653D2253223B41652E6C656E6774683C3D393B41652B3D22532229242841652C7563293B7661722042653D4D28224D696C6C697365636F6E6473222C2131293B5228227A222C302C302C227A6F6E65';
wwv_flow_api.g_varchar2_table(423) := '4162627222292C5228227A7A222C302C302C227A6F6E654E616D6522293B7661722043653D6F2E70726F746F747970653B43652E6164643D6C652C43652E63616C656E6461723D6B622C43652E636C6F6E653D6C622C43652E646966663D73622C43652E';
wwv_flow_api.g_varchar2_table(424) := '656E644F663D45622C43652E666F726D61743D77622C43652E66726F6D3D78622C43652E66726F6D4E6F773D79622C43652E746F3D7A622C43652E746F4E6F773D41622C43652E6765743D502C43652E696E76616C696441743D4E622C43652E69734166';
wwv_flow_api.g_varchar2_table(425) := '7465723D6D622C43652E69734265666F72653D6E622C43652E69734265747765656E3D6F622C43652E697353616D653D70622C43652E697353616D654F7241667465723D71622C43652E697353616D654F724265666F72653D72622C43652E697356616C';
wwv_flow_api.g_varchar2_table(426) := '69643D4C622C43652E6C616E673D6E652C43652E6C6F63616C653D42622C43652E6C6F63616C65446174613D43622C43652E6D61783D67652C43652E6D696E3D66652C43652E70617273696E67466C6167733D4D622C43652E7365743D502C43652E7374';
wwv_flow_api.g_varchar2_table(427) := '6172744F663D44622C43652E73756274726163743D6D652C43652E746F41727261793D49622C43652E746F4F626A6563743D4A622C43652E746F446174653D48622C43652E746F49534F537472696E673D76622C43652E746F4A534F4E3D4B622C43652E';
wwv_flow_api.g_varchar2_table(428) := '746F537472696E673D75622C43652E756E69783D47622C43652E76616C75654F663D46622C43652E6372656174696F6E446174613D4F622C43652E796561723D65652C43652E69734C656170596561723D74612C43652E7765656B596561723D51622C43';
wwv_flow_api.g_varchar2_table(429) := '652E69736F5765656B596561723D52622C43652E717561727465723D43652E71756172746572733D57622C43652E6D6F6E74683D68612C43652E64617973496E4D6F6E74683D69612C43652E7765656B3D43652E7765656B733D24622C43652E69736F57';
wwv_flow_api.g_varchar2_table(430) := '65656B3D43652E69736F5765656B733D5F622C43652E7765656B73496E596561723D54622C43652E69736F5765656B73496E596561723D53622C43652E646174653D70652C43652E6461793D43652E646179733D67632C43652E7765656B6461793D6863';
wwv_flow_api.g_varchar2_table(431) := '2C43652E69736F5765656B6461793D69632C43652E6461794F66596561723D6E632C43652E686F75723D43652E686F7572733D78652C43652E6D696E7574653D43652E6D696E757465733D79652C43652E7365636F6E643D43652E7365636F6E64733D7A';
wwv_flow_api.g_varchar2_table(432) := '652C43652E6D696C6C697365636F6E643D43652E6D696C6C697365636F6E64733D42652C43652E7574634F66667365743D55612C43652E7574633D57612C43652E6C6F63616C3D58612C43652E70617273655A6F6E653D59612C43652E686173416C6967';
wwv_flow_api.g_varchar2_table(433) := '6E6564486F75724F66667365743D5A612C43652E69734453543D24612C43652E6973445354536869667465643D5F612C43652E69734C6F63616C3D61622C43652E69735574634F66667365743D62622C43652E69735574633D63622C43652E6973555443';
wwv_flow_api.g_varchar2_table(434) := '3D63622C43652E7A6F6E65416262723D76632C43652E7A6F6E654E616D653D77632C43652E64617465733D7528226461746573206163636573736F7220697320646570726563617465642E20557365206461746520696E73746561642E222C7065292C43';
wwv_flow_api.g_varchar2_table(435) := '652E6D6F6E7468733D7528226D6F6E746873206163636573736F7220697320646570726563617465642E20557365206D6F6E746820696E7374656164222C6861292C43652E79656172733D7528227965617273206163636573736F722069732064657072';
wwv_flow_api.g_varchar2_table(436) := '6563617465642E20557365207965617220696E7374656164222C6565292C43652E7A6F6E653D7528226D6F6D656E7428292E7A6F6E6520697320646570726563617465642C20757365206D6F6D656E7428292E7574634F666673657420696E7374656164';
wwv_flow_api.g_varchar2_table(437) := '2E2068747470733A2F2F6769746875622E636F6D2F6D6F6D656E742F6D6F6D656E742F6973737565732F31373739222C5661293B7661722044653D43652C45653D7B73616D654461793A225B546F6461792061745D204C54222C6E6578744461793A225B';
wwv_flow_api.g_varchar2_table(438) := '546F6D6F72726F772061745D204C54222C6E6578745765656B3A2264646464205B61745D204C54222C6C6173744461793A225B5965737465726461792061745D204C54222C6C6173745765656B3A225B4C6173745D2064646464205B61745D204C54222C';
wwv_flow_api.g_varchar2_table(439) := '73616D65456C73653A224C227D2C46653D7B4C54533A22683A6D6D3A73732041222C4C543A22683A6D6D2041222C4C3A224D4D2F44442F59595959222C4C4C3A224D4D4D4D20442C2059595959222C4C4C4C3A224D4D4D4D20442C205959595920683A6D';
wwv_flow_api.g_varchar2_table(440) := '6D2041222C4C4C4C4C3A22646464642C204D4D4D4D20442C205959595920683A6D6D2041227D2C47653D22496E76616C69642064617465222C48653D222564222C49653D2F5C647B312C327D2F2C4A653D7B6675747572653A22696E202573222C706173';
wwv_flow_api.g_varchar2_table(441) := '743A2225732061676F222C733A226120666577207365636F6E6473222C6D3A2261206D696E757465222C6D6D3A222564206D696E75746573222C683A22616E20686F7572222C68683A22256420686F757273222C643A226120646179222C64643A222564';
wwv_flow_api.g_varchar2_table(442) := '2064617973222C4D3A2261206D6F6E7468222C4D4D3A222564206D6F6E746873222C793A22612079656172222C79793A222564207965617273227D2C4B653D412E70726F746F747970653B4B652E5F63616C656E6461723D45652C4B652E63616C656E64';
wwv_flow_api.g_varchar2_table(443) := '61723D7A632C4B652E5F6C6F6E6744617465466F726D61743D46652C4B652E6C6F6E6744617465466F726D61743D41632C4B652E5F696E76616C6964446174653D47652C4B652E696E76616C6964446174653D42632C4B652E5F6F7264696E616C3D4865';
wwv_flow_api.g_varchar2_table(444) := '2C4B652E6F7264696E616C3D43632C4B652E5F6F7264696E616C50617273653D49652C4B652E70726570617273653D44632C4B652E706F7374666F726D61743D44632C4B652E5F72656C617469766554696D653D4A652C4B652E72656C61746976655469';
wwv_flow_api.g_varchar2_table(445) := '6D653D45632C4B652E706173744675747572653D46632C4B652E7365743D792C4B652E6D6F6E7468733D63612C4B652E5F6D6F6E7468733D57642C4B652E6D6F6E74687353686F72743D64612C4B652E5F6D6F6E74687353686F72743D58642C4B652E6D';
wwv_flow_api.g_varchar2_table(446) := '6F6E74687350617273653D66612C4B652E5F6D6F6E74687352656765783D5A642C4B652E6D6F6E74687352656765783D6B612C4B652E5F6D6F6E74687353686F727452656765783D59642C4B652E6D6F6E74687353686F727452656765783D6A612C4B65';
wwv_flow_api.g_varchar2_table(447) := '2E7765656B3D58622C4B652E5F7765656B3D6F652C4B652E66697273744461794F66596561723D5A622C4B652E66697273744461794F665765656B3D59622C4B652E7765656B646179733D62632C4B652E5F7765656B646179733D71652C4B652E776565';
wwv_flow_api.g_varchar2_table(448) := '6B646179734D696E3D64632C4B652E5F7765656B646179734D696E3D73652C4B652E7765656B6461797353686F72743D63632C4B652E5F7765656B6461797353686F72743D72652C4B652E7765656B6461797350617273653D66632C4B652E5F7765656B';
wwv_flow_api.g_varchar2_table(449) := '6461797352656765783D74652C4B652E7765656B6461797352656765783D6A632C4B652E5F7765656B6461797353686F727452656765783D75652C4B652E7765656B6461797353686F727452656765783D6B632C4B652E5F7765656B646179734D696E52';
wwv_flow_api.g_varchar2_table(450) := '656765783D76652C4B652E7765656B646179734D696E52656765783D6C632C4B652E6973504D3D73632C4B652E5F6D6572696469656D50617273653D77652C4B652E6D6572696469656D3D74632C452822656E222C7B6F7264696E616C50617273653A2F';
wwv_flow_api.g_varchar2_table(451) := '5C647B312C327D2874687C73747C6E647C7264292F2C6F7264696E616C3A66756E6374696F6E2861297B76617220623D612531302C633D313D3D3D722861253130302F3130293F227468223A313D3D3D623F227374223A323D3D3D623F226E64223A333D';
wwv_flow_api.g_varchar2_table(452) := '3D3D623F227264223A227468223B72657475726E20612B637D7D292C612E6C616E673D7528226D6F6D656E742E6C616E6720697320646570726563617465642E20557365206D6F6D656E742E6C6F63616C6520696E73746561642E222C45292C612E6C61';
wwv_flow_api.g_varchar2_table(453) := '6E67446174613D7528226D6F6D656E742E6C616E674461746120697320646570726563617465642E20557365206D6F6D656E742E6C6F63616C654461746120696E73746561642E222C48293B766172204C653D4D6174682E6162732C4D653D596328226D';
wwv_flow_api.g_varchar2_table(454) := '7322292C4E653D596328227322292C4F653D596328226D22292C50653D596328226822292C51653D596328226422292C52653D596328227722292C53653D596328224D22292C54653D596328227922292C55653D246328226D696C6C697365636F6E6473';
wwv_flow_api.g_varchar2_table(455) := '22292C56653D246328227365636F6E647322292C57653D246328226D696E7574657322292C58653D24632822686F75727322292C59653D246328226461797322292C5A653D246328226D6F6E74687322292C24653D24632822796561727322292C5F653D';
wwv_flow_api.g_varchar2_table(456) := '4D6174682E726F756E642C61663D7B733A34352C6D3A34352C683A32322C643A32362C4D3A31317D2C62663D4D6174682E6162732C63663D4F612E70726F746F747970653B63662E6162733D4F632C63662E6164643D51632C63662E7375627472616374';
wwv_flow_api.g_varchar2_table(457) := '3D52632C63662E61733D57632C63662E61734D696C6C697365636F6E64733D4D652C63662E61735365636F6E64733D4E652C63662E61734D696E757465733D4F652C63662E6173486F7572733D50652C63662E6173446179733D51652C63662E61735765';
wwv_flow_api.g_varchar2_table(458) := '656B733D52652C63662E61734D6F6E7468733D53652C63662E617359656172733D54652C63662E76616C75654F663D58632C63662E5F627562626C653D54632C63662E6765743D5A632C63662E6D696C6C697365636F6E64733D55652C63662E7365636F';
wwv_flow_api.g_varchar2_table(459) := '6E64733D56652C63662E6D696E757465733D57652C63662E686F7572733D58652C63662E646179733D59652C63662E7765656B733D5F632C63662E6D6F6E7468733D5A652C63662E79656172733D24652C63662E68756D616E697A653D64642C63662E74';
wwv_flow_api.g_varchar2_table(460) := '6F49534F537472696E673D65642C63662E746F537472696E673D65642C63662E746F4A534F4E3D65642C63662E6C6F63616C653D42622C63662E6C6F63616C65446174613D43622C63662E746F49736F537472696E673D752822746F49736F537472696E';
wwv_flow_api.g_varchar2_table(461) := '67282920697320646570726563617465642E20506C656173652075736520746F49534F537472696E67282920696E737465616420286E6F7469636520746865206361706974616C7329222C6564292C63662E6C616E673D6E652C52282258222C302C302C';
wwv_flow_api.g_varchar2_table(462) := '22756E697822292C52282278222C302C302C2276616C75654F6622292C57282278222C4664292C57282258222C4964292C24282258222C66756E6374696F6E28612C622C63297B632E5F643D6E65772044617465283165332A7061727365466C6F617428';
wwv_flow_api.g_varchar2_table(463) := '612C313029297D292C24282278222C66756E6374696F6E28612C622C63297B632E5F643D6E657720446174652872286129297D292C612E76657273696F6E3D22322E31332E30222C62284B61292C612E666E3D44652C612E6D696E3D4D612C612E6D6178';
wwv_flow_api.g_varchar2_table(464) := '3D4E612C612E6E6F773D68652C612E7574633D682C612E756E69783D78632C612E6D6F6E7468733D4A632C612E6973446174653D642C612E6C6F63616C653D452C612E696E76616C69643D6C2C612E6475726174696F6E3D64622C612E69734D6F6D656E';
wwv_flow_api.g_varchar2_table(465) := '743D702C612E7765656B646179733D4C632C612E70617273655A6F6E653D79632C612E6C6F63616C65446174613D482C612E69734475726174696F6E3D50612C612E6D6F6E74687353686F72743D4B632C612E7765656B646179734D696E3D4E632C612E';
wwv_flow_api.g_varchar2_table(466) := '646566696E654C6F63616C653D462C612E7570646174654C6F63616C653D472C612E6C6F63616C65733D492C612E7765656B6461797353686F72743D4D632C612E6E6F726D616C697A65556E6974733D4B2C612E72656C617469766554696D6554687265';
wwv_flow_api.g_varchar2_table(467) := '73686F6C643D63642C612E70726F746F747970653D44653B7661722064663D613B72657475726E2064667D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2057576547435852694)
,p_plugin_id=>wwv_flow_api.id(2057511222487066919)
,p_file_name=>'moment.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
