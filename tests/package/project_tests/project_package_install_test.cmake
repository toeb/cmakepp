function(test)


return()


  ## on package materialized
  ## on package installed
  ## on package loaded
  function(project_package_install)
    package_dependency(${ARGN})
    ans(dependency)
    ## check if package installed

    map_tryget(${dependency} uri)
    ans(uri)
    uri_coerce(uri)

    this_get(local)
    assign(installed = local.query("${uri}"))

    if(installed)
      error("package {uri.uri} is already installed")
      return()
    endif()
    
    ## satisfy dependency 



    ## add dependency to project 

    ## resolve package

    
    ## materialize package 

    ## install package 

    ## load package (in dependency order)

    ## save project?
  endfunction()

  ## on package uninstalling
  ## on package dematerializing
  ## on package uninstalled
  function(project_package_uninstall)
    package_dependency(${ARGN})
    ans(dependency)
    ## check if installed

    ## uninstall package 

    ## dematerialize package
  
    ## remove dependency from project

    ## save project?
  endfunction()







endfunction()