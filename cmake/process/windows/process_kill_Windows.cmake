
# windows implementation for process kill
function(process_kill_Windows process_handle)
  process_handle("${process_handle}")
  map_tryget(${process_handle} pid)
  ans(pid)

  win32_taskkill(/PID ${pid} --result)
  ans(res)
  scope_import_map(${res})
  if(error_code)
    return(false)
  endif()
  return(true)
endfunction()
