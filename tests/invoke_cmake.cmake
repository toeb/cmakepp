function(test)
  mkdir("${test_dir}")
  cd("${test_dir}")
  cmake(--help-command string)
  ans(res)

  assert("${res}" MATCHES "String operations.")
endfunction()