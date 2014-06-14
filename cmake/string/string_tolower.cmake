# transforms the specifiedstring to lower case
function(string_tolower str)
  string(TOLOWER "${str}" str)
  return_ref(str)
endfunction()