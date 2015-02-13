
  function(string_toupper str)
    string(TOUPPER "${str}" str)
    return_ref(str)
  endfunction()