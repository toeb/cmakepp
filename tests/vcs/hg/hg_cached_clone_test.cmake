function(test)

return()

  timer_start(t1)
  hg_cached_clone("https://bitbucket.com/toeb/test_repo_hg" "clone1")
  timer_print_elapsed(t1)


  timer_start(t1)
  hg_cached_clone("https://bitbucket.com/toeb/test_repo_hg" "clone2")
  timer_print_elapsed(t1)

return()

  timer_start(t1)
  hg_cached_clone("clone1" "https://bitbucket.com/eigen/eigen" "")
  timer_print_elapsed(t1)


  timer_start(t1)
  hg_cached_clone("clone2" "https://bitbucket.com/eigen/eigen"  "")
  timer_print_elapsed(t1)

endfunction()