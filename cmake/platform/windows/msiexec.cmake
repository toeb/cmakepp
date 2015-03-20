function(test)
  if(NOT WIN32)
    return()
  endif()

  timer_start(t1)
  reg_query("HKLM/SOFTWARE/Microsoft/Windows/CurrentVersion/Uninstall")
  ans(res)
  timer_print_elapsed(t1)
  list_select_property(res key)
  ans(res)
  message("${res}")

endfunction()

# wraps the win32 console executable cmd.exe
function(msiexec)
  wrap_executable(msiexec msiexec.exe)
  msiexec(${ARGN})
  return_ans()
endfunction()

#
function(msiexec_lean)
  wrap_executable_bare(msiexec_lean msiexec.exe)
  msiexec_lean(${ARGN})
  return_ans()
endfunction()