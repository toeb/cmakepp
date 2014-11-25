function(test)
  mkdir("${test_dir}")
  cd("${test_dir}")
  function(get_property_list)
    cmake(--help-property-list --result)
    ans(res)
    map_tryget(${res} output)
    ans(output)
    string(REPLACE "\n" ";" output "${output}")
    list_pop_front(output)

    json_print(${res})
    
    return(${output})
  endfunction()

  get_property_list()
  ans(res)
  foreach(prop ${res})
    message("prop '${prop}'")
  endforeach()

  message("stack: ${LISTFILE_STACK}")
endfunction()