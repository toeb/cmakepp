


  function(package_source_push_archive package_handle uri)
    set(args ${ARGN})

    ## parse and extract package_descriptor and package dir
    package_handle("${package_handle}")
    ans(package_handle)

    if(NOT package_handle)
      return()
    endif()

    map_tryget("${package_handle}" package_descriptor)
    ans(package_descriptor)

    map_tryget("${package_handle}" content_dir)
    ans(source_dir)


    uri("${uri}")
    ans(uri)

    ## get fully qualified local path
    uri_to_localpath("${uri}")
    ans(archive_path)
    path_qualify(archive_path)

    ## copy package content to a temporary directory
    file_tempdir()
    ans(temp_dir)

    package_source_push_path("${source_dir};${package_descriptor}" "${temp_dir}" --force)


    ## pass format along
    list_extract_labelled_keyvalue(args --format)
    ans(format)

    ## compress all files in temp_dir into package
    pushd("${temp_dir}")
      compress("${archive_path}" "**" ${format})
    popd()

    ## delete temp dir
    rm("${temp_dir}")

    ## return valid package uri
    uri_format("${archive_path}")
    ans(result)

    return_ref(result)
  endfunction()