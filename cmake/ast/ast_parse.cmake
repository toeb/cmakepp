# ast_parse expects ast_language and ast_parsers to be set in PARENT_SCOPE
#
  function(ast_parse stream definition_id )
   # message(PUSH)

   # message("${definition_id}")
#    stream_print(${stream})
    if(ARGN)
        set(ast_parsers ${ARGN})
        list_pop_front(ast_language ast_parsers)

    else()
        if(NOT ast_parsers)
            message(FATAL_ERROR "missing ast_parsers")
        endif()
        if(NOT ast_language)
            message(FATAL_ERROR "missing ast_language")
        endif()
    endif()

    # remove any leading whitespace from stream
    stream_trim(${stream})
    # return if stream is empty
    stream_isempty(${stream})
    ans(is_empty)
    if(is_empty)
    #  message(POP)
      return(false)
    endif()
    # get definition to be parsed
    map_get(${ast_language} definition ${definition_id})
    # get value indicating if definition expects a node to be created
    map_tryget(${definition} create_node "node")
    # loop through parsers until one successfully parses stream
    foreach(parser ${ast_parsers})
        eval("${parser}(\"${definition}\" \"${stream}\" \"${create_node}\")")
        ans(node)
        # node  contains either a boolean or a ast-node
        # node is false if parser could not parse
        if(node)      
          break()
        endif()
    endforeach()
    # append definition to current node if a node was returned
    map_isvalid(${node} is_map)
    if(is_map)
      map_append(${node} types ${definition_id})
    endif()
    # return node or success value
    if(node)
    endif()
 #   message("${definition_id} : ${node}")
  #  message(POP)
    return(${node})
  endfunction()