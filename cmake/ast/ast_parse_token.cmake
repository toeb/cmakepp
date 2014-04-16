
  function(ast_parse_token definition stream create_node)
   # message(FORMAT "trying to parse {definition.name}")
   # ref_print("${definition}")
   # ref_print(${definition})

    token_stream_take(${stream} ${definition})
    ans(token)

    if(NOT token)
      return(false)
    endif()
    
    #message(FORMAT "parsed {definition.name}: {token.data}")
    if(NOT create_node)
      return(true)
    endif()

    map_get(${token} data data)
    map_tryget(${definition} replace replace)
    if(replace)
      map_get(${definition} regex regex)
      string(REGEX REPLACE "${regex}" "\\${replace}" data "${data}")
    endif()

    map_set(${token} data "${data}")
    return(${token})

  endfunction()