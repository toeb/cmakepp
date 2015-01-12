
  function(uri_params_deserialize query)
      
    string(REPLACE "&" "\;" query_assignments "${query}")
    string(ASCII 21 c)
    map_new()
    ans(query_data)
    foreach(query_assignment ${query_assignments})
      string(REPLACE "=" "\;"  value "${query_assignment}")
      list_pop_front(value)
      ans(key)
      set(path "${key}")      
      #if("${path}" MATCHES "\\[[^0-9]+\\]")
      string(REPLACE "[]" "${c}" path "${path}")      
      string(REGEX REPLACE "\\[([^0-9]+)\\]" ".\\1" path "${path}")
      string(REPLACE "${c}" "[]" path "${path}")

      #endif()
#      string(REPLACE "[]" "${c}" path "${key}")
      #string(REPLACE "[" "." path "${path}")
      #string(REPLACE "]" "" path "${path}")
      #string(REPLACE "${c}" "[]" path "${path}")

   #   print_vars(key value path)

      uri_decode("${path}")
      ans(path)
      uri_decode(${value})
      ans(value)



      nav_write("${query_data}" "${path}" "${value}")
#      map_path_set(query_data ${path} "${value}")

    endforeach()
    return_ref(query_data)
  endfunction()