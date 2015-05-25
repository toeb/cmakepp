## package_source_pull_git(<~uri> <path?>) -> <package handle>
##
## pulls the package described by the uri  into the target_dir
## e.g.  package_source_pull_git("https://github.com/toeb/cutil.git?ref=devel")
function(package_source_pull_git uri)
  set(args ${ARGN})

  list_pop_front(args)
  ans(target_dir)

  path_qualify(target_dir)

  package_source_resolve_git("${uri}")
  ans(package_handle)

  if(NOT package_handle)
    return()
  endif()


  is_git_dir("${target_dir}")
  ans(is_git)

  if(is_git)
    log("'${target_dir}' is already a git repository. checking if it is the same")
    package_source_resolve_git("${target_dir}")
    ans(target_repo)
    assign(target_revision = target_repo.scm_descriptor.ref.revision)
    assign(package_revision = package_handle.scm_descriptor.ref.revision)
    if("${target_revision}_" STREQUAL "${package_revision}_")
      log("'${target_dir}' is already a git repository is already up to date.")
      map_set(${package_handle} content_dir "${target_dir}")
      return_ref(package_handle)
    endif()
    log("removing '${target_dir}' because it is incompatible with {uri.uri}")

    rm(-r "${target_dir}")
    ##http://stackoverflow.com/questions/2411031/how-do-i-clone-into-a-non-empty-directory
  endif()

  assign(remote_uri = package_handle.scm_descriptor.ref.uri)
  assign(revision = package_handle.scm_descriptor.ref.revision)

  git_cached_clone("${remote_uri}" "${target_dir}" --ref "${revision}" ${args})
  rethrow(true)
  ans(target_dir)

  map_set(${package_handle} content_dir "${target_dir}")

  return_ref(package_handle)
endfunction()   

