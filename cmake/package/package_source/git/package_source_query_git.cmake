## returns a list of valid package uris which contain the scheme gitscm
## you can specify a query for ref/branch/tag by adding ?ref=* or ?ref=name
## only ?ref=* returns multiple uris
  function(package_source_query_git uri_string)
    set(args ${ARGN})

    list_extract_flag(args --package-handle)
    ans(return_package_handle)

    uri("${uri_string}")
    ans(uri)

    map_tryget("${uri}" schemes)
    ans(scheme)

    list_extract_flag(scheme gitscm)
    ans(is_gitscm)

    map_set(${uri} scheme "${scheme}")


    uri_qualify_local_path("${uri}")
    ans(uri)

    uri_format("${uri}" --no-query --remove-scheme gitscm)
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

    if(NOT "${rev}_" STREQUAL "_")
      ## todo validate rev?
      if(NOT "${rev}" MATCHES "^[a-fA-F0-9]+$")
        return()
      endif()

      set(result "gitscm+${remote_uri}?rev=${rev}")
      if(return_package_handle)
        map_new()
        ans(package_handle)

        assign(!package_handle.uri = result)
        assign(!package_handle.query_uri = uri_string)
        assign(!package_handle.scm_descriptor.scm = 'git')
        assign(!package_handle.scm_descriptor.ref.revision = rev)
        assign(!package_handle.scm_descriptor.ref.type = '')
        assign(!package_handle.scm_descriptor.ref.name = '')
        set(result ${package_handle})
      endif()
    elseif("${ref}_" STREQUAL "*_")
      ## get all remote refs and format a uri for every found tag/branch
      git_remote_refs("${remote_uri}")
      ans(refs)
      set(result)
      foreach(ref ${refs})
        map_tryget(${ref} name)
        ans(ref_name)
        map_tryget(${ref} type)
        ans(ref_type)
        map_tryget(${ref} revision)
        ans(revision)
        if("${ref_type}" STREQUAL "tags" OR "${ref_type}" STREQUAL "heads")
          if("${ref_type}" STREQUAL "tags")
            set(ref_type tag)
          elseif("${ref_type}" STREQUAL "heads")
            set(ref_type branch)
          else()
            set(ref_type ref)
          endif()
          set(current_uri "gitscm+${remote_uri}?rev=${revision}")
          #list(APPEND result "gitscm+${remote_uri}?${ref_type}=${ref_name}")
          if(return_package_handle)
            map_new()
            ans(package_handle)

            assign(!package_handle.uri = current_uri)
            assign(!package_handle.query_uri = uri_string)
            assign(!package_handle.scm_descriptor.scm = 'git')
            assign(!package_handle.scm_descriptor.ref = ref)
            list(APPEND result ${package_handle})
          else()
            list(APPEND result "${current_uri}")
          endif()
        endif()
      endforeach()
    elseif(NOT "${ref}_" STREQUAL "_")
      ## ensure that the specified ref exists and return a valid uri if it does
      git_remote_ref("${remote_uri}" "${ref}" "*")
      ans(ref)
      if(NOT ref)
        return()
      endif()
      map_tryget(${ref} type)
      ans(ref_type)

      map_tryget(${ref} revision)
      ans(revision)
      if("${ref_type}" STREQUAL "heads")
        set(ref_type branch)
      elseif("${ref_type}" STREQUAL "tags")
        set(ref_type tag)
      else()
        set(ref_type ref)
      endif()
      map_tryget(${ref} name)
      ans(ref_name)

      #set(result "gitscm+${remote_uri}?${ref_type}=${ref_name}")
      set(result "gitscm+${remote_uri}?rev=${revision}")
      if(return_package_handle)
        map_new()
        ans(package_handle)
        assign(!package_handle.uri = result)
        assign(!package_handle.query_uri = uri_string)
        assign(!package_handle.scm_descriptor.scm = 'git')
        assign(!package_handle.scm_descriptor.ref = ref)

        set(result ${package_handle})
      endif()
    else()
      git_remote_ref("${remote_uri}" "HEAD" "*")
      ans(tip)
      map_tryget("${tip}" revision)
      ans(revision)
      ## use the default (no ref)
      set(result "gitscm+${remote_uri}?rev=${revision}")

      if(return_package_handle)
        map_new()
        ans(package_handle)
        assign(!package_handle.uri = result)
        assign(!package_handle.query_uri = uri_string)
        assign(!package_handle.scm_descriptor.scm = 'git')
        assign(!package_handle.scm_descriptor.ref = tip)
        set(result ${package_handle})
      endif()
    endif()


    
    return_ref(result)
  endfunction()