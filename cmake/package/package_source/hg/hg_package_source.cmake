
  function(hg_package_source)
    obj("{
      source_name:'hgscm',
      pull:'package_source_pull_hg',
      query:'package_source_query_hg',
      resolve:'package_source_resolve_hg'
    }")
    return_ans()
  endfunction()

