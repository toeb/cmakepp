# creates a systemwide alias callend ${name} which executes the specified command_string
# 
function(alias_create name command_string)
  oocmake_config(bin_dir)
  ans(bin_dir)

  set(path "${bin_dir}/${name}.bat")

  if(WIN32)
    message("creating windows alias")
    file_write("${path}" "@echo off\r\n${command_string}")
  else()
    message("only implemented for windows")
  endif()



endfunction()
