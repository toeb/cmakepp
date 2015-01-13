function(test)

return()
  new()
  ans(obj)

  function(prop_set ref prop)



  endfunction()
  function(prop_tryget ref prop)

    map_get_special("${ref}" object)
    ans(isobject)
    if(isobject)
      foreach(part ${nav})
        obj_get("${current}" "${part}")
        ans(current)
        if("${current}_" STREQUAL "_")
          break()
        endif()
      endforeach()
    else()
      foreach(part ${nav})
        map_tryget("${current}" "${part}")
        ans(current)
        if("${current}_" STREQUAL "_")
          break()
        endif()
      endforeach()
    endif()
    
  endfunction()

  function(assign lvalue equals rvalue)    
    ## is a value
    if("${rvalue}" MATCHES "^'.*'$")
      string_decode_delimited("${rvalue}" ')
      ans(value)
    elseif("${rvalue}" MATCHES "(^{.*}$)|(^\\[.*\\]$)")
      script("${rvalue}")
      ans(value)
    else()
      navigation_expression_parse("${rvalue}")
      ans(rvalue)
      list_pop_front(rvalue)
      ans(ref)

      nav_tryget("${${ref}}" ${rvalue})
      ans(value)


      if("${ARGN}" MATCHES "^\\(.*\\)$")
        if(NOT value)
          set(value ${ref})
        endif()
        call(${value} ${ARGN})
        ans(value)
      endif()
    endif()

    navigation_expression_parse("${lvalue}")
    ans(lvalue)
    list_pop_front(lvalue)
    ans(lvalue_ref)
    nav_set("${${lvalue_ref}}" "${lvalue}" "${value}")
    ans(value)

    set(${lvalue_ref} ${value} PARENT_SCOPE)
    return()
  endfunction()



  function(testfunc)
    return(234)
  endfunction()

  set(a)
  assign(a = '123')
  message("a ${a}")
  assign(a = testfunc())
  message("a ${a}")
  assign(a = "{b:123,c:{d:'testfunc'}}")
  message("a ${a}")
  
  assign(a = a.c.d())
  message("a ${a}")


obj("{asd:323}")
ans(b)
assign(b.asd = '123')
json_print(${b})





endfunction()