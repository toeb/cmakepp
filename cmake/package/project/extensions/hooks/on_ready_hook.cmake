
function(on_ready_hook project_handle package_handle)
  package_handle_invoke_hook("${package_handle}" hooks.on_ready ${project_handle} ${package_handle})
endfunction()

