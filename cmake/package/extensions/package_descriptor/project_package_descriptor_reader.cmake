## `(<project>)-><void>`
##
## reads the package descriptor from a project local file if 
## `project_handle.project_descriptor.project_descriptor_file` is configured
function(project_package_descriptor_reader project)
  map_get_map(${project} package_descriptor)
  ans(package_descriptor)

  map_import_properties(${project} project_descriptor content_dir)
  map_import_properties(${project_descriptor} package_descriptor_file)

  if(NOT package_descriptor_file)
    return()
  endif()


  map_set_special(${project_descriptor} project_package_descriptor_was_read true)

  path_qualify_from("${content_dir}" "${package_descriptor_file}")
  ans(package_descriptor_file)


  log("reading package descriptor from '${package_descriptor_file}'" --function project_package_descriptor_reader)
  fread_data("${package_descriptor_file}")
  ans(new_package_descriptor)
  if(new_package_descriptor)
    map_copy_shallow("${package_descriptor}" "${new_package_descriptor}")
  else()
    log("could not read package descriptor from '${package_descriptor_file}'" --function project_package_descriptor_reader)
  endif()

endfunction()
