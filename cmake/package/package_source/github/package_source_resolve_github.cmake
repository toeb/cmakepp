
  ## resolves the specifie package uri 
  ## and if uniquely identifies a package 
  ## returns its pacakge descriptor
  function(package_source_resolve_github uri)  
    set(github_api_token "?client_id=$ENV{GITHUB_DEVEL_TOKEN_ID}&client_secret=$ENV{GITHUB_DEVEL_TOKEN_SECRET}")

    ## get a single valid github package source uri
    ## or return
    package_source_query_github("${uri}")
    ans(valid_uri_string)

    list(LENGTH valid_uri_string uri_count)
    if(NOT ${uri_count} EQUAL 1)
      return()
    endif()



    uri("${valid_uri_string}")
    ans(valid_uri)

    ## get owner and repository and use it to format url
    assign(owner = valid_uri.normalized_segments[0])
    assign(repo = valid_uri.normalized_segments[1])

    set(api_uri "https://api.github.com")
    set(repo_uri "${api_uri}/repos/${owner}/${repo}${github_api_token}")

    ## get the repository descriptor
    http_get("${repo_uri}" "")
    ans(res)
    assign(content = res.content)
    json_deserialize("${content}")
    ans(repo_descriptor)


    ## try to get the package descriptor remotely
    set(ref master)
    set(path package.cmake)
    set(raw_uri "https://raw.githubusercontent.com/")
    set(package_descriptor_uri "${raw_uri}/${owner}/${repo}/${ref}/${path}" )

    http_get("${package_descriptor_uri}" "")
    ans(package_descriptor_response)

    assign(package_descriptor_content = package_descriptor_response.content)

    json_deserialize("${package_descriptor_content}")
    ans(package_descriptor)


    ## map default values on the packge descriptor 
    ## using the information from repo_descriptor
    assign(description = repo_descriptor.description)

    map_defaults("${package_descriptor}" "{
      id:$repo,
      version:'0.0.0',
      description:$description
    }")
    ans(package_descriptor)
    
    ## response
    map_new()
    ans(result)
    map_set(${result} package_descriptor "${package_descriptor}")
    map_set(${result} uri "${valid_uri_string}")
    map_set(${result} repo_descriptor "${repo_descriptor}")

    return_ref(result)
  endfunction()