function(shell_set_env key value)
  if(WIN32)
    shell("SETX ${key} ${value}")
  else()
    message(FATAL_ERROR "shell_set_env not implemented for anything else than windows")
  endif()


endfunction()

function(shell_redirect code)
  file_tmp("txt" "")
  ans(tmp_file)
  shell("code > ${tmp_file}")
  fread("${tmp_file}")
  
  file(REMOVE "${tmp_file}")
endfunction()

function(shell_get key)
  if(WIN32)
    shell("")
  else()
    message(FATAL_ERROR "shell_get not implemented on anything else than windows")
  endif()
endfunction()