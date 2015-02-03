


  ## package load is called for every installed package in arbitrary order
  ## here things which do not dependend on other packages can be done
  function(project_load_package package_uri)
    assign(package_handle = this.dependency_source.resolve(${package_uri}))
    event_emit(project_on_package_load ${this} ${package_handle})
  endfunction()