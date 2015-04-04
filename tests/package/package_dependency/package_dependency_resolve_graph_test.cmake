function(test)

  metadata_package_source("meta")
  ans(package_source)

  assign(success = package_source.add_package_descriptor("{
    id:'A',
    version:'1.0.0',
    dependencies:{
      'B':'true',
      'D':'true'
    }
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'B',
    version:'1.0.0',
    dependencies:{
      'C':'true'
    }
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'C',
    version:'1.0.0'
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'D',
    version:'1.0.0',
    dependencies:{
      'C':'true'
    }
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'E',
    version:'1.0.0'
  }"))


  function(test_package_dependency_graph_resolve)
    map_new()
    ans(cache)
    set(args ${ARGN})

    while(true)
      list_extract_labelled_value(args --cached)
      ans(cached)

      if(NOT cached)
        break()
      endif()

      call(package_source.resolve(${cached}))
      ans(res)
      map_tryget(${res} uri)
      ans(uri)
      map_set(${cache} ${uri} ${res})
    endwhile()

    package_source_query_resolve_all(${package_source} --cache ${cache} ${args})
    ans(package_handles)
    map_values("${package_handles}")
    ans(package_handle_maps)
    set(package_handles)
    foreach(package_handle_map ${package_handle_maps})
      map_values(${package_handle_map})
      ans_append(package_handles)
    endforeach()
    timer_start(package_dependency_graph_resolve)
    package_dependency_graph_resolve("${package_source}" ${package_handles} --cache "${cache}")
    ans(res)
    timer_print_elapsed(package_dependency_graph_resolve)

    map_new()
    ans(result)
    map_set(${result} cache ${cache})
    map_set(${result} result ${res})
    return_ref(result)
  endfunction()


  define_test_function(test_uut test_package_dependency_graph_resolve)


  test_uut("{cache:{'meta:A':{},'meta:B':{},'meta:C':{},'meta:D':{}}}" A)
  test_uut("{cache:{'meta:C':{}}, result:{'meta:C':{}}}" C --cached C )
  test_uut("{cache:{'meta:C':{}}}" --cached C)
  test_uut("{result:{}}")
  test_uut("{cache:{'meta:E':{}}}" E)
  test_uut("{cache:{'meta:C':{}, 'meta:E':{}}}" E C)
  test_uut("{cache:{'meta:B':{}, 'meta:C':{}}}" B)
  

  endfunction()

