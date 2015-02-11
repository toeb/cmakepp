## pads the specified string to be as long as specified
## if the string is longer then nothing is padded
## if no delimiter is specified than " " (space) is used
## if --prepend is specified the padding is inserted into front of string
function(string_pad str len)  
  set(delimiter ${ARGN})
  list_extract_flag(delimiter --prepend)
  ans(prepend)
  if("${delimiter}_" STREQUAL "_")
    set(delimiter " ")
  endif()  
  string(LENGTH "${str}" actual)  
  if(${actual} LESS ${len})
    math(EXPR n "${len} - ${actual}")    
    string_repeat("${delimiter}" ${n})
    ans(padding)
    if(prepend)
      set(str "${padding}${str}")
    else()
      set(str "${str}${pad}")    
    endif()    
  endif()

  return_ref(str)
endfunction()