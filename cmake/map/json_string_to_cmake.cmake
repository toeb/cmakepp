
  function(json_string_to_cmake str)
    # remove trailing and leading quotation marks
    string_slice("${str}" 1 -2)
    ans(str)

    string(REPLACE "\\\\;" ";" str "${str}")
    string(ASCII 8 char)
    string(REPLACE  "\\b" "${char}" str "${str}")
    string(ASCII 12 char)
    string(REPLACE  "\\f" "${char}" str "${str}")

    string(REPLACE "\\n" "\n" str "${str}")
    string(REPLACE "\\t" "\t" str "${str}")
    string(REPLACE "\\t" "\t" str "${str}")
    string(REPLACE "\\r" "\r" str "${str}")
    string(REPLACE "\\\"" "\"" str "${str}")

    string(REPLACE "\\\\" "\\" str "${str}")

    return_ref(str)
      
  endfunction()