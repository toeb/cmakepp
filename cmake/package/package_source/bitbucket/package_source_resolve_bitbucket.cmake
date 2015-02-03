
  function(package_source_resolve_bitbucket uri)
    uri("${uri}")
    ans(uri)
    
    ## query for a valid and single  bitbucket uris 
    package_source_query_bitbucket("${uri}")
    ans(valid_uri_string)
    list(LENGTH valid_uri_string uri_count)
    if(NOT uri_count EQUAL 1)
      return()
    endif()

    ## get owner repo and ref
    uri("${valid_uri_string}")
    ans(valid_uri)

    map_tryget(${valid_uri} normalized_segments)
    ans(segments)

    list_extract(segments owner repo ref)


    ## get repo descriptor (return if not found)
    set(api_uri "https://api.bitbucket.org/2.0")
    set(request_uri "${api_uri}/repositories/${owner}/${repo}" )

    http_get("${request_uri}" "" --json)
    ans(repo_descriptor)

    if(NOT repo_descriptor)
      return()
    endif()

    ## if no ref is set query the bitbucket api for main branch
    if("${ref}_" STREQUAL "_")
      ## get the main branch
      set(main_branch_request_uri "https://api.bitbucket.org/1.0/repositories/${owner}/${repo}/main-branch")

      http_get("${main_branch_request_uri}" "" --json)
      ans(response)
      assign(main_branch = response.name)
      set(ref "${main_branch}")  
    endif()

    ## try to get an existing package descriptor
    set(raw_uri "https://bitbucket.org/${owner}/${repo}/raw/${ref}/${path}")

    set(path package.cmake)
    http_get("${raw_uri}" "" --json)
    ans(package_descriptor)

    ## setup package descriptor default value

    map_defaults("${package_descriptor}" "{
      id:$repo_descriptor.full_name, 
      version:'0.0.0',
      description:$repo_descriptor.description
    }")
    ans(package_descriptor)

    ## response
    map_new()
    ans(result)
    map_set(${result} package_descriptor "${package_descriptor}")
    map_set(${result} uri "${valid_uri_string}")
    map_set(${result} repo_descriptor "${repo_descriptor}")

    return(${result})
  endfunction()