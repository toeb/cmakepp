
  function(project_load_packages)
    ## load all packages
    assign(installed_packages = this.dependency_source.query("?*"))

    foreach(installed_package ${installed_packages})
      assign(success = project_load_package(${installed_package}))
    endforeach()

    return()

  endfunction()