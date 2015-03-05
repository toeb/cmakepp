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
      'C':'false'
    }
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'E',
    version:'1.0.0'
  }"))


  function(create_clauses clauses package_handle_map package_uri)

    map_tryget("${package_handle_map}" "${package_uri}")
    ans(dependee_handle)

    map_tryget(${dependee_handle} dependencies)
    ans(dependencies)


    map_tryget(${dependee_handle} package_descriptor)
    ans(package_descriptor)

    map_tryget("${package_descriptor}" dependencies)
    ans(conditions)


    map_keys(${dependencies})
    ans(admissable_uris)

    foreach(admissable_uri ${admissable_uris})
      map_tryget("${conditions}" "${admissable_uri}")
      ans(dependency_conditions)
      map_tryget("${dependencies}" "${admissable_uri}")
      ans(dependency_handles)
      ## multiple dependecy handles per admissable uri

      if(NOT "${dependency_conditions}" MATCHES "^(true)|(false)$")
        message(FATAL_ERROR "comlpex dependency conditions not supported")
      endif()

      if("${dependency_conditions}" STREQUAL "false")
        foreach(dependency_handle ${dependency_handles})
          map_tryget(${dependency_handle} uri)
          ans(dependency_uri)
          sequence_add(${clauses} "${package_uri}|!${dependency_uri}")
          ans(ci)
        endforeach()
      else()
        sequence_add(${clauses} "!${package_uri}")
        ans(ci)
        # todo complex conditions
        foreach(dependency_handle ${dependency_handles})
          map_tryget(${dependency_handle} uri)
          ans(dependency_uri)
          sequence_append_string("${clauses}" "${ci}" "|${dependency_uri}")
        endforeach()

      endif()

    endforeach()
  endfunction()

  ##  
  ##  returns a map of package_uris which consist of a valid dependecy configuration
  ##  { <package uri>:{ state: required|incompatible|optional}, package_handle{ dependencies: {packageuri: package handle} } }
  ##  or a reason why the configuration is impossible
  ## sideffects
  ##  
  function(dependencies_satisfy package_source)
    
    map_new()
    ans(cache)
    package_source_resolve_all(${package_source} --cache ${cache} ${ARGN})
    ans(required_package_handles)

    ## returns a map of package_uri -> package_handle
    package_dependency_graph_resolve(${cache} ${required_package_handles})
    ans(package_handles)

    ## create boolean satisfiablitiy problem 
    map_keys("${package_handles}")
    ans(package_uris)
    set(package_uris ${package_uris})
   # print_vars(package_uris)

    sequence_new()
    ans(clauses)


    foreach(package_uri ${package_uris})
      create_clauses("${clauses}" "${package_handles}" "${package_uri}")
      
    endforeach()
    map_keys(${clauses})
    ans(keys)
    set(res)
    foreach(key ${keys})
      map_tryget(${clauses} ${key})
      ans(clause)
      set(res "${res}&${clause}")
    endforeach()
    string(SUBSTRING "${res}" 1 -1 res)

    foreach(package_handle ${required_package_handles})
      map_tryget(${package_handle} uri)
      ans(required_uri)
      set(res "${res}&${required_uri}")
    endforeach()
    message("${res}")

    cnf("${res}")
    ans(cnf)
    print_cnf("${cnf}")

    dp_naive("${cnf}")
    ans(res)
    literal_to_atom_assignments(${cnf} ${res})
    ans(res)
    

    print_vars(res)


    map_new()
    return_ans()
  endfunction()

  function(test_dependencies_satisfy)
    timer_start(dep_sat)
    dependencies_satisfy(${package_source} ${ARGN})
    ans(res)
    timer_print_elapsed(dep_sat)
    map_new()
    ans(result)
    map_set(${result} result ${res})
    return_ref(result)
  endfunction()

  define_test_function(test_uut test_dependencies_satisfy )
  test_uut("{}" A)

  return()
  

set("
{
  'pkg1':{ 
    content_dir:'./cmake/cmakepp'
    conditions:{
    }
  },
  'pkg2':{
    conditions:{
      'os.name':'Windows'
      'os.version':{version:'>6' }
    }
  },
  'cxx:':{
    conditions:{
      compiler:['msvc','gcc'],
    }
  },
  'gcc:'{
    conditions:{

    }
  }

}
")

## <dependencies: { <admissable uri>: { <content_dir:path>? <conditions: <cnf query on package descriptor>>   }... }>

function(package_dependencies dependencies)
  obj("${dependencies}")
  ans(dependencies)

  map_keys(${dependencies})
  ans(package_uris)


endfunction()
  


  fwrite_data("pkg1/package.cmake" "{id:'pkg1'}" --json)
  fwrite_data("pkg2/package.cmake" "{id:'pkg2', os:{name:'Windows', version:'6.1'}}}" --json)
  
  ## `(<package descriptor>)->{ <<package uri>:<bool>>... }`
  function(package_dependencies_satisify)


  endfunction()


endfunction()