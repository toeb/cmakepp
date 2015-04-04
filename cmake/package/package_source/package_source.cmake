## `()-><package source>`
##
## returns the specified package source
## valid package soruces are returned
## valid package source types are created and returned
function(package_source source)
  is_map("${source}")
  ans(ismap)
  if(ismap)
    return_ref(source)
  endif()

  if(NOT COMMAND "${source}_package_source")
    return()
  endif()
  eval("${source}_package_source(${ARGN})")
  return_ans()
endfunction()
