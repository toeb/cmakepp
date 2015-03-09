
## fast wrapper for cmake
function(_cmake)
  wrap_executable_bare(_cmake "${CMAKE_COMMAND}")
  _cmake(${ARGN})
  return_ans()
endfunction()