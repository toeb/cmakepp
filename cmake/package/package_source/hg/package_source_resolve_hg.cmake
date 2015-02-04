

  function(package_source_resolve_hg uri)
    file_tempdir()
    ans(temp_dir)

    package_source_pull_hg("${uri}" "${temp_dir}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()


    return_ref(package_handle)
  endfunction()
