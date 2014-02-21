function(obj_typecheck this typename)
  obj_istype(${this} res ${typename})
  if(NOT res)
    obj_gettype(${this} actual)
  	message(FATAL_ERROR "type exception expected '${typename} but got '${actual}'")

  endif()
endfunction()