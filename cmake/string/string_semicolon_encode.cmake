# encodes semicolons with seldomly used utf8 chars.
# causes error for string(SUBSTRING) command
  function(string_semicolon_encode str)
    string(ASCII  31 us)
    string(REPLACE ";" "${us}" str "${str}" )
    return_ref(str)
  endfunction()