

macro(arguments_extract_defined_value_map __start_arg_index __end_arg_index __name)
  arguments_encoded_list("${__start_arg_index}" "${__end_arg_index}")
  ans(__arg_res)
  parameter_definition_get("${__name}")
  ans(defs)
  list_extract_defined_values(__arg_res "${defs}")
  #ans_extract(values)
  #ans(rest)  
endmacro()