

 function(ast_parse_list definition stream create_node)
 
   # message("parsing list")
    token_stream_push(${stream})

    map_get(${definition} begin begin)
    map_get(${definition} end end)
    map_get(${definition} separator separator)
    map_get(${definition} element element)
   # message(" ${begin} <${element}> <${separator}> ${end}")
    ast_parse(${stream} ${begin})
    ans(begin_ast)
    if(NOT begin_ast)
      token_stream_pop(${stream})
      return(false)
    endif()

    set(child_list)
    while(true)
      ast_parse(${stream} ${element})
      ans(element_ast)

      if(NOT element_ast)
        break()
      endif()
     # message("appending child ${element_ast}")
      list(APPEND child_list ${element_ast})

      ast_parse(${stream} ${end})
      ans(end_ast)
      if(end_ast)
        break()
      endif()

      ast_parse(${stream} ${separator})
      ans(separator_ast)

      if(NOT separator_ast)
        token_stream_pop(${stream})
      #  message("failed")
        return(false)
      endif()
    endwhile()
   # message("done")
    token_stream_commit(${stream})

    if(NOT create_node)
      return(true)
    endif()


    map_create(node)
    map_set(${node} children "${child_list}")
    return(${node})
  endfunction()