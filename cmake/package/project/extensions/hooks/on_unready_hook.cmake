## 
## 
## calls the package_descritpor's `cmakepp.hooks.on_unready` hook if the package is still available
function(on_unready_hook project_handle package_handle)
  map_tryget(${package_handle} materialization_descriptor)
  ans(is_materialized)
  if(is_materialized)
    package_handle_invoke_hook(
      "${package_handle}" 
      hooks.on_unready 
      ${project_handle} 
      ${package_handle}
      )
  endif()
endfunction()
