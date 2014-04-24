
function(map_has this key )  
  get_property(res GLOBAL PROPERTY "${this}.${key}" SET)
  return(${res})
endfunction()
macro(map_has this key )  
  get_property(__ans GLOBAL PROPERTY "${this}.${key}" SET)
endmacro()