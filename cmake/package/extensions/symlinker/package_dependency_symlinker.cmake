## `(<project handle> <package handle> [---unlink])-><void>`
##
## adds a symlink from dependees package folder to dependencies content folder 
## the symlink is relative to the package folder and configured in the package's dependency constraints using the symlink property
## 
## `{ id:'mypkg', dependencies:'some-dependency':{symlink:'pkg1'}}` this will cause the content of some-dependency to be symlinked to <package root>/pkg1
## 
## the symlinker is automatically executed when a package becomes ready (and unready)
## 
function(package_dependency_symlinker project package)
  set(args ${ARGN})
  list_extract_flag_name(args --unlink)
  ans(unlink)
  map_import_properties(${package} dependencies package_descriptor content_dir)
  map_tryget(${package_descriptor} dependencies)
  ans(dependency_constraints)
  map_keys(${dependencies})
  ans(dependency_uris)

  ## loop through all admissable uris and get the dependency as well as the constraints
  foreach(dependency_uri ${dependency_uris})
    map_tryget(${dependencies} ${dependency_uri})
    ans(dependency)
    map_tryget(${dependency_constraints} ${dependency_uri})
    ans(constraints)

    ## if the constraints have the symlink property the symlinker
    ## creates a link from the dependee's content_dir/${symlink} to the dependencies ${content_dir}
    map_has(${constraints} symlink)
    ans(has_content_dir)
    if(has_content_dir)
      map_tryget(${constraints} symlink)
      ans(symlink)

      path_qualify_from(${content_dir} ${symlink})
      ans(symlink)

      map_tryget(${dependency} content_dir)
      ans(dependency_content_dir)
      print_vars(symlink dependency_content_dir unlink)

      ## creates the link
      ln("${dependency_content_dir}" "${symlink}" ${unlink})

    endif()
  endforeach()
endfunction()


## register the symlinker to act on package ready/unready
function(__package_dependency_symlinker)
  event_addhandler(project_on_package_ready package_dependency_symlinker)
  event_addhandler(project_on_package_unready "[]() package_dependency_symlinker({{ARGN}} --unlink)")
endfunction()
task_enqueue(__package_dependency_symlinker)