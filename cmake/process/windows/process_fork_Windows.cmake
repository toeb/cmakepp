

## windows implementation for fork
function(process_fork_Windows process_start_info)
  process_start_info("${process_start_info}")
  ans(process_start_info)
  scope_import_map(${process_start_info})
  
  win32_fork(-exec "${command} ${arg_string}" -workdir "${cwd}" --result)
  ans(exec_result)
  scope_import_map(${exec_result})
  if(return_code)
    json_print(${exec_result})
    message(FATAL_ERROR "failed to fork process.  returned code was ${return_code} message:\n ${stdout}  ")
  endif()

  string(REGEX MATCH "[1-9][0-9]*" pid "${stdout}")
  set(status running)
  map_capture_new(pid process_start_info status)
  return_ans()  
endfunction()
