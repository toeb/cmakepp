
  function(svn_package_source)
    obj("{
      source_name:'svnscm',
      pull:'package_source_pull_svn',
      query:'package_source_query_svn',
      resolve:'package_source_resolve_svn'
    }")
    return_ans()
  endfunction()
