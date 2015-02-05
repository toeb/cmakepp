  ## project_install()
  ## 
  ## events:
  ##   project_on_package_install(<project package> <package handle>)
  ##   project_on_package_load(<project package> <package handle>)
  function(project_install)
    set(args ${ARGN})
    list_pop_front(args)
    ans(uri)
    if(NOT uri)
      error("no uri was specified to install")
    endif()

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
      error("remote package could not be pulled: '{uri.input}'" uri temp_dir)
      return()
    endif()
    assign(package_uri = this.dependency_source.push("${remote_package}" ${args}))
    rm("${temp_dir}")
    if(NOT package_uri)
      error("remote package could not pushed into project: '{uri.input}'" uri remote_package)
      return()
    endif()

    assign(installed_package_handle = this.dependency_source.resolve("${package_uri}"))


    if(NOT installed_package_handle)
      print_vars(package_uri)
      message(FATAL_ERROR "nononono")
    endif()
    ## project install is executed before load
    project_install_package("${installed_package_handle}")

    ## project is loaded
    project_load_installed_package("${installed_package_handle}")


    return_ref(package_uri)
  endfunction()