
function(managed_package_source source_name directory)
  path_qualify(directory)
  obj("{
    source_name:$source_name,
    directory:$directory,
    pull:'package_source_pull_managed',
    push:'package_source_push_managed',
    query:'package_source_query_managed',
    resolve:'package_source_resolve_managed',
    delete:'package_source_delete_managed'
  }")
  return_ans()
endfunction()


