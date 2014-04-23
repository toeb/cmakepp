
  function(string_parentheses_encode str)
    string(REPLACE "\(" "†" str "${str}")
    string(REPLACE "\)" "‡" str "${str}")
  endfunction()