function(test)

  metadata_package_source("meta")
  ans(package_source)

  assign(success = package_source.add_package_descriptor("{
    id:'A',
    version:'1.0.0',
    dependencies:{
      'B':true,
      'D':true
    }
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'B',
    version:'1.0.0'
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'C',
    version:'1.0.0'
  }"))
  assign(success = package_source.add_package_descriptor("{
    id:'D',
    version:'1.0.0'
  }"))



  function(dependencies_satisfy package_source)

    map_new()
    ans(cache)
    function(expand_dependencies package_source cache descriptor)
      call(package_source.query('${ARGN}'))
      ans(uris)
      set(dependencies)
      foreach(uri ${uris})
        map_has("${cache}" "${uri}")
        ans(is_resolved)
        if(NOT is_resolved)
          call(package_source.resolve(${uri}))
          ans_append(dependencies)
        else()
          map_tryget()
        endif()
      endforeach()
      return_ref(dependencies)
      return()
    endfunction()

    expand_dependencies(${package_source} ${cache} ${ARGN})
    ans(dependencies)
    curry3(() => expand_dependencies("${package_source}" "${cache}" "/*"))
    ans(expand)
    dfs(${expand} ${dependencies})




  endfunction()


  dependencies_satisfy(${package_source} A)

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