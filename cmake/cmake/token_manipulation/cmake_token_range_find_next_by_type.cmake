## `(<start:<token>> <token type>)-><token>`  
##
## returns the next token that has the specified token type
## or null
function(cmake_token_range_find_next_by_type start type)
  set(current ${start})
  while(current)
    map_tryget(${current} type)
    ans(current_type)
    if("${current_type}" MATCHES "${type}")
      return_ref(current)
    endif()
    map_tryget(${current} next)
    ans(current)
  endwhile()
endfunction()

