## package_source_pull_git(<~uri> <path?>)
## pulls the package described by the uri  into the target_dir
## e.g.  package_source_pull_git("https://github.com/toeb/cutil.git?ref=devel")
  function(package_source_pull_git uri)
    set(args ${ARGN})

    package_source_query_git("${uri}")
    ans(valid_uri_string)
    list(LENGTH valid_uri_string uri_count)
    ## require single valid uri
    if(NOT uri_count EQUAL 1)
      return()
    endif()

    uri("${valid_uri_string}")
    ans(uri)


    uri_format("${uri}" --no-query --remove-scheme gitscm)
    ans(remote_uri)

    list_pop_front(args)
    ans(target_dir)
    path_qualify(target_dir)

    ## get ref
    assign(ref = uri.params.ref)
    assign(branch = uri.params.branch)  
    assign(tag = uri.params.tag)
    set(ref ${ref} ${branch} ${tag})
    list_pop_front(ref)
    ans(ref)


    git_cached_clone("${target_dir}" "${remote_uri}" "${ref}")
    ans(target_dir)

    package_handle("${target_dir}")
    ans(package_handle)

    map_tryget(${uri} file_name)
    ans(default_id)

    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)

    map_defaults("${package_descriptor}" "{
      id:$default_id,
      version:'0.0.0'
    }")
    ans(package_descriptor)

    map_new()
    ans(package_handle)
    map_set(${package_handle} package_descriptor "${package_descriptor}")
    map_set(${package_handle} uri "${valid_uri_string}")
    map_set(${package_handle} content_dir "${target_dir}")


    return_ref(package_handle)
  endfunction()   

