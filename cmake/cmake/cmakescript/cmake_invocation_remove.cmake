

function(cmake_invocation_remove invocation)
  map_tryget(${invocation} invocation_token)
  ans(begin)
  map_tryget(${invocation} arguments_end_token)
  ans(end)
  cmake_token_range_remove("${begin};${end}")
  return()
endfunction()

