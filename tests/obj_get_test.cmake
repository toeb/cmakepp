function(obj_get_test)
# returns the objects value at ${key}
function(obj_get obj key)
  map_get_special("${obj}" "getter")
  ans(getter)
  if(NOT getter)
    set(getter obj_default_getter)
  endif()
  eval("${getter}(\"\${obj}\" \"\${key}\")")
  return_ans()
endfunction()



  function(obj_has obj key)
    map_get_special("${obj}" has)
    ans(has)
    if(NOT has)
      set(has obj_default_has_member)
    endif()
    eval("${has}(\"\${obj}\" \"\${key}\")")
    return_ans()
  endfunction()

  # sets the objects value at ${key}
  function(obj_set obj key)
    map_get_special("${obj}" "setter")
    ans(setter)
    if(NOT setter)
      set(setter obj_default_setter)
    endif()
    eval("${setter}(\"\${obj}\" \"\${key}\" \"${ARGN}\")")
    return_ans()
  endfunction()

  # calls the object itself
  function(obj_call obj)
    map_get_special("${obj}" "call")
    ans(call)
    if(NOT call)
      message(FATAL_ERROR "cannot call '${obj}' - it has no call function defined")
    endif()
    set(this "${obj}")
    function_call("${call}" (${ARGN}))
    return_ans()
  endfunction()



  # returns all keys for the specified object
  function(obj_keys obj)
    map_get_special("${obj}" get_keys)
    ans(get_keys)
    if(NOT get_keys)
      set(get_keys obj_default_get_keys)
    endif()
    eval("${get_keys}(\"\${obj}\")")
    return_ans()
  endfunction()

  # 
  function(obj_callmember obj key)
    map_get_special("${obj}" "call_member")
    ans(call_member)
    if(NOT call_member)
      set(call_member obj_default_callmember)
    endif()
    function_call("${call_member}" ("${obj}" "${key}" ${ARGN}))
    return_ans()
  endfunction()

  function(obj_setprototype obj prototype)
    map_set_special("${obj}" prototype "${prototype}")
    return()
  endfunction()
  function(obj_getprototype obj)
    map_get_special("${obj}" prototype)
    ans(res)
    return_ref(res)
  endfunction()


# get simple
ref_new()
ans(obj)
obj_set(${obj} k1 v1)
obj_get(${obj} k1)
ans(res)
assert("${res}" STREQUAL "v1")


# get non existing
ref_new()
ans(obj)
obj_get(${obj} k1)
ans(res)
assert(NOT res)

# get inherited
map_new()
ans(obj)
map_new()
ans(parent)
obj_set(${parent} k1 v1)
map_set_special("${obj}" prototype "${parent}")
obj_get(${obj} k1)
ans(res)
assert("${res}" STREQUAL "v1") 




return()
  ref_new()
  ans(obj)


  map()
    key(testval)
    val("hello")
  end()
  ans(proto)
  ref_print(${proto})
  map_set_special(${obj} prototype "${proto}")

  obj_get(${obj} testval)
  ans(res)
  message("res '${res}'")

  obj_set(${obj} testval2 hell)

  obj_keys(${obj})
  ans(keys)


  function(myfunction)
    message("hello there from ${testval} : ${ARGN}")
    return(great)
  endfunction()
  function(mythiscall)
    message("hello from this call ${testval} :${ARGN}")
    return_ans()
  endfunction()

  map_set_special("${obj}" call mythiscall)
  obj_set(${obj} myfu myfunction)

  obj_callmember("${obj}" myfu "v1" "vf2")
  ans(res)
  message("res res ${res}")

  function_call("${obj}"(a b c d))
  ans(res)
  message("res res res ${res}")

message("keys ${keys}")

ref_print(${obj})

endfunction()