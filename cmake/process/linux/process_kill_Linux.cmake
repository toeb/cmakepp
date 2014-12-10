

  ## platform specific implementaiton for process_kill
  function(process_kill_Linux handle)
    process_handle("${handle}")
    ans(handle)

    map_tryget(${handle} pid)
    ans(pid)

    linux_kill(-SIGTERM ${pid} --result)
    ans(res)

    map_tryget(${res} return_code)
    ans(return_code)

    return_truth("${return_code}" EQUAL 0)
  endfunction() 