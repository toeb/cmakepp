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




  function(test_package_source_query_resolve_all)
    map_new()
    ans(cache)
    package_source_query_resolve_all(${package_source} --cache ${cache} ${ARGN})
    ans(package_handles)

    map_new()
    ans(result)
    map_set(${result} cache ${cache})
    map_set(${result} result ${package_handles})
    return_ref(result)
  endfunction()


  define_test_function(test_uut test_package_source_query_resolve_all)

  test_uut("{result:{A:null,B:null,C:null,D:null,E:null}}")  
  test_uut("{result:{A:{'meta:A':{}},B:null,C:null,D:null,E:null}}" A)
  test_uut("{result:{A:null,B:null,C:{},D:null,E:{}}}" C E)
  test_uut("{result:{A:null,B:null,C:null,D:null,E:null,K:{}}}" K)

endfunction()