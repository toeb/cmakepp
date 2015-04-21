
function(promise_from_value)
  promise_new()
  ans(promise)
  map_set("${promise}" promise_state "resolved")
  map_set("${promise}" value "${ARGN}")
  return_ref(promise)
endfunction()