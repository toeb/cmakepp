## package_source_resolve_hg
##
## resolves a uri package to a immutable unqiue uri 
##
  function(package_source_resolve_hg uri)
    set(args ${ARGN})
    uri("${uri}")
    ans(uri)

    package_source_query_hg("${uri}" --package-handle)
    ans(package_handle)

    list(LENGTH package_handle count)
    if(NOT "${count}" EQUAL 1)
      error("could not uniquely resolve {uri.uri}" uri package_handle)
      return()
    endif()


    assign(remote_uri = package_handle.scm_descriptor.ref.uri)
    assign(hash = package_handle.scm_descriptor.ref.hash)


    hg_cached_clone("${remote_uri}" --ref "${hash}" --read package.cmake)
    ans(package_descriptor_content)

    json_deserialize("${package_descriptor_content}")
    ans(package_descriptor)

    assign(default_id = uri.file_name)
    map_defaults("${package_descriptor}" "{
      id:$default_id,
      version:'0.0.0'
    }")
    ans(package_descriptor)
    map_set(${package_handle} package_descriptor "${package_descriptor}")

    return_ref(package_handle)

  endfunction()
