## returns a list of valid package uris which contain the scheme gitscm
## you can specify a query for ref/branch/tag by adding ?ref=* or ?ref=name
## only ?ref=* returns multiple uris
  function(package_source_query_git uri_string)
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
    set(ref ${ref} ${branch} ${tag})
    list_pop_front(ref)
    ans(ref)

    if(ref STREQUAL "*")
      ## get all remote refs and format a uri for every found tag/branch
      git_remote_refs("${remote_uri}")
      ans(refs)
      set(result)
      foreach(ref ${refs})
        map_tryget(${ref} name)
        ans(ref_name)
        map_tryget(${ref} type)
        ans(ref_type)
        if("${ref_type}" STREQUAL "tags" OR "${ref_type}" STREQUAL "heads")
          if("${ref_type}" STREQUAL "tags")
            set(ref_type tag)
          elseif("${ref_type}" STREQUAL "heads")
            set(ref_type branch)
          else()
            set(ref_type ref)
          endif()
          list(APPEND result "gitscm+${remote_uri}?${ref_type}=${ref_name}")
        endif()
      endforeach()
    elseif(NOT ref STREQUAL "")
      ## ensure that the specified ref exists and return a valid uri if it does
      git_remote_ref("${remote_uri}" "${ref}" "*")
      ans(ref)
      if(NOT ref)
        return()
      endif()
      map_tryget(${ref} type)
      ans(ref_type)
      if("${ref_type}" STREQUAL "heads")
        set(ref_type branch)
      elseif("${ref_type}" STREQUAL "tags")
        set(ref_type tag)
      else()
        set(ref_type ref)
      endif()
      map_tryget(${ref} name)
      ans(ref_name)

      set(result "gitscm+${remote_uri}?${ref_type}=${ref_name}")
    
    else()
      ## use the default (no ref)
      set(result "gitscm+${remote_uri}")
    endif()
    
    return_ref(result)
  endfunction()