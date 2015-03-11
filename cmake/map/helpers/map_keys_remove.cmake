
function(map_keys_remove map)
  get_property(keys GLOBAL PROPERTY "${map}" )
  if(keys AND ARGN)
    list(REMOVE_ITEM keys ${ARGN})
    set_property(GLOBAL PROPERTY "${map}" ${keys})
  endif()
endfunction()