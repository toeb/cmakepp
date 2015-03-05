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
    package_source_resolve_all(${package_source} --cache ${cache} ${ARGN})
    ans(package_handles)
    timer_start(package_dependency_graph_resolve)
    package_dependency_graph_resolve("${cache}" ${package_handles})
    timer_print_elapsed(package_dependency_graph_resolve)

    map_new()
    ans(result)
    map_set(${result} cache ${cache})
    map_set(${result} result ${res})
    return_ref(result)
  endfunction()


  define_test_function(test_uut test_package_dependency_graph_resolve)

  test_uut("{}")
  test_uut("{cache:{'meta:E':{}}}" E)
  test_uut("{cache:{'meta:C':{}, 'meta:E':{}}}" E C)
  test_uut("{cache:{'meta:B':{}, 'meta:C':{}}}" B)
  test_uut("{cache:{'meta:A':{},'meta:B':{},'meta:C':{},'meta:D':{}}}" A)
  

  endfunction()