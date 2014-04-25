# removes the beginning of a string
function(string_remove_beginning original beginning)
  string(LENGTH "${beginning}" len)
  string(SUBSTRING "${original}" ${len} -1 original)
  return_ref(original)
endfunction()