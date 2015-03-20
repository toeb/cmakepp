## `()->` 
##
## **config**
## 
## **hooks**:
##   `package_descriptor.cmakepp.hooks.on_materialized(<project handle> <packag handle>)`
##     this hook is invoked if it exists. it is invoked before the on_load hook 
##     this means that the project's exports were not loaded when the hook is called
##     however since cmake files are callable you can specify a local path
function(on_materialized_hook project_handle package_handle)
  package_handle_invoke_hook("${package_handle}" hooks.on_materialized ${project_handle} ${package_handle})
endfunction()

