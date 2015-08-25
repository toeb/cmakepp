
function(promise_from_callable callable)
  task_new("${callable}")
  ans(task)
  promise_from_task("${task}")
  ans(promise)
  return_ref(promise)
endfunction()
