

  ## queryies the registry for the specified key
  ## returns a list of entries containing all direct child elements
  function(reg_query key)
    string(REPLACE / \\ key "${key}")
    reg(query "${key}" --result)
    ans(res)

    map_tryget(${res} output)
    ans(output)


    map_tryget(${res} result)
    ans(error)

    if(error)
      return()
    endif()
    
    string_semicolon_encode("${output}")
    ans(output)
    string(REPLACE "\n" ";" lines ${output})

    set(entries)
    foreach(line ${lines})
      reg_entry_parse(${key} ${line})
      ans(res)
      if(res)
        list(APPEND entries ${res})
      endif()
    endforeach()

    return_ref(entries)
  endfunction()