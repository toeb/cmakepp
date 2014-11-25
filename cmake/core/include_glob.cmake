#includes all files identified by globbing expressions
# see file_glob on globbing expressions
function(include_glob)
  set(args ${ARGN})
  file_glob(${args})
  ans(files)
  foreach(file ${files})
    include_once("${file}")
  endforeach()

  return()
endfunction()