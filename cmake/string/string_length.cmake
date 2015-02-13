
  function(string_length str)
    string(LENGTH "${str}" len)
    return_ref(len)
  endfunction()