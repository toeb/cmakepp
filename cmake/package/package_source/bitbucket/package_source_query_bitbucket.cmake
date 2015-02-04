
  function(package_source_query_bitbucket uri)
    uri("${uri}")
    ans(uri)

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
    
    http_get("${request_uri}" "")
    ans(response)
    map_tryget(${response} client_status)
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

        http_get("${next_uri}" "")
        ans(response)
        map_tryget(${response} client_status)
        ans(error)
        if(error)
          message(WARNING "failed to query host ${next_uri} ${error}")
          return()
        endif()


      endwhile()      

      list(REMOVE_DUPLICATES repos)
      list(REMOVE_ITEM repos ssh https) # hack: these are different names
      set(result)
      ## possibly this should recursively check if the repo really exists
      foreach(repo ${repos})
        list(APPEND result "bitbucket:${owner}/${repo}")
      endforeach()
    endif()  

    return_ref(result)
  endfunction()
