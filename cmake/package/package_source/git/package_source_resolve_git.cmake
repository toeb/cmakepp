## returns a pacakge descriptor for the specified git uri 
## takes long for valid uris because the whole repo needs to be checked out
parameter_definition(
  package_source_resolve_git 
  <uri{"the query uri of a git package"}:<uri>> 
)
function(package_source_resolve_git)
  arguments_extract_defined_values(0 ${ARGC} package_source_resolve_git)
  ans(args) 
  
  log("package_source_resolve_git: resolving '{uri.uri}'...")

  package_source_query_git("${uri}" --package-handle)
  ans(package_handle)

  list(LENGTH package_handle count)
  
  if(NOT "${count}" EQUAL 1)
    error("could not get a unqiue uri for '{uri.uri}' (got {count})")
    return()
  endif()

  assign(remote_uri = package_handle.scm_descriptor.ref.uri)
  assign(rev = package_handle.scm_descriptor.ref.revision)
  assign(type = package_handle.scm_descriptor.ref.type)
  assign(default_version = package_handle.scm_descriptor.ref.name)
  ## tries to extract version from tag information by parsing the tag name
  if("${type}" STREQUAL "tags")
    semvers_extract("${default_version}")
    ans_extract(semver)
    if(semver)
      assign(default_version = semver.string)
    else()
      set(default_version "0.0.0")
    endif()
  else()
    set(default_version "0.0.0")
  endif()

  ## uses the uri filename as the default package name
  map_tryget(${uri} file_name)
  ans(default_id)

  ##  try to get package descriptor
  git_cached_clone("${remote_uri}" --ref ${rev} --read package.cmake)
  ans(package_descriptor_content)

  json_deserialize("${package_descriptor_content}")
  ans(package_descriptor)
  


  map_defaults("${package_descriptor}" "{
    id:$default_id,
    version:$default_version
  }")
  ans(package_descriptor)

  map_set(${package_handle} package_descriptor ${package_descriptor})

  log("package_source_resolve_git: successfully resolved {package_descriptor.id}@{package_descriptor.version}")

  return_ref(package_handle)
endfunction()