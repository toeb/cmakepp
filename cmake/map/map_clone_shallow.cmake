
function(map_clone_shallow original)
  map_isvalid("${original}" ismap)
  if(ismap)
    map_create(result)
    map_keys("${original}" keys)
    foreach(key ${keys})
      map_get("${original}" value ${key})
      map_set("${result}" ${key} ${value})
    endforeach()
    return(${result})
  endif()

  ref_isvalid("${original}" isref)
  if(isref)
    ref_get(${original} res)
    ref_gettype(${original} type)
    ref_new(result ${type})
    ref_set(${result} ${res})
    return(${result})
  endif()

  # everythign else is a value type and can be returned
  return_ref(original)

endfunction()