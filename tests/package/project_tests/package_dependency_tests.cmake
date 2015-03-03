function(test)
  

set("
{
  'pkg1':{ 
    'content_dir':'./cmake/cmakepp'
    'conditions':{
    }
  },
  'pkg2':{
    conditions:{
      'os.name':'Windows'
      'os.version':{version:'>6' }
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