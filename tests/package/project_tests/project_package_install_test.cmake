function(test)



  ## on package materialized
  ## on package installed
  ## on package loaded
  function(project_package_install)
    ## check if package installed

    ## add dependency to project 

    ## resolve package

    ## satisfy dependencies 

    ## materialize package 

    ## install package 

    ## load package (in dependency order)

    ## save project?
  endfunction()

  ## on package uninstalling
  ## on package dematerializing
  ## on package uninstalled
  function(project_package_uninstall)
    ## check if installed

    ## uninstall package 

    ## dematerialize package
  
    ## remove dependency from project

    ## save project?
  endfunction()

  ## `(<~package dependency>)-><package dependency>`
  function(package_dependency)
    set(args ${ARGN})
    ref_isvalid("${args}")
    ans(ismap)
    if(ismap)
      return_ref(args)
    endif()

    list_pop_front(args)
    ans(uri)

    if("${uri}_" STREQUAL "_")
      return()
    endif()



  endfunction()



endfunction()