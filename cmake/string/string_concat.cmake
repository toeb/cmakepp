
  function(string_concat)
    string(CONCAT ans ${ARGN})
    return_ref(ans)
  endfunction()