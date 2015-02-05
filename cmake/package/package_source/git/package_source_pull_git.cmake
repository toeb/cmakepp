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


    assign(remote_uri = package_handle.scm_descriptor.ref.uri)
    assign(revision = package_handle.scm_descriptor.ref.revision)

    git_cached_clone("${remote_uri}" "${target_dir}" --ref "${revision}" ${args})
    ans(target_dir)

    map_set(${package_handle} content_dir "${target_dir}")

    return_ref(package_handle)
  endfunction()   

