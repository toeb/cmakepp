function(obj_gettype  ref result)
  obj_getownproperty(${ref} type "__type__")
  return_value(${type})
endfunction()