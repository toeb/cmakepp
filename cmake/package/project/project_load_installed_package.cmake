


  ## package load is called for every installed package in arbitrary order
  ## here things which do not dependend on other packages can be done
  function(project_load_installed_package package_handle)    
    event_emit(project_on_package_load ${this} ${package_handle})
  endfunction()