# special chars |||||||↔|†|‡
macro(string_codes)

  string(ASCII 29 "${ARGN}bracket_open_code")
  string(ASCII 28 "${ARGN}bracket_close_code")
  string(ASCII 20 "${ARGN}ref_token")
  string(ASCII 31 "${ARGN}semicolon_code")
  string(ASCII 24 "${ARGN}empty_code")
  string(ASCII 2  "${ARGN}paren_open_code")
  string(ASCII 3  "${ARGN}paren_close_code")
  set("${ARGN}identifier_token" "__")
endmacro()

function(string_codes_print)
  string_codes()
  print_vars("bracket_open_code")
  print_vars("bracket_close_code")
  print_vars("ref_token")
  print_vars("semicolon_code")
  print_vars("empty_code")
  print_vars("paren_open_code")
  print_vars("paren_close_code")
endfunction()



#task_enqueue("[]()string_codes_print()")