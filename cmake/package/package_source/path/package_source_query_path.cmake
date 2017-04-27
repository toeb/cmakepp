## package_source_query_path(<uri> <?target_path>)
function(package_source_query_path uri)
  set(args ${ARGN})

  uri_coerce(uri)

  list_extract_flag(args --package-handle)
  ans(return_package_handle)



  ## check that uri is local
  map_tryget("${uri}" "normalized_host")
  ans(host)

  if(NOT "${host}" STREQUAL "localhost")
    return()
  endif()   

  uri_check_scheme("${uri}" "file?")
  ans(scheme_ok)
  if(NOT scheme_ok)
    error("path package query only accepts file and <none> as a scheme")
    return()
  endif()

  map_import_properties(${uri} query)
  
 if(NOT "_${query}" MATCHES "(^_$)|(_hash=[0-9a-zA-Z]+)")
    error("path package source only accepts a hash query in the uri.")
    return()
  endif()

  ## get localpath from uri and check that it is a dir and cotnains a package_descriptor
  uri_to_localpath("${uri}")
  ans(path)

  path_qualify(path)

  if(NOT IS_DIRECTORY "${path}")
    return()
  endif()


  ## old style package descriptor
  json_read("${path}/package.cmake")
  ans(package_descriptor)
  if(NOT package_descriptor)
    ## tries to open the package descriptor
    ## in any other format
    fopen_data("${path}/package")
    ans(package_descriptor)
  endif()
  


  ## compute hash
  set(content)


  
  assign(default_id = uri.last_segment)
  map_defaults("${package_descriptor}" "{id:$default_id,version:'0.0.0'}")
  ans(package_descriptor)
  assign(content = package_descriptor.content)

  if(content)
    pushd("${path}")
      checksum_glob_ignore(${content} --recurse)
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