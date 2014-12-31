function(test)


## create a map path of which the leaf value is set to ${current}
function(navigation_expression_make_path current)
  set(args ${ARGN})
  list(REVERSE ARGN)
  foreach(expr ${ARGN})
    navigation_expression_unpack(expr)
    if(expr.is_property)
      map_new()
      ans(v)
      map_set(${v} ${expr.property} ${current})
      set(current ${v})
    endif()
  endforeach()
  return(${current})
endfunction()


  define_test_function(test_uut navigation_expression_make_path)
    
  test_uut("{a:1}" 1 "a")
  test_uut("asd" asd)
  test_uut("{asd:{bsd:{csd:34}}}" 3  asd bsd csd --print)

return()


  test_uut("{a:{b:'c'}}" a b c)


endfunction()