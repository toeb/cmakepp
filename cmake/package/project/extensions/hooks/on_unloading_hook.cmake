

function(on_unloading_hook project_handle package_handle)
  package_handle_invoke_hook(${package_handle} hooks.on_unloading ${project_handle} ${package_handle})
endfunction()
