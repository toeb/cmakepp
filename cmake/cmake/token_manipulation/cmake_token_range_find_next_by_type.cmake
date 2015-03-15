## `(<start:<token>> <token type> [<value:<regex>>])-><token>`  
##
## returns the next token that has the specified token type
## or null
function(cmake_token_range_find_next_by_type range type)
  list_extract(range current end)
  set(regex ${ARGN})
  while(current AND NOT "${current}" STREQUAL "${end}")
    map_tryget(${current} type)
    ans(current_type)
    if("${current_type}" MATCHES "${type}")
      if(regex)
        map_tryget(${current} literal_value)
        ans(current_value)
        print_vars(current_value current_type regex)
        if("${current_value}" MATCHES "${regex}")
          message("match")
          return_ref(current)
        endif()
        message(nomatch)
      else()
        return_ref(current)
      endif()
    endif()
    map_tryget(${current} next)
    ans(current)
  endwhile()
endfunction()

