  function(token_new definition data)
    map_tryget(${definition}  ignore_token)
    ans(ignore_token)
    if(ignore_token)
      return()
    endif()
    map_new()
    ans(token)
    map_set(${token} definition ${definition})
    map_set(${token} data "${data}")
    return_ref(token)
  endfunction()