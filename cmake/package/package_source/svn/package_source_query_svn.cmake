
  function(package_source_query_svn uri)
    set(input_uri "${uri}")
    uri("${uri}")
    ans(uri)

    svn_uri_analyze("${uri}")
    ans(svn_uri)

    svn_uri_format_ref("${svn_uri}")
    ans(ref_uri)

    svn_remote_exists("${ref_uri}")
    ans(remote_exists)

    if(NOT remote_exists)
      return()
    endif()

    svn_uri_format_package_uri("${svn_uri}")
    ans(package_uri)

    return("svnscm+${package_uri}")
  endfunction()