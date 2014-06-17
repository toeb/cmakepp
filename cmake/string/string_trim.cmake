function(string_trim str)
  string(STRIP "${str}" str)
  return_ref(str)
endfunction()