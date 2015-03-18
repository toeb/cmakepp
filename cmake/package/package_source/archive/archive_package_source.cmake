##
##
##
function(archive_package_source)
  obj("{
    source_name:'archive',
    pull:'package_source_pull_archive',
    query:'package_source_query_archive',
    resolve:'package_source_resolve_archive',
    rate_uri:'package_source_rate_uri_archive'
  }")
  return_ans()
endfunction()

