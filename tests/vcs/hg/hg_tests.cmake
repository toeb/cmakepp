function(test)

  find_package(Hg)
  if(NOT HG_FOUND)
    message("Test Inconclusive, missing mercurial")
    return()
  endif() 

  cd("${test_dir}")

  hg(--version --quiet)
  ans(res)

  assert("${res}" MATCHES "${HG_VERSION_STRING}")





endfunction()