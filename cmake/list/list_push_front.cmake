
function(list_push_front lst value)
  set(${lst} ${value} ${${lst}} PARENT_SCOPE)   
endfunction()