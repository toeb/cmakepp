## package_source_query_path(<uri> <?target_path>)
function(package_source_query_path uri)
  set(args ${ARGN})

  uri("${uri}")
  ans(uri)

  list_extract_flag(args --package-handle)
  ans(return_package_handle)



  ## check that uri is local
  map_tryget("${uri}" "normalized_host")
  ans(host)

  if(NOT "${host}" STREQUAL "localhost")
    return()
  endif()   

  ## get localpath from uri and check that it is a dir and cotnains a package_descriptor
  uri_to_localpath("${uri}")
  ans(path)

  path("${path}")
  ans(path)

  if(NOT IS_DIRECTORY "${path}")
    return()
  endif()

  ## compute hash
  set(content)

  set(package_descriptor)
  if(EXISTS "${path}/package.cmake")
    json_read("${path}/package.cmake")
    ans(package_descriptor)
  endif()
  
  assign(default_id = uri.last_segment)
  map_defaults("${package_descriptor}" "{id:$default_id,version:'0.0.0'}")
  ans(package_descriptor)
  assign(content = package_descriptor.content)

  if(content)
    pushd("${path}")
      checksum_glob_ignore(${content})
      ans(hash)
    popd()
  else()
    checksum_dir("${path}")
    ans(hash)
  endif()

  assign(expected_hash = uri.params.hash)

  if(expected_hash AND NOT "${hash}" STREQUAL "${expected_hash}")
    error("hashes did not match for ${path}")
    return()
  endif()

  ## create the valid result uri (file:///e/t/c)
  uri("${path}?hash=${hash}")
  ans(result)

  ## convert uri to string
  uri_format("${result}")
  ans(result)

  if(return_package_handle)
    set(package_handle)
    assign(!package_handle.uri = result)
    assign(!package_handle.query_uri = uri.uri)
    assign(!package_handle.package_descriptor = package_descriptor)
    assign(!package_handle.directory_descriptor.hash = hash)
    assign(!package_handle.directory_descriptor.path = path)
    assign(!package_handle.directory_descriptor.pwd = pwd())

    set(result ${package_handle})
  endif()

return_ref(result)
endfunction()