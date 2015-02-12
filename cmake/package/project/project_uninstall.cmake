

  ## 
  ## events:
  ##   project_on_package_uninstall(<project package> <package handle>)
  function(project_uninstall uri)
    uri_coerce(uri)

    assign(installed_package = this.dependency_source.resolve("${uri}"))

    if(NOT installed_package)
      error("package '{uri.input}' does not exist in project")
      return()
    endif()

    event_emit(project_on_package_uninstall ${this} ${installed_package})


    assign(success = this.dependency_source.delete("${uri}"))


    return(${success})
  endfunction()