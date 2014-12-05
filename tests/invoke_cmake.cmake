function(test)
  mkdir("${test_dir}")
  cd("${test_dir}")
  cmake(--help-command string --result)
  ans(res)

  map_tryget(${res} result)
  ans(error)

  assert(NOT error)
endfunction()