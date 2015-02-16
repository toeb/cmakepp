  ## package_source_push_managed(<package handle> ) -> <uri string>
  ##
  ## returns a valid uri if the package was pushed successfully 
  ## else returns null
  ##
  ## expects a this object to be defined which contains directory and source_name
  ## --reference flag indicates that the content will not be copied into the the package source 
  ##             the already existing package dir will be used 
  ## --force     flag indicates that existing package should be overwritten
  function(package_source_push_managed)
    if("${ARGN}" MATCHES "(.*);=>;?(.*)")
        set(source_args "${CMAKE_MATCH_1}")
        set(args "${CMAKE_MATCH_2}")
    else()
        set(source_args ${ARGN})
        set(args)
    endif()
    list_pop_front(source_args)
    ans(source)


    list_extract_flag(args --force)
    ans(force)

    this_get(directory)
    this_get(source_name)

    list_peek_front(source_args)
    ans(uri)

    assign(package_handle = source.resolve(${uri}))

    if(NOT package_handle)
      error("could not result ${source_args} to a package handle")
      return()
    endif()

    package_handle_hash("${package_handle}")
    ans(hash)

    set(location "${directory}/${hash}")

    if(EXISTS "${location}" AND NOT force)
      error("package (${hash}) already exists ")
      return()
    endif()


    set(target_dir "${location}/content")

    assign(package_handle = source.pull(${source_args} "${target_dir}"))

    assign(!package_handle.managed_descriptor.hash = hash)
    assign(!package_handle.managed_descriptor.managed_dir = location)
    assign(!package_handle.working_dir = '${location}/workspace')
    assign(!package_handle.managed_descriptor.source_name = source_name)
    assign(!package_handle.content_dir = target_dir)

    qm_write("${location}/package_handle.qm" "${package_handle}")


    return_ref(package_handle)


  endfunction()




