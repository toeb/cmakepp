

  function(package_source_pull_svn uri)
    set(args ${ARGN})

    package_source_query_svn("${uri}")
    ans(valid_uri_string)

    list(LENGTH valid_uri_string uri_count)
    if(NOT uri_count EQUAL 1)
      return()
    endif()

    uri("${valid_uri_string}")
    ans(uri)


    uri_format("${uri}" --no-query --remove-scheme svnscm)
    ans(remote_uri)

    list_pop_front(args)
    ans(target_dir)
    path_qualify(target_dir)

    ## branch / tag / trunk / revision
    assign(svn_revision = uri.params.revision)
    assign(svn_branch = uri.params.branch)
    assign(svn_tag = uri.params.tag)
    if(NOT svn_revision STREQUAL "")
      set(svn_revision --revision "${svn_revision}")
    endif() 

    if(NOT svn_branch STREQUAL "")
      set(svn_branch --branch "${svn_branch}")
    endif() 

    if(NOT svn_tag STREQUAL "")
      set(svn_tag --tag "${svn_tag}")
    endif() 

    svn_cached_checkout("${remote_uri}" "${target_dir}" ${revision} ${branch} ${tag})
    ans(success)

    if(NOT success)
      return()
    endif()


    ## package_descriptor
    package_handle("${target_dir}")
    ans(package_handle)

    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)


    ## response
    map_new()
    ans(result)
    map_set("${result}" package_descriptor "${package_descriptor}")
    map_set("${result}" uri "${valid_uri_string}")
    map_set("${result}" content_dir "${target_dir}")
    return(${result})

  endfunction()

