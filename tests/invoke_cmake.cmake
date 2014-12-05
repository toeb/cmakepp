function(test)
  mkdir("${test_dir}")
  cd("${test_dir}")
  cmake(--help-command string --result)
  ans(res)

  json_print(${res})



  message("res ${res}")

  assert("${res}" MATCHES "String operations.")
endfunction()