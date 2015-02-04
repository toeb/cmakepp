# encodes semicolons with seldomly used utf8 chars.
# causes error for string(SUBSTRING) command
  function(string_semicolon_encode str)
    # make faster by checking if semicolon exists?
    string(ASCII  31 us)
    # string(FIND "${us}" has_semicolon)
    #if(has_semicolon GREATER -1) replace ...

    string(REPLACE ";" "${us}" str "${str}" )
    return_ref(str)
  endfunction()