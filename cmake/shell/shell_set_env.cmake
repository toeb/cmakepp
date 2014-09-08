# sets a system wide environment variable 
# the variable will not be available until a new console is started
function(shell_env_set key value)
  if(WIN32)
    shell("SETX ${key} ${value}")
  else()
    message(WARNING "shell_set_env not implemented for anything else than windows")
  endif()
endfunction()

# creates a shell script file containing the specified code and the correct extesion to execute
# with execute_process
function(shell_script_create path code)
  if(WIN32)
    if(NOT "${path}" MATCHES "\\.bat$")
      set(path "${path}.bat")
    endif()
    set(code "@echo off\n${code}")
  else()
    if(NOT "${path}" MATCHES "\\.sh$")
      set(path "${path}.sh")
    endif()
    set(code "#!/bin/bash\n${path}")
    touch("${path}")
    execute_process(COMMAND chmod +x "${path}")
  endif()
    fwrite("${path}" "${code}")
    return_ref(path)
endfunction()

# returns a filename which does not exist yet
# you need to pass a filter which contains the stirng {id}
# id will be varied untikl a file is found which does not exist
# the complete path will be returned
function(file_temp_name template)
  oocmake_config(temp_dir)
  ans(temp_dir)
  file_random( "${temp_dir}/${template}")
  ans(rnd)
  return_ref(rnd)
endfunction()

# creates a temporary script file which contains the specified code
# and has the correct exension to be run with execute_process
# the path to the file will be returned
function(shell_tmp_script code)
  shell_get_script_extension()
  ans(ext)
  file_temp_name("{id}.${ext}")
  ans(tmp)
  shell_script_create("${tmp}" "${code}")
  ans(res)
  return_ref(res)
endfunction()

# returns the extension for a shell script file on the current console
# e.g. on windows this returns bat on unix/bash this returns bash
# uses shell_get() to determine which shell is used
function(shell_get_script_extension)
  shell_get()
  ans(shell)
  if("${shell}" STREQUAL "cmd")
    return(bat)
  elseif("${shell}" STREQUAL "bash")
    return(sh)
  else()
    message(FATAL_ERROR "no shell could be recognized")
  endif()

endfunction()


# removes a system wide environment variable
function(shell_env_unset key)
  # set to nothing
  shell_env_set("${key}" "")
  if(WIN32)
    shell("REG delete HKCU\Environment /V ${key}")
  else()
    message(WARNING "shell_env_unset not implemented for anything else than windows")
  endif()
endfunction()

# returns which shell is used (bash,cmd) returns nothing if unknown
function(shell_get)
  if(WIN32)
    return("cmd")
  endif()
  shell_env_get(SHELL)
  ans(res)
  if(NOT res)
    return()
  endif()
  return(bash)
endfunction()

# creates the bash string using the map env which contains key value pairs
function(bash_profile_compile env)
  set(res)
  map_keys(${env})
  ans(keys)
  foreach(key ${keys})
    map_tryget(${env} ${key})
    ans(val)
    set(res "${res}export ${key}=\"${val}\"\n")
  endforeach()
  return_ref(res)
endfunction()

# creates and writes the bash profile env to path (see bash_profile_compile)
function(bash_profile_write path env)
  bash_profile_compile(${env})
  ans(str)
  shell_script_create("${profile_path}" "${str}")
  return_ans()
endfunction()

# registers
function(bash_autostart_register)
  set(session_profile_path "~/.profile")
  if(NOT EXISTS "${session_profile_path}")
    touch("${session_profile_path}")
  endif()
  fread("${session_profile_path}")
  ans(profile)

  set(profile_path "~/oocmake.profile.sh")

  if(NOT EXISTS "${profile_path}")
    shell_script_create("${profile_path}" "")
  endif()

  if("${profile}" MATCHES "${profile_path}\n")
    return()
  endif()

  set(profile "${profile}\n${profile_path}\n")
  fwrite("${session_profile_path}" "${profile}")

  return()
endfunction()

# removes the cmake profile from ~/.profile
function(bash_autostart_unregister)
  set(session_profile_path "~/.profile")
  if(NOT EXISTS "${session_profile_path}")
    return()
  endif()
  fread("${session_profile_path}")
  ans(content)
  string_regex_escape("${session_profile_path}")
  ans(escaped)
  string(REGEX REPLACE "${escaped}" "" content "${content}")
  fwrite("${session_profile_path}" "${content}")
  return()
endfunction()

# returs true if the oocmake session profile (environment variables)are registered
function(bash_autostart_isregistered)
  set(session_profile_path "~/.profile")

  if(NOT EXISTS "${session_profile_path}")
    return(false)
  endif()

  fread("${session_profile_path}")
  ans(content)
  string_regex_escape("${session_profile_path}")
  ans(escaped)
  if("${content}" MATCHES "${escaped}")
    return(true)
  endif()
  return(false)
endfunction()
# redirects the output of the specified shell to the result value of this function
function(shell_redirect code)
  file_tmp("txt" "")
  ans(tmp_file)
  shell("${code} > ${tmp_file}")
  fread("${tmp_file}")
  ans(res)
  file(REMOVE "${tmp_file}")
  return_ref(res)
endfunction()

# returns the value of the shell's environment variable ${key}
function(shell_env_get key)
    shell_redirect("echo %${key}%")
endfunction()