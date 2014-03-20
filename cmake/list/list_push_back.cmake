
function(list_push_back lst value)
  set(${lst} ${${lst}} ${value} PARENT_SCOPE)
endfunction()