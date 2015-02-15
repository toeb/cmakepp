
#creates a unique id
function(make_guid)
  string(RANDOM LENGTH 10 id)
  set(__ans ${id} PARENT_SCOPE)
endfunction()
