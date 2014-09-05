# runs a shell script on the current platform
# not that
function(shell cmd)
  if(WIN32)
    file_tmp("bat" "@echo off\n${cmd}")
    ans(shell_script)
  else()
    file_tmp("sh" "#!/bin/bash\n${cmd}")
    ans(shell_script)
    # make script executable
    execute_process(COMMAND "chmod" "+x" "${shell_script}")
  endif()

  # execute shell script which write the keyboard input to the ${value_file}
  set(args ${ARGN})

  list_extract_flag(args --result)
  ans(result_flag)

  execute("{
    path:$shell_script,
    args:$args
    }")
  ans(res)

  # remove temp file
  file(REMOVE "${shell_script}")
  if(result_flag)
    return_ref(res)
  endif()

  map_tryget(${res} result)
  ans(return_code)

  if(NOT "_${return_code}" STREQUAL "_0")
    return()
  endif()

  map_tryget(${res} output)
  ans(output)
  return_ref(output)
endfunction()