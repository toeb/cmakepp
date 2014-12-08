

## windows specific implementation for process_info
function(process_info_Windows handlish)
  process_handle("${handlish}")
  ans(handle)
  map_tryget(${handle} pid)
  ans(pid)
  win32_tasklist(/V /FO CSV /FI "PID eq ${pid}")
  ans(csv)
  csv_deserialize("${csv}" --headers)
  ans(res)
  return_ref(res)
endfunction()


