

  ## 
  ## events:
  ##   project_on_package_uninstall(<project package> <package handle>)
  function(project_uninstall uri)
    uri_coerce(uri)

    assign(installed_package = this.local.resolve("${uri}"))

    if(NOT installed_package)
      error("package '{uri.input}' does not exist in project")
      return()
    endif()

    event_emit(project_on_package_uninstall ${this} ${installed_package})

    assign(package_uri = installed_package.uri)
    assign(success = this.local.delete("${package_uri}"))


    return(${success})
  endfunction()