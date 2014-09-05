# turns the lazy cmake code into valid cmake
#
function(lazy_cmake cmake_code)
# normalize cmake 
  # 
  if(NOT "${cmake_code}" MATCHES "[ ]*[a-zA-Z0-9_]+\\(.*\\)[ ]*")
    string(REGEX REPLACE "[ ]*([a-zA-Z0-9_]+)[ ]*(.*)" "\\1(\\2)" cmd "${cmake_code}")
  endif()
  return_ref(cmd)

endfunction()