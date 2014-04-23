
function(function_parse function_ish)

  global_get(__function_cache)
  set(cache)
  if(NOT __function_cache)
      map_new()
      ans(cache)
      global_set(__function_cache ${cache})

  endif()

  if(NOT function_ish)
    return()
  endif()


  string(MD5 hash "${function_ish}")

  is_function(function_type "${function_ish}")
  if(NOT function_type)
    return()
  endif()
  get_function_string(function_string "${function_ish}")
  if(NOT function_string)
    return()
  endif()

  parse_function(func "${function_string}")

  string(MD5 signature_hash "${func_name};${func_type};${func_args}")
  string(MD5 code_hash "${function_string}")
  string(MD5 source_hash "${function_ish};${function_type}")


  nav("cache.${code_hash}")
  ans(cached)
  if(cached)
    return(${cached})
  endif()

  map_new()
  ans(descriptor)
  nav("cache.${code_hash}" ${descriptor})
    
  nav("descriptor.code" "${function_string}")
  nav("descriptor.source_hash" "${source_hash}")
  nav("descriptor.source_type" "${function_type}")
  nav("descriptor.code_hash" "${code_hash}")
  nav("descriptor.signature_hash" "${signature_hash}")
  nav("descriptor.name" "${func_name}")
  nav("descriptor.args" "${func_args}")
  nav("descriptor.type" "${func_type}")
  nav("descriptor.source" "${function_ish}")

  return(${descriptor})
endfunction()

