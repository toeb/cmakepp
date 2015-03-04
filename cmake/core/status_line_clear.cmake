function(status_line_clear)
  string_repeat(" " 80)
  ans(whitespace)

  eval("
    function(status_line_clear)
      echo_append(\"\r${whitespace}\r\")    
    endfunction()
  ")
  status_line_clear()
endfunction()
