function(test)
  cmake(--help-command string)
  ans(res)

  assert("${res}" MATCHES "String operations.")
endfunction()