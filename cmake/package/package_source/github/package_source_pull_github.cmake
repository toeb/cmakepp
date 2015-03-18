## package_source_pull_github(<~uri> <?target_dir>) -> <package handle>
function(package_source_pull_github uri)
  set(args ${ARGN})
  uri_coerce(uri)
  log("pulling {uri.uri}" --trace --function package_source_pull_github)  

  ## get package descriptor 
  package_source_resolve_github("${uri}")
  ans(package_handle)
  if(NOT package_handle)
    return()
  endif()

  ## get path
  list_pop_front(args)
  ans(target_dir)
  path_qualify(target_dir)

  ## retreive the hidden/special repo_descriptor
  ## to gain access to the clone url
  map_tryget(${package_handle} github_descriptor)
  ans(repo_descriptor)

  map_tryget(${package_handle} package_descriptor)
  ans(package_descriptor)

  ## alternatives git_url/clone_url
  map_tryget(${repo_descriptor} clone_url)
  ans(clone_url)

  package_source_pull_git("${clone_url}" "${target_dir}")
  ans(scm_package_handle)

  if(NOT scm_package_handle)
    return()
  endif()

  map_tryget("${scm_package_handle}" package_descriptor)
  ans(scm_package_descriptor)

  assign(package_handle.repo_descriptor = scm_package_handle.repo_descriptor)

  map_defaults("${package_descriptor}" "${scm_package_descriptor}")

  map_tryget("${scm_package_handle}" content_dir)
  ans(scm_content_dir)

  map_set("${package_handle}" content_dir "${scm_content_dir}")

  return_ref(package_handle)

endfunction()