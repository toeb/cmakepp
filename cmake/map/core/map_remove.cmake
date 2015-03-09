
function(map_remove map key)
  map_has("${map}" "${key}")
  ans(has_key)
  ## set value to "" without updating key
  map_set_hidden("${map}" "${key}")
  if(NOT has_key)
    return(false)
  endif()
  get_property(keys GLOBAL PROPERTY "${map}")
  list(REMOVE_ITEM keys "${key}")
  set_property(GLOBAL PROPERTY "${map}" "${keys}")
  return(true)
endfunction()