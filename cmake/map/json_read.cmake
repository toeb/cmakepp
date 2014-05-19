

  function(json_read file)
    if(NOT EXISTS "${file}")
      return()
    endif()
    file(READ "${file}" data)
    json_deserialize("${data}")
    ans(data)
    return_ref(data)
  endfunction()