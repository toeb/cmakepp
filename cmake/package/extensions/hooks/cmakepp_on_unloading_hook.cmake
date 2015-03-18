

function(cmakepp_on_unloading_hook project_handle package_handle)
  package_handle_invoke_hook(${package_handle} cmakepp.hooks.on_unloading ${project_handle} ${package_handle})
endfunction()
