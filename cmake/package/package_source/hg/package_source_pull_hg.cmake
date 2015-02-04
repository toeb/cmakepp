
  function(package_source_pull_hg uri)
    set(args ${ARGN})


    package_source_query_hg("${uri}" ${args})
    ans(valid_uri_string)
    
    list(LENGTH valid_uri_string uri_count)
    ## require single valid uri
    if(NOT uri_count EQUAL 1)
      return()
    endif()

    uri("${valid_uri_string}")
    ans(uri)


    uri_format("${uri}" --no-query --remove-scheme "hgscm")
    ans(remote_uri)

    list_pop_front(args)
    ans(target_dir)


    ## get ref
    assign(ref = uri.params.ref)
    assign(branch = uri.params.branch)  
    assign(tag = uri.params.tag)
    set(ref ${ref} ${branch} ${tag})
    list_pop_front(ref)
    ans(ref)

    hg_cached_clone("${target_dir}" "${remote_uri}" "${ref}")
    ans(target_dir)

    package_handle("${target_dir}")
    ans(package_handle)

    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)

    map_tryget(${uri} file_name)
    ans(default_id)

    map_defaults("${package_descriptor}" "{
      id:$default_id,
      version:'0.0.0'
    }")
    ans(package_descriptor)

    ## response
    map_new()
    ans(result)
    map_set(${result} package_descriptor ${package_descriptor})
    map_set(${result} uri "${valid_uri_string}")
    map_set(${result} content_dir "${target_dir}")

    return_ref(result)
  endfunction()