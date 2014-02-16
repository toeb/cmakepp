function(obj_settype ref typename)
  obj_nullcheck(${ref})
  obj_setownproperty(${ref} "__type__" ${typename})
endfunction()