# tries to get the value map[key] and returns NOTFOUND if
# it is not found
function(map_tryget map key)
  get_property(res GLOBAL PROPERTY "${map}.${key}")
  return_ref(res)
endfunction()
macro(map_tryget map key)
  get_property(__ans GLOBAL PROPERTY "${map}.${key}")
endmacro()
