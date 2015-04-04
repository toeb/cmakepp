


  function(interpret_bracket list_token)
    list(LENGTH list_token count)
    if(NOT "${count}" EQUAL 1)
      return()
    endif()
    map_tryget("${list_token}" type)
    ans(type)
    if(NOT "${type}" STREQUAL "bracket")
      return()
    endif()

    map_tryget("${list_token}" tokens)
    ans(tokens)
    
    interpret_separation("${tokens}" "comma")
    ans(ast)

    map_set(${ast} type bracket)
    return(${ast})

  endfunction()
