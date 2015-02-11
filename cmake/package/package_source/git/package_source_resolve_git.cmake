## returns a pacakge descriptor for the specified git uri 
## takes long for valid uris because the whole repo needs to be checked out
function(package_source_resolve_git uri_string)
  set(args ${ARGN})

  uri("${uri_string}")
  ans(uri)

  package_source_query_git("${uri}" --package-handle)
  ans(package_handle)

  list(LENGTH package_handle count)
  
  if(NOT "${count}" EQUAL 1)
    return()
  endif()

  assign(remote_uri = package_handle.scm_descriptor.ref.uri)
  assign(rev = package_handle.scm_descriptor.ref.revision)

  git_cached_clone("${remote_uri}" --ref ${rev} --read package.cmake)
  ans(package_descriptor_content)

  json_deserialize("${package_descriptor_content}")
  ans(package_descriptor)

  map_tryget(${uri} file_name)
  ans(default_id)

  map_defaults("${package_descriptor}" "{
    id:$default_id,
    version:'0.0.0'
  }")
  ans(package_descriptor)

  map_set(${package_handle} package_descriptor ${package_descriptor})

  return_ref(package_handle)
endfunction()