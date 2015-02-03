## returns a pacakge descriptor for the specified git uri 
## takes long for valid uris because the whole repo needs to be checked out
function(package_source_resolve_git uri_string)
  set(args ${ARGN})

  file_tempdir()
  ans(temp_dir)

  package_source_pull_git("${uri_string}" "${temp_dir}")
  ans(res)

  if(NOT res)
    return()
  endif() 
  
  return_ref(res)
endfunction()