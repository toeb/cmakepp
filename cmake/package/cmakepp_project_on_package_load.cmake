
##
##
## imports all files specified in the package_handle's 
## package_descriptor.cmakepp.export property relative
## to the package_handle.content_dir.  the files are
## included in which they were globbed.
##
## hooks:
##   package_descriptor.cmakepp.hooks.on_load(<project handle> <package handle>):
##     after files were imported the hook stored under 
##     package_descriptor.cmakepp.hooks.on_load is called
##     the value of on_load may be anything callable (file,function lambda)
##     the functions which were exported in the previous step
##     can be such callables. 
## 
##
## events:
##   on_package_load(<project package> <package handle>):
##     emitted after cmake exports  were loaded and packge's
##     on_load hook was invoked. 
##          
function(cmakepp_project_on_package_load project_handle package_handle)
  ## load the exports and include them once
  assign(content_dir = package_handle.content_dir)
  assign(export = package_handle.package_descriptor.cmakepp.export)

  if(IS_DIRECTORY "${content_dir}")
    pushd("${content_dir}")
      glob_ignore("${export}")
      ans(paths)
    popd()

    foreach(path ${paths})
      include_once("${path}")
    endforeach()
  endif()


  ## call on_load hook
  package_handle_invoke_hook(${package_handle} cmakepp.hooks.on_load ${project_handle} ${package_handle})

  ## emit the onload event
  event_emit(on_package_load ${project} ${package_handle})
endfunction()

## register listener for the project_on_package_load event 
## as soon as cmakepp loads
task_enqueue("[]()event_addhandler(project_on_package_load cmakepp_project_on_package_load)")


