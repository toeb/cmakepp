## `(<cmake code> [--extended])-><cmake ast>`
##
## this function parses cmake code and returns a ast 
## because of cmakes simple syntax this ast is actually just a token list 
## ```
## <token> ::= { 
##  type: "command_invocation"|"bracket_comment"|"line_comment"|"quoted_argument"|"unquoted_argument"|"nesting"|"nesting_end"|"file"
##  value: <string> the actual string as is in the source code 
##  [literal_value : <string>] # the value which actually is meant (e.g. "asd" -> asd  | # I am A comment -> ' I am A comment')
##  next: <token>
##  previous: <token>
## }
## <nesting token> ::= <token> v {
##   "begin"|"end": <nesting token>
## }
## <extended token> ::= (<token>|<nesting token>) v {
##  line:<uint> # the line in which the token is found
##  column: <uint> # the column in which the token starts
##  length: <uint> # the length of the token 
## }
## ```
function(cmake_parse_string code)
  set(args ${ARGN})
  list_extract_flag(args --extended)
  ans(extended)
#    print_var(code)
  string_codes()
  set(literal_token ${free_token})
  set(nesting_token ${free_token1})
  ## encode list to remove unwanted codes
  string_encode_list("${code}")
  ans(code)

  set(regex_ref "${ref_token}:[0-9]+")
  set(regex_nesting_start_char "\\(")
  set(regex_nesting_end_char "\\)")
  set(regex_cmake_newline "\n")
  set(regex_cmake_space_chars " \t")
  set(regex_cmake_space_range "[${regex_cmake_space_chars}]")
  set(regex_cmake_space "${regex_cmake_space_range}+")
  set(regex_bracket_comment "#${bracket_open_code}${bracket_open_code}(.*)${bracket_close_code}${bracket_close_code}")
  set(regex_line_comment "#([^\n]*)")
  set(regex_quoted_argument "\"([^\"\\]|([\\][\"])|([\\][\\])|([\\]))*\"")
  set(regex_literal "(${regex_bracket_comment})|(${regex_line_comment})|(${regex_quoted_argument})")
  set(regex_cmake_identifier "[A-Za-z_][A-Za-z0-9_]*")
  set(regex_escaped_paren_open "([^\\\\])\\\\\\(")
  set(regex_escaped_paren_close "([^\\\\])\\\\\\)")
  set(regex_nesting "${regex_nesting_start_char}([^${regex_nesting_end_char}${regex_nesting_start_char}]*)${regex_nesting_end_char}")
  set(regex_unquoted_argument_chars "[^#\\\\\" \t\n${literal_token}${ref_token}]|[${free_token3}${free_token4}]")
  set(regex_unquoted_argument "(${regex_unquoted_argument_chars})+")
  set(regex_tokens "(${regex_ref})|(${regex_cmake_space_range}+)|${regex_cmake_newline}|${literal_token}|(${regex_unquoted_argument})")

  ## extract all literals which contain alot of control chars
  string(REGEX MATCHALL "${regex_literal}" literal_values "${code}")
  string(REGEX REPLACE "${regex_literal}" "${literal_token}" code "${code}")
  set(literals)
  foreach(literal ${literal_values})
    if("${literal}" MATCHES "\"(.*)\"")
      set(type quoted_argument)
      set(value "${CMAKE_MATCH_0}")
      cmake_string_unescape("${CMAKE_MATCH_1}")
      ans(literal_value)
    elseif("${literal}" MATCHES "${regex_bracket_comment}")
      set(type bracket_comment)
      set(value "${CMAKE_MATCH_0}")
      set(literal_value "${CMAKE_MATCH_1}")
    elseif("${literal}" MATCHES "${regex_line_comment}")
      set(type line_comment)
      set(value "${CMAKE_MATCH_0}")
      set(literal_value "${CMAKE_MATCH_1}")
    else()
      message("unknown literal ${literal}")
      error("unknown literal ${literal}")
      return()
    endif()

    string_decode_list("${value}")
    ans(value)

    string(LENGTH "${value}" length)
    map_new()
    ans(literal)
    map_set(${literal} type "${type}")
    map_set(${literal} literal_value "${literal_value}")
    map_set(${literal} value "${value}")
    list(APPEND literals ${literal})

  endforeach()


  ## replace escaped parentheses
  string(REGEX REPLACE "${regex_escaped_paren_open}"  "\\1${free_token3}" code "${code}")
  string(REGEX REPLACE "${regex_escaped_paren_close}" "\\1${free_token4}" code "${code}")


  ## extract all nestings and replace them with the ref to the nesting object
  while(true)
    string(REGEX MATCHALL "${regex_nesting}" current_nestings "${code}" )
    if(NOT current_nestings)
      break()
    endif()
    string(REGEX REPLACE "${regex_nesting}" "${nesting_token}" code "${code}")

    foreach(nesting ${current_nestings})
      if("${nesting}" MATCHES "${regex_nesting}")
        string(REGEX MATCHALL "${regex_tokens}" children "${CMAKE_MATCH_1}")
        map_new()
        ans(token)
        map_set(${token} type "nesting")
        map_set(${token} value "(")
        map_set(${token} children ${children})

        ## replace first occurance pf ${free_token}
        string(FIND "${code}" "${nesting_token}" index)
        string(SUBSTRING "${code}" "0" "${index}" part1)
        math(EXPR index "${index} + 1")
        string(SUBSTRING "${code}" "${index}" "-1" part2)
        set(code "${part1}${token}${part2}")
      endif()
    endforeach()
  endwhile()

  ## match all leftover tokens and put the in the queue
  string(REGEX MATCHALL "${regex_tokens}" queue "${code}")


  set(line_counter 0)
  set(column_counter 0)
  set(tokens)
  set(nesting_depth 0)

  map_new()
  ans(root)
  map_set(${root} type "file")
  set(previous ${root})
  ## loop throught the token queue until it is empty
  ## insert nested tokens into beginning of queue when a nesting is found
  while(true)
    if(NOT queue)
      break()
    endif()

    list(GET queue 0 token)
    list(REMOVE_AT queue 0)

    if("${token}" MATCHES "^${regex_ref}$")
      #either nesting or nesting end

      map_tryget(${token} type)
      ans(type)
      if("${type}" STREQUAL "nesting")        
        map_new()
        ans(nesting_end)
        map_set(${nesting_end} type nesting_end)
        map_set(${nesting_end} begin "${token}")
        map_set(${nesting_end} value ")")
        map_set(${token} end "${nesting_end}")
        map_tryget(${token} children)
        ans(children)
        list(INSERT queue 0 ${children} ${nesting_end})
        math(EXPR "nesting_depth" "${nesting_depth} + 1")
      elseif("${type}" STREQUAL "nesting_end")
        math(EXPR "nesting_depth" "${nesting_depth} - 1")
      endif()
    elseif("${token}" STREQUAL "${literal_token}")
      list(GET literals 0 token)
      list(REMOVE_AT literals 0)
    elseif("${token}" STREQUAL "${regex_cmake_newline}")
      map_new()
      ans(token)
      map_set(${token} type new_line)
      map_set(${token} value "\n")     
    elseif("${token}" MATCHES "^${regex_cmake_space}$")
      set(value "${token}")
      map_new()
      ans(token)
      map_set(${token} type white_space)
      map_set(${token} value "${value}")
    elseif("${token}" MATCHES "^${regex_cmake_identifier}$" AND NOT nesting_depth AND "${queue}" MATCHES "^(${regex_cmake_space};)?${regex_ref}")
      set(value "${token}")
      map_new()
      ans(token)
      map_set(${token} type command_invocation)
      map_set(${token} value "${value}")
    elseif("${token}" MATCHES "^${regex_unquoted_argument}$")
      map_new()
      ans(token)
      string(REPLACE "${free_token3}" "\\(" value "${CMAKE_MATCH_0}")
      string(REPLACE "${free_token4}" "\\)" value "${value}")
      string_decode_list("${value}")
      ans(value)
      ## unescape cmake string

      cmake_string_unescape("${value}")
      ans(literal_value)
      map_set(${token} type unquoted_argument)
      map_set(${token} value "${value}")
      map_set(${token} literal_value "${literal_value}")
    endif()

    ## setup the linked list
    map_set(${previous} next ${token})
    map_set(${token} previous ${previous})
    set(previous ${token})

    
    if(extended) #these are computed values which make parsing slow
      map_tryget(${token} type)
      ans(type)
      map_property_string_length("${token}" value)
      ans(length)
      map_set("${token}" length "${length}")
      map_append("${root}" "${type}s" ${token})
      map_set(${token} line ${line_counter})
      map_set(${token} column ${column_counter})
      math(EXPR  column_counter "${column_counter} + ${length}")
      if("${type}" STREQUAL "new_line")
        set(column_counter 0)
        math(EXPR line_counter "${line_counter} + 1")
      endif()
    endif()
      

  endwhile()

  
  return_ref(root)
endfunction() 

