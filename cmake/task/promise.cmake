## `(<task>|<promise>|<any>)-><promise>` 
##
## transforms the input into a promise
## if the input is a promise it is directly retunred
## if input is  a task it is transformed into a promise
## if input is anything else it is wrapped inside a resolved promise
function(promise)
  set(promise "${ARGN}")
  is_promise("${promise}")
  ans(is_promise)
  if(NOT is_promise)
    
    is_task("${promise}")
    ans(is_task)
    if(is_task)
      promise_from_task("${promise}")
      ans(promise)
    else()
      is_anonymous_function(${ARGN})
      ans(is_anonymous_function)
      if( is_anonymous_function)              
        arguments_anonymous_function(0 ${ARGC})
        ans(function)
        promise_from_callable("${function}")
        ans(promise)
      else()
        promise_from_value("${promise}")
        ans(promise)
      endif()

      
    endif()
  endif()
  task_queue_global()
  ans(task_queue)
  map_set_default("${promise}" task_queue "${task_queue}")  

  return_ref(promise)
endfunction()


