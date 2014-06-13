
# default implementation for calling a member
# imports all vars int context scope
# and binds this to the calling object
function(obj_default_callmember this key)
  #message("obj_default_callmember ${this}.${key}(${ARGN})")
  obj_get("${this}" "${key}")
  ans(member_function)
  if(NOT member_function)
    message(FATAL_ERROR "member does not exists '${this}.${key}'")
  endif()
  # this elevates all values of obj into the execution scope
  #obj_import("${this}")  
  call("${member_function}"(${ARGN}))
  return_ans()
endfunction()


function(obj_injectable_callmember this key)
  map_get_special("${this}" before_call)
  ans(before_call)
  map_get_special("${this}" after_call)
  ans(after_call)

  set(call_this ${this})
  set(call_args ${ARGN})
  set(call_key ${key})
  set(call_result)
  
  if(before_call)
    call("${before_call}"())
  endif()
  obj_default_callmember("${this}" "${key}" "${ARGN}")
  ans(call_result)
  if(after_call)
    call("${after_call}"())
  endif()
  return_ref(call_result)
endfunction()


function(obj_before_callmember obj func)
  map_set_special("${obj}" call_member obj_injectable_callmember)
  map_set_special("${obj}" before_call "${func}")
endfunction()

function(obj_after_callmember obj func)
  map_set_special("${obj}" call_member obj_injectable_callmember)
  map_set_special("${obj}" after_call "${func}")
endfunction()