## returns a list of valid package uris which contain the scheme gitscm
## you can specify a query for ref/branch/tag by adding ?ref=* or ?ref=name
## only ?ref=* returns multiple uris
  function(package_source_query_git uri)
    set(args ${ARGN})

    list_extract_flag(args --package-handle)
    ans(return_package_handle)

    uri("${uri}")
    ans(uri)



    uri_qualify_local_path("${uri}")
    ans(uri)

    uri_format("${uri}" --no-query)
    ans(remote_uri)

    ## check if remote exists
    git_remote_exists("${remote_uri}")
    ans(remote_exists)


    ## remote does not exist
    if(NOT remote_exists)
      return()
    endif()

    ## get ref and check if it exists
    assign(ref = uri.params.ref)
    assign(branch = uri.params.branch)  
    assign(tag = uri.params.tag)
    assign(rev = uri.params.rev)

    set(ref ${ref} ${branch} ${tag})
    list_pop_front(ref)
    ans(ref)

    set(remote_refs)
    if(NOT "${rev}_" STREQUAL "_")
      ## todo validate rev furhter??
      if(NOT "${rev}" MATCHES "^[a-fA-F0-9]+$")
        return()
      endif()

      obj("{
        revision:$rev,
        type:'rev',
        name:$rev,
        uri:$remote_uri  
      }")

      ans(remote_refs)
    elseif("${ref}_" STREQUAL "*_")
      ## get all remote refs and format a uri for every found tag/branch
      git_remote_refs("${remote_uri}")
      ans(refs)

      foreach(ref ${refs})
        map_tryget(${ref} type)
        ans(ref_type)
        if("${ref_type}" MATCHES "(tags|heads)")
          list(APPEND remote_refs ${ref})
        endif()
      endforeach()
    elseif(NOT "${ref}_" STREQUAL "_")
      ## ensure that the specified ref exists and return a valid uri if it does
      git_remote_ref("${remote_uri}" "${ref}" "*")
      ans(remote_refs)
    else()

      git_remote_ref("${remote_uri}" "HEAD" "*")
      ans(remote_refs)
    endif()


    ## generate result from the scm descriptors
    set(results)
    foreach(remote_ref ${remote_refs})
      git_scm_descriptor("${remote_ref}")
      ans(scm_descriptor)
      assign(rev = scm_descriptor.ref.revision)
      set(result "${remote_uri}?rev=${rev}")
      if(return_package_handle)
        set(package_handle)
        assign(!package_handle.uri = result)
        assign(!package_handle.scm_descriptor = scm_descriptor)
        assign(!package_handle.query_uri = uri.uri)
        set(result ${package_handle})
      endif()
      list(APPEND results ${result})
    endforeach()


    
    return_ref(results)
  endfunction()