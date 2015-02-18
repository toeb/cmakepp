function(test)

  fwrite_data("pkg1/package.cmake" "{dependencies:['./pkg2','./pkg3']}" --json)
  fwrite_data("pkg2/package.cmake" "{dependencies:['./pkg3']}" --json)
  fwrite_data("pkg3/package.cmake" "{dependencies:[]}" --json)


  path_package_source()
  ans(path_source)

  managed_package_source("src" "${test_dir}/source")
  ans(source)

  assign(pkg1 = source.push(${path_source} pkg1))
  assign(pkg2 = source.push(${path_source} pkg2))
  assign(pkg3 = source.push(${path_source} pkg3))

  managed_package_source("src" "${test_dir}/target")
  ans(sink)

  default_package_source()
  ans(default_source)

  function(resolve_dependencies source)
    function(dependency_hash source dep)
      map_tryget(${dep} uri)
      return_ans()
    endfunction()
    function(dependency_expand source dep)
      message(FORMAT "expand {dep.package_descriptor.id}")
      assign(deps = dep.package_descriptor.dependencies)
      set(preds)
      foreach(dep ${deps})
        message("resolving ${dep}")
        assign(predecessors = source.resolve("${dep}"))
        message("pred ${predecessors}")
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
    foreach(it ${order})
      print_vars(it.package_descriptor.id)
    endforeach()
  endfunction()

  resolve_dependencies(${default_source} ${pkg1})




endfunction()