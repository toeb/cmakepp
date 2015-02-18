# runs a shell script on the current platform
# not that
function(shell cmd)
  
  shell_get()
  ans(shell)
  if("${shell}" STREQUAL "cmd")
    file_tmp("bat" "@echo off\n${cmd}")
    ans(shell_script)
  elseif("${shell}" STREQUAL "bash")
    file_tmp("sh" "#!/bin/bash\n${cmd}")
    ans(shell_script)
    # make script executable
    execute_process(COMMAND "chmod" "+x" "${shell_script}")

  endif()

  # execute shell script which write the keyboard input to the ${value_file}
  set(args ${ARGN})

  list_extract_flag(args --process-handle)
  ans(return_process_handle)

  execute("${shell_script}" ${args} --process-handle)
  ans(res)

  # remove temp file
  file(REMOVE "${shell_script}")
  if(return_process_handle)
    return_ref(res)
  endif()

  map_tryget(${res} exit_code)
  ans(exit_code)

  if(NOT "_${exit_code}" STREQUAL "_0")
    return()
  endif()

  map_tryget(${res} stdout)
  ans(stdout)
  return_ref(stdout)
endfunction()