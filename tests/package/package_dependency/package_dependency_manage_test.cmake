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


  map_new()
  ans(project_handle)

  package_dependency_update_handle(${project_handle} "A false" "B optional" "C" "D {content_dir:'asd'}")
  ans(res)
  json_print(${res})

  #json_print(${project_handle})


  map_new()
  ans(project_handle)
  map_set(${project_handle} uri project)

  project_handle_update_dependencies(${package_source} ${project_handle} B )
  ans(res)
  json_print(${res})


endfunction()