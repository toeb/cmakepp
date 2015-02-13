
macro(string_codes)

  string(ASCII 29 "${ARGN}bracket_open_code")
  string(ASCII 30 "${ARGN}bracket_close_code")
  string(ASCII 31 "${ARGN}semicolon_code")
  string(ASCII 24 "${ARGN}empty_code")
  string(ASCII 2  "${ARGN}paren_open_code")
  string(ASCII 3  "${ARGN}paren_close_code")
endmacro()