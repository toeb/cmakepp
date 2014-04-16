
  function(ast_parse_token )#definition stream create_node definition_id
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

    map_tryget(${definition} replace replace)
    if(replace)
      map_get(${token} data data)
      map_get(${definition} regex regex)
      string(REGEX REPLACE "${regex}" "\\${replace}" data "${data}")
      #message("data after replace ${data}")
      map_set_hidden(${token} data "${data}")
    endif()
    #map_tryget(${definition} def name)
    map_set_hidden(${token} types ${definition_id})
    return(${token})

  endfunction()