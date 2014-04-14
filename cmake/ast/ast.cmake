# parses an abstract syntax tree from str
function(ast str)
  # set parsers  needed by ast_parse
  set(
    ast_parsers 
    ast_parse_match
    ast_parse_regex
    ast_parse_any
    ast_parse_sequence
  )
  # get language... todo...
  global_get(ast_language)
  if(NOT ast_language)
    file(READ "${package_dir}/resources/expr.json" string_data)
    json_deserialize(ast_language "${string_data}")
    global_set(ast_language ${ast_language})
  endif()
  # set default root definition to expr
  set(base_definition ${ARGN})
  if(NOT base_definition)
    set(base_definition expr)
  endif()
  # transform str to a stream
  stream_new("${str}")
  ans(stream)
  # parse ast and return result
  ast_parse(${stream} "${base_definition}")
  return_ans()
endfunction()