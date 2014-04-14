function(ast_parse_any definition stream create_node)
  # check if definition contains "any" property
  map_tryget(${definition} any any)
  if(NOT any)
    return(false)
  endif()
  ref_get(${any} any)
  
  # try to parse any of the definitions contained in "any" property
  foreach(def ${any})
    ast_parse(${stream} "${def}")
    ans(node)
    if(node)
      # first definition to parse stream wins
      return(${node})
    endif()
  endforeach()
  # if none could be parsed return false
  return(false)
endfunction()
