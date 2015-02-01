

# deserializes the specified file
function(qm_deserialize_file quick_map_file)
  if(NOT EXISTS "${quick_map_file}")
    return()
  endif()
  include(${quick_map_file})
  ans(res)
  map_tryget(${res} data)
  return_ans()
endfunction()