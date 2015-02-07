  ## log function
  ##  --error    flag indicates that errors occured
  ##  --warning  flag indicates warnings
  ##  --info     flag indicates a info output
  ##  --debug    flag indicates a debug output
  ## 
  ##  --error-code <code> 
  ##  --level <n> 
  ##  --push <section> depth+1
  ##  --pop <section>  depth-1
  function(log)

    set(args ${ARGN})
    list_extract_flag(args --warning)
    list_extract_flag(args --info)
    list_extract_flag(args --debug)
    list_extract_flag(args --aftereffect)
    ans(aftereffect)
    list_extract_flag(args --error)
    ans(is_error)
    list_extract_labelled_value(args --level)
    list_extract_labelled_value(args --push)
    list_extract_labelled_value(args --pop)
    list_extract_labelled_value(args --error-code)
    ans(error_code)
    map_new()
    ans(entry)
    list_pop_front(args)
    ans(message)
    map_format("${message}")
    ans(message)
    if(aftereffect)
      log_last_error_entry()
      ans(last_error)
      map_set(${entry} preceeding_error ${last_error})
    endif()
    map_set(${entry} message ${message})
    map_set(${entry} args this ${args})
    map_set(${entry} function ${member_function})
    map_set(${entry} error_code ${error_code})
    set(type)
    if(is_error OR NOT error_code STREQUAL "")
      set(type error)
    endif()
    
    map_set(${entry} type ${type})
    ref_append(log_record ${entry})
  endfunction()
