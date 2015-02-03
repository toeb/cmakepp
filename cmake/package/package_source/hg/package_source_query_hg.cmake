
  function(package_source_query_hg uri)
    uri("${uri}")
    ans(uri)

    map_tryget("${uri}" schemes)
    ans(scheme)

    list_extract_flag(scheme hgscm)
    ans(is_hgscm)

    map_set(${uri} scheme "${scheme}")

    list(LENGTH scheme scheme_count)
    if(scheme_count GREATER 1)
      ## only one scheme is allowed
      return()
    endif()

    uri_qualify_local_path("${uri}")
    ans(uri)

    uri_format("${uri}" --no-query --remove-scheme hgscm)
    ans(remote_uri)

    ## check if remote exists
    hg_remote_exists("${remote_uri}")
    ans(remote_exists)


    if(NOT remote_exists)
      return()
    endif()

    ## get ref 
    assign(ref = uri.params.ref)
    assign(branch = uri.params.branch)
    assign(tag = uri.params.tag)
    set(ref ${ref} ${branch} ${tag})
    list_pop_front(ref)
    ans(ref)

    if(NOT ref STREQUAL "")
      ## need to checkout

      if(ref STREQUAL "*")
        message(FATAL_ERROR "ref query currently not allowed for hg")
      endif()
      set(result "hgscm+${remote_uri}?ref=${ref}")
    else()
      set(result "hgscm+${remote_uri}")
    endif()

    return_ref(result)
  endfunction() 