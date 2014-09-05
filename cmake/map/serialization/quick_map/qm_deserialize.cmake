
function(qm_deserialize quick_map_string)
  set_ans("")
  eval("${quick_map_string}")
  ans(res)
  map_tryget(${res} data)
  return_ans()
endfunction()


function(qm_deserialize_file quick_map_file)
  include(${quick_map_file})
  ans(res)
  map_tryget(${res} data)
  return_ans()
endfunction()