
function(map_keys_sort map)
  get_property(keys GLOBAL PROPERTY "${map}")
  if(keys)
    list(SORT keys)
    set_property(GLOBAL PROPERTY "${map}" ${keys})
  endif()
endfunction()
