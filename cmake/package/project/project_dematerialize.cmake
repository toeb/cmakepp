## 
## events:
##   project_on_package_dematerializing(<project package> <package handle>)
function(project_dematerialize uri)
  uri_coerce(uri)

  assign(package_handle = this.local.resolve("${uri}"))

  if(NOT package_handle)
    error("package '{uri.input}' does not exist in project")
    return()
  endif()

  event_emit(project_on_package_dematerializing ${this} ${package_handle})

  assign(package_uri = package_handle.uri)
  assign(success = this.local.delete("${package_uri}"))


  return(${success})
endfunction()