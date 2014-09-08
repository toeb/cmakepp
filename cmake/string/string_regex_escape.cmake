# escapes chars used by regex
  function(string_regex_escape str)
    string(REGEX REPLACE "(\\/|\\]|\\.|\\[|\\*)" "\\\\\\1" str "${str}")
    return_ref(str)
  endfunction()