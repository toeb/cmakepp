## `(~<promise>)-> <promise>`
##
## initializes the specified promise by adding it to its task queue
function(promise_start promise)
  promise("${promise}")
  ans(promise)
  continuation_resolve("" "${promise}")
  return(${promise})
endfunction()
