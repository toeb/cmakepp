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

  function(test_package_dependency_resolve package_id)
    map_new()
    ans(cache)
    assign(package_handle = package_source.resolve("${package_id}"))
    timer_start(package_dependency_resolve)
    package_dependency_resolve("${package_source}"  "${package_handle}" --cache "${cache}")
    ans(res)
    timer_print_elapsed(package_dependency_resolve)
    map_new()
    ans(result)
    print_vars(res)
    map_set(${result} cache "${cache}")
    map_set(${result} result ${res})
    return_ref(result)
  endfunction()


  define_test_function(test_uut test_package_dependency_resolve package_id)
  test_uut("{
    result:{
     'C':{
       'meta:C':{
          dependees:{
            'meta:D':{}
          }}}}}" "D")

  test_uut("{cache:{'meta:C':{}, 'C':{} }}" "D")
  test_uut("{result:{'C':{} }}" "D")
  test_uut("{result:{}}" "C")
  #test_uut("{cache:{'meta:B':{}, 'meta:D':{}}}" "A")
 

endfunction()