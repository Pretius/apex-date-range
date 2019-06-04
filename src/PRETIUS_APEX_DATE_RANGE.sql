create or replace package PRETIUS_APEX_DATE_RANGE as

  procedure render_daterange (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result 
  );
  
end;
