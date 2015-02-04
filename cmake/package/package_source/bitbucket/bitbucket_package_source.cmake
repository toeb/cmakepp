  function(bitbucket_package_source)
    obj("{
      source_name:'bitbucket',
      pull:'package_source_pull_bitbucket',
      query:'package_source_query_bitbucket',
      resolve:'package_source_resolve_bitbucket'
    }")
    return_ans()
  endfunction()

