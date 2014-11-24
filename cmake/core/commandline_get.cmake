# returns the list of command line arguments
function(commandline_get)
  set(args)
  foreach(i RANGE ${CMAKE_ARGC})  
    list(APPEND args "${CMAKE_ARGV${i}}")
  endforeach()  
  return_ref(args)
endfunction() 
