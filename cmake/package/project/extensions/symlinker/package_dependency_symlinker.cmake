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
  list_extract_flag(args --unlink)
  ans(unlink)
  map_import_properties(${package} dependencies package_descriptor content_dir)
  map_tryget(${package_descriptor} dependencies)
  ans(dependency_constraints)
  if(NOT dependencies)
    return()
  endif()
  
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
    ans(has_symlink)
    if(has_symlink)
      map_tryget(${constraints} symlink)
      ans(symlink)

      is_address("${symlink}")
      ans(isref)
      if(NOT isref)
        set(single_link "${symlink}")
        map_new()
        ans(symlink)
        map_set("${symlink}" "${single_link}" ".")
      endif()

      map_keys("${symlink}")
      ans(links)

      foreach(link ${links})          
        map_tryget("${symlink}" "${link}")
        ans(target)

        ## dependency
        ## project 
        ## package
        format("${link}")
        ans(relative_link)
        format("${target}")
        ans(relative_target)

        path_qualify_from("${content_dir}" "${relative_link}")
        ans(link)

        map_tryget(${dependency} content_dir)
        ans(dependency_content_dir)

        path_qualify_from("${dependency_content_dir}" "${relative_target}")
        ans(target)
        ## creates or destroys the link
        if(unlink)
         log("unlinking '${link}' from '${target}' ({package.uri})" --function package_dependency_symlinker)
          unlink("${link}")
        else()
          ## ensure that directory exists
          get_filename_component(dir "${link}" PATH)
          if(NOT EXISTS "${dir}")
            mkdir("${dir}")
          endif()
          log("linking '${link}' to '${target}' ({package.uri})" --function package_dependency_symlinker)
          ln("${target}" "${link}")
          ans(success)
          if(NOT success)
           error("failed to link '${link}' to '${target}' ({package.uri})" --function package_dependency_symlinker)
          endif()
        endif()

      endforeach()
    endif()
  endforeach()
endfunction()

