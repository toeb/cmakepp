function(ast_parse stream definition_id )

#  message(PUSH)
  if(ARGN)
      set(args ${ARGN})
      list_pop_front(ast_language args)

      map_get(${ast_language} ast_parsers parsers)
      map_get(${ast_language} ast_definitions definitions)
      function_import_map(${ast_parsers} __ast_call_parser)

  else()
      if(NOT ast_language)
          message(FATAL_ERROR "missing ast_language")
      endif()
  endif()

 # map_get(${ast_language} parsers parsers)
  map_get(${ast_definitions} definition ${definition_id})
  map_tryget(${definition} create_node node)
  map_get(${definition} parser parser)  
  #map_get(${ast_parsers} parser_command "${parser}")

 # message("using ${parser_command} to parse ${definition_id}")
  #eval("${parser_command}(\"${definition}\" \"${stream}\" \"${create_node}\")")
  __ast_call_parser("${parser}" "${definition}" "${stream}" "${create_node}")
  ans(node)
  
 

  #message(FORMAT "parsed {node.types}")
  #message(POP)
  return(${node})
endfunction()