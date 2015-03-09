function(test)

  fwrite_data("pkg1/package.cmake" "{dependencies:['pkg2']}" --json)
  fwrite_data("pkg2/package.cmake" "{dependencies:[]}" --json)
  fwrite_data("pkg3/package.cmake" "{dependencies:[]}" --json)
  fwrite_data("pkg4/package.cmake" "{dependencies:[]}" --json)
  fwrite_data("pkg5/package.cmake" "{dependencies:[]}" --json)


  path_package_source()
  ans(path_source)

  ## get package descriptors for root packages
  assign(pkg1 = path_source.resolve(pkg1))
  assign(pkg5 = path_source.resolve(pkg5))


  

  timer_start(t1)
  package_dependency_order(${path_source} ${pkg5} ${pkg1} )
  ans(order)
  timer_print_elapsed(t1)

  
  list_select_property(order package_descriptor)
  ans(order)
  list_select_property(order id)
  ans(ids)

  print_vars(ids)

  assert(${ids} CONTAINS pkg1)
  assert(${ids} CONTAINS pkg2)
  assert(${ids} CONTAINS pkg5)

  list_isinorder(ids pkg2 pkg1)
  ans(pkg2_comes_before_pkg1)
  assert(pkg2_comes_before_pkg1)

endfunction()