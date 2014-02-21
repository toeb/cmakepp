function(obj_settype this typename)
  obj_nullcheck(${this})
  obj_setownproperty(${this} "__type__" ${typename})
endfunction()