## queries github to find all packages of a specified user 
## or a specific repository by owner/reponame
## returns a list of valid package uris
function(package_source_query_github uri)
  set(github_api_token "?client_id=$ENV{GITHUB_DEVEL_TOKEN_ID}&client_secret=$ENV{GITHUB_DEVEL_TOKEN_SECRET}")

  set(api_uri "https://api.github.com")

  ## parse uri and extract the two first segments 
  uri("${uri}")
  ans(uri)


  assign(scheme = uri.scheme)
  if(NOT "${scheme}" MATCHES "(^$)|(^github$)")
    return()
  endif()


  assign(segments = uri.normalized_segments)
  list_extract(segments user repo)
  if(NOT user)
    return()
  endif()
  
  if(repo)
    ## check if a single repository exists
    http_get("${api_uri}/repos/${user}/${repo}${github_api_token}" "")
    ans(res)
    assign(error = res.client_status)
    if(error)
      return()
    endif()
    return("github:${user}/${repo}")
  else()
    ## check for all repositories

    http_get("${api_uri}/users/${user}/repos${github_api_token}" "")
    ans(res)
    assign(error = res.client_status)
    if(error)
      return()
    endif()
    assign(content = res.content)
    
    ## this is a quick way to get all full_name fields of the unparsed json
    ## parsing large json files would be much too slow
    regex_escaped_string("\"" "\"") 
    ans(regex)
    set(full_name_regex "\"full_name\" *: ${regex}")
    string(REGEX MATCHALL  "${full_name_regex}" matches "${content}")
    set(github_urls)
    foreach(match ${matches})
      string(REGEX REPLACE "${full_name_regex}" "\\1" match "${match}")
      list(APPEND github_urls "github:${match}")
    endforeach() 


    return_ref(github_urls)
  endif()
endfunction()

