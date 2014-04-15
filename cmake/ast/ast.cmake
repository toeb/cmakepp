# parses an abstract syntax tree from str
function(ast str language)
  map_get(${language} parsers parsers)
  ref_get(${parsers} parsers)

  # set default root definition to expr
  set(root_definition ${ARGN})
  if(NOT root_definition)
    map_get(${language} root_definition root_definition)
  endif()

  map_get(${language} definitions definitions)
  
  # transform str to a stream
  stream_new("${str}")
  ans(stream)
  # parse ast and return result
  ast_parse(${stream} "${root_definition}" ${definitions} ${parsers})
  return_ans()
endfunction()