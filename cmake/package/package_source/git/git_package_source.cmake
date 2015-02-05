

  function(git_package_source)
    obj("{
      source_name:'gitscm',
      pull:'package_source_pull_git',
      query:'package_source_query_git',
      resolve:'package_source_resolve_git'
    }")
    return_ans()
  endfunction()
