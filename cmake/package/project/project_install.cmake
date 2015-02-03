
  ## 
  ## events:
  ##   project_on_package_install(<project package> <package handle>)
  ##   project_on_package_load(<project package> <package handle>)
  function(project_install)
    set(args ${ARGN})
    list_pop_front(args)
    ans(uri)

    uri("${uri}")
    ans(uri)

    ## pull package from remote source to temp directory
    ## then push it into dependency_source from there
    ## return if anything did not work
    path_temp()
    ans(temp_dir)
    assign(project_dir = this.project_dir)
    assign(remote_package = this.remote.pull("${uri}" "${temp_dir}" ${args}))
    if(NOT remote_package)
      rm("${temp_dir}")
      log(--error "remote package could not be pulled: '{uri.input}'" uri temp_dir)
      return()
    endif()
    assign(package_uri = this.dependency_source.push("${remote_package}" ${args}))
    rm("${temp_dir}")
    if(NOT package_uri)
      log(--error "remote package could not pushed into project: '{uri.input}'" uri remote_package)
      return()
    endif()

    project_install_package("${package_uri}")
    project_load_package("${package_uri}")

    return_ref(package_uri)
  endfunction()