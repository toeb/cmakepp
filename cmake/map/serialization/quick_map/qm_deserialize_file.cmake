

# deserializes the specified file
function(qm_deserialize_file quick_map_file)
  include(${quick_map_file})
  ans(res)
  map_tryget(${res} data)
  return_ans()
endfunction()