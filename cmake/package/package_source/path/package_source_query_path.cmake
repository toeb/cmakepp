## package_source_query_path(<uri> <?target_path>)
function(package_source_query_path uri)
  uri("${uri}")
  ans(uri)


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

  ## todo: change?
  if(NOT EXISTS "${path}/package.cmake")
    return()
  endif()

  ## create the valid result uri (file:///e/t/c)
  uri("${path}")
  ans(result)


  ## convert uri to string
  uri_format("${result}")
  ans(uri_string)

return_ref(uri_string)
endfunction()