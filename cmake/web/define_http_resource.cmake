
  function(define_http_resource function method uri_string)
    uri("${uri_string}")
    ans(uri)

    map_tryget("${uri}" scheme_specific_part)
    ans(scheme_specific_part)
    map_tryget("${uri}" scheme)
    ans(scheme)

    string(REGEX MATCHALL ":([a-zA-Z][a-zA-Z0-9_]*)" replaces "${scheme_specific_part}")

    list_remove_duplicates(replaces)

    set(function_args "")

    foreach(replace ${replaces})
      string(REGEX REPLACE ":([a-zA-Z][a-zA-Z0-9_]*)" "\\1" name "${replace}")
      string(REPLACE "${replace}" "\${${name}}" uri_string "${uri_string}")
      set(function_args "${function_args} ${name}")
    endforeach()    

    set(code "
      function(${function}${function_args})
        set(args \${ARGN})

        list_extract_flag(args --response)
        ans(return_response)

        list_extract_flag(args --json)        
        ans(return_json)

        list_extract_flag(args --silent-fail)
        ans(silent_fail)


        list_extract_flag(args --return-code)
        ans(return_return_code)

        set(resource_uri \"${uri_string}\")

        http_${method}(\"\${resource_uri}\" \${args})
        ans(response)

        if(return_response)
          return_ref(response)
        endif()

        assign(error = res.client_status)

        if(return_return_code)
          return_ref(error)
        endif()
        if(error)
            error(\"failed to perform http request. client error: \${error}\")
          if(NOT silent_fail)
            message(FATAL_ERROR \"failed to perform http request. client error: \${error}\")
          endif()
          return()
        endif()

        assign(content = res.content)

        if(return_json)
          json_deserialize(\"\${content}\")
          ans(content)
        endif()
        return_ref(content)
      endfunction()
    ")
    eval("${code}")
    return()

  endfunction()