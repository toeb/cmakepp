
function(map_keys_set map)
  set_property(GLOBAL PROPERTY "${map}" ${ARGN})
endfunction()