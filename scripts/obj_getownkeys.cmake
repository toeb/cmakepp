function(obj_getkeys ref result)
  file(GLOB keys "${ref}/*")
  return_value(${keys})
endfunction()