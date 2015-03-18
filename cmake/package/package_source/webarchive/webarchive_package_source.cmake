

  function(webarchive_package_source)
    obj("{
      source_name:'webarchive',
      pull:'package_source_pull_webarchive',
      query:'package_source_query_webarchive',
      resolve:'package_source_resolve_webarchive',
      rate_uri:'package_source_rate_uri_webarchive'
    }")
    return_ans()
  endfunction()

