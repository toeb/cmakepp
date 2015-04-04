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
function(on_loaded_hook project_handle package_handle)
  

  log("invoking on loaded hook for {package_handle.uri}" --trace --function on_loaded_hook)
  ## call on_load hook
  package_handle_invoke_hook(${package_handle} hooks.on_load ${project_handle} ${package_handle})
endfunction()


