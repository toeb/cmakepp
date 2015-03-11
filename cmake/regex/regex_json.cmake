macro(regex_json)
  
  if(NOT __regex_json_defined)
    set(__regex_json_defined)
    set(regex_json_string_literal "\"([^\"\\]|([\\][\"])|([\\][\\])|([\\]))*\"")

    set(regex_json_number_literal "[0-9]+")
    set(regex_json_bool_literal "(true)|(false)")
    set(regex_json_null_literal "null")
    set(regex_json_literal "(${regex_json_string_literal})|(${regex_json_number_literal})|${regex_json_bool_literal}|(${regex_json_null_literal})")
  endif()
endmacro()