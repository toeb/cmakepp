
# returns the objects value at ${key}
function(obj_get obj key)
  map_get_special("${obj}" "getter")
  ans(getter)
  if(NOT getter)
    obj_default_getter("${obj}" "${key}")
    return_ans()
    #set(getter obj_default_getter)
  endif()
  set_ans("")
  eval("${getter}(\"\${obj}\" \"\${key}\")")
  return_ans()
endfunction()


