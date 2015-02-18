  ## package_source_pull_composite(<~uri?>) -> <package handle>
  ##
  ## pulls the specified package from the best matching child sources
  ## returns the corresponding handle on success else nothing is returned
  function(package_source_pull_composite uri)
    set(args ${ARGN})

    uri("${uri}")
    ans(uri)

    ## resolve package and return if none was found
    package_source_resolve_composite("${uri}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()

    ## get package source and uri from handle
    ## because current uri might not be fully qualified
    map_tryget(${package_handle} package_source)
    ans(package_source)

    map_tryget(${package_handle} uri)
    ans(package_uri)

    ## use the package package source to pull the correct package
    ## and return the result
    assign(package_handle = package_source.pull("${package_uri}" ${args}))

    return_ref(package_handle)
  endfunction()
