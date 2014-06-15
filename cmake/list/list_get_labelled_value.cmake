
function(list_get_labelled_value lst label)
  list_extract_labelled_value(${lst} ${label} ${ARGN})
  return_ans()
endfunction()