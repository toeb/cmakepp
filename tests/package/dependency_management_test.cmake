function(test)

  fwrite_data("pkg1/package.cmake" "{dependencies:[]}" --json)
  fwrite_data("pkg2/package.cmake" "{dependencies:[]}" --json)
  fwrite_data("pkg3/package.cmake" "{dependencies:[]}" --json)
  fwrite_data("pkg4/package.cmake" "{dependencies:[]}" --json)
  fwrite_data("pkg5/package.cmake" "{dependencies:[]}" --json)


  path_package_source()
  ans(path_source)

  managed_package_source("src" "${test_dir}/source")
  ans(source)

  assign(pkg1 = source.push(${path_source} pkg1))
  assign(pkg2 = source.push(${path_source} pkg2))
  assign(pkg3 = source.push(${path_source} pkg3))
  assign(pkg4 = source.push(${path_source} pkg4))
  assign(pkg5 = source.push(${path_source} pkg5))

  managed_package_source("src" "${test_dir}/target")
  ans(sink)


  function(dependency_order source)
    function(dependency_hash source dep)
      ref_isvalid(${dep})
      ans(isref)
      if(NOT isref)
        assign(dep = source.resolve("${dep}"))
      endif()
      map_tryget(${dep} uri)
      return_ans()
    endfunction()
    function(dependency_expand source dep)
      ref_isvalid(${dep})
      ans(isref)
      if(NOT isref)
        assign(dep = source.resolve("${dep}"))
      endif()
      assign(deps = dep.package_descriptor.dependencies)
      set(preds)
      foreach(dep ${deps})
        assign(predecessors = source.resolve("${dep}"))
        list(APPEND preds ${predecessors})
      endforeach()
      return_ref(preds)
    endfunction()

    curry3((dep) => dependency_hash("${source}" /dep) )
    ans(hash)
    curry3((dep) => dependency_expand("${source}" /dep) )
    ans(dep)



    topsort("${hash}" "${dep}" ${ARGN})
    ans(order)
    list_reverse(order)
    return_ref(order)
  endfunction()
  timer_start(t1)
  dependency_order(${path_source} ./pkg5 ./pkg1 )
  ans(order)
  timer_print_elapsed(t1)

  foreach(it ${order})
      print_vars(it.uri)
  endforeach()
    




endfunction()