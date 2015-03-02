function(test)



  return()
  ## dependency
  ## uri - package_uri
  ## optional - indicates wether this dependency is required or not 
  ## content_dir (project relative)
  ## 

  ## satifisfies the specified dependency using the meta data acuired by package source
  ##
  function(dependency_issatisfiable source dependency)
    package_dependency("${dependency}")
    ans(dependency)

    map_tryget(${dependency} uri)
    ans(uri)

    uri_coerce(uri)

    ## get dependency order

  endfunction()


  ## http://minisat.se/downloads/MiniSat_v1.13_short.pdf
  function(sat)

  endfunction()

  ## get all conditions for dependency 
  ## condition 
  ## {
  ##   uri: 
  ## } 
  ## environment:?os=osx&... => false
  ## environment:?arch=x64... => true
  ## somepackage => true|false 
  ## get all dependencies and create a table uri=><package handle>, sat => 
  ## 
  function(package_dependency_conditions)
    package_dependency(${ARGN})
    ans(package_dependency)

    map_tryget(${package_dependency} dependencies)
    ans(dependencies)

  endfunction() 



  function(package_dependency_resolve source)
    foreach(dependency ${ARGN})
      package_dependency("${dependency}")
      ans(dependency)


    endforeach()
  endfunction()

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