
  function(github_package_source)
    obj("{
      source_name:'github',
      pull:'package_source_pull_github',
      query:'package_source_query_github',
      resolve:'package_source_resolve_github'
    }")
    return_ans()
  endfunction()

