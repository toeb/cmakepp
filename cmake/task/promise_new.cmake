
function(promise_new)
  map_new()
  ans(promise)
  map_set_special("${promise}" $type promise)
  map_set("${promise}" promise_state "pending")
  return_ref(promise)
endfunction()
