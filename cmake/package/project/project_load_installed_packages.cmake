##
## 
## loads every currently installed package in this project 
## and then loads the project itself
##
## events:
##   project_on_packages_loaded(<project handle>)
  function(project_load_installed_packages)
    ## load all packages
    assign(installed_package_uris = this.local.query("?*"))
    set(package_handles)
    foreach(installed_package_uri ${installed_package_uris})
      assign(package_handle = this.local.resolve("${installed_package_uri}"))
      list(APPEND package_handles ${package_handle})
      assign(success = project_load_installed_package("${package_handle}"))
      assign(this.installed_package_handles[] = ${package_handle})
    endforeach()

    ## lastly load the current project
    ## this ensures that all dependency files
    assign(success = project_load_installed_package(${this}))

    event_emit(project_on_packages_loaded ${this} ${package_handles})
    
    return()
  endfunction()