  ## package_source_push_managed(<package handle> ) -> <uri string>
  ##
  ## returns a valid uri if the package was pushed successfully 
  ## else returns null
  ##
  ## expects a this object to be defined which contains directory and source_name
  ## --reference flag indicates that the content will not be copied into the the package source 
  ##             the already existing package dir will be used 
  ## --content-dir <dir> flag indicates where the package content will reside
  ## --package-dir <dir> flag indicates parent dir of content of package
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

    list_extract_labelled_value(source_args --content-dir)
    ans(content_dir)

    list_extract_labelled_value(source_args --package-dir)
    ans(package_dir)

    list_extract_flag(args --force)
    ans(force)

    this_get(directory)

    list_pop_front(source_args)
    ans(uri)

    uri_coerce(uri)

    assign(package_handle = source.resolve(${uri}))

    if(NOT package_handle)
      error("could not resolve ${source_args} to a package handle")
      return()
    endif()

    package_handle_hash("${package_handle}")
    ans(hash)

    set(managed_dir "${directory}/${hash}")

    if(EXISTS "${managed_dir}" AND NOT force)
      error("package (${hash}) already exists ")
      return()
    endif()

    if(NOT content_dir)
      if(NOT package_dir)
        this_get(package_dir)
      endif()
      if(package_dir)
        assign(id = package_handle.package_descriptor.id)
        assign(version = package_handle.package_descriptor.version)
        

        path("${package_dir}/${id}")
        ans(content_dir)
        if(EXISTS "${content_dir}")
          path("${package_dir}/${id}@${version}")
          ans(content_dir)
          if(EXISTS "${content_dir}")
            path("${package_dir}/${hash}")
          endif()
        endif()
      else()
        set(content_dir "${managed_dir}/content")
      endif()
    else()
      path_qualify(content_dir)
    endif()

    assign(package_handle = source.pull("${uri}" ${source_args} "${content_dir}"))
    if(NOT package_handle)
      error("failed to pull {uri.uri} to {content_dir}")
      return()
    endif()
    assign(!package_handle.managed_descriptor.hash = hash)
    assign(!package_handle.managed_descriptor.managed_dir = managed_dir)
    assign(!package_handle.managed_descriptor.remote_source_name = source.source_name)
    assign(!package_handle.managed_descriptor.remote_uri = uri.uri)
    assign(!package_handle.working_dir = '${managed_dir}/workspace')

    qm_write("${managed_dir}/package_handle.qm" "${package_handle}")


    return_ref(package_handle)


  endfunction()




