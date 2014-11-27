# creates a file or updates the file access time
# *by appending an empty string
function(touch path)
  path("${path}")
  ans(path)

  set(args ${ARGN})
  list_extract_flag(--nocreate)
  ans(nocreate)

  set(cmd touch)
  if(nocreate)
    set(cmd touch_nocreate)
  endif()

  cmake(-E ${cmd} "${path}")

  return()
endfunction()

