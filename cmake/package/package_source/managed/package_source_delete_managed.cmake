function(package_source_delete_managed uri)
  uri_coerce(uri)

  package_source_resolve_managed("${uri}")
  ans(package_handle)


  if(NOT package_handle)
    return(false)
  endif()

  assign(location = package_handle.managed_descriptor.managed_dir)
  if(NOT EXISTS "${location}")
    message(FATAL_ERROR "the package is known but its directory does not exist")
  endif()

  rm(-r "${location}")

  return(true)
endfunction()