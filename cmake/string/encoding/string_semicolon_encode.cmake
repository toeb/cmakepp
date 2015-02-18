# encodes semicolons with seldomly used utf8 chars.
# causes error for string(SUBSTRING) command
  function(string_semicolon_encode str)
    # make faster by checking if semicolon exists?
    string(ASCII  31 semicolon_code)
    # string(FIND "${semicolon_code}" has_semicolon)
    #if(has_semicolon GREATER -1) replace ...

    string(REPLACE ";" "${semicolon_code}" str "${str}" )
    return_ref(str)
  endfunction()


## faster
  function(string_semicolon_encode str)
    string_codes()
    eval("
      function(string_semicolon_encode str)
        string(REPLACE \";\" \"${semicolon_code}\" str \"\${str}\" )
        set(__ans \"\${str}\" PARENT_SCOPE)
      endfunction()
    ")
    string_semicolon_encode("${str}")
    return_ans()
  endfunction()

