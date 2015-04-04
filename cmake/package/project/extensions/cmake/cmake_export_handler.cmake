## ``
##
## exports (includes) all files spcified in `package_descriptor.cmake.export` glob ignore expressions
## which allow  the project to have access to the cmake specified
function(cmake_export_handler project_handle package_handle)

  ## load the exports and includes them once
  assign(content_dir = package_handle.content_dir)
  assign(export = package_handle.package_descriptor.cmake.export)
  if(IS_DIRECTORY "${content_dir}")
    pushd("${content_dir}")
      glob_ignore(${export})
      ans(paths)
    popd()

    log("{package_handle.uri}: loading exports '${paths}'" --trace --function cmake_export_handler)
    foreach(path ${paths})
      include_once("${path}")
    endforeach()
  endif()
endfunction()