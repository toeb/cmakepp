
# invokes a single task
function(task_run_next)
  ref_get(__initial_invoke_later_list)
  ans(tasks)
  foreach(task ${tasks})
    string_semicolon_decode("${task}")
    ans(task)
    task_enqueue("${task}")
  endforeach()

  function(task_run_next)
    map_tryget(global task_current)
    ans(task_running)
    if(task_running)
      return()
    endif()

    map_pop_front(global task_queue)
    ans(task)

    if(NOT task)
      return()
    endif()
    map_tryget(${task} arguments)
    ans(arguments)
    map_tryget(${task} callback)
    ans(callback)
    set(this ${task})

    map_set(${task} state "running")
    map_set(global task_current ${task})
    
    eval("${callback}(${arguments})")
    ans(result)
    map_set(${task} result "${result}")
    map_set(${task} state "complete")
    map_set(global task_current)

    return_ref(task)
  endfunction()
  task_run_next()
  return_ans()
endfunction()
