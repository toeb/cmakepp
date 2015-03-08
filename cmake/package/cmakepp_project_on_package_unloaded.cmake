
function(cmakepp_project_on_package_unloaded project_handle package_handle)
  package_handle_invoke_hook(${package_handle} cmakepp.hooks.on_unloaded ${project_handle} ${package_handle})
endfunction()
task_enqueue("[]()event_addhandler(project_on_package_unloaded cmakepp_project_on_package_unloaded)")
