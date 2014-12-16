  # repeats ${what} and separates it by separator
  function(string_repeat what n)
    set(separator "${ARGN}")
    set(res)
    foreach(i RANGE 1 ${n})
      if(NOT ${i} EQUAL 1)
        set(res "${separator}${res}")
      endif()
      set(res "${res}${what}")
    endforeach()
    return_ref(res)
  endfunction()
