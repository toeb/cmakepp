## `(<uri> [<target dir>])-> <package handle>`
##
## pulls the specified host package into the target_dir
## this functions currently just creates a directory with nothing in it
function(package_source_pull_host uri)
  set(args ${ARGN})
  uri_coerce(uri)
  package_source_resolve_host("${uri}")
  ans(package_handle)

  list_pop_front(args)
  ans(target_dir)
  if(NOT package_handle)
    return()
  endif()

  path_qualify(target_dir)

  mkdir("${target_dir}")

  assign(package_handle.content_dir = target_dir)

  return_ref(package_handle)
endfunction()