
  # sets the objects value at ${key}
  function(obj_set obj key)
    map_get_special("${obj}" "setter")
    ans(setter)
    if(NOT setter)
      obj_default_setter("${obj}" "${key}" "${ARGN}")
      return_ans()
      #set(setter obj_default_setter)
    endif()
    eval("${setter}(\"\${obj}\" \"\${key}\" \"${ARGN}\")")
    return_ans()
  endfunction()