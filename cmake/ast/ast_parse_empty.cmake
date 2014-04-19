
  function(ast_parse_empty )#definition stream create_node
    map_tryget(${definition} is_empty empty)
    if(NOT is_empty)
      return(false)
    endif()
   # message("parsed empty!")
    if(NOT create_node)
      return(true)
    endif()

    map_create(node)
    return(${node})
  endfunction()