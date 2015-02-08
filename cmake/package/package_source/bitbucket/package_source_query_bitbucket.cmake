## package_source_query_bitbucket(<~uri> [--package-handle])->
  function(package_source_query_bitbucket uri)
    set(args ${ARGN})

    list_extract_flag(args --package-handle)
    ans(return_package_handle)


    uri("${uri}")
    ans(uri)

    ## scheme needs to be empty or match bitbuckt
    assign(scheme = uri.scheme)
    if(NOT "${scheme}_" STREQUAL "_" AND NOT  "${scheme}" STREQUAL "bitbucket")
      return()
    endif()


    assign(segments = uri.normalized_segments)
    list_extract(segments owner repo)

    set(api_uri "https://api.bitbucket.org/2.0")

    if("${owner}_" STREQUAL "_")
      return()
    endif()

    if("${repo}_" STREQUAL "_")
      set(request_uri "${api_uri}/repositories/${owner}")
    else()
      set(request_uri "${api_uri}/repositories/${owner}/${repo}")
    endif() 
    
    http_get("${request_uri}" --return-code)
    ans(error)
    if(error)
      return()
    endif()

    if(NOT "${repo}_" STREQUAL "_")
      set(result "bitbucket:${owner}/${repo}")
    else()
      set(repos)
      while(true)
        map_tryget(${response} content)
        ans(content)
        
        json_extract_string_value(next "${content}")
        ans(next_uri)
      
        json_extract_string_value("name" "${content}")
        ans(names)

        list(APPEND repos ${names})

        if(NOT next_uri)
          break()
        endif()

        http_get("${next_uri}" --response)
        ans(response)
        map_tryget(${response} client_status)
        ans(error)
        if(error)
          message(WARNING "failed to query host ${next_uri} ${error}")
          return()
        endif()
      endwhile()   
      list_remove_duplicates(repos)
      list_remove(repos ssh https)# hack: these are different name properties

      set(result)
      ## possibly this should recursively check if the repo really exists
      foreach(repo ${repos})
        list(APPEND result "bitbucket:${owner}/${repo}")
      endforeach()
    endif()  

    return_ref(result)
  endfunction()
