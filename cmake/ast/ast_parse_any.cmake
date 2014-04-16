function(ast_parse_any )#definition stream create_node definition_id
  # check if definition contains "any" property
  map_tryget(${definition} any any)
  ref_get(${any} any)
  
  # try to parse any of the definitions contained in "any" property
  foreach(def ${any})    
    ast_parse(${stream} "${def}")
    ans(node)
    if(node)
      # first definition to parse stream wins
     # append definition to current node if a node was returned
      ref_isvalid("${node}" is_map)
      if(is_map)
        #map_tryget(${definition} definition_id name)
        map_append(${node} types ${definition_id})
      endif()
      return_ref(node)
    endif()
  endforeach()
  # if none could be parsed return false
  return(false)



endfunction()
