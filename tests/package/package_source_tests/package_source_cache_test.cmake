function(test)




  github_package_source()
  ans(github_source)

  cached_package_source("${default_source}")#"cache") 
  ans(uut)



  timer_start(query_miss)
  assign(res = uut.query(toeb/cmakepp))
  timer_print_elapsed(query_miss)
  assert(res)

  timer_start(query_hit)
  assign(res = uut.query(toeb/cmakepp))
  timer_print_elapsed(query_hit)
  assert(res)
  


  assign(res = uut.resolve(toeb/cmakepp))
  timer_start(resolve_miss)
  assign(res = uut.resolve(toeb/cmakepp))
  timer_print_elapsed(resolve_miss)
  assert(res)

  timer_start(resolve_hit)
  assign(res = uut.resolve(?id=cmakepp))
  timer_print_elapsed(resolve_hit)
  assert(res)

  timer_start(resolve_hit)
  assign(res = uut.resolve(?id=cmakepp))
  timer_print_elapsed(resolve_hit)
  assert(res)

  timer_start(pull_miss)
  assign(res = uut.pull(?id=cmakepp pull_miss))
  timer_print_elapsed(pull_miss)
  assert(res)

  timer_start(pull_hit)
  assign(res = uut.pull(?id=cmakepp pull_hit))
  timer_print_elapsed(pull_hit)
  assert(res)
  
endfunction()