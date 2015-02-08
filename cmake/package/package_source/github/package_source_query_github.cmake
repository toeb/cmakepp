

## queries github to find all packages of a specified user 
## or a specific repository by owner/reponame
## returns a list of valid package uris
function(package_source_query_github uri)
  set(args ${ARGN})

  list_extract_flag(args --package-handle)
  ans(return_package_handle)


  ## parse uri and extract the two first segments 
  uri("${uri}")
  ans(uri)


  assign(scheme = uri.scheme)
  if(NOT "${scheme}_" STREQUAL "_" AND NOT "${scheme}" STREQUAL "github")
    return()
  endif()


  assign(segments = uri.normalized_segments)
  list_extract(segments user repo ref_type ref)
  if(NOT user)
    return()
  endif()
  set(package_handles)
  if(repo)
    ## check if a single repository exists
    github_api("repos/${user}/${repo}" --response)
    ans(response)
    map_tryget(${response} client_status)
    ans(error)
    if(error)
      return()
    endif()
#    set(package_handles "github:${user}/${repo}")
    assign(hash = uri.params.hash)
    if(hash)
      github_api("repos/${user}/${repo}/commits/${hash}" --return-code)
      ans(error)

     # http_get("${api_uri}/repos/${user}/${repo}/commits/${hash}${github_api_token}" --return-code)
      if(error)
        return()
      endif()
      set(package_handles "github:${user}/${repo}?hash=${hash}")
    elseif(ref_type AND ref)
      github_api("repos/${user}/${repo}/${ref_type}/${ref}" --json --silent-fail)
      ans(result)
      if(NOT result)
        return()
      endif()
      assign(hash = result.commit.sha)
      set(package_handles "github:${user}/${repo}/${ref_type}/${ref}?hash=${hash}")

    else()
      set(tags)
      set(branches)
      if(NOT ref_type OR "${ref_type}" STREQUAL "tags")
        github_api("repos/${user}/${repo}/tags" --json)
        ans(tags)
      endif()
      if(NOT ref_type OR "${ref_type}" STREQUAL "branches")
        github_api("repos/${user}/${repo}/branches" --json)
        ans(branches)
      endif()
      set(package_handles)
      foreach(tag ${tags})
        assign(name = tag.name)
        assign(hash = tag.commit.sha)
        list(APPEND package_handles "github:${user}/${repo}/tags/${name}?hash=${hash}")
      endforeach()

      foreach(branch ${branches})
        assign(name = branch.name)
        assign(hash = branch.commit.sha)
        list(APPEND package_handles "github:${user}/${repo}/branches/${name}?hash=${hash}")
      endforeach()

    endif()


  else()
    ## check for all repositories

    github_api("users/${user}/repos" --response)
    ans(res)
    assign(error = res.client_status)
    if(error)
      return()
    endif()
    assign(content = res.content)

    
    ## this is a quick way to get all full_name fields of the unparsed json
    ## parsing large json files would be much too slow
    json_extract_string_value(full_name "${content}")
    ans(full_names)
    json_extract_string_value(default_branch "${content}")
    ans(default_branches)
    foreach(full_name ${full_names})
      list_pop_front(default_branches)
      ans(default_branch)
      list(APPEND package_handles "github:${full_name}/branches/${default_branch}")
    endforeach() 
  endif()


    if(return_package_handle)
      set(uris ${package_handles})
      set(package_handles)
      foreach(github_url ${uris})
        set(package_handle)
        assign(!package_handle.uri = github_url)
        assign(!package_handle.query_uri = uri.uri)
        list(APPEND package_handles ${package_handle})
      endforeach()
      return_ref(package_handles)
    endif()
    return_ref(package_handles)
endfunction()

