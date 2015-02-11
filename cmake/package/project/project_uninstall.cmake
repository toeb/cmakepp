

  ## 
  ## events:
  ##   project_on_package_uninstall(<project package> <package handle>)
  function(project_uninstall uri)
    uri("${uri}")
    ans(uri)

    assign(installed_package = this.dependency_source.resolve("${uri}"))

    if(NOT installed_package)
      error("package '{uri.input}' does not exist in project")
      return()
    endif()

    event_emit(project_on_package_uninstall ${this} ${installed_package})

    map_import_properties(${installed_package} managed_dir)
    rm("${managed_dir}")

    return(true)
  endfunction()