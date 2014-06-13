# 
function(obj_callmember obj key)
  #message("obj_callmember ${obj}.${key}(${ARGN})")
  map_get_special("${obj}" "call_member")
  ans(call_member)
  if(NOT call_member)
    obj_default_callmember("${obj}" "${key}" ${ARGN})
    return_ans()
    #set(call_member obj_default_callmember)
  endif()
  call("${call_member}" ("${obj}" "${key}" ${ARGN}))
  return_ans()
endfunction()

