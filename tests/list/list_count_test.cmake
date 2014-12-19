function(test)

## counts all element for which the element hold 
function(list_count lst predicate)
  function_import("${predicate}" as predicate_function REDEFINE)
  set(ct 0)
  foreach(item ${${lst}})
    predicate_function("${item}")
    ans(match)
    if(match)
      math(EXPR ct "${ct} + 1") 
    endif()
  endforeach()
  return("${ct}")
endfunction()


  index_range(0 10)
  ans(res)

  ## counts all uneven elements
  list_count(res "
    function(func i)
      return_math(\"\${i} % 2\")
    endfunction()")

  ans(res)
  assert(${res} EQUAL 5)



endfunction()