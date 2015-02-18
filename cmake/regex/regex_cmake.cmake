macro(regex_cmake)
#http://www.cmake.org/cmake/help/v3.0/manual/cmake-language.7.html#grammar-token-regex_cmake_escape_sequence
  set(regex_cmake_newline "\n")
  set(regex_cmake_space_chars " \t")
  set(regex_cmake_space "[${regex_cmake_space_chars}]+")
  set(regex_cmake_line_comment "#([^${regex_cmake_newline}]*)")
  set(regex_cmake_line_comment.comment CMAKE_MATCH_1)

  set(regex_cmake_line_ending "(${regex_cmake_line_comment})?(${regex_cmake_newline})")

  set(regex_cmake_separation "(${regex_cmake_space})|(${regex_cmake_line_ending})")

  set(regex_cmake_identifier "[A-Za-z_][A-Za-z0-9_]*")

  set(regex_cmake_bracket_open "[(=+)[")
  set(regex_cmake_bracket_close "](=+)]")
  set(regex_cmake_bracket_content ".*")
  set(regex_cmake_bracket_argument "${regex_cmake_bracket_open}${regex_cmake_bracket_content}${regex_cmake_bracket_close}")
  

  set(regex_cmake_backslash "\\\\")

  #set(escape_identity "(\\\\()|\\\\)|\\\\#|\\\\\"|\\\\ |)
  #set(escape_encoded "\\\\t|\\\\r|\\\\n")
  set(regex_cmake_escape_semicolon "\\\;")
  set(regex_cmake_escape_sequence "(${escape_identity})|(${escape_encoded})|(${regex_cmake_escape_semicolon})")
  set(regex_cmake_quoted_continuation "\\\\\n")
  set(regex_cmake_quoted_element "([^\"${regex_cmake_backslash}])|(${regex_cmake_escape_sequence})|(${regex_cmake_quoted_continuation})")
  set(regex_cmake_quoted_argument "\"()\"")

  set(regex_cmake_argument "${regex_cmake_bracket_argument}|${regex_cmake_quoted_argument}|${unquoted_argument}")
  set(regex_cmake_separated_arguments "((${regex_cmake_separation})+(${regex_cmake_argument})?)|")
  set(regex_cmake_arguments "(${regex_cmake_argument})?(${regex_cmake_separated_arguments})*")

  set(regex_cmake_argument_string ".*")
  set(regex_cmake_command_invocation "(${regex_cmake_space})*(${regex_cmake_identifier})(${regex_cmake_space})*\\((${regex_cmake_argument_string})\\)")
  set(regex_cmake_command_invocation.regex_cmake_identifier CMAKE_MATCH_2)
  set(regex_cmake_command_invocation.arguments CMAKE_MATCH_4)

  set(regex_cmake_separated_arguments)
  set(regex_cmake_file_element "(${regex_cmake_command_invocation}${regex_cmake_line_ending})|((${bracket_comment}|${regex_cmake_space})*|(${regex_cmake_line_ending}))")
  set(regex_cmake_file "(${regex_cmake_file_element})*")


  set(regex_cmake_function_begin "(^|${cmake_regex_newline})(${regex_cmake_space})?function(${regex_cmake_space})?\\([^\\)\\(]*\\)")
  set(regex_cmake_function_end   "(^|${cmake_regex_newline})(${regex_cmake_space})?endfunction(${regex_cmake_space})?\\(([^\\)\\(]*)\\)")
  set(regex_cmake_function_signature "(^|${cmake_regex_newline})((${regex_cmake_space})?)(${regex_cmake_identifier})((${regex_cmake_space})?)\\([${regex_cmake_space_chars}${regex_cmake_newline}]*(${regex_cmake_identifier})(.*)\\)")
  set(regex_cmake_function_signature.name CMAKE_MATCH_7)
  set(regex_cmake_function_signature.args CMAKE_MATCH_8)
  
endmacro()