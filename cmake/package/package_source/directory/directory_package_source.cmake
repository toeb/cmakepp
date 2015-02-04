
  function(directory_package_source source_name directory)
    path_qualify(directory)
    obj("{
      source_name:$source_name,
      directory:$directory,
      pull:'package_source_pull_directory',
      query:'package_source_query_directory',
      resolve:'package_source_resolve_directory'
    }")
    return_ans()
  endfunction()
