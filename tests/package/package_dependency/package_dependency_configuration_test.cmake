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
      'C':'true',
      'E':'false'
    }
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'E',
    version:'1.0.0'
  }"))



  function(test_package_dependency_configuration)
    timer_start(dep_sat)
    
    project_descriptor_new(${ARGN})
    ans(project_descriptor)

    #print_vars(project_descriptor)
    package_dependency_configuration(${package_source} ${project_descriptor})
    ans(res)
    timer_print_elapsed(dep_sat)
    map_new()
    ans(result)
    map_set(${result} result ${res})
    map_set(${result} project ${project_descriptor})
    #print_vars(result)
    return_ref(result)
  endfunction()

  define_test_function(test_uut test_package_dependency_configuration )
  test_uut("{result:{'meta:A':'true', 'meta:B':'true', 'meta:C':'true', 'meta:D':'true', 'meta:E':'false'}}" A)
  test_uut("{result:{'meta:E':'true'}}" E)
  test_uut("{result:{'meta:E':'false','meta:D':'true','meta:C':'true'}}" D)
  test_uut("{result:{'meta:B':'true','meta:C':'true'}}" B)
  test_uut("{result:{'meta:B':'true','meta:C':'true','meta:D':'true','meta:E':'false'}}" B D)
  test_uut("{result:{'meta:C':'true','meta:E':'true'}}" E C)

  return()

endfunction()