  ## package_source_push_managed(<package handle> ) -> <uri string>
  ##
  ## returns a valid uri if the package was pushed successfully 
  ## else returns null
  ##
  ## expects a this object to be defined which contains directory and source_name
  ## --reference flag indicates that the content will not be copied into the the package source 
  ##             the already existing package dir will be used 
  ## --force     flag indicates that existing package should be overwritten
  function(package_source_push_managed package_handle)
    set(args ${ARGN})

    list_extract_flag(args --reference)
    ans(reference)

    this_get(directory)
    this_get(source_name)

    ## check if package handle is valid
    package_handle("${package_handle}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()

    ## create a hash for the package
    package_handle_hash("${package_handle}")
    ans(hash)

    set(location "${directory}/${hash}")

    if(EXISTS "${location}")
      ## same hash already used
      return()
    endif()

    map_tryget(${package_handle} content_dir)
    ans(source_content_dir)
    
    set(content_dir "${location}/content")


    ## if reference do not copy content else copy content
    if(NOT reference)
      ## copy only if exists (if it does not exist no content dir is set)
      cp_dir("${source_content_dir}" "${location}/content")
    else()
      set(content_dir "${source_content_dir}")
    endif()

    ## set local urio
    set(local_uri "${source_name}:${hash}")

    set(index)
    
    # create a index file which contains all searchable data
    assign(!index.hash = hash)
    assign(!index.id = package_handle.package_descriptor.id)
    assign(!index.version = package_handle.package_descriptor.id)
    assign(!index.tags = package_handle.package_descriptor.tags)
    assign(!index.tags[] = package_handle.package_descriptor.id)
    assign(!index.local_uri = local_uri)
    assign(!index.remote_uri = package_handle.uri)
    assign(!index.query_uri = package_handle.query_uri)
    assign(!index.content_dir = content_dir)
    assign(!index.source_content_dir = source_content_dir)
    qm_write("${location}/index.cmake" "${index}")

    assign(package_descriptor = package_handle.package_descriptor)
    qm_write("${location}/package.cmake" "${package_descriptor}")
    

    return_ref(local_uri)
  endfunction()




