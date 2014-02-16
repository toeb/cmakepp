function(obj_typecheck ref typename)
  obj_istype(${ref} res ${typename})
  if(NOT res)
    obj_gettype(${ref} actual)
  	message(FATAL_ERROR "type exception expected '${typename} but got '${actual}'")

  endif()
endfunction()