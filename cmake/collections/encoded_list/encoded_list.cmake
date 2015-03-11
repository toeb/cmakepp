  

## faster
function(encoded_list str)
  string_codes()
  eval("
    function(encoded_list str)
      if(\"\${str}_\" STREQUAL \"_\")
        return(${empty_code})
      endif()
    string(REPLACE \"[\" \"${bracket_open_code}\" str \"\${str}\")
    string(REPLACE \"]\" \"${bracket_close_code}\" str \"\${str}\")
    string(REPLACE \";\" \"${semicolon_code}\" str \"\${str}\")
    set(__ans \"\${str}\" PARENT_SCOPE)
  endfunction()
  ")
  encoded_list("${str}")
  return_ans()
endfunction()



## faster
function(encoded_list_decode str)
  string_codes()
  eval("
  function(encoded_list_decode str)
    if(\"\${str}_\" STREQUAL \"${empty_code}_\")
      return()
    endif()
    string(REPLACE \"${bracket_open_code}\" \"[\"  str \"\${str}\")
    string(REPLACE \"${bracket_close_code}\" \"]\"  str \"\${str}\")
    string(REPLACE \"${semicolon_code}\" \";\"  str \"\${str}\")
    set(__ans \"\${str}\" PARENT_SCOPE)
  endfunction()
  ")
  encoded_list_decode("${str}")
  return_ans()
endfunction()


  macro(encoded_list_get __lst idx)
    list(GET ${__lst} ${idx} __ans)
    string_decode_list("${__ans}")
  endmacro()

  function(encoded_list_set __lst idx)
    string_encode_list("${ARGN}")
    list_replace_at(${__lst} ${idx} ${__ans})
    set(${__lst} ${${__lst}} PARENT_SCOPE)
  endfunction()

  function(encoded_list_append __lst)
    string_encode_list("${ARGN}")
    list(APPEND "${__lst}" ${__ans})
    set(${__lst} ${${__lst}} PARENT_SCOPE)
  endfunction()



  function(encoded_list_remove_item __lst)
    string_encode_list("${ARGN}")
    if(NOT ${__lst})
      return()
    endif()
    list(REMOVE_ITEM ${__lst} ${__ans})
    set(${__lst} ${${__lst}} PARENT_SCOPE)
    return()
  endfunction()
  
  macro(encoded_list_remove_at __lst)
    list_remove_at(${__lst} ${ARGN})
  endmacro()

  function(encoded_list_pop_front __lst)
    list_pop_front(${__lst})
    ans(front)
    set(${__lst} ${${__lst}} PARENT_SCOPE)
    string_decode_list("${front}")
    return_ans()
  endfunction()

  function(encoded_list_peek_front __lst)
    list_peek_front(${__lst})
    ans(front)
    string_decode_list("${front}")
    return_ans()
  endfunction()

  function(encoded_list_pop_back __lst)
    list_pop_back(${__lst})
    ans(back)
    set(${__lst} ${${__lst}} PARENT_SCOPE)
    string_decode_list("${back}")
    return_ans()
  endfunction()

  function(encoded_list_peek_back __lst)
    list_peek_back(${__lst})
    ans(back)
    string_decode_list("${back}")
    return_ans()
  endfunction()
