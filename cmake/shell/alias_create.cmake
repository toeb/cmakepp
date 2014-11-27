# creates a systemwide alias callend ${name} which executes the specified command_string
# 
function(alias_create name command_string)

  shell_get()
  ans(shell)

  if(WIN32)      
    oocmake_config(bin_dir)
    ans(bin_dir)

    set(path "${bin_dir}/${name}.bat")
    file_write("${path}" "@echo off\r\n${command_string} %*")
    reg_append_if_not_exists(HKCU/Environment Path "${bin_dir}")
    ans(res)
    if(res)
      message(INFO "alias ${name} was created - it will be available as soon as you restart your shell")
    else()
      message(INFO "alias ${name} as created - it is directly available for use")
    endif()
    return(true)
  endif()


  if("${shell}" STREQUAL "bash")
    home_path(.bashrc)
    ans(bc)
    fappend("${bc}" "\nalias ${name}='${command_string}'")
    message(INFO "alias ${name} was created - it will be available as soon as you restart your shell")

  else()
    message(FATAL_ERROR "creating alias is not supported by oocmake on your system your current shell (${shell})")
  endif()
endfunction()

