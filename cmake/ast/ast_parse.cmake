function(ast_parse stream definition_id )

#  message(PUSH)
  if(ARGN)
      set(args ${ARGN})
      list_pop_front(ast_language args)

      map_get(${ast_language} parsers parsers)
      map_keys(${parsers} keys)
      

      set("ifs" "if(false)\n")
      foreach(key ${keys})
        map_get(${parsers} command_name ${key})
          set(ifs "${ifs}elseif(\"${key}\" STREQUAL \"\${parser_command}\" )\n#message(\${command_name})\n${command_name}(\"\${definition}\" \"\${stream}\" \"\${create_node}\")\nreturn_ans()\n")
      endforeach()
    set(ifs "${ifs}endif()\n")
      #message("ifs ${ifs}")

      set("evl" "
function(__ast_call_parser parser_command definition stream create_node)
  #message(\"mumu \${parser_command}\")
  ${ifs}
  return()
endfunction()
      ")
      #message(${evl})
      eval("${evl}")

  else()
      if(NOT ast_language)
          message(FATAL_ERROR "missing ast_language")
      endif()
  endif()

  map_get(${ast_language} parsers parsers)
  map_get(${ast_language} definitions definitions)
  map_get(${definitions} definition ${definition_id})
  map_tryget(${definition} create_node node)
  map_get(${definition} parser parser)  
  #map_get(${parsers} parser_command "${parser}")

 # message("using ${parser_command} to parse ${definition_id}")
  #eval("${parser_command}(\"${definition}\" \"${stream}\" \"${create_node}\")")
  __ast_call_parser("${parser}" "${definition}" "${stream}" "${create_node}")
  ans(node)
  
  # append definition to current node if a node was returned
  ref_isvalid("${node}" is_map)
  if(is_map)
    map_append(${node} types ${definition_id})
  endif()

  #message(FORMAT "parsed {node.types}")
  #message(POP)
  return(${node})
endfunction()