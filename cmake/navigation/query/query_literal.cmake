
function(query_literal)

    map_new()
    ans(handlers)
    map_set(__query_literal_handlers bool      query_literal_bool)
    map_set(__query_literal_handlers match     query_literal_match)
    map_set(__query_literal_handlers strequal  query_literal_strequal)

  function(query_literal query_literal_value )
    if("${query_literal_value}_" STREQUAL "_")
      return()
    endif()

    ref_isvalid("${query_literal_value}")
    ans(is_ref)

    if(is_ref)
      set(query_literal ${query_literal_value})
    else()
      # is predicate?
      if(false)
        
      else()
        if("${query_literal_value}" MATCHES "^(true)|(false)$")
          ## boolish
          map_new()
          ans(query_literal)
          map_set(${query_literal} bool ${query_literal_value})
        else()
          ## just a value -> strequal
          map_new()
          ans(query_literal)
          map_set(${query_literal} strequal ${query_literal_value})
        endif()
      endif()
    endif()
    map_keys(${query_literal})
    ans(type)
    map_tryget(${query_literal} "${type}")
    ans(expected)
    map_tryget(__query_literal_handlers "${type}")
    ans(handler)
   # print_vars(handler expected type query_literal)
    # too slow - 
    #curry3("()" => "${handler}"("${expected}" /*))
    # faster curry:
    if(NOT handler)
      return()
    endif()
    if("${ARGN}_" STREQUAL "_")
      function_new()
      ans(alias)
    else()
      set(alias ${ARGN})
    endif()

    eval("
    function(${alias})
      ${handler}(\"${expected}\" \${ARGN})
      set(__ans \${__ans} PARENT_SCOPE)
    endfunction()
    ")
    # end of faster curry

    return_ref(alias)
  endfunction()

  query_literal(${ARGN})
  return_ans()
endfunction()