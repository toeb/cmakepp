
  ## resolves all dependencies for the specified package_handle
  ## keys of `package_handle.package_descriptor.dependencies` are `admissable uri`s 
  ## `admissable uri`s are resolved to `dependency handle`s 
  ## returns a map of `<admissable_uri>: <dependency handle>` if no dependencies are present 
  ## an empty map is returned
  ## sideffects 
  ## sets `<package handle>.dependencies.<admissable uri> = <dependency handle...>`
  ## sets  to `<dependency handle>.dependees.<package uri> = <package handle>`
  function(package_dependency_resolve package_source cache package_handle )
    if(NOT package_handle)
      message(FATAL_ERROR "no package handle specified")
    endif()

    ## get the dependencies specified in package_handle's package_descriptor
    ## it does not matter if the package_descriptor does not exist
    set(admissable_uris)
    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)
    if(package_descriptor)
      map_tryget("${package_descriptor}" dependencies)
      ans(dependencies)
      if(dependencies)
        map_keys("${dependencies}")
        ans(admissable_uris)
      endif()
    endif()
   # print_vars(admissable_uris)
    ## create package handle dependencies (<admissable uri> : <dependency handle>)
    map_new()
    ans(package_handle_dependencies)
    map_set(${package_handle} dependencies ${package_handle_dependencies})

    ## create package handle dependees (<package uri> : <package handle>)
    map_tryget(${package_handle} dependees)
    ans(dependees)
    if(NOT dependees)
      map_new()
      ans(dependees)
      map_set(${package_handle} dependees ${dependees})
    endif()

    ## get package uri
    map_tryget(${package_handle} uri)
    ans(package_uri)

    ## get all `dependency handle`s 
    set(dependency_handles)
    foreach(admissable_uri ${admissable_uris})
      ## check cache for admissable uri 
      ## if it is set then that admissable_uri was already queried and resolved 
      ## to 0...n `package handle`s and do not have to be resolved again because
      ## the result stays the same for the same package source
      map_has(${cache} "${admissable_uri}")
      ans(resolved)


      if(resolved)
        map_tryget(${cache} "${admissable_uri}")
        ans(current_dependency_handles)
      else()
        ## dependencies were not yet resolved 
        ## query the package source for the admissable_uri
        ## and then resolve each returned package_uri (using the cache first then the package source)
        ## query and resolve results are added to cache
        set(current_dependency_handles)
        call(package_source.query("${admissable_uri}"))
        ans(current_dependency_uris)
        foreach(dependency_uri ${current_dependency_uris})
          map_tryget(${cache} ${dependency_uri})
          ans(dependency_handle)
          if(NOT dependency_handle)
            call(package_source.resolve("${dependency_uri}"))
            ans(dependency_handle)
            map_tryget("${dependency_handle}" uri)
            ans(dependency_uri)
            # update cache
            map_set("${cache}" "${dependency_uri}" "${dependency_handle}")
            map_append_unique("${cache}" "${admissable_uri}" "${dependency_handle}")
          endif()
          list(APPEND current_dependency_handles ${dependency_handle})
        endforeach()
      endif()

      ## current_dependency_handles contains all package handles for current package handle
      list(APPEND dependency_handles ${current_dependency_handles})

      map_set("${package_handle_dependencies}" "${admissable_uri}" ${current_dependency_handles})
      foreach(current_dependency_handle ${current_dependency_handles})
        map_tryget(${current_dependency_handle} dependees)
        ans(dependees)
        if(NOT dependees)
          map_new()
          ans(dependees)
          map_set(${current_dependency_handle} dependees ${dependees}) 
        endif()
        map_set("${dependees}" "${package_uri}" "${package_handle}")
      endforeach()
    endforeach()


    return_ref(package_handle_dependencies)
  endfunction()
