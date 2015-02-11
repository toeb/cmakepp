


  ## this function is called after a package was successfully pulled
  ##
  function(project_install_package package_handle)
    event_emit(project_on_package_install ${this} ${package_handle})
  endfunction()