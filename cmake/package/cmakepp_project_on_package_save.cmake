
##
##
##
## hooks:
##   package_descriptor.cmakepp.hooks.on_save(<project handle> <package handle>):
## 
##
## events:
##   on_package_save(<project package> <package handle>):
##          
function(cmakepp_project_on_package_save project_handle package_handle)
  ## call on_save hook
  package_handle_invoke_hook(${package_handle} cmakepp.hooks.on_save ${project_handle} ${package_handle})

  ## emit the on_package_save event
  event_emit(on_package_save ${project} ${package_handle})
endfunction()

## register listener for the project_on_package_load event 
## as soon as cmakepp loads
task_enqueue("[]()event_addhandler(project_on_package_save cmakepp_project_on_package_save)")
