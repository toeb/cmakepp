# creates a systemwide alias callend ${name} which executes the specified command_string
# 
function(alias_create name command_string)
  oocmake_config(bin_dir)
  ans(bin_dir)

  set(path "${bin_dir}/${name}.bat")

  shell_get()
  ans(shell)

  if("${shell}" STREQUAL "cmd")
    file_write("${path}" "@echo off\r\n${command_string} %*")
  elseif("${shell}" STREQUAL "bash")
    home_path(.bashrc)
    ans(bc)
    fappend("${bc}" "\nalias ${name}='${command_string}'")
  else()
    message(FATAL_ERROR "creating alias is not supported by oocmake on your system shell :${shell}")
  endif()





endfunction()

