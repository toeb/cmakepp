


  ## this function is called after a package was successfully pulled
  ##
  function(project_install_package package_uri)
    assign(package_handle = this.dependency_source.resolve(${package_uri}))
    event_emit(project_on_package_install ${this} ${package_handle})
  endfunction()