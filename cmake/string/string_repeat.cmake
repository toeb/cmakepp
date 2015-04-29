## `(<what:<string>> <n:<int>>)-><res:<string>>`
##
## Repeats string "what" "n" times and separates them with an optional separator
##
## **Examples**
##  set(input "a")
##  string_repeat("${input}" 2) # => "aa"
##  string_repeat("${input}" 2 "@") # => "a@a"
##
##  
function(string_repeat what n)
  set(separator "${ARGN}")
  
  if(${n} LESS 1)
    return()
  endif()
  
  foreach(i RANGE 1 ${n})
    if(${i} GREATER 1)
      set(res "${res}${separator}${what}")
    else()
      set(res "${what}")
    endif()
  endforeach()
  
  return_ref(res)
endfunction()