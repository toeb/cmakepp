
## windows specific implementation for process_info
function(process_info_Windows handlish)
  process_handle("${handlish}")
  ans(handle)
  map_tryget(${handle} pid)
  ans(pid)


  win32_tasklist(/V /FO CSV /FI "PID eq ${pid}" --result )
  ans(exe_result)

  map_tryget(${exe_result} return_code)
  ans(error)
  if(error)
    return()
  endif()


  map_tryget(${exe_result} output)
  ans(csv)

  csv_deserialize("${csv}" --headers)  
  ans(res)

  map_rename(${res} PID pid)
  return_ref(res)
endfunction()


