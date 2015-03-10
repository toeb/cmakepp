
  function(package_source_resolve_svn uri)
    package_source_query_svn("${uri}")
    ans(valid_uri_string)
    list(LENGTH valid_uri_string uri_count)

    if(NOT uri_count EQUAL 1)
      return()
    endif()



    svn_uri_analyze("${valid_uri_string}")
    ans(svn_uri)

    map_import_properties(${svn_uri} base_uri ref_type ref revision)

    string(REGEX REPLACE "^svnscm\\+" "" base_uri "${base_uri}")
    if(NOT revision)
      set(revision HEAD)
    endif()


    if("${ref_type}" STREQUAL "branch")
      set(ref_type branches)
    elseif("${ref_type}" STREQUAL "tag")
      set(ref_type tags)
    endif()
    set(checkout_uri "${base_uri}/${ref_type}/${ref}/package.cmake@${revision}")
    
    fwrite_temp("")
    ans(tmp)
    rm(${tmp})
    svn(export "${checkout_uri}" "${tmp}" --exit-code)
    ans(error)

    if(NOT error)
      package_handle("${tmp}")
      ans(package_handle)

      map_tryget("${package_handle}" package_descriptor)
      ans(package_descriptor)
      rm(tmp)
    endif()

    string(REGEX MATCH "[^/]+$" default_id "${base_uri}")

    map_defaults("${package_descriptor}" "{
      id:$default_id,
      version:'0.0.0'
    }")
    ans(package_descriptor)
    ## response
    map_new()
    ans(package_handle)

    map_set(${package_handle} package_descriptor "${package_descriptor}")
    map_set(${package_handle} uri "${valid_uri_string}")

    return_ref(package_handle)
  endfunction()