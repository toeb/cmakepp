
# convenience function for accessing cmake
# use cd() to navigate to working directory
# usage is same as cmake command line client
# syntax differs: cmake arg1 arg2 ... -> cmake(arg1 arg2 ...)
# add a --result flag to get a object containing return code
# input args etc.
# else only console output is returned
function(cmake)
  wrap_executable(cmake "${CMAKE_COMMAND}")
  cmake(${ARGN})
  return_ans()
endfunction() 
