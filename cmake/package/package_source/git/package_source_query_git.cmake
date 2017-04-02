
parameter_definition(
  package_source_query_git 
  <uri{"the query uri of a git package"}:<uri>> 
  [--package-handle{"if set, return a package handle instead of <unique_uri>"}=>return_package_handle]
  "#returns a list of valid `<package uri>`s. You can specify a query for ref/branch/tag by adding `?ref=*`, `?ref=name`, `?ref=<hash>`. Only when using `?ref=*` are multiple `<package uri>`s returned."
)
function(package_source_query_git)
  arguments_extract_defined_values(0 ${ARGC} package_source_query_git)
  ans(args)

  uri_coerce(uri)

  log("git_package_source: querying for {uri.uri}" --trace)


  uri_qualify_local_path("${uri}")
  ans(uri)

  uri_format("${uri}" --no-query)
  ans(remote_uri)

  ## check if remote exists
  git_remote_exists("${remote_uri}")
  ans(remote_exists)


  ## remote does not exist
  if(NOT remote_exists)
    log("git_package_source: remote '{remote_uri}' does not exist")
    return()
  endif()

  ## get ref and check if it exists
  assign(ref = uri.params.ref)
  assign(branch = uri.params.branch)  
  assign(tag = uri.params.tag)
  assign(rev = uri.params.rev)

  ## todo: check if unused params are passed
  ## which should result in a warning


  set(ref ${ref} ${branch} ${tag})
  list_pop_front(ref)
  ans(ref)

  set(remote_refs)
  if(NOT "${rev}_" STREQUAL "_")
    ## todo validate rev furhter??
    if(NOT "${rev}" MATCHES "^[a-fA-F0-9]+$")
       error("git_package_source: invalid revision for {uri.uri}: '{rev}'")
      return()
    endif()

    obj("{
      revision:$rev,
      type:'rev',
      name:$rev,
      uri:$remote_uri  
    }")

    ans(remote_refs)
  elseif("${ref}_" STREQUAL "*_")
    ## get all remote refs and format a uri for every found tag/branch
    git_remote_refs("${remote_uri}")
    ans(refs)

    foreach(ref ${refs})
      map_tryget(${ref} type)
      ans(ref_type)
      if("${ref_type}" MATCHES "(tags|heads)")
        list(APPEND remote_refs ${ref})
      endif()
    endforeach()
  elseif(NOT "${ref}_" STREQUAL "_")
    ## ensure that the specified ref exists and return a valid uri if it does
    git_remote_ref("${remote_uri}" "${ref}" "*")
    ans(remote_refs)
  else()

    git_remote_ref("${remote_uri}" "HEAD" "*")
    ans(remote_refs)
  endif()


  ## generate result from the scm descriptors
  set(results)
  foreach(remote_ref ${remote_refs})
    git_scm_descriptor("${remote_ref}")
    ans(scm_descriptor)
    assign(rev = scm_descriptor.ref.revision)
    set(result "${remote_uri}?rev=${rev}")
    log("git_package_source: query '{uri.uri}' found '{result}'" --trace)
    if(return_package_handle)
      set(package_handle)
      assign(!package_handle.uri = result)
      assign(!package_handle.scm_descriptor = scm_descriptor)
      assign(!package_handle.query_uri = uri.uri)
      set(result ${package_handle})
    endif()
    list(APPEND results ${result})
  endforeach()


  
  return_ref(results)
endfunction()