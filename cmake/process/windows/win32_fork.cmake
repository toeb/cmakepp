#wraps the windows 32 for script which starts a new executable in a separate process and returns the PID
function(win32_fork)
  cmakepp_config(base_dir)
  ans(base_dir)
  wrap_executable(win32_fork "${base_dir}/resources/exec_windows.bat")
  win32_fork(${ARGN})
  return_ans()
endfunction()