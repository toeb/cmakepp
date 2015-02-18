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
      return()
    endif()

    uri_coerce(uri)


    ## pull package from remote source to temp directory
    ## then push it into local from there
    ## return if anything did not work

    assign(remote = this.remote)
    assign(local = this.local)



    assign(installed_package_handle = local.push(${remote} ${uri}))
    


    if(NOT installed_package_handle)
      message(FATAL_ERROR "nononono")
    endif()

    ## project install is executed before load
    project_install_package("${installed_package_handle}")

    ## project is loaded
    project_load_installed_package("${installed_package_handle}")

    return_ref(installed_package_handle)
  endfunction()