
## `(<project>)-><void>`
##  
## writes the package_descriptor to a package_descriptor_file
## if it is configured. does not overwrite package_descriptor_file
## if it was newly set
function(project_package_descriptor_writer project)
  map_import_properties(${project} project_descriptor content_dir)
  map_import_properties(${project_descriptor} package_descriptor_file)
  if(NOT package_descriptor_file)

    return()
  endif()
  map_get_special(${project_descriptor} project_package_descriptor_was_read)
  ans(was_read)


  path_qualify_from("${content_dir}" "${package_descriptor_file}")
  ans(package_descriptor_file)

    
  map_tryget(${project_handle} package_descriptor)
  ans(package_descriptor)

  if(NOT was_read)
    fread_data("${package_descriptor_file}")
    ans(new_package_descriptor)
    if(new_package_descriptor)
      map_copy_shallow(${package_descriptor} ${new_package_descriptor})
    endif()
  endif()


  if(package_descriptor)
    log("writing package descriptor to '${package_descriptor_file}'" --function project_package_descriptor_reader)
    fwrite_data("${package_descriptor_file}" ${package_descriptor})
  endif()


endfunction()
