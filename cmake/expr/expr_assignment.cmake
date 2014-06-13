

  function(expr_assignment str scope)
    set(regex_single_quote_string "'[^']*'")
    set(regex_double_quote_string "\"[^\"]*\"")
    set(regex_string "((${regex_single_quote_string})|(${regex_double_quote_string}))")
    
    string(REGEX MATCHALL "(${regex_string}|[^=]+|=)" matches "${str}")

    set(lvalues)
    set(rvalues)

    foreach(match ${matches})     
      string(STRIP "${match}" match) 
      if("${match}" STREQUAL "=" )
        list(APPEND lvalues ${rvalues})
        set(rvalues)
      endif()
      list(APPEND rvalues "${match}")
    endforeach()
    
    list(REMOVE_ITEM lvalues =)
    list(REMOVE_ITEM rvalues =)

    expr("${rvalues}")

    ans(rvalue)

    message("lvalues ${lvalues}")
    message("rvalues ${rvalues} => ${rvalue}")


    foreach(lvalue ${lvalues})
      expr_assign_lvalue("${lvalue}" "${rvalue}" ${scope})
    endforeach()
    
  endfunction()