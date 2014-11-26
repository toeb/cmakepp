

# sets a system wide environment variable 
# the variable will not be available until a new console is started
function(shell_env_set key value)
  shell_get()
  ans(shell)
  if("${shell}" STREQUAL "cmd")
    shell("SETX ${key} ${value}")
  elseif("${shell}" STREQUAL "bash")
    home_path(.bashrc)
    ans(path)
    fappend("${path}" "\nexport ${key}=${value}")
  else()
    message(WARNING "shell_set_env not implemented")
  endif()
endfunction()