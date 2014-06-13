# removes the back of a string
function(string_remove_ending original ending)
  string(LENGTH "${ending}" len)
  string(LENGTH "${original}" orig_len)
  math(EXPR len "${orig_len} - ${len}")
  string(SUBSTRING "${original}" 0 ${len} original)
  return_ref(original)
  endfunction()
