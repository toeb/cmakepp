  ## function which is called after cmakepp was loaded
  ## this is used to create and register events or other things once
  function(cmakepp_after_initialize)
    ## register listener for the project_on_package_load event 
    ## which exports cmake files of package and calls on_load hook
    event_addhandler(project_on_package_load cmakepp_project_on_package_load)
    
    ## register listener for the project_on_package_install event 
    ## which directly after a package is installed in a project
    event_addhandler(project_on_package_install cmakepp_project_on_package_install)

  endfunction()
