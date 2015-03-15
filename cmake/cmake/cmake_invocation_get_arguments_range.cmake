## `(<invocation:<command invocation>>)->[<start:<token>> <end:<token>>]`
## 
## returns the token range of the invocations arguments
function(cmake_invocation_get_arguments_range invocation)
  token_find_next_type("${invocation}" nesting)
  ans(arguments_begin)
  map_tryget(${arguments_begin} end)
  ans(arguments_end)
  map_tryget(${arguments_begin} next)
  ans(arguments_begin)
  return(${arguments_begin} ${arguments_end})
endfunction()
